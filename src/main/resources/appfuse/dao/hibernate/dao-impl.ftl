<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>

<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>
package ${basepackage}.dao.${path};

import ${basepackage}.model.${pojo.shortName};
import ${basepackage}.dao.${path}.${pojo.shortName}Dao;
import org.springframework.stereotype.Repository;
import com.fargo.basis.dao.hibernate.GenericDaoHibernate;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.MatchMode;
import com.fargo.basis.common.model.SearchConditionValue;
import com.fargo.basis.util.list.ListUtil;
@Repository("${pojoNameLower}Dao")
public class ${pojo.shortName}DaoHibernate extends GenericDaoHibernate<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> implements ${pojo.shortName}Dao {


    public ${pojo.shortName}DaoHibernate() {
        super(${pojo.shortName}.class);
    }
    
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
		super.save(${pojoNameLower},false);
	}    
    @Override
	protected void assembleQryParam(SearchConditionValue searchValue,Criteria cr) {
		<#if pojoAnno.foreignParentPOJO?exists >
			cr.add(Restrictions.eq("${pojoAnno.foreignParentPOJO.identifierProperty.name}", ${pojoAnno.foreignParentPOJO.identifierProperty.name}));
		</#if> 
			<#--
				<#if pojoAnno.annoFieldUtil.textSearch>
					if(searchValue.getTextValue()!=null && !"".equals(searchValue.getTextValue())){
						${pojoAnno.annoFieldUtil.getTextSearchStr()};
					}
				</#if>
			-->
		<#if pojoAnno.annoFieldUtil.combinedSearch>
			${pojoAnno.annoFieldUtil.getConditionSearchStr()}
		</#if>
	}
}

