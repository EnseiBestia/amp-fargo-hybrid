package org.appfuse.tool;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.io.FileUtils;
import org.appfuse.anno.AnnoFieldUtil;
import org.appfuse.anno.FieldAnnoExtend;
import org.appfuse.anno.POJOAnno;
import org.appfuse.anno.TableAnnoExtend;
import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.RootClass;
import org.hibernate.tool.hbm2x.GenericExporter;
import org.hibernate.tool.hbm2x.pojo.POJOClass;
import org.jboss.logging.Logger;

import com.alibaba.fastjson.JSONObject;

import org.apache.commons.lang.StringUtils;
/**
 * This class is used to process FreeMarker templates and
 * produce files from them.
 *
 * @author mraible
 */
public class AppFuseExporter extends GenericExporter {
	Logger logger = Logger.getLogger(AppFuseExporter.class);
    private POJOAnno pojoAnno = new POJOAnno();
    private JSONObject pojoExtend = new JSONObject();
    private String path = null;
    private String daoFramework = null;
    public AppFuseExporter() {
        init();
    }

    public AppFuseExporter(Configuration cfg, File outputdir) {
        super(cfg, outputdir);
        init();
    }

    public void init() {
        super.setArtifactCollector(new NoXMLFormatArtifactCollector());
    }

    public String getName() {
        return "appfuse";
    }
    public void initPOJOAnno(){
    	Iterator<POJOClass> iterator = this.getCfg2JavaTool().getPOJOIterator(this.getConfiguration().getClassMappings());
    	String parentPojoName = null;
    	String foreignParentPojoName = null;
    	String entityName = System.getProperty("entity");
    	//init fieldUtil
    	{
	    	String annoFieldUtilClass = AnnoFieldUtil.class.getName()+getDaoFilename(daoFramework);
			Class annoClass;
			try {
				annoClass = Class.forName(annoFieldUtilClass);
				pojoAnno.setAnnoFieldUtil((AnnoFieldUtil)annoClass.newInstance());
			} catch (Exception e) {
				e.printStackTrace();
			}
    	}
    	//Table Annotation,init allPOJOMap
        while ( iterator.hasNext() ) {	
			POJOClass eee =  iterator.next();
			String shortName = eee.getShortName();
			pojoAnno.getAllPOJOMap().put(shortName, eee);
			if(shortName.equals(entityName)){
				pojoAnno.setPojo(eee);
				RootClass rs=(RootClass)eee.getDecoratedObject();
            	TableAnnoExtend tae=(TableAnnoExtend) rs.getMappedClass().getAnnotation(TableAnnoExtend.class);
            	if(tae!=null){
        			parentPojoName = StringUtils.isBlank(tae.parent())?null:tae.parent();
        			pojoAnno.setParentName(parentPojoName);
        			pojoAnno.getAnnoFieldUtil().setParent(parentPojoName);
        			foreignParentPojoName = StringUtils.isBlank(tae.foreignParent())?null:tae.foreignParent();
        			pojoAnno.setForeignParentName(foreignParentPojoName);
        			
        			pojoAnno.getAnnoFieldUtil().setTextSearch(tae.textSearch());
        			pojoAnno.getAnnoFieldUtil().setCombinedSearch(tae.combinedSearch());
                	if(tae.description()!=null && !tae.description().equals("")){
                		pojoAnno.getAnnoFieldUtil().setDescription(tae.description());
                	}else{
                		pojoAnno.getAnnoFieldUtil().setDescription(shortName);
                	}
            	}
			}
        }
    	POJOClass curPOJO = pojoAnno.getPojo();
    	//init property
		for(Iterator<Property> iterator2=curPOJO.getAllPropertiesIterator();iterator2.hasNext();){
			Property p1 = iterator2.next();
			pojoAnno.getAnnoFieldUtil().addProperty(p1);
		}
		//init parent -> for childPOJO generate
        if(parentPojoName!=null){
        	if(pojoAnno.getAllPOJOMap().containsKey(parentPojoName)){
        		POJOClass parentPO = pojoAnno.getAllPOJOMap().get(parentPojoName);
				pojoAnno.setParentPOJO(parentPO);
				String parentForeignField=null;
				RootClass rs=(RootClass)parentPO.getDecoratedObject();
            	Field[] fs = rs.getMappedClass().getDeclaredFields();  
                for(Field f:fs){  
                	FieldAnnoExtend meta = f.getAnnotation(FieldAnnoExtend.class);  
                    if(meta!=null){  
                       if(meta.type()==5){
                    	   if(meta.childModel()!=null && meta.childModel().equals(curPOJO.getShortName())){
                    		   parentForeignField=f.getName();
                    	   }
                       }
                     }  
                 }  
				for(Iterator<Property> iterator2=parentPO.getAllPropertiesIterator();iterator2.hasNext();){
					Property p1 = iterator2.next();
					if(parentForeignField!=null && parentForeignField.equals(p1.getName())){
						pojoAnno.setChildPropInParent(p1);
					}
				}
        	}
        }
        //init foreignParent -> for childPOJO generate
        if(foreignParentPojoName!=null){
        	if(pojoAnno.getAllPOJOMap().containsKey(foreignParentPojoName)){
        		POJOClass foreignParentPO = pojoAnno.getAllPOJOMap().get(foreignParentPojoName);
        		pojoAnno.setForeignParentPOJO(foreignParentPO);
        	}
        }
        //init Field && init child -> for parentPOJO 
        {
        	RootClass rs=(RootClass)curPOJO.getDecoratedObject();
        	Field[] fs = rs.getMappedClass().getDeclaredFields();  
        	for(Field f:fs){  
				FieldAnnoExtend meta = f.getAnnotation(FieldAnnoExtend.class);  
			    if(meta!=null){  
				    for(Iterator iterator2=curPOJO.getAllPropertiesIterator();iterator2.hasNext();){
						Property p1 = (Property) iterator2.next();
						if(f.getName()!=null && f.getName().equals(p1.getName())){
							pojoAnno.getAnnoFieldUtil().addField(f, meta);
						}
				    }
				    	
				    if(meta.type()==5){
				    	String childModelName = meta.childModel();
				        pojoAnno.getChildrenList().add(childModelName);
				        if(pojoAnno.getAllPOJOMap().containsKey(childModelName)){
				        	POJOClass childPOJO = pojoAnno.getAllPOJOMap().get(childModelName);
				        	pojoAnno.getChildrenPOJOMap().put(childPOJO.getShortName(), childPOJO);
			        		pojoAnno.getChildrenPOJOList().add(childPOJO);
			        		if(pojoAnno.getAnnoFieldUtil().getAllPropertyList().contains(f.getName())){
			        			pojoAnno.getChildrenKeyMap().put(childPOJO.getShortName(), pojoAnno.getAnnoFieldUtil().getAllPropertyMap().get(f.getName()));
			        		}
				        }
				     }
			    }  
			}
        }
    }
    
    public void initPOJOExtend(){
    	/**
    	 * read from json file
    	 */
    	String entityName = pojoAnno.getPojo().getShortName();
    	String jsonPath = "src/test/resources/pojoJson/"+entityName+".json";
    	File jsonFile = new File(jsonPath);
    	try {
			String jsonString = FileUtils.readFileToString(jsonFile);
			pojoExtend = (JSONObject)JSONObject.parse(jsonString);
		} catch (IOException e) {
			System.out.println(entityName+".json not configured");
			//e.printStackTrace();
		}
    }
    public void doStart() {
    	if(System.getProperty("path")!=null && ! "".equals(System.getProperty("path"))){
    		path=System.getProperty("path");
    	}else{
    		System.out.println("请指定path属性");
    		System.exit(0);
    	}
    	
        daoFramework = getProperties().getProperty("daoframework");
        //specify daoFramework in gen command,refer to wiki @Cre 2016-03-04
        String daoFrameworkCmd = System.getProperty("dao");
        if(!StringUtils.isEmpty(daoFrameworkCmd)){
        	daoFramework = daoFrameworkCmd;
        }  
        
    	try{
    		initPOJOAnno();
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	initPOJOExtend();
    	
  	
    	
        String generateCore = getProperties().getProperty("generate-core");
        if (generateCore != null && generateCore.equals("true")) {
            generateCore();
        }

        String generateWeb = getProperties().getProperty("generate-web");
        if (!"true".equals(generateCore) && generateWeb != null && generateWeb.equals("true")) {
            generateWeb();
        }
        
        if (generateCore == null && generateWeb == null) {
            generateCore();
            generateWeb();
        }
    }
    
    private void generateCore() {
        //noinspection UnnecessaryUnboxing
        boolean genericCore = Boolean.valueOf(getProperties().getProperty("genericcore")).booleanValue();

        // generate sample-data.xml
        //configureExporter("appfuse/dao/sample-data.ftl", "src/test/resources/{class-name}-sample-data.xml").start();

        // Encourage use of genericCore - less code to maintain!
        if (genericCore) {
            configureExporter("appfuse/service/generic-beans.ftl", "src/main/resources/{class-name}-generic-beans.xml").start();
        } else {
        	if(pojoAnno.getParentName()==null || pojoAnno.getParentName().equals(System.getProperty("entity"))){
	            // DAO Test
	            //configureExporter("appfuse/dao/dao-test.ftl", "src/test/java/{basepkg-name}/dao/{class-name}DaoTest.java").start();
	
	            // DAO Interfaces
	            configureExporter("appfuse/dao/dao.ftl", "src/main/java/{basepkg-name}/dao/"+path+"/{class-name}Dao.java").start();
	
	            // DAO Bean Definition - only used when genericCore == true
	            configureExporter("appfuse/dao/dao-bean.ftl", "src/main/resources/{class-name}Dao-bean.xml").start();
	

	            // DAO Implementation
	            configureExporter("appfuse/dao/" + daoFramework + "/dao-impl.ftl",
	                    "src/main/java/{basepkg-name}/dao/"+path+"/{class-name}Dao" +
	                            getDaoFilename(daoFramework) + ".java").start();
	            
	            // Manager Test
	            //configureExporter("appfuse/service/manager-test.ftl",
	            //        "src/test/java/{basepkg-name}/service/impl/{class-name}ManagerImplTest.java").start();
	
	            // Manager Interface
	            configureExporter("appfuse/service/manager.ftl",
	                    "src/main/java/{basepkg-name}/service/"+path+"/{class-name}Manager.java").start();
	
	            // Manager Implementation
	            configureExporter("appfuse/service/manager-impl.ftl",
	                    "src/main/java/{basepkg-name}/service/"+path+"/{class-name}ManagerImpl.java").start();
	            
	            configureExporter("appfuse/aspect/aspect-impl.ftl",
	                    "src/main/java/{basepkg-name}/morphia/aspect/"+path+"/{class-name}InterceptorImpl.java").start();
        	}
        }


        // iBATIS SQL Map files
        if (daoFramework.equals("ibatis")) {
            configureExporter("appfuse/dao/ibatis/sql-map-config.ftl",
                "src/main/resources/{class-name}-sql-map-config.xml").start();
            configureExporter("appfuse/dao/ibatis/sql-map.ftl",
                "src/main/resources/sqlmaps/{class-name}SQL.xml").start();
            configureExporter("appfuse/dao/ibatis/compass-gps.ftl",
                "src/main/resources/compass-gps.xml").start();
            configureExporter("appfuse/dao/ibatis/select-ids.ftl",
                "src/main/resources/{class-name}-select-ids.xml").start();
        }

        // Manager Bean Definition - only used when genericCore == true
        configureExporter("appfuse/service/manager-bean.ftl", "src/main/resources/{class-name}Manager-bean.xml").start();
    }

    private void generateWeb() {
        String packaging = getProperties().getProperty("packaging");
        boolean webProject = packaging != null && packaging.equalsIgnoreCase("war");

        if (!webProject) return;

        String webFramework = getProperties().getProperty("webframework");
        
        GenericExporter gexp=configureExporter("appfuse/web/spring/controller.ftl", "src/main/java/{basepkg-name}/webapp/controller/{class-name}Controller.java");
       
        if (webFramework.equalsIgnoreCase("jsf")) {
            // tests
            configureExporter("appfuse/web/jsf/list-test.ftl", "src/test/java/{basepkg-name}/webapp/action/{class-name}ListTest.java").start();
            configureExporter("appfuse/web/jsf/form-test.ftl", "src/test/java/{basepkg-name}/webapp/action/{class-name}FormTest.java").start();

            // managed beans
            configureExporter("appfuse/web/jsf/list.ftl", "src/main/java/{basepkg-name}/webapp/action/{class-name}List.java").start();
            configureExporter("appfuse/web/jsf/form.ftl", "src/main/java/{basepkg-name}/webapp/action/{class-name}Form.java").start();

            // views
            configureExporter("appfuse/web/jsf/list-view.ftl", "src/main/webapp/{class-name}s.xhtml").start();
            configureExporter("appfuse/web/jsf/form-view.ftl", "src/main/webapp/{class-name}Form.xhtml").start();

            // configuration
            configureExporter("appfuse/web/jsf/navigation.ftl", "src/main/webapp/WEB-INF/{class-name}-navigation.xml").start();

            // JSF managed beans configured by Spring annotations in 2.1+
            //configureExporter("appfuse/web/jsf/managed-beans.ftl", "src/main/webapp/WEB-INF/{class-name}-managed-beans.xml").start();
        } else if (webFramework.equalsIgnoreCase("spring")) {
            // tests
            //configureExporter("appfuse/web/spring/controller-test.ftl", "src/test/java/{basepkg-name}/webapp/controller/{class-name}ControllerTest.java").start();
            //configureExporter("appfuse/web/spring/formcontroller-test.ftl", "src/test/java/{basepkg-name}/webapp/controller/{class-name}FormControllerTest.java").start();

        	if(pojoAnno.getParentName()!=null){
        		if(!pojoAnno.getParentName().equals(System.getProperty("entity"))){
        			 // controllers
    	        	configureExporter("appfuse/web/spring/controller-child.ftl", "src/main/java/{basepkg-name}/webapp/controller/"+path+"/{class-name}Controller.java").start();
    	            //configureExporter("appfuse/web/spring/formcontroller.ftl", "src/main/java/{basepkg-name}/webapp/controller/{class-name}FormController.java").start();
    	        	
    	            // views
    	            configureExporter("appfuse/web/spring/list-view-child.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}List.jsp").start();
    	            configureExporter("appfuse/web/spring/form-view-child.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}Form.jsp").start();

        		}else{
        			// controllers
    	        	configureExporter("appfuse/web/spring/controller-tree.ftl", "src/main/java/{basepkg-name}/webapp/controller/"+path+"/{class-name}Controller.java").start();
    	            //configureExporter("appfuse/web/spring/formcontroller.ftl", "src/main/java/{basepkg-name}/webapp/controller/{class-name}FormController.java").start();
    	        	
    	            // views
    	            configureExporter("appfuse/web/spring/list-view-tree.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}List.jsp").start();
    	            configureExporter("appfuse/web/spring/form-view-tree.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}Form.jsp").start();

        		}
	            
        		       		
        	}else{
        		// controllers
	        	configureExporter("appfuse/web/spring/controller.ftl", "src/main/java/{basepkg-name}/webapp/controller/"+path+"/{class-name}Controller.java").start();
	            //configureExporter("appfuse/web/spring/formcontroller.ftl", "src/main/java/{basepkg-name}/webapp/controller/{class-name}FormController.java").start();
	        	
	            // views
	            configureExporter("appfuse/web/spring/list-view.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}List.jsp").start();
	            configureExporter("appfuse/web/spring/form-view.ftl", "src/main/webapp/WEB-INF/pages/"+path+"/{class-name}Form.jsp").start();
        	}
            // Controllers configured by Spring annotations in 2.1+
            //configureExporter("appfuse/web/spring/controller-beans.ftl", "src/main/webapp/WEB-INF/{class-name}-beans.xml").start();

            // validation
            configureExporter("appfuse/web/spring/form-validation.ftl", "src/main/webapp/WEB-INF/{class-name}-validation.xml").start();
        } else if (webFramework.equalsIgnoreCase("struts")) {
            // tests
            configureExporter("appfuse/web/struts/action-test.ftl", "src/test/java/{basepkg-name}/webapp/action/{class-name}ActionTest.java").start();

            // controllers
            configureExporter("appfuse/web/struts/action.ftl", "src/main/java/{basepkg-name}/webapp/action/{class-name}Action.java").start();

            // views
            configureExporter("appfuse/web/struts/list-view.ftl", "src/main/webapp/WEB-INF/pages/{class-name}List.jsp").start();
            configureExporter("appfuse/web/struts/form-view.ftl", "src/main/webapp/WEB-INF/pages/{class-name}Form.jsp").start();

            // configuration
            // This template is not used anymore (APF-798), but retained in case we do want to create definitions by default in the future
            configureExporter("appfuse/web/struts/action-beans.ftl", "src/main/webapp/WEB-INF/{class-name}-struts-bean.xml").start();

            configureExporter("appfuse/web/struts/struts.ftl", "src/main/resources/{class-name}-struts.xml").start();

            // validation
            configureExporter("appfuse/web/struts/model-validation.ftl", "src/main/resources/{basepkg-name}/model/{class-name}-validation.xml").start();
            configureExporter("appfuse/web/struts/action-validation.ftl", "src/main/resources/{basepkg-name}/webapp/action/{class-name}Action-validation.xml").start();
        } else if (webFramework.equalsIgnoreCase("tapestry")) {
            // tests
            configureExporter("appfuse/web/tapestry/list-test.ftl", "src/test/java/{basepkg-name}/webapp/pages/{class-name}ListTest.java").start();
            configureExporter("appfuse/web/tapestry/form-test.ftl", "src/test/java/{basepkg-name}/webapp/pages/{class-name}FormTest.java").start();

            // managed beans
            configureExporter("appfuse/web/tapestry/list.ftl", "src/main/java/{basepkg-name}/webapp/pages/{class-name}List.java").start();
            configureExporter("appfuse/web/tapestry/form.ftl", "src/main/java/{basepkg-name}/webapp/pages/{class-name}Form.java").start();

            // views
            configureExporter("appfuse/web/tapestry/list-view.ftl", "src/main/webapp/{class-name}List.tml").start();
            configureExporter("appfuse/web/tapestry/form-view.ftl", "src/main/webapp/{class-name}Form.tml").start();
        } else {
            log.warn("Your project's web framework '" + webFramework + "' is not supported by AMP at this time.");
            log.warn("See http://issues.appfuse.org/browse/EQX-211 for more information.");

        }

        // menu
        if (!webFramework.equalsIgnoreCase("tapestry")) {
            //configureExporter("appfuse/web/menu.ftl", "src/main/webapp/common/{class-name}-menu.jsp").start();
            //configureExporter("appfuse/web/menu-light.ftl", "src/main/webapp/common/{class-name}-menu-light.jsp").start();
            //configureExporter("appfuse/web/menu-config.ftl", "src/main/webapp/WEB-INF/{class-name}-menu-config.xml").start();
        } else {
            //configureExporter("appfuse/web/tapestry/menu.ftl", "src/main/webapp/{class-name}-menu.tml").start();
        }

        // i18n
        configureExporter("appfuse/web/ApplicationResources.ftl", "src/main/resources/{class-name}_ApplicationResources.properties").start();

        // ui tests
        if (!webFramework.equals("wicket") && !webFramework.equals("spring-security") &&
                !webFramework.equals("spring-freemarker") && !webFramework.equals("stripes")) {
           // configureExporter("appfuse/web/" + webFramework + "/web-tests.ftl", "src/test/resources/{class-name}-web-tests.xml").start();
        }
    }

    private String getDaoFilename(String daoFramework) {
        if (daoFramework.equalsIgnoreCase("ibatis")) {
            return "iBatis";
        } else if (daoFramework.equalsIgnoreCase("jpa")) {
            return "Jpa";
        } else {
            return Character.toUpperCase(daoFramework.charAt(0)) + daoFramework.substring(1);
        }
    }

    private GenericExporter configureExporter(String template, String pattern) {
    	
        // Add custom template path if specified
        String[] templatePaths;
        if (getProperties().getProperty("templatedirectory") != null) {
            templatePaths = new String[getTemplatePaths().length + 1];
            templatePaths[0] = getProperties().getProperty("templatedirectory");
            if (getTemplatePaths().length > 1) {
                for (int i = 1; i < getTemplatePaths().length; i++) {
                    templatePaths[i] = getTemplatePaths()[i-1];
                }
            }
        } else {
            templatePaths = getTemplatePaths();   
        }

        GenericExporter exporter = new GenericExporter(getConfiguration(), getOutputDirectory()) {
			@Override
            protected void exportPOJO(Map map, POJOClass element) {
                if (element.getShortName().equals(System.getProperty("appfuse.entity"))) {
/*                	map.put("childrenList", childrenList);
                	map.put("childrenPOJOMap", childrenPOJOMap);
                	map.put("childrenKeyMap", childrenKeyMap);
                	map.put("annoFieldUtil", annoFieldUtil);
                	map.put("childrenPOJOList", childrenPOJOList);
                	map.put("allPOJOMap", pojoAnno.getAllPOJOMap()); */
                	map.put("pojoAnno", pojoAnno);
                	map.put("pojoExtend",pojoExtend);
                	map.put("path", path);
                	map.put("daoFramework", daoFramework);                	
                	System.out.println("map:"+map+"|"+element);
                    super.exportPOJO(map, element);
                }
            }

            @Override
            protected String resolveFilename(POJOClass element) {
                String filename = super.resolveFilename(element);
                String packageLocation = getPackageNameForFile(element).replace(".", "/");

                String pojoName = System.getProperty("entity");

                // A dot in the entity name means the person is specifying the package.
                if (System.getProperty("entity").contains(".")) {
                    packageLocation = pojoName.substring(0, pojoName.indexOf(".model"));
                    packageLocation = packageLocation.replace(".", "/");
                }

                if (packageLocation.endsWith("model") && packageLocation.indexOf('/') > -1) {
                    packageLocation = packageLocation.substring(0, packageLocation.lastIndexOf('/'));
                }
                filename = filename.replace("{basepkg-name}", packageLocation);
                return filename;
            }
        };
        
        System.out.println("===="+System.getProperty("path"));
        exporter.setProperties((Properties) getProperties().clone());
        //System.out.println((Properties) getProperties());
        exporter.setTemplatePath(templatePaths);
        exporter.setTemplateName(template);
        exporter.setFilePattern(pattern);
        exporter.setArtifactCollector(getArtifactCollector());
        exporter.getProperties().put("data", new DataHelper());
        exporter.getProperties().put("util", new org.appfuse.tool.StringUtils());
        return exporter;
    }
}
