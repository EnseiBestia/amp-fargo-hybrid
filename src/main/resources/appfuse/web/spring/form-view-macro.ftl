<#macro formComponent >
	<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
	<#assign idx=1>
	<input type="hidden" name="addFlagOf${pojo.shortName}Form"  value="${'$'}{addFlagOf${pojo.shortName}Form}"/>   
	<input type="hidden" name="formToken"  value="${'$'}{formToken}"/>   
	<#foreach field in pojo.getAllPropertiesIterator()>
		<#if field.equals(pojo.identifierProperty)>
		    <#assign idFieldName = field.name>
		    <#lt/><form:hidden path="${field.name}"/>
		<#elseif pojoAnno.annoFieldUtil.isTreeParentKey(field) >
			<form:hidden path="${field.name}"/>	
		<#elseif field.name=="library" || field.name=="overt" >
			<form:hidden path="${field.name}"/>	
	 	<#elseif pojoAnno.annoFieldUtil.isChildProperty(field) >
		<#elseif pojoAnno.annoFieldUtil.isCustomProperty(field) >		
		<#elseif pojoAnno.annoFieldUtil.isFileKey(field) >		
		<#else>
			<#if idx%2!=0>
			<div style="" class="form-group">
			</#if>
				<div class="col-md-6">
			       	<label class="col-md-3 control-label cont-label-style"><fmt:message key="${pojoNameLower}.${field.name}"/>
						<#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.annoFieldUtil.getAnnoInfo(field).required>
							<span class="required"> *</span>		
						</#if>
					</label>
			        <div class="col-md-8 col-md-style">
			        	<#if pojoAnno.annoFieldUtil.isFixedProperty(field) >
				        	<#if pojoAnno.annoFieldUtil.getAnnoInfo(field).type==2  || pojoAnno.annoFieldUtil.getAnnoInfo(field).type==4>
				        		<appfuse:lookupSelect2 cssClass="form-control form-lineheight" libraryPath="${'$'}{libraryPath}" id="${field.name}" 
				        			name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" propertyCode="${field.name}" 
				        			multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" dataSource="${daoFramework}" />
				        		
				        	<#else>
				        	    <appfuse:lookupSelect2 cssClass="form-control form-lineheight" libraryPath="${'$'}{libraryPath}" id="${field.name}_fullId" useFullId="true"
				        	    	name="${field.name}.fullId" value="${'$'}{${pojoNameLower}.${field.name}.fullId}" propertyCode="${field.name}" 
				        	    	multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" dataSource="${daoFramework}"/>
				        	
				        	</#if>
				        <#elseif pojoAnno.annoFieldUtil.isEnumProperty(field) >
				        	<appfuse:lookupSelect2 cssClass="form-control form-lineheight" libraryPath="${'$'}{libraryPath}" id="${field.name}" name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" enumCode="${pojoAnno.annoFieldUtil.getAnnoInfo(field).enumCode}" 
				        	multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}" type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" dataSource="${daoFramework}"/>
						<#elseif pojoAnno.annoFieldUtil.isForeignKey(field) >
				            <#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel]?exists>  
					            <appfuse:lookupSelect2 cssClass="form-control form-lineheight"  libraryPath="${'$'}{libraryPath}" 
					            		id="${field.name}.${pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel].identifierProperty.name}" 
					            		name="${field.name}.${pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel].identifierProperty.name}" 
					            		value="${'$'}{${pojoNameLower}.${field.name}.${pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel].identifierProperty.name}}" 
										formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}"
										 multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"
										type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" dataSource="${daoFramework}"/>	            	        
				            </#if>	
						<#elseif pojoAnno.annoFieldUtil.isCommonForeignKey(field) >		 
				            <#if pojoAnno.annoFieldUtil.getAnnoInfo(field)?exists &&  pojoAnno.allPOJOMap[pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel]?exists>  
								<appfuse:lookupSelect2 cssClass="form-control form-lineheight"  libraryPath="${'$'}{libraryPath}" id="${field.name}" name="${field.name}" value="${'$'}{${pojoNameLower}.${field.name}}" 
									formName="${pojoAnno.annoFieldUtil.getAnnoInfo(field).foreignModel}" multiple="${pojoAnno.annoFieldUtil.getAnnoInfo(field).multiple?string('true', 'false')}"
									 type="${pojoAnno.annoFieldUtil.getAnnoInfo(field).type}" dataSource="${daoFramework}"/>	            	        
							</#if>     
						<#else>
							<#foreach column in field.getColumnIterator()>
						    	<#if field.name!="library" && field.name!="overt">
								            <#if field.value.typeName == "java.util.Date" || field.value.typeName == "date">
								            	<#global dateExists = true/>
								            	<form:input path="${field.name}" id="${field.name}" size="11" title="date"  cssClass="form-control input-sm datepicker123"/>
								            <#elseif field.value.typeName == "boolean" || field.value.typeName == "java.lang.Boolean">
								            	<form:checkbox path="${field.name}" id="${field.name}" cssClass="checkbox"/>
								            <#else>
								            	<form:input path="${field.name}" id="${field.name}" <#if (column.length > 0)> maxlength="${column.length?c}"</#if> cssClass="form-control input-sm" />
								            </#if>
								</#if>	
					    	</#foreach>		
					    </#if>   
					</div>   				
				</div>
			<#if idx%2==0||!pojo.getAllPropertiesIterator().hasNext()>	
			</div>
			</#if>
			<#assign idx=idx+1>
		</#if>
	</#foreach>
</#macro>