<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign identifierType = pojo.getJavaTypeName(pojo.identifierProperty, jdk5)>

<#assign parentPojoNameLower = pojoAnno.parentPOJO.shortName.substring(0,1).toLowerCase()+pojoAnno.parentPOJO.shortName.substring(1)>
<#assign parentIdentifierType = pojoAnno.parentPOJO.getJavaTypeName(pojoAnno.parentPOJO.identifierProperty, jdk5)>


<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/messages.jsp" %>

<c:if test="{'$'}{not empty searchError}">
    <div class="alert alert-error fade in">
        <a href="#" data-dismiss="alert" class="close">&times;</a>
        <c:out value="{'$'}{searchError}"/>
    </div>
</c:if>

<h2><fmt:message key="${pojoNameLower}List.heading"/></h2>

<div class="widget-box" id="${pojoNameLower}ListActions">
		<div class="widget-title">
			<span class="icon">
				<i class="fa fa-th"></i>
			</span>
			<h5><fmt:message key="${pojoNameLower}List.heading"/></h5>
			<div class="buttons">
					<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${parentPojoNameLower}-add']}">
				    	<button type="button" class="btn" id="bt-${pojoNameLower}-add" onclick="bt_${pojoNameLower}_add_click(this)">
				   		 	<i class="fa fa-plus"></i> <fmt:message key="button.add"/>
				   		 </button>	
				   		 				   			
				   	</c:if>
				
			</div>
		</div>
		<div class="widget-content nopadding" style="overflow:auto;">
			<table class="table table-bordered table-striped table-hover">
				<thead>
					<tr>
						<#foreach field in pojo.getAllPropertiesIterator()>
							<#if field.equals(pojo.identifierProperty)>
							<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >
								<th><fmt:message key="${pojoNameLower}.${field.name}"/></th>
							<#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
								<th><fmt:message key="${pojoNameLower}.${field.name}"/></th>
							<#elseif pojoAnno.annoFieldUtil.isChildProperty(field) >
							<#elseif pojoAnno.annoFieldUtil.isTreeParentKey(field) >

							<#elseif pojoAnno.annoFieldUtil.isCustomProperty(field) >
							<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) ||pojoAnno.annoFieldUtil.isCommonForeignKey(field)>
								<th><fmt:message key="${pojoNameLower}.${field.name}"/></th>
							<#elseif field.name!="library" && field.name!="overt">

							    <th><fmt:message key="${pojoNameLower}.${field.name}"/></th>
							</#if>
							
						</#foreach>
						
						<th><fmt:message key="title.operate"/></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="v_values" items="${'$'}{${parentPojoNameLower}.${pojoAnno.childPropInParent.name}}">
					<tr>
						<#foreach field in pojo.getAllPropertiesIterator()>
							<#if field.equals(pojo.identifierProperty)>
							
							<#elseif pojoAnno.annoFieldUtil.isFixedProperty(field) >
								<td>
								    <#if pojoAnno.annoFieldUtil.getAnnoInfo(field).type==2 || pojoAnno.annoFieldUtil.getAnnoInfo(field).type==4>
										<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
											value="${'$'}{v_values.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" dataSource="${daoFramework}"/>
									<#else>
										<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple>
											<c:forEach var="fieldItems" items="${'$'}{${pojoNameLower}List.${field.name}.id}" varStatus="fieldStatus">
											<c:if test="${'$'}{!fieldStatus.first}">
											,
											</c:if>
											<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
												value="${'$'}{fieldItems.id}" multiple="false" dataSource="${daoFramework}"/>
										<#else>
										
											<appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" propertyCode="${field.name}" 
											value="${'$'}{v_values.${field.name}.id}" multiple="false" dataSource="${daoFramework}"/>
										</#if> 
										
										
									</#if>    	 	
					        	</td>
					        	
							<#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
					
								<td><appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" 
			value="${'$'}{v_values.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" dataSource="${daoFramework}"/></td>
							<#elseif pojoAnno.annoFieldUtil.isChildProperty(field) >
							<#elseif pojoAnno.annoFieldUtil.isTreeParentKey(field) >

							<#elseif pojoAnno.annoFieldUtil.isCustomProperty(field) >
							<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) ||pojoAnno.annoFieldUtil.isCommonForeignKey(field)>
								<td><appfuse:lookupView libraryPath="${'$'}{libraryPath}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}" 
			value="${'$'}{v_values.${field.name}}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" dataSource="${daoFramework}"/></td>
						
							<#elseif field.name!="library" && field.name!="overt">
							    <#if field.value.typeName == "java.util.Date" || field.value.typeName == "date">
							        <td><fmt:formatDate value="${'$'}{v_values.${field.name}}" pattern="${'$'}{datePattern}"/></td>
							    <#elseif field.value.typeName == "boolean">
							        <td><input type="checkbox" disabled="disabled" <c:if test="${'$'}{v_values.${field.name}}">checked="checked"</c:if>/></td>
							    <#else>
							        <td>${'$'}{v_values.${field.name}}</td>
							    </#if>
							</#if>						
						</#foreach>
							
						<td>
						
						<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${parentPojoNameLower}-edit']}">
					    	<button type="button" class="btn btn-purple btn-xs" id="bt-${pojoNameLower}-edit" onclick="bt_${pojoNameLower}_edit_click(this,'${'$'}{v_values.${pojo.identifierProperty.name}}')">
					   		 	<i class="fa fa-edit"></i> <fmt:message key="button.edit"/>
					   		</button>		
					   	</c:if>
					   	<c:if test="${'$'}{!empty currentUserPrivilegeMap.privilegeMap['${parentPojoNameLower}-edit']}">
					    	<button type="button" class="btn btn-danger btn-xs" id="bt-${pojoNameLower}-delete" onclick="bt_${pojoNameLower}_delete_click(this,'${'$'}{v_values.${pojo.identifierProperty.name}}')">
					   			<i class="fa fa-trash-o"></i> <fmt:message key="button.delete"/>
					   		</button>	
					   	</c:if> 
						
						</td>
						
					</tr>
					
				</c:forEach>	
				</tbody>
		</table>							
	</div>
</div>


<script type="text/javascript">
    	function bt_${pojoNameLower}_add_click(btt){
    		btt.disabled=true;
			ajaxLoadHtmlInDiv($(btt),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/add/${parentPojoNameLower}/${'$'}{${parentPojoNameLower}.${pojoAnno.parentPOJO.identifierProperty.name}}/php");    	
    	}
    	function bt_${pojoNameLower}_edit_click(btt,pkId){
    		btt.disabled=true;
			ajaxLoadHtmlInDiv($(btt),"${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/edit/"+pkId+"/${parentPojoNameLower}/${'$'}{${parentPojoNameLower}.${pojoAnno.parentPOJO.identifierProperty.name}}/php");
    	}
    	function bt_${pojoNameLower}_delete_click(btt,pkId){
    		btt.disabled=true;
    		if(confirmDeleteMessage()){
				ajaxLoadHtmlInDiv($(btt),'${'$'}{ctx}/lb/${'$'}{libraryPath}/${pojoNameLower}/delete/'+pkId+'/${parentPojoNameLower}/${'$'}{${parentPojoNameLower}.${pojoAnno.parentPOJO.identifierProperty.name}}/php','post');
			}else{
				btt.disabled=false;
			}
    	}
</script>

