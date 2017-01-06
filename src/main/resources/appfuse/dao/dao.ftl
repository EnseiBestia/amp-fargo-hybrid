package ${basepackage}.dao.${path};

<#assign classbody>
<#assign pojoName = pojo.importType(pojo.getDeclarationName())>
import ${basepackage}.model.${pojo.shortName};
import com.fargo.basis.dao.GenericDao;


/**
 * An interface that provides a data management interface to the ${pojoName} table.
 */
public interface ${pojoName}Dao extends GenericDao<${pojoName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> {
</#assign>
${pojo.generateImports()}
${classbody}
public void saveMainBody(${pojoName} a0);
}