<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>
<#assign nameProperty = pojo.identifierProperty>

<#foreach annotmp in pojoAnno.annoFieldUtil.annoInfoes>   	
    <#if annotmp.name>
    	<#assign nameProperty = annotmp.property>
    </#if>
</#foreach>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/messages.jsp" %>

<c:if test="{'$'}{not empty searchError}">
    <div class="alert alert-error fade in">
        <a href="#" data-dismiss="alert" class="close">&times;</a>
        <c:out value="{'$'}{searchError}"/>
    </div>
</c:if>


<div class="row <c:if test="${'$'}{listFlag!='select1' && listFlag!='select2'}">row-list-title-row</c:if>" >
<c:if test="${'$'}{listFlag!='select1' && listFlag!='select2'}">
	<div class="col-xs-12 col-sm-3 nopadding" id="search-div-title">
		<h2><fmt:message key="${pojoNameLower}List.heading"/></h2>
		
		<div class="widget-box widget-plain">
		<div class="widget-content">
			<div class="input-group nopadding">
				<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-add']}">
			    	<button type="button" class="btn btn-purple" id="bt-${pojoNameLower}-add" >
			   		 	<i class="fa fa-plus"></i> <fmt:message key="button.add"/>
			   	</button>		
			   	</c:if>
			   	<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-delete']}">
			    	<button type="button" class="btn btn-dark-red" id="bt-${pojoNameLower}-delete">
			   			<i class="fa fa-trash-o"></i> <fmt:message key="button.delete"/></button>	
			   	</c:if>
			</div>
		</div>
		</div>
	</div>
</c:if>		
	<#if pojoAnno.annoFieldUtil.combinedSearch>
		<div class="<c:if test="${'$'}{listFlag!='select1' && listFlag!='select2'}">col-xs-12 col-sm-9 row-list-title-col-search</c:if><c:if test="${'$'}{listFlag=='select1' || listFlag=='select2'}">col-xs-12 col-sm-12</c:if>" id="search-div-content">
		<form:form commandName="searchValue" id="${pojoNameLower}SearchForm" class="form-inline nopadding">
			<#foreach field in pojo.getAllPropertiesIterator()>
				<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists && pojoAnno.annoFieldUtil.getAnnoInfo(field).combinedSearch>
					
					<div class="form-group row-list-form-group">
		    			<div class="input-group nopadding">
		      				<div class="input-group-addon row-form-search-label"><fmt:message key="${pojoNameLower}.${field.name}"/></div>
		      			
					<#if pojoAnno.annoFieldUtil.isEnumProperty(field) >
								<appfuse:lookupSelect2 cssClass="form-control" libraryPath="${'$'}{libraryPath}" id="combinedConditionValue_${field.name}" name="combinedConditionValue['${field.name}']" value="${'$'}{searchValue.combinedConditionValue['${field.name}']}" 
				            		enumCode="${pojoAnno.annoFieldUtil.getAnnoInfo(field).enumCode}" multiple="true" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" cssStyle="width:200px"/>
					<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >
								<appfuse:lookupSelect2 cssClass="form-control" libraryPath="${'$'}{libraryPath}" id="combinedConditionValue_${field.name}" name="combinedConditionValue['${field.name}']" value="${'$'}{searchValue.combinedConditionValue['${field.name}']}" 
				            		propertyCode="${field.name}" multiple="true" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" cssStyle="width:200px"/>												
					</#if>
						</div>
		  			</div>
				</#if>
				<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists && pojoAnno.annoFieldUtil.getAnnoInfo(field).textSearch>
					<div class="form-group row-list-form-group">
		    			<div class="input-group nopadding">
		      				<div class="input-group-addon row-form-search-label" ><fmt:message key="${pojoNameLower}.${field.name}"/></div>
		      				<c:if test="${'$'}{empty searchValue.combinedConditionValue['${field.name}']}">
		      				<form:input path="combinedConditionValue['${field.name}']" id="combinedConditionValue_${field.name}"  cssClass="form-control form-input-init-null row-form-search-input" value=""/>	
		      				</c:if>
		      				<c:if test="${'$'}{!empty searchValue.combinedConditionValue['${field.name}']}">
		      				<form:input path="combinedConditionValue['${field.name}']" id="combinedConditionValue_${field.name}"  cssClass="form-control"  />	
		      				</c:if>
		      			</div>
		  			</div>
				</#if>
			</#foreach>
			
			<div class="form-group row-list-form-group" >	
			      <button class="btn btn-primary" type="button" id="bt-${pojoNameLower}-textSearch"><i class="fa fa-search"></i> <fmt:message key="button.textSearch"/></button>
			</div>				
			

		</form:form>
		</div>
	<#elseif pojoAnno.annoFieldUtil.textSearch>
		<div class="col-xs-12 col-sm-4" style="position:absolute;bottom:0;right:0;padding-right:0px">
		<form:form commandName="searchValue" id="${pojoNameLower}SearchForm">
			<div class="input-group nopadding">
					<form:input path="textValue" id="textValue"  cssClass="form-control" />
					
			      	<span class="input-group-btn">
			        	<button class="btn btn-primary" type="button" id="bt-${pojoNameLower}-textSearch"><i class="fa fa-search"></i> <fmt:message key="button.textSearch"/></button>
			      	</span>	  	
			</div>	
		</form:form>
		</div>	
		
	</#if>
</div>           



<div class="widget-box">
	<div class="widget-title">
		<span class="icon"><i class="fa fa-th"></i></span>
		<div id="breadcrumb" style="border-top:0px;border-bottom:0px;background-color:#FAFAFA">
		<a href="${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/0/${'$'}{listFlag}/php" class="tip-bottom"><fmt:message key="title.a.root"/> </a>
		<c:forEach var="v_${pojoNameLower}" items="${'$'}{parentsList}">
			<a href="${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/${'$'}{v_${pojoNameLower}.${pojo.identifierProperty.name}}/${'$'}{listFlag}/php" class="current">${'$'}{v_${pojoNameLower}.${nameProperty.name}} </a>
		</c:forEach>
		</div>
		<appfuse:tablePageSizeSetTag formName="${pojoNameLower}" pageSize="${'$'}{pageSize}"/>
	</div>
	<div class="widget-content" style="overflow:auto;">
		
<display:table name="${pojoNameLower}List" class="table table-condensed table-striped table-hover" requestURI="${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/${'$'}{parentId}/${'$'}{listFlag}/php" id="${pojoNameLower}List" 
	export="false"  pagesize="${'$'}{pageSize}" partialList="true" size="${'$'}{totalSize}">
<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-delete'] && listFlag!='select1'}">	
	<display:column title="<input  id='${pojoNameLower}ListChkAll' type='checkbox' name='${pojoNameLower}ListChkAll' onclick='checkAllOf${pojoNameLower}List()'"> 
      <input type="checkbox" name="${pojoNameLower}ListChecklist" value="${'$'}{${pojoNameLower}List.${pojo.identifierProperty.name}}"/> 
    </display:column>
</c:if>
<c:if test="${'$'}{listFlag=='select1'}">
	<display:column> 
      <input type="radio" name="${pojoNameLower}ListChecklist" value="${'$'}{${pojoNameLower}List.${pojo.identifierProperty.name}}"/> 
    </display:column>

</c:if>
<#foreach field in pojo.getAllPropertiesIterator()>
<#if field.equals(pojo.identifierProperty)>
	<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-view'] && listFlag!='select1' && listFlag!='select2'}">
		
        <display:column sortable="false"         titleKey="${pojoNameLower}.${field.name}">
         	<a href="${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/view/${'$'}{${pojoNameLower}List.${pojo.identifierProperty.name}}/${pojoNameLower}/${'$'}{${pojoNameLower}List.parent}/php">
         		${'$'}{${pojoNameLower}List.${field.name}}</a>
        </display:column>
         
	</c:if>
	<c:if test="${'$'}{empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-view'] || listFlag=='select1' || listFlag=='select2'}">
		<display:column property="${field.name}" sortable="false" titleKey="${pojoNameLower}.${field.name}"/>
	</c:if>	
<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >
   	<display:column sortable="false" titleKey="${pojoNameLower}.${field.name}">
    <#if pojoAnno.annoFieldUtil.getAnnoInfo(field).type==2 || pojoAnno.annoFieldUtil.getAnnoInfo(field).type==4>
		<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
			value="${'$'}{${pojoNameLower}List.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"/>
	<#else>
		<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
			<c:forEach var="fieldItems" items="${'$'}{${pojoNameLower}List.${field.name}.id}" varStatus="fieldStatus">
			<c:if test="${'$'}{!fieldStatus.first}">
			,
			</c:if>
			<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
				value="${'$'}{fieldItems.id}" multiple="false"/>
		<#else>
		
			<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
			value="${'$'}{${pojoNameLower}List.${field.name}.id}" multiple="false"/>
		</#if> 
		
		
	</#if>    	       	
	</display:column>  
        	
	
<#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
	<display:column sortable="false" titleKey="${pojoNameLower}.${field.name}">
		<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" 
			value="${'$'}{${pojoNameLower}List.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"/>
		
	</display:column>
<#elseif pojoAnno.annoFieldUtil.isChildProperty(field) >
<#elseif pojoAnno.annoFieldUtil.isTreeParentKey(field) >
<#elseif pojoAnno.annoFieldUtil.isCustomProperty(field) >

<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) >
	<display:column sortable="false" titleKey="${pojoNameLower}.${field.name}">
		<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}" 
			value="${'$'}{${pojoNameLower}List.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"/>
	</display:column>
<#elseif pojoAnno.annoFieldUtil.isCommonForeignKey(field) >

	<display:column sortable="false" titleKey="${pojoNameLower}.${field.name}">
		<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}" 
			value="${'$'}{${pojoNameLower}List.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"/>
	</display:column>
<#elseif field.name!="library" && field.name!="overt">
	<#if field.value.typeName == "java.util.Date" || field.value.typeName == "date">
        <#lt/>    <display:column sortProperty="${field.name}" sortable="false" titleKey="${pojoNameLower}.${field.name}">
        <#lt/>         <fmt:formatDate value="${'$'}{${pojoNameLower}List.${field.name}}" pattern="${'$'}{datePattern}"/>
        <#lt/>    </display:column>
    <#elseif field.value.typeName == "boolean">
        <#lt/>    <display:column sortProperty="${field.name}" sortable="false" titleKey="${pojoNameLower}.${field.name}">
        <#lt/>        <input type="checkbox" disabled="disabled" <c:if test="${'$'}{${pojoNameLower}List.${field.name}}">checked="checked"</c:if>/>
        <#lt/>    </display:column>
    <#else>
        <#lt/>    <display:column property="${field.name}" sortable="false" titleKey="${pojoNameLower}.${field.name}"/>
    </#if>
	    
    
</#if>
</#foreach>

<display:column sortable="false"  titleKey="title.operate">
	<a href="${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/${'$'}{${pojoNameLower}List.${pojo.identifierProperty.name}}/${'$'}{listFlag}/php">
    	<fmt:message key="button.listChild"/>
    </a>	
</display:column>
</display:table>
</div>
</div>

<script type="text/javascript">
	
	function checkAllOf${pojoNameLower}List(){
			
		if($("#${pojoNameLower}ListChkAll").prop('checked') ==true){
			$("input[name='${pojoNameLower}ListChecklist']").prop("checked",true);
		}else{
			$("input[name='${pojoNameLower}ListChecklist']").prop("checked",false);
		}
	}
	$(document).ready(function() {
	<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-add']}">
		$('#bt-${pojoNameLower}-add').click(function(){
    		$(this).attr('disabled',true)
			ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/add/${pojoNameLower}/${'$'}{parentId}/php");
    	});
    </c:if>
	<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${pojoNameLower}-delete']}">	
    	$('#bt-${pojoNameLower}-delete').click(function(){
    		$(this).attr('disabled',true);
			var selstrs=""
			$("input[name='${pojoNameLower}ListChecklist']").each(function(){
			     if ($(this).prop("checked")==true) {
			    	selstrs=selstrs+ $(this).attr("value")+"-";
			    }
			});
			if(selstrs==""){
				alertMessageOfUnicorn("<fmt:message key='message.selectnull.ondelete'/>");
				$(this).attr('disabled',false);
			}else{
				if(confirmDeleteMessage()){
					ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/delete/"+selstrs+"/${pojoNameLower}/${'$'}{parentId}/php",'post');
				}else{
					$(this).attr('disabled',false);
				}
			}
    	});
    </c:if>	
    	<#if pojoAnno.annoFieldUtil.textSearch || pojoAnno.annoFieldUtil.combinedSearch>
    	$('#bt-${pojoNameLower}-textSearch').click(function(){
    		$(this).attr('disabled',true)
			ajaxLoadHtmlInDiv($(this),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/list/${pojoNameLower}/${'$'}{parentId}/${'$'}{listFlag}/php","post","${pojoNameLower}SearchForm","");
    	});
    	</#if>
    	
		$("#${pojoNameLower}SearchForm .form-input-init-null").attr("value","");  		
		
		<c:if test="${'$'}{listFlag!='select1' && listFlag!='select2'}">
    	 		
		reInitTitleDivHeight("search-div-title","search-div-content");
		</c:if>	
		
		<#foreach field in pojo.getAllPropertiesIterator()>
				<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists && pojoAnno.annoFieldUtil.getAnnoInfo(field).combinedSearch>	
					<#if pojoAnno.annoFieldUtil.isEnumProperty(field) || pojoAnno.annoFieldUtil.isFixedProperty(field) >
					
						${'$'}("#combinedConditionValue_${field.name}").on("change", function(e) { 
							
							reInitTitleDivHeight("search-div-title","search-div-content");
							
							
						})
					</#if>
				</#if>
			</#foreach>
	});
</script>

