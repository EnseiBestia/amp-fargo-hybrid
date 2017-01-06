

<#assign pojoNameLower = pojoAnno.parentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.parentPOJO.shortName.substring(1)>
<#assign getIdMethodName = pojoAnno.parentPOJO.getGetterSignature(pojoAnno.parentPOJO.identifierProperty)>
<#assign setIdMethodName = 'set' + pojoAnno.parentPOJO.getPropertyName(pojoAnno.parentPOJO.identifierProperty)>
<#assign identifierType = pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)>

<#assign childPOJONameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign childGetIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
<#assign childSetIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign childIdentifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>


<#assign libraryExits = false>

package ${basepackage}.webapp.controller.${path};

import com.btxy.basis.dao.SearchException;
<#if genericcore>
import ${appfusepackage}.service.GenericManager;
<#else>
import ${basepackage}.service.${path}.${pojoAnno.parentPOJO.shortName}Manager;
</#if>
import ${basepackage}.model.${pojo.shortName};
import ${basepackage}.model.${pojoAnno.parentPOJO.shortName};

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
import com.fargo.basis.common.annotation.FormToken;
import com.fargo.basis.util.codec.UUIDUtil;
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
    private GenericManager<${pojoAnno.parentPOJO.shortName}, ${pojoAnno.parentPOJO.getJavaTypeName(pojo.identifierProperty, jdk5)}> ${pojoNameLower}Manager;
<#else>
    private ${pojoAnno.parentPOJO.shortName}Manager ${pojoNameLower}Manager;
</#if>

    @Autowired
<#if genericcore>
    public void set${pojoAnno.parentPOJO.shortName}Manager(@Qualifier("${pojoNameLower}Manager") GenericManager<${pojoAnno.parentPOJO.shortName}, ${pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)}> ${pojoNameLower}Manager) {
<#else>
    public void set${pojoAnno.parentPOJO.shortName}Manager(${pojoAnno.parentPOJO.shortName}Manager ${pojoNameLower}Manager) {
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
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/list/${pojoNameLower}/{parentId}/php*")
    public ModelAndView listFirst(@PathVariable String libraryPath,@PathVariable ${identifierType} parentId,HttpServletRequest request)throws Exception {	
  		return list(libraryPath,parentId,"mt",request);
  	}
  	
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/list/${pojoNameLower}/{parentId}/{listFlag}/php*")
    public ModelAndView list(@PathVariable String libraryPath,@PathVariable ${identifierType} parentId,@PathVariable String listFlag,HttpServletRequest request)throws Exception {
        Model model = new ExtendedModelMap();
        model.addAttribute("listFlag",listFlag);
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        if (parentId!=null) {
            ${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(parentId);
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        }
        return new ModelAndView("${path}/${pojo.shortName}List", model.asMap());
    }
    
 <#--
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/view/{${pojo.identifierProperty.name}}/php*",method = RequestMethod.GET)
    public ModelAndView view(@PathVariable String libraryPath,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name})throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", false);
        if (${pojo.identifierProperty.name}!=null) {
            ${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(${pojo.identifierProperty.name});
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
  -->
  


    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/add/${pojoNameLower}/{parentId}/php*",method = RequestMethod.GET)
    @FormToken(save=true)    
    public ModelAndView add(@PathVariable String libraryPath,@PathVariable ${pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)} parentId)throws Exception {
    	Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        ${pojo.shortName} ${childPOJONameLower}= new  ${pojo.shortName}();
        
        <#-- use UUID  as ID -->
         ${childPOJONameLower}.${childSetIdMethodName}(UUIDUtil.genBase64UUID()); 
              
        <#if libraryExits>
        	${childPOJONameLower}.setLibrary(LibraryInfoCache.getInstance().getLibraryIdByPath(libraryPath));
        	${childPOJONameLower}.setOvert(false);
        </#if>    
        ${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= new ${pojoAnno.parentPOJO.shortName}();
        ${pojoNameLower}.${setIdMethodName}(parentId);
        model.addAttribute("${pojoNameLower}", ${pojoNameLower});
        model.addAttribute("${childPOJONameLower}", ${childPOJONameLower});
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", "1");

        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/edit/{${pojo.identifierProperty.name}}/${pojoNameLower}/{parentId}/php*",method = RequestMethod.GET)
    @FormToken(save=true)    
    public ModelAndView edit(@PathVariable String libraryPath,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name},@PathVariable ${pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)} parentId)throws Exception {
    	
        Model model = new ExtendedModelMap();
    	super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
    	model.addAttribute("formEditFlag", true);   	
        if (parentId!=null && ${pojo.identifierProperty.name}!=null) {
            ${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(parentId);
            ${pojo.shortName} ${childPOJONameLower}=null;
            List<${pojo.shortName}> list=${pojoNameLower}.${pojoAnno.parentPOJO.getGetterSignature(pojoAnno.childPropInParent)}();
            for(${pojo.shortName} one:list){
            	if(one.${childGetIdMethodName}().equals( ${pojo.identifierProperty.name})){
            		${childPOJONameLower}=one;
            		break;
            	}
            }
            model.addAttribute("${pojoNameLower}", ${pojoNameLower});
            model.addAttribute("${childPOJONameLower}", ${childPOJONameLower});
            
        }
        return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
    }
    
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/formSubmit/${pojoNameLower}/{parentId}/php*",method = RequestMethod.POST)
    @FormToken(remove=true)
    public ModelAndView onSubmit(@PathVariable String libraryPath,${pojo.shortName} ${childPOJONameLower},@PathVariable ${pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)} parentId,  HttpServletRequest request,
                           HttpServletResponse response)throws Exception {                
                           
        Model model = new ExtendedModelMap(); 
        super.libraryAndPropertyPass(model, DM_FORM_NAME, libraryPath);
        model.addAttribute("formEditFlag", true);
        model.addAttribute("addFlagOf${pojo.shortName}Form", request.getParameter("addFlagOf${pojo.shortName}Form"));
        
        if (validator != null) { // validator is null during testing     
        	ServerValidataResult svr=new ServerValidataResult();      	
        	validate(${childPOJONameLower}, svr);      	

            if (svr.hasErrors()) { // don't validate when deleting
            	saveError(request,svr.getAllErrorMessage());
        		return new ModelAndView("${path}/${pojo.shortName}Form", model.asMap());
            }
        }
        log.debug("entering 'onSubmit' method...");

       	${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(parentId);
        
        boolean isNew = ("1".equals(request.getParameter("addFlagOf${pojo.shortName}Form")));
        
        if(isNew){
        	if(${pojoNameLower}.${pojoAnno.parentPOJO.getGetterSignature(pojoAnno.childPropInParent)}()==null){
        		${pojoNameLower}.set${pojoAnno.parentPOJO.getPropertyName(pojoAnno.childPropInParent)}(new ArrayList<${pojo.shortName}>());
        	}
        	${pojoNameLower}.${pojoAnno.parentPOJO.getGetterSignature(pojoAnno.childPropInParent)}().add(${childPOJONameLower});
        }else{
        	
            List<${pojo.shortName}> list=${pojoNameLower}.${pojoAnno.parentPOJO.getGetterSignature(pojoAnno.childPropInParent)}();
            for(${pojo.shortName} one:list){
            	if(one.${childGetIdMethodName}().equals(${childPOJONameLower}.${childGetIdMethodName}())){
            	<#foreach field in pojo.getAllPropertiesIterator()>	
            		<#if field.equals(pojo.identifierProperty)>					    					    
					<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >					
					<#else>
					one.${'set' + pojo.getPropertyName(field)}(${childPOJONameLower}.${pojo.getGetterSignature(field)}());						
					
            		</#if>
            	</#foreach>	
            		break;
            	}
            }
              	
        }
        String success = "redirect:/lb/{libraryPath}/${childPOJONameLower}/list/${pojoNameLower}/" + parentId+"/mt/php";
        Locale locale = request.getLocale();
      
        ${pojoNameLower}Manager.save(${pojoNameLower});

        String key = (isNew) ? "${childPOJONameLower}.added" : "${childPOJONameLower}.updated";
        saveMessage(request, getText(key, locale));

        return new ModelAndView(success, model.asMap());
    }
    @RequestMapping(value = "/lb/{libraryPath}/${childPOJONameLower}/delete/{${pojo.identifierProperty.name}}/${pojoNameLower}/{parentId}/php*",method = RequestMethod.POST)
    public ModelAndView delete(@PathVariable String libraryPath,@PathVariable ${pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)} parentId,HttpServletRequest request,
            HttpServletResponse response,@PathVariable ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)} ${pojo.identifierProperty.name})throws Exception {
        
        Model model = new ExtendedModelMap(); 
    	Locale locale = request.getLocale();
    	${pojoAnno.parentPOJO.shortName} ${pojoNameLower}= ${pojoNameLower}Manager.get(parentId);
    	
    	${pojo.shortName} ${childPOJONameLower}1=null;
        List<${pojo.shortName}> list=${pojoNameLower}.${pojoAnno.parentPOJO.getGetterSignature(pojoAnno.childPropInParent)}();
        for(${pojo.shortName} one:list){
        	if(one.${childGetIdMethodName}().equals(${pojo.identifierProperty.name})){
        		${childPOJONameLower}1=one;
        		break;
        	}
        }
        if(${childPOJONameLower}1!=null){
        	list.remove(${childPOJONameLower}1);
        }
        
        ${pojoNameLower}Manager.save(${pojoNameLower});
        
        saveMessage(request, getText("${pojoNameLower}.deleted", locale));
        String success = "redirect:/lb/{libraryPath}/${childPOJONameLower}/list/${pojoNameLower}/" + parentId+"/mt/php?pageGroupType=back";
        return new ModelAndView(success, model.asMap());
    }   
     
}
