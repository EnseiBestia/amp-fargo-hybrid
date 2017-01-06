<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>

<#assign dateExists = false>
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
<input type="hidden" name="addFlagOf${pojo.shortName}Form"  value="${'$'}{addFlagOf${pojo.shortName}Form}"/>   
<#foreach field in pojo.getAllPropertiesIterator()>
<#if field.equals(pojo.identifierProperty)>
    <#assign idFieldName = field.name>
    
    <#lt/><form:hidden path="${field.name}"/>
    
<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >

	<div class="form-group">    
       	<label class="col-sm-3 col-md-3 col-lg-2 control-label"><fmt:message key="${pojoNameLower}.${field.name}"/>
			<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
				<span class="required"> *</span>		
			</#if>
		</label>
        <div class="col-sm-9 col-md-9 col-lg-6">
        
        	<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).type==2  || pojoAnno.annoFieldUtil.getAnnoInfo(field).type==4>
        		<appfuse:lookupSelect2 cssClass="form-control" libraryPath="${'$'}{libraryPath}" id="${field.name}" 
        			name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" propertyCode="${field.name}" 
        			multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" />
        		
        	<#else>
        	    <appfuse:lookupSelect2 cssClass="form-control" libraryPath="${'$'}{libraryPath}" id="${field.name}_fullId" useFullId="true"
        	    	name="${field.name}.fullId" value="${'$'}{${pojoNameLower}.${field.name}.fullId}" propertyCode="${field.name}" 
        	    	multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}"/>
        	
        	</#if>
		</div>
    </div>
    
<#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
	<div class="form-group">
		<label class="col-sm-3 col-md-3 col-lg-2 control-label"><fmt:message key="${pojoNameLower}.${field.name}"/>
			<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
				<span class="required"> *</span>		
			</#if>
		</label>
        <div class="col-sm-9 col-md-9 col-lg-6">
			<appfuse:lookupSelect2 cssClass="form-control" libraryPath="${'$'}{libraryPath}" id="${field.name}" name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" enumCode="${pojoAnno.annoFieldUtil.getAnnoInfo(field).enumCode}" 
        	multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}"/>
		</div>
    </div>
<#elseif pojoAnno.annoFieldUtil.isChildProperty(field) >

<#elseif pojoAnno.annoFieldUtil.isTreeParentKey(field) >
<form:hidden path="${field.name}"/>

<#elseif pojoAnno.annoFieldUtil.isCustomProperty(field) >

<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) >
		    <div class="form-group">		    
		  				<label class="col-sm-3 col-md-3 col-lg-2 control-label"><fmt:message key="${pojoNameLower}.${field.name}"/>
							<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
								<span class="required"> *</span>		
							</#if>
						</label>
			    <div class="col-sm-9 col-md-9 col-lg-6">	            
		            <#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel]?exists>  
		            	<select id="${field.name}" name="${field.name}.${pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel].identifierProperty.name}" class="form-control"  style="width:100%;height:34px"></select>	            	        
		            </#if>
		        </div>
	        </div>
<#elseif pojoAnno.annoFieldUtil.isCommonForeignKey(field) >
			
		    <div class="form-group">		    
		  				<label class="col-sm-3 col-md-3 col-lg-2 control-label"><fmt:message key="${pojoNameLower}.${field.name}"/>
							<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
								<span class="required"> *</span>		
							</#if>
						</label>
			    <div class="col-sm-9 col-md-9 col-lg-6">	  
		            <#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel]?exists>  
		            	<appfuse:lookupSelect2 cssClass="form-control"  libraryPath="${'$'}{libraryPath}" id="${field.name}" name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}"/>	            	        
		            </#if>
		        </div>
	        </div>
<#else>
	<#foreach column in field.getColumnIterator()>
    
    <#if field.name=="library" || field.name=="overt">
        <form:hidden path="${field.name}"/>	
	</#if>
    <#if field.name!="library" && field.name!="overt">
	    
	    <div class="form-group">
	    
	        	<label class="col-sm-3 col-md-3 col-lg-2 control-label"><fmt:message key="${pojoNameLower}.${field.name}"/>
					<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
						<span class="required"> *</span>		
					</#if>
				</label>
	        <div class="col-sm-9 col-md-9 col-lg-6">
	            <#if field.value.typeName == "java.util.Date" || field.value.typeName == "date">
	            <#assign dateExists = true/>
	            <form:input path="${field.name}" id="${field.name}" size="11" title="date"  cssClass="form-control input-sm datepicker123"/>
	            <#elseif field.value.typeName == "boolean" || field.value.typeName == "java.lang.Boolean">
	            <form:checkbox path="${field.name}" id="${field.name}" cssClass="checkbox"/>
	            <#else>
	            <form:input path="${field.name}" id="${field.name}" <#if (column.length > 0)> maxlength="${column.length?c}"</#if> cssClass="form-control input-sm" />
	            </#if>
	            
	        </div>
	    </div>        	
	</#if>	

    </#foreach>
	
</#if>
</#foreach>
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
        <a href='<c:url value="/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/${'$'}{parentId}/mt/php?pageGroupType=back"/>' class="btn btn-dark-green">
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
			ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/edit/${'$'}{${pojoNameLower}.${pojo.identifierProperty.name}}/${pojoNameLower}/${'$'}{parentId}/php");
    	});
    	
    	$('#bt-${pojoNameLower}-save').click(function(){
    		$(this).attr('disabled',true);
			if(validate_${pojoNameLower}Form.form()){
				ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/formSubmit/${pojoNameLower}/${'$'}{parentId}/php","post","${pojoNameLower}Form");
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
