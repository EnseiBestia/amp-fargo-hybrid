package org.appfuse.anno;

import java.io.Serializable;
import java.lang.reflect.Field;

import org.hibernate.mapping.Property;

public class AnnoInfo implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String description;
	
	private Property property;
	
	public int type;
	public String enumCode;
	public String fixedPropertyCode;
	public String childModel;
	public String foreignModel;
	
	public boolean required;
	public int maxlength ;
	
	
	public int minlength;
	public long max;
	public long min;
	
	public boolean date;
	public boolean number;
	public boolean digits;
	public boolean email;
	
	public boolean url;
	
	public boolean pleaseSelect;
	
	public Field field;
	
	
	public boolean textSearch;
	public boolean combinedSearch;
	
	public boolean name;
	
	public boolean multiple;
	
	public int selectModel;
	
	public String enumArray;
	
	public int getSelectModel() {
		return selectModel;
	}

	public void setSelectModel(int selectModel) {
		this.selectModel = selectModel;
	}

	public boolean isName() {
		return name;
	}

	public void setName(boolean name) {
		this.name = name;
	}

	public String getForeignModel() {
		return foreignModel;
	}

	public void setForeignModel(String foreignModel) {
		this.foreignModel = foreignModel;
	}

	public AnnoInfo(Field field1,FieldAnnoExtend fae) {
		// TODO Auto-generated constructor stub
		this.type=fae.type();
		this.enumCode=fae.enumCode();
		this.fixedPropertyCode=fae.fixedPropertyCode();
		this.childModel=fae.childModel();
		this.foreignModel=fae.foreignModel();
		this.required=fae.required();
		this.maxlength=fae.maxlength();
		this.minlength=fae.minlength();
		this.max=fae.max();
		this.min=fae.min();
		this.date=fae.date();
		this.number=fae.number();
		this.digits=fae.digits();
		this.email=fae.email();
		this.url=fae.url();
		this.field=field1;
		this.pleaseSelect=fae.pleaseSelect();
		this.description=fae.description();
		
		this.textSearch=fae.textSearch();
		this.combinedSearch=fae.combinedSearch();
		
		
		this.name=fae.name();
		this.multiple=fae.multiple();
		this.selectModel=fae.selectModel();
		
		
		this.enumArray=fae.enumArray();
		
		if(this.description==null || "".equals(this.description)){
			this.description=field1.getName();
		}
	}

	public boolean isTextSearch() {
		return textSearch;
	}

	public void setTextSearch(boolean textSearch) {
		this.textSearch = textSearch;
	}

	public boolean isCombinedSearch() {
		return combinedSearch;
	}

	public void setCombinedSearch(boolean combinedSearch) {
		this.combinedSearch = combinedSearch;
	}

	public boolean isMultiple() {
		return multiple;
	}

	public void setMultiple(boolean multiple) {
		this.multiple = multiple;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isPleaseSelect() {
		return pleaseSelect;
	}

	public void setPleaseSelect(boolean pleaseSelect) {
		this.pleaseSelect = pleaseSelect;
	}

	public Field getField() {
		return field;
	}

	public void setField(Field field) {
		this.field = field;
	}

	public AnnoInfo() {
		// TODO Auto-generated constructor stub
	}
	public int getMinlength() {
		return minlength;
	}
	public void setMinlength(int minlength) {
		this.minlength = minlength;
	}
	public long getMax() {
		return max;
	}
	public void setMax(long max) {
		this.max = max;
	}
	public long getMin() {
		return min;
	}
	public void setMin(long min) {
		this.min = min;
	}
	public boolean isDate() {
		return date;
	}
	public void setDate(boolean date) {
		this.date = date;
	}
	public boolean isNumber() {
		return number;
	}
	public void setNumber(boolean number) {
		this.number = number;
	}
	public boolean isDigits() {
		return digits;
	}
	public void setDigits(boolean digits) {
		this.digits = digits;
	}
	public boolean isEmail() {
		return email;
	}
	public void setEmail(boolean email) {
		this.email = email;
	}
	public boolean isUrl() {
		return url;
	}
	public void setUrl(boolean url) {
		this.url = url;
	}
	public boolean isRequired() {
		return required;
	}
	public void setRequired(boolean required) {
		this.required = required;
	}
	public int getMaxlength() {
		return maxlength;
	}
	public void setMaxlength(int maxlength) {
		this.maxlength = maxlength;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public String getEnumCode() {
		return enumCode;
	}
	public void setEnumCode(String enumCode) {
		this.enumCode = enumCode;
	}
	public String getFixedPropertyCode() {
		return fixedPropertyCode;
	}
	public void setFixedPropertyCode(String fixedPropertyCode) {
		this.fixedPropertyCode = fixedPropertyCode;
	}
	public String getChildModel() {
		return childModel;
	}
	public void setChildModel(String childModel) {
		this.childModel = childModel;
	}
	public Property getProperty() {
		return property;
	}
	public void setProperty(Property property) {
		this.property = property;
	}
	
	public String getEnumArray() {
		return enumArray;
	}

	public void setEnumArray(String enumArray) {
		this.enumArray = enumArray;
	}

	@Override
	public String toString() {
		return "AnnoInfo [property=" + property + ", type=" + type
				+ ", enumCode=" + enumCode + ", fixedPropertyCode="
				+ fixedPropertyCode + ", childModel=" + childModel + "]";
	}
	
	
}
