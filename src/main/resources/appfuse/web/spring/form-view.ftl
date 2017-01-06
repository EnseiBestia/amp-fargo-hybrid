<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>
<#if pojoAnno.foreignParentPOJO?exists >
	<#assign foreignParentKeyPath = "${pojoAnno.foreignParentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.foreignParentPOJO.shortName.substring(1)}/${'$'}{${pojoAnno.foreignParentPOJO.identifierProperty.name}}/">
<#else>
	<#assign foreignParentKeyPath = "">
</#if>
<#global dateExists = false>

<#import "form-view-macro.ftl" as formMacro>

<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/messages.jsp" %>
<head>
    <title><fmt:message key="${pojoNameLower}Detail.title"/></title>
    <meta name="heading" content="<fmt:message key='${pojoNameLower}Detail.heading'/>"/>
</head>
<c:set var="delObject" scope="request"><fmt:message key="${pojoNameLower}List.${pojoNameLower}"/></c:set>
<script type="text/javascript">var msgDelConfirm =
   "<fmt:message key="delete.confirm"><fmt:param value=${'"'}${r"${delObject}"}${'"'}/></fmt:message>";
</script>

<h2><fmt:message key="${pojoNameLower}Detail.heading"/></h2>
<!--<div class="widget-box widget-plain">
<div class="widget-content">



</div>
</div>-->
<div class="widget-box">
	<div class="widget-title">
		<span class="icon">
			<i class="fa fa-align-justify"></i>									
		</span>
		<h5><fmt:message key="${pojoNameLower}Detail.message"/></h5>
	</div>
	<div class="widget-content nopadding">
	
<form:form commandName="${pojoNameLower}" cssClass="form-horizontal"
           id="${pojoNameLower}Form" onsubmit="return validate${pojo.shortName}(this)">
<#rt/>
<@formMacro.formComponent />

	<%@ include file="/scripts/customProperty.jsp" %>
    <div class="form-actions">
    
    
    <c:if test="${'$'}{!formEditFlag && !empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-edit']}">
	<button type="button" class="btn btn-purple" id="bt-${pojoNameLower}-edit" >
       		<i class="fa fa-edit"></i> <fmt:message key="button.edit"/>
    </button>
    	
    </c:if>
    <c:if test="${'$'}{formEditFlag}">
        <button type="button" class="btn btn-yellow" id="bt-${pojoNameLower}-save" >
            <i class="fa fa-check"></i> <fmt:message key="button.save"/>
        </button>
    </c:if>
        <a href='<c:url value="/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${foreignParentKeyPath}mt/php?pageGroupType=back"/>' class="btn btn-dark-green">
            <i class="fa fa-reply"></i> <fmt:message key="button.return"/></a>
                      
    </div>
</form:form>
</div>
</div>

<#foreach childPojoclass in pojoAnno.childrenPOJOList>

<div class="div_iframe" id="${childPojoclass.shortName}Of${pojo.shortName}ListDiv">
	<c:if test="${'$'}{addFlagOf${pojo.shortName}Form!='1'}">
	<%@ include file="${childPojoclass.shortName}List.jsp" %>
	</c:if>
</div>

</#foreach>


<appfuse:javascriptValidate formName="${pojoNameLower}" cdata="false" dynamicJavascript="true" staticJavascript="false"/>


<script type="text/javascript">
		
    $(document).ready(function() {
    	$('#bt-${pojoNameLower}-edit').click(function(){
    		$(this).attr('disabled',true)
			ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/edit/${'$'}{${pojoNameLower}.${pojo.identifierProperty.name}}/${foreignParentKeyPath}php");
    	});
    	
    	$('#bt-${pojoNameLower}-save').click(function(){
    		$(this).attr('disabled',true);
			if(validate_${pojoNameLower}Form.form()){
				ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/formSubmit/${foreignParentKeyPath}php","post","${pojoNameLower}Form");
			}else{
				$(this).attr('disabled',false);
			}
    	});
    	
        <c:if test="${'$'}{formEditFlag}">
         $("input[type='text']:visible:enabled:first", document.forms['${pojoNameLower}Form']).focus();
<#if dateExists>
        ${'$'}('.datepicker123').datepicker();
</#if>	
		</c:if>
        <c:if test="${'$'}{!formEditFlag}">
        	$("#${pojoNameLower}Form input").attr("disabled","disabled");  	
        	$("#${pojoNameLower}Form select").attr("disabled","disabled");
        	$("#${pojoNameLower}Form textarea").attr("disabled","disabled");
    	</c:if>
    	
    	<#foreach field in pojo.getAllPropertiesIterator()>
			<#if pojoAnno.annoFieldUtil.isFixedProperty(field) >

        
	        	<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).type==2  || pojoAnno.annoFieldUtil.getAnnoInfo(field).type==4>
	        		<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
						${'$'}("#${field.name}").on("change", function(e) { 			
				    		validate_${pojoNameLower}Form.element(${'$'}("#${field.name}"));
						})	        		
	        		</#if>
	        		
	        	<#else>
	        		<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
						${'$'}("#${field.name}_fullId").on("change", function(e) { 			
				    		validate_${pojoNameLower}Form.element(${'$'}("#${field.name}_fullId"));
						})	        		
	        		</#if>	        	   	
	        		
	        	</#if>
		
			<#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
	
	        		<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
						${'$'}("#${field.name}").on("change", function(e) { 			
				    		validate_${pojoNameLower}Form.element(${'$'}("#${field.name}"));
						})	        		
	        		</#if>
			<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) >
			
		    		
			<#elseif pojoAnno.annoFieldUtil.isCommonForeignKey(field) >
	        		<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
						${'$'}("#${field.name}").on("change", function(e) { 			
				    		validate_${pojoNameLower}Form.element(${'$'}("#${field.name}"));
						})	        		
	        		</#if>			
		    
			
			</#if>
    	</#foreach>
    	
	    <c:forEach var="v_customProperty" items="${'$'}{customPropertyList}">
	            <c:if test="${'$'}{v_customProperty.valueType=='AVF' && v_customProperty.multiple}">           	
	            		${'$'}("#customPropertyMap_${'$'}{v_customProperty.propertyCode}").on("change", function(e) { 			
					    		validate_${pojoNameLower}Form.element(${'$'}("#customPropertyMap_${'$'}{v_customProperty.propertyCode}"));
						})         	
	        	</c:if>      	
		</c:forEach>
    });
    
</script>
