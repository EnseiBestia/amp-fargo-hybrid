<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
package ${basepackage}.service.${path};

import ${basepackage}.dao.${path}.${pojo.shortName}Dao;
import ${basepackage}.model.${pojo.shortName};
import ${basepackage}.service.${path}.${pojo.shortName}Manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import javax.jws.WebService;
import com.fargo.basis.service.GenericManagerImpl;


@Service("${pojoNameLower}Manager")
//@WebService(serviceName = "${pojo.shortName}Service", endpointInterface = "${basepackage}.service.${pojo.shortName}Manager")
public class ${pojo.shortName}ManagerImpl extends GenericManagerImpl<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> implements ${pojo.shortName}Manager {
    ${pojo.shortName}Dao ${pojoNameLower}Dao;

    @Autowired
    public ${pojo.shortName}ManagerImpl(${pojo.shortName}Dao ${pojoNameLower}Dao) {
        super(${pojoNameLower}Dao);
        this.${pojoNameLower}Dao = ${pojoNameLower}Dao;
    }
    @Override
	public void saveMainBody(${pojo.shortName} ${pojoNameLower}) {
		// TODO Auto-generated method stub
		this.${pojoNameLower}Dao.saveMainBody(${pojoNameLower});
	}
}