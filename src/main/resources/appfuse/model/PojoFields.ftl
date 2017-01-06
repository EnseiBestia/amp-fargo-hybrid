<#foreach field in pojo.getAllPropertiesIterator()><#rt/>
	<#if pojo.getMetaAttribAsBool(field, "gen-property", true)><#rt/>
				<#foreach column in field.columnIterator>
					<#if column.comment?exists && column.comment?trim?length!=0>     
						 <#lt/>	@FieldAnnoExtend(description="${column.comment}")
					</#if>
				</#foreach>
		<#if pojo.hasIdentifierProperty()><#rt/>
	        <#if field.equals(clazz.identifierProperty)><#rt/>
			<#lt/>	@org.mongodb.morphia.annotations.Id
	        </#if><#rt/>
    	</#if><#rt/>
	    <#lt/>	${pojo.getFieldModifiers(field)} ${pojo.getJavaTypeName(field, jdk5)} ${field.name}<#if pojo.hasFieldInitializor(field, jdk5)> = ${pojo.getFieldInitialization(field, jdk5)}</#if>;
	</#if><#rt/>
</#foreach><#rt/>