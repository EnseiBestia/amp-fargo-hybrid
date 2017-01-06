<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign setIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>


package ${basepackage}.dao.${path};

import ${basepackage}.model.${pojo.shortName};
import ${basepackage}.dao.${path}.${pojo.shortName}Dao;
import org.springframework.stereotype.Repository;

import org.mongodb.morphia.query.Query;
import com.btxy.basis.util.list.ListUtil;
import com.fargo.basis.common.model.SearchConditionValue;
import com.fargo.basis.dao.mongodb.GenericDaoMongodb;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

@Repository("${pojoNameLower}Dao")
public class ${pojo.shortName}DaoMongodb extends GenericDaoMongodb<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> implements ${pojo.shortName}Dao {

	@Override
	public void saveMainBody(${pojo.shortName} ${pojoNameLower})  {
		${pojo.shortName} ${pojoNameLower}2=super.get(${pojoNameLower}.${getIdMethodName}());
		if(${pojoNameLower}!=null && ${pojoNameLower}2!=null){
			<#foreach annoInfo in pojoAnno.annoFieldUtil.annoInfoes>
				<#if annoInfo.type==5 || annoInfo.type==8>
			${pojoNameLower}.set${pojo.getPropertyName(annoInfo.property)}(${pojoNameLower}2.${pojo.getGetterSignature(annoInfo.property)}());
				</#if>
			</#foreach>
		}	
		super.save(${pojoNameLower});
	        <#--Field[] fields = ${pojo.shortName}.class.getDeclaredFields();
	        for(Field field : fields)
	        {
	            String name = field.getName();
	            
	            String firstLetter = name.substring(0,1).toUpperCase(); 
	            String getMethodName = "get" + firstLetter + name.substring(1);
	            String setMethodName = "set" + firstLetter + name.substring(1);            
	            //System.out.println(getMethodName + "," + setMethodName);
	            try{
		            Method getMethod = ${pojo.shortName}.class.getMethod(getMethodName, new Class[]{});
		            Method setMethod = ${pojo.shortName}.class.getMethod(setMethodName, new Class[]{field.getType()});
		            if(getMethod!=null && setMethod!=null){
			            Object value = getMethod.invoke(${pojoNameLower}2, new Object[]{});
			            if(value instanceof java.util.ArrayList<?>){
			            	List tmp=(java.util.ArrayList<?>)value;
			            	if(tmp.size()>0){
			            		if(!(tmp.get(0) instanceof String || tmp.get(0) instanceof Boolean 
			            				|| tmp.get(0) instanceof Integer || tmp.get(0) instanceof Long 
			            				|| tmp.get(0) instanceof Float || tmp.get(0) instanceof Double  )){
						            setMethod.invoke(${pojoNameLower}, new Object[]{value});
						            System.out.println("setMethod.invoke:"+name+"|"+value.getClass()+"|"+value);
			            		}
			            	}
			            }
			            
		            }
		            
		            
	            }catch(NoSuchMethodException e){
	            	//e.printStackTrace();
	            } catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
	            
	        }-->
	}    
	@Override
	protected void assembleQryParam(SearchConditionValue searchValue,Query<${pojo.shortName}> q) {
		<#if pojoAnno.foreignParentPOJO?exists >
			q.and(q.criteria("${pojoAnno.foreignParentPOJO.identifierProperty.name}").equal(${pojoAnno.foreignParentPOJO.identifierProperty.name}));
		</#if> 
		<#if pojoAnno.annoFieldUtil.textSearch>
		if(searchValue.getTextValue()!=null && !"".equals(searchValue.getTextValue())){
			${pojoAnno.annoFieldUtil.getTextSearchStr()};
		}
		</#if>
		<#if pojoAnno.annoFieldUtil.combinedSearch>
			<#-- if(searchValue.getTextValue()!=null && !"".equals(searchValue.getTextValue())){} -->
			${pojoAnno.annoFieldUtil.getConditionSearchStr()}
		</#if>
	}
	
}
