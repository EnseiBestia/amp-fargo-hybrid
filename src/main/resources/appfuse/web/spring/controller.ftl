

<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
<#assign setIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>

<#assign nameProperty = pojo.identifierProperty>

<#foreach annotmp in pojoAnno.annoFieldUtil.annoInfoes>   	
    <#if annotmp.name>
    	<#assign nameProperty = annotmp.property>
    </#if>
</#foreach>

<#assign libraryExits = false>

<#if pojoAnno.foreignParentPOJO?exists >
	<#assign foreignParentKeyPath = "${pojoAnno.foreignParentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.foreignParentPOJO.shortName.substring(1)}/{${pojoAnno.foreignParentPOJO.identifierProperty.name}}/">
	<#assign foreignParentKeyDefine = ",@PathVariable final ${pojoAnno.foreignParentPOJO.getJavaTypeName(pojoAnno.foreignParentPOJO.identifierProperty, jdk5)} ${pojoAnno.foreignParentPOJO.identifierProperty.name}">
	<#assign foreignParentKeyModelSet = "model.addAttribute(\"${pojoAnno.foreignParentPOJO.identifierProperty.name}\", ${pojoAnno.foreignParentPOJO.identifierProperty.name});">
	
<#else>
	<#assign foreignParentKeyPath = "">
	<#assign foreignParentKeyDefine = "">
	<#assign foreignParentKeyModelSet ="">
	
</#if>
package ${basepackage}.webapp.controller.${path};

import com.btxy.basis.dao.SearchException;
<#if genericcore>
import ${appfusepackage}.service.GenericManager;
<#else>
import ${basepackage}.service.${path}.${pojo.shortName}Manager;
</#if>
import ${basepackage}.model.${pojo.shortName};

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
import com.fargo.basis.common.annotation.FormToken;
import com.fargo.basis.common.model.PaginatedListHelper;
import com.fargo.basis.common.model.SearchConditionValue;
import com.fargo.basis.webapp.controller.BaseFormController;

import com.btxy.basis.webapp.util.displaytable.PageTools;
import com.btxy.basis.common.model.ServerValidataResult;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import com.btxy.basis.model.CfgStateMachineButton;
import com.btxy.basis.model.CfgStateMachineDefine;
import com.btxy.basis.cache.cfg.CfgStateMachineDefineCache;
import com.btxy.basis.cache.cfg.CfgStateMachineValueCache;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import com.btxy.basis.util.list.ListUtil;
import com.btxy.basis.util.map.MapUtil;
import com.btxy.basis.util.zx.LongUtil;
import java.lang.reflect.Method;


@Controller
public class ${pojo.shortName}Controller extends BaseFormController{
	private static final String DM_FORM_NAME="${pojoNameLower}";

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
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/${foreignParentKeyPath}php*")
    public ModelAndView listFirst(@PathVariable String libraryPath${foreignParentKeyDefine},HttpServletRequest request,final SearchConditionValue searchValue)throws Exception {	
  		<#if pojoAnno.foreignParentPOJO?exists >
  		return list(libraryPath,${pojoAnno.foreignParentPOJO.identifierProperty.name},request,searchValue,"mt");
  		<#else>
  		return list(libraryPath,request,searchValue,"mt");
  		</#if>
  	} 
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/${foreignParentKeyPath}{listFlag}/php*")
    public ModelAndView list(@PathVariable String libraryPath${foreignParentKeyDefine},HttpServletRequest request,final SearchConditionValue searchValue,@PathVariable String listFlag)throws Exception {
        Model model = new ExtendedModelMap();
       
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        int currentPage=super.getDisplayTagCurrentPage(request,"${pojoNameLower}List");
        
    	int pageSize=PageTools.getPageSizeOfUserForm(request,"${pojoNameLower}");
    	
    	model.addAttribute("searchValue",searchValue);
    	model.addAttribute("listFlag",listFlag);
    	${foreignParentKeyModelSet}
        try {       
        <#if libraryExits>
        	PaginatedListHelper<${pojo.shortName}> paginaredList=${pojoNameLower}Manager.find(currentPage,pageSize,LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath),searchValue);
        	//model.addAttribute(${pojoNameLower}Manager.getAll(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath)));
        </#if>
        <#if !libraryExits>
        	PaginatedListHelper<${pojo.shortName}> paginaredList=${pojoNameLower}Manager.find(currentPage,pageSize,searchValue);
        </#if>            

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
 
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/view/{${pojo.identifierProperty.name}}/${foreignParentKeyPath}php*",method = RequestMethod.GET)
    public ModelAndView view(@PathVariable String libraryPath${foreignParentKeyDefine},@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name})throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", false);
    	${foreignParentKeyModelSet}
        if (${pojo.identifierProperty.name}!=null) {
            ${pojo.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(${pojo.identifierProperty.name});
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/add/${foreignParentKeyPath}php*",method = RequestMethod.GET)
    @FormToken(save=true)
    public ModelAndView add(@PathVariable String libraryPath${foreignParentKeyDefine})throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        ${pojo.shortName} ${pojoNameLower}= new  ${pojo.shortName}();
        <#--Hibernate use auto_increment  -->
        <#if daoFramework!="hibernate">
        	${pojoNameLower}.${setIdMethodName}(SequenceUtil.getNext(${pojo.shortName}.class));
        </#if>     
        ${foreignParentKeyModelSet}   
        <#if libraryExits>
        	${pojoNameLower}.setLibrary(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath));
        	${pojoNameLower}.setOvert(false);
        </#if>      
        <#if pojoAnno.foreignParentPOJO?exists >
  		${pojoNameLower}.set${pojoAnno.foreignParentPOJO.getPropertyName(pojoAnno.foreignParentPOJO.identifierProperty)}(${pojoAnno.foreignParentPOJO.identifierProperty.name});
  		</#if>
  		
        model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", "1");

        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/edit/{${pojo.identifierProperty.name}}/${foreignParentKeyPath}php*",method = RequestMethod.GET)
    @FormToken(save=true)
    public ModelAndView edit(@PathVariable String libraryPath${foreignParentKeyDefine},@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name})throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", true);   
    	${foreignParentKeyModelSet}	
        if (${pojo.identifierProperty.name}!=null) {
            ${pojo.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(${pojo.identifierProperty.name});
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
            
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/formSubmit/${foreignParentKeyPath}php*",method = RequestMethod.POST)
    @FormToken(remove=true)
    public ModelAndView onSubmit(@PathVariable String libraryPath${foreignParentKeyDefine},${pojo.shortName} ${pojoNameLower},  HttpServletRequest request,
                           HttpServletResponse response)throws Exception {  
        Model model = new ExtendedModelMap(); 
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", request.getParameter("addFlagOf${pojo.shortName}Form"));
        ${foreignParentKeyModelSet}
        
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
        
        <#if pojoAnno.foreignParentPOJO?exists >
  		String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/${pojoAnno.foreignParentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.foreignParentPOJO.shortName.substring(1)}/"+${pojoAnno.foreignParentPOJO.identifierProperty.name}+"/mt/php";
  		<#else>
  		String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/mt/php";
  		</#if>
  		
        
        Locale locale = request.getLocale();

        if(isNew){
        	${pojoNameLower}Manager.save(${pojoNameLower},true);
        }else{
        	${pojoNameLower}Manager.saveMainBody(${pojoNameLower});
        }
        
        
        
        String key = (isNew) ? "${pojoNameLower}.added" : "${pojoNameLower}.updated";
        saveMessage(request, getText(key, locale));

        if (!isNew) {   	
        	        
	        <#if pojoAnno.foreignParentPOJO?exists >
	  		success = "redirect:/lb/{libraryPath}/${pojoNameLower}/view/"+${pojoNameLower}.${getIdMethodName}()+"/${pojoAnno.foreignParentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.foreignParentPOJO.shortName.substring(1)}/"+${pojoAnno.foreignParentPOJO.identifierProperty.name}+"/php";
	  		<#else>
	  		success = "redirect:/lb/{libraryPath}/${pojoNameLower}/view/"+${pojoNameLower}.${getIdMethodName}()+"/php" ;
	  		</#if>
            
        }
    

        return new ModelAndView(success, model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/delete/{${pojo.identifierProperty.name}List}/${foreignParentKeyPath}php*",method = RequestMethod.POST)
    public ModelAndView delete(@PathVariable String libraryPath${foreignParentKeyDefine},HttpServletRequest request,
            HttpServletResponse response,@PathVariable String ${pojo.identifierProperty.name}List)throws Exception {
        Model model = new ExtendedModelMap(); 
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        ${foreignParentKeyModelSet}
    	Locale locale = request.getLocale();
    	if(${pojo.identifierProperty.name}List!=null){
    		String[] a=${pojo.identifierProperty.name}List.split("-");
    		if(a!=null){
    			for(String one:a){
    				${pojoNameLower}Manager.remove(new Long(one));
    			}
    		}
    	}
        saveMessage(request, getText("${pojoNameLower}.deleted", locale));
        
        <#if pojoAnno.foreignParentPOJO?exists >
  		String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/${pojoAnno.foreignParentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.foreignParentPOJO.shortName.substring(1)}/"+${pojoAnno.foreignParentPOJO.identifierProperty.name}+"/mt/php?pageGroupType=back";
  		<#else>
        String success = "redirect:/lb/{libraryPath}/${pojoNameLower}/list/mt/php?pageGroupType=back";
  		</#if>
        return new ModelAndView(success, model.asMap());
    }    
    
    @RequestMapping(value = "/lb/{libraryPath}/${pojoNameLower}/list/select/${foreignParentKeyPath}php*")
    public void getSelect2Json(@PathVariable String libraryPath${foreignParentKeyDefine},HttpServletResponse response)throws Exception {	
    <#if libraryExits>
    	List<${pojo.shortName}> list=${pojoNameLower}Manager.getAll(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath));
    </#if>
    <#if !libraryExits>	
    	List<${pojo.shortName}> list=${pojoNameLower}Manager.getAll();
    </#if>
    	JSONArray array=new JSONArray();
    	for(int i=0;list!=null && i<list.size();i++){
    		    JSONObject obj=new JSONObject();
    			obj.put("id", list.get(i).${getIdMethodName}());
    			obj.put("text", list.get(i).${pojo.getGetterSignature(nameProperty)}());
    			array.add(obj);
    	}
    	returnJSON(array,response);
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
