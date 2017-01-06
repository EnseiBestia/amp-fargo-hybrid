package org.appfuse.anno;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.TYPE)  
@Retention(RetentionPolicy.RUNTIME)  
public @interface TableAnnoExtend {
	public String description() default"";
	public boolean textSearch() default true;
	public boolean combinedSearch() default false;
	
	public String parent() default "";
	public String foreignParent() default "";
}
