<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#assign setIdMethodName = 'set' + pojo.getPropertyName(pojo.identifierProperty)>
<#assign getIdMethodName = pojo.getGetterSignature(pojo.identifierProperty)>


package ${basepackage}.morphia.aspect.${path};

import ${basepackage}.model.${pojo.shortName};
import org.springframework.stereotype.Component;


import com.btxy.basis.morphia.aspect.base.ModelInterceptorImpl;
import com.btxy.basis.morphia.aspect.base.ModelInterceptorInterface;


public class ${pojo.shortName}InterceptorImpl implements ModelInterceptorInterface<${pojo.shortName}> {

    @Override
	public void onChange(${pojo.shortName} t, int type) {
		// TODO Auto-generated method stub
		System.out.println("======come here:${pojo.shortName}InterceptorImpl=====[t:"+t+",type:"+type+"]");
	}  
}
