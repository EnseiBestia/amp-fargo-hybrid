

<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
<#assign setIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>

<#assign childPOJONameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign childGetIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
<#assign childSetIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign childIdentifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>

<#assign parentProperty = pojo.identifierProperty>

<#foreach annotmp in pojoAnno.annoFieldUtil.annoInfoes>   	
    <#if annotmp.type==7>
    	<#assign parentProperty = annotmp.property>
    </#if>
</#foreach>

<#assign nameProperty = pojo.identifierProperty>

<#foreach annotmp in pojoAnno.annoFieldUtil.annoInfoes>   	
    <#if annotmp.name>
    	<#assign nameProperty = annotmp.property>
    </#if>
</#foreach>

<#assign libraryExits = false>

package ${basepackage}.webapp.controller.${path};

import com.btxy.basis.dao.SearchException;
<#if genericcore>
import ${appfusepackage}.service.GenericManager;
<#else>
import ${basepackage}.service.${path}.${pojo.shortName}Manager;
</#if>
import ${basepackage}.model.${pojo.shortName};

import java.util.List;
import com.btxy.basis.util.zx.LongUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.web.servlet.ModelAndView;

import org.apache.commons.lang.StringUtils;
import org.springframework.validation.BindingResult;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import com.btxy.basis.common.util.SequenceUtil;
import com.btxy.basis.cache.LibraryInfoCache;

import com.btxy.basis.common.model.PaginatedListHelper;
import com.btxy.basis.webapp.util.displaytable.PageTools;
import com.btxy.basis.webapp.controller.BaseFormController;
import com.btxy.basis.common.model.ServerValidataResult;
import com.btxy.basis.common.model.QueryContditionSet;
import com.btxy.basis.common.model.SearchConditionValue;
import org.mongodb.morphia.query.Query;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import com.btxy.basis.util.list.ListUtil;
import com.btxy.basis.util.map.MapUtil;
import com.btxy.basis.util.zx.LongUtil;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import com.btxy.basis.model.CfgStateMachineButton;
import com.btxy.basis.model.CfgStateMachineDefine;
import com.btxy.basis.cache.cfg.CfgStateMachineDefineCache;
import com.btxy.basis.cache.cfg.CfgStateMachineValueCache;
import java.lang.reflect.Method;


@Controller
public class ${pojo.shortName}Controller extends BaseFormController{
	private static final String DM_FORM_NAME="${childPOJONameLower}";

<#if genericcore>
    private GenericManager<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> ${pojoNameLower}Manager;
<#else>
    private ${pojo.shortName}Manager ${pojoNameLower}Manager;
</#if>

    @Autowired
<#if genericcore>
    public void set${pojo.shortName}Manager(@Qualifier("${pojoNameLower}Manager") GenericManager<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> ${pojoNameLower}Manager) {
<#else>
    public void set${pojo.shortName}Manager(${pojo.shortName}Manager ${pojoNameLower}Manager) {
</#if>  
        this.${pojoNameLower}Manager = ${pojoNameLower}Manager;
    }
<#foreach field in pojo.getAllPropertiesIterator()>
    <#foreach column in field.getColumnIterator()>   	
        <#if field.name=="library">
        	<#assign libraryExits = true>
        </#if>
    </#foreach>
</#foreach>
    public ${pojo.shortName}Controller() {      
    }  
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/php*")
    public ModelAndView listFirst(@PathVariable String libraryPath,HttpServletRequest request,final SearchConditionValue searchValue)throws Exception {	
  		return list(libraryPath,0l,request,searchValue,"mt");
  	} 
  	@RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/{parentId}/php*")
    public ModelAndView listSecond(@PathVariable String libraryPath,@PathVariable final ${identifierType} parentId,HttpServletRequest request,final SearchConditionValue searchValue)throws Exception {
  		return list(libraryPath,parentId,request,searchValue,"mt");
  	}   
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/{parentId}/{listFlag}/php*")
    public ModelAndView list(@PathVariable String libraryPath,@PathVariable final ${identifierType} parentId,HttpServletRequest request,final SearchConditionValue searchValue,@PathVariable String listFlag)throws Exception {
        
        Model model = new ExtendedModelMap();
      	model.addAttribute("listFlag",listFlag);
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        int currentPage=super.getDisplayTagCurrentPage(request,"${pojoNameLower}List");
        
    	int pageSize=PageTools.getPageSizeOfUserForm(request,"${pojoNameLower}");
    	
    	model.addAttribute("searchValue",searchValue);
    	model.addAttribute("parentId",parentId);
        try {       
        <#if libraryExits>
        	PaginatedListHelper<${pojo.shortName}> paginaredList=${pojoNameLower}Manager.find(currentPage,pageSize,LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath),new QueryContditionSet<${pojo.shortName}>(){
				@Override
				public void setContdition(Query<${pojo.shortName}> q) {
					// TODO Auto-generated method stub
					q.field("${parentProperty.name}").equal(parentId);
			    	
			    	<#if pojoAnno.annoFieldUtil.combinedSearch>
			    		${pojoAnno.annoFieldUtil.getConditionSearchStr()};
					<#else>
			    		if(searchValue.getTextValue()!=null && !"".equals(searchValue.getTextValue())){
			    			${pojoAnno.annoFieldUtil.getTextSearchStr()};
			    		}			    	
			    	</#if>
				}        		
        	});
        	//model.addAttribute(${pojoNameLower}Manager.getAll(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath)));
        </#if>
        <#if !libraryExits>
        	PaginatedListHelper<${pojo.shortName}> paginaredList=${pojoNameLower}Manager.find(currentPage,pageSize,new QueryContditionSet<${pojo.shortName}>(){
				@Override
				public void setContdition(Query<${pojo.shortName}> q) {
					// TODO Auto-generated method stub
					q.field("${parentProperty.name}").equal(parentId);
			    	<#if pojoAnno.annoFieldUtil.combinedSearch>
			    		${pojoAnno.annoFieldUtil.getConditionSearchStr()};
					<#else>
			    		if(searchValue.getTextValue()!=null && !"".equals(searchValue.getTextValue())){
			    			${pojoAnno.annoFieldUtil.getTextSearchStr()};
			    		}			    	
			    	</#if>
				}        		
        	});
        </#if>            
        	List<${pojo.shortName}> parentsList=new ArrayList<${pojo.shortName}>();
        	Long p1=parentId;
        	while(p1!=0){
        		${pojo.shortName} ${pojoNameLower}1=${pojoNameLower}Manager.get(p1);
        		if(${pojoNameLower}1!=null){
        			parentsList.add(0,${pojoNameLower}1);
        			p1=${pojoNameLower}1.getParent()==null?0l:${pojoNameLower}1.getParent();
        		}
        	}
        	model.addAttribute("parentsList",parentsList);
        	//model.addAttribute(paginaredList);
        	model.addAttribute("${pojoNameLower}List",paginaredList.getList());
        	model.addAttribute("pageSize", pageSize);
        	model.addAttribute("totalSize", paginaredList.getFullListSize());
        } catch (SearchException se) {
            model.addAttribute("searchError", se.getMessage());
            model.addAttribute(new PaginatedListHelper<${pojo.shortName}>());
            model.addAttribute("${pojoNameLower}List",new ArrayList<${pojo.shortName}>());
            model.addAttribute("pageSize", pageSize);
        	model.addAttribute("totalSize", 0);
        }
        return new ModelAndView("${path}/${pojo.shortName}List", model.asMap());
     
    }

    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/view/{${pojo.identifierProperty.name}}/${pojoNameLower}/{parentId}/php*",method = RequestMethod.GET)
    public ModelAndView view(@PathVariable String libraryPath,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name},@PathVariable Long parentId)throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", false);
    	model.addAttribute("parentId",parentId);
        if (${pojo.identifierProperty.name}!=null) {
            ${pojo.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(${pojo.identifierProperty.name});
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/add/${pojoNameLower}/{parentId}/php*",method = RequestMethod.GET)
    public ModelAndView add(@PathVariable String libraryPath,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} parentId)throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("parentId",parentId);
        ${pojo.shortName} ${childPOJONameLower}= new  ${pojo.shortName}();
        ${childPOJONameLower}.${childSetIdMethodName}(SequenceUtil.getNext(${pojo.shortName}.class));        
        <#if libraryExits>
        	${childPOJONameLower}.setLibrary(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath));
        	${childPOJONameLower}.setOvert(false);
        </#if>    
        ${pojoNameLower}.setParent(parentId);
        model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", "1");

        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/edit/{${pojo.identifierProperty.name}}/${pojoNameLower}/{parentId}/php*",method = RequestMethod.GET)
    public ModelAndView edit(@PathVariable String libraryPath,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name},@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} parentId)throws Exception {
    	
        Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", true);  
    	model.addAttribute("parentId",parentId); 	
        if (${pojo.identifierProperty.name}!=null) {
            ${pojo.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(${pojo.identifierProperty.name});
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
            
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/formSubmit/${pojoNameLower}/{parentId}/php*",method = RequestMethod.POST)

    public ModelAndView onSubmit(@PathVariable String libraryPath,${pojo.shortName} ${childPOJONameLower},@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} parentId,  HttpServletRequest request,
                           HttpServletResponse response)throws Exception {                
                           
        Model model = new ExtendedModelMap(); 
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", request.getParameter("addFlagOf${pojo.shortName}Form"));
        model.addAttribute("parentId",parentId);
        if (validator != null) { // validator is null during testing     
        	ServerValidataResult svr=new ServerValidataResult();      	
        	validate(${pojoNameLower}, svr);      	
            
            if (svr.hasErrors()) { // don't validate when deleting
            	saveError(request,svr.getAllErrorMessage());
        		return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
            }
        }

        log.debug("entering 'onSubmit' method...");

        boolean isNew = ("1".equals(request.getParameter("addFlagOf${pojo.shortName}Form")));
        
        String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/"+parentId+"/mt/php" ;
        Locale locale = request.getLocale();

        if(isNew){
        	${pojoNameLower}Manager.save(${pojoNameLower},true);
        }else{
        	${pojoNameLower}Manager.saveMainBody(${pojoNameLower});
        }
        
        
        
        String key = (isNew) ? "${pojoNameLower}.added" : "${pojoNameLower}.updated";
        saveMessage(request, getText(key, locale));

        if (!isNew) {
            success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/"+parentId+"/mt/php" ;
        }
    

        return new ModelAndView(success, model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/delete/{${pojo.identifierProperty.name}List}/${pojoNameLower}/{parentId}/php*",method = RequestMethod.POST)
    public ModelAndView delete(@PathVariable String libraryPath,@PathVariable String ${pojo.identifierProperty.name}List,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} parentId,HttpServletRequest request,
            HttpServletResponse response)throws Exception {
        Model model = new ExtendedModelMap(); 
        model.addAttribute("parentId",parentId);
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	Locale locale = request.getLocale();
    	if(${pojo.identifierProperty.name}List!=null){
    		String[] a=${pojo.identifierProperty.name}List.split("-");
    		if(a!=null){
    			for(String one:a){
    				${pojoNameLower}Manager.remove(new Long(one));
    				deleteChildren(new Long(one));
    			}
    		}
    	}
        saveMessage(request, getText("${pojoNameLower}.deleted", locale));
        String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/"+parentId+"/mt/php?pageGroupType=back";
        return new ModelAndView(success, model.asMap());
        
    }    
    private void deleteChildren(final Long parentId){
    	List<${pojo.shortName}> list=${pojoNameLower}Manager.find(new QueryContditionSet<${pojo.shortName}>(){
			@Override
			public void setContdition(Query<${pojo.shortName}> q) {
				// TODO Auto-generated method stub
				q.field("${parentProperty.name}").equal(parentId);
			}        		
    	});
    	for(int i=0;list!=null && i<list.size();i++){
    		${pojoNameLower}Manager.remove(list.get(i).${getIdMethodName}());
    		deleteChildren(list.get(i).${getIdMethodName}());
    	}
    }
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/select/php*")
    public void getSelect2Json(@PathVariable String libraryPath,HttpServletResponse response)throws Exception {	
    <#if libraryExits>
    	List<${pojo.shortName}> list=${pojoNameLower}Manager.getAll(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath));
    </#if>
    <#if !libraryExits>	
    	List<${pojo.shortName}> list=${pojoNameLower}Manager.getAll();
    </#if>
    	Map<Long,List<${pojo.shortName}>> map=new HashMap<Long,List<${pojo.shortName}>>();
    	JSONArray array=new JSONArray();
    	for(int i=0;list!=null && i<list.size();i++){
    		 MapUtil.appendListEntityToMap(map, list.get(i).getParent(), list.get(i));
    	}
    	initTree("",0l,array,map);
    	returnJSON(array,response);
  	} 

	private void initTree(String parentLab,Long parentId,JSONArray array,Map<Long,List<${pojo.shortName}>> map){
    	List<${pojo.shortName}> list1=map.get(parentId);
    	if(list1!=null){
    		for(${pojo.shortName} one:list1){
    			JSONObject obj=new JSONObject();
    			obj.put("id", one.${getIdMethodName}());
    			obj.put("text", parentLab+one.${pojo.getGetterSignature(nameProperty)}());
    			array.add(obj);
    			initTree(parentLab+"&nbsp;&nbsp;&nbsp;&nbsp;",one.${getIdMethodName}(),array,map);
    		}
    	}
    }
    
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/edit/stateMachineSubmit/{objectId}/{machineId}/{buttonId}/php*",method = RequestMethod.POST)
    public void stateMachineSubmit(@PathVariable String libraryPath,@PathVariable Long objectId,@PathVariable Long machineId,@PathVariable Long buttonId,HttpServletResponse response)throws Exception {
    	JSONObject obj=new JSONObject();
    	try{
	    	//StTaskInfo task=StTaskInfoCache.getInstance().addTask(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath),taskType, formName, objectId, new HashMap<String,Object>());
	    	${pojo.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(objectId);
	    	if(${pojoNameLower}!=null){
	    		CfgStateMachineDefine define=CfgStateMachineDefineCache.getInstance().getEntityById(machineId);
	    		CfgStateMachineButton button=CfgStateMachineValueCache.getInstance().getCfgStateMachineButton(buttonId);
		        if(define!=null && button!=null){
		        	Method setMethod=CfgStateMachineDefineCache.getInstance().getStateFieldSetMethod(machineId);
		        	setMethod.invoke(${pojoNameLower}, new Object[]{button.getTargetStat()});
		        	${pojoNameLower}Manager.save(${pojoNameLower});
		        	
		        	obj.put("rtnValue", 1);
		    		obj.put("rtnDescription", button.getButtonName()+"成功!");
		    		super.returnJSON(obj, response);
		    		return;
		        }
	    	}
    	
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	obj.put("rtnValue", 0);
		obj.put("rtnDescription", "数据更新失败，请稍后重试!");
    	super.returnJSON(obj, response);
    }
}
