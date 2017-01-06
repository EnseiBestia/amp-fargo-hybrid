package org.appfuse.anno;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.FIELD)  
@Retention(RetentionPolicy.RUNTIME)  
public @interface FieldAnnoExtend {
	
	/*
	 * 0:基本类型;
	 * 1:基本枚举类型;
	 * 2:固定变量-enum;
	 * 3:固定变量-muliti;
	 * 4:固定变量-tree;
	 * 5: child List;
	 * 6:foreignKey  此类型慎用
	 * 7:TreeParentKey 
	 * 8:foreignParentKey 
	 * 9:foreighKey 普通外键，非lazy加载的对象外键
	 * 10.文件
	 * 11.基本枚举类型，枚举值定义在注解中
	 * 
	 * */
	
	public int type() default 0;
	public String enumCode() default"";
	public String fixedPropertyCode() default"";
	public String childModel() default"";
	public String foreignModel() default"";
	
	public boolean required() default false;
	public int maxlength() default 0;
	public int minlength() default 0;
	public long max() default 0;
	public long min() default 0;
	
	public boolean date() default false;
	public boolean number() default false;
	public boolean digits() default false;
	public boolean email() default false;
	
	public boolean url() default false;

	
	public boolean pleaseSelect() default false;
	
	
	public String description() default"";
	
	public boolean textSearch() default false;
	public boolean combinedSearch() default false;
	
	public boolean name() default false;
	
	public boolean multiple() default false;
	public int selectModel() default 0;//0:后台一次性返回选择数据 1:ajax返回选择数据 2:弹出对话框选择数据
	
	public String enumArray() default "";
}
