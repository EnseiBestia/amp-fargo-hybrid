package ${basepackage}.service.${path};

import ${basepackage}.model.${pojo.shortName};

import java.util.List;
import javax.jws.WebService;
import com.fargo.basis.service.GenericManager;

//@WebService
public interface ${pojo.shortName}Manager extends GenericManager<${pojo.shortName}, ${pojo.getJavaTypeName(pojo.identifierProperty, jdk5)}> {
    public void saveMainBody(${pojo.shortName} a0);
}