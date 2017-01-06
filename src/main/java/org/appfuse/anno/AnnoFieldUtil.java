package org.appfuse.anno;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.mapping.Collection;
import org.hibernate.mapping.Property;


public abstract class AnnoFieldUtil {
	/*用于搜索*/
	
	List<Property> allPropertyList=new ArrayList<Property>();
	
	public List<Property> getAllPropertyList() {
		return allPropertyList;
	}
	public void setAllPropertyList(List<Property> allPropertyList) {
		this.allPropertyList = allPropertyList;
	}
	public Map<String, Property> getAllPropertyMap() {
		return allPropertyMap;
	}
	public void setAllPropertyMap(Map<String, Property> allPropertyMap) {
		this.allPropertyMap = allPropertyMap;
	}


	Map<String,Property> allPropertyMap=new HashMap<String,Property>();

	public Property getNameProperty(){
		
		return null;
	}
	
	
    public static String getUTF8String(String s) {  
    	StringBuilder sb = new StringBuilder();
		for (int i = 0; i < s.length(); ++i) {
			if (s.charAt(i) <= 256) {
				sb.append("\\u00");
			} else {
				sb.append("\\u");
			}
			sb.append(Integer.toHexString(s.charAt(i)));
		}
		return sb.toString();
    }  
    
    
    String description = "";
	
    boolean textSearch =true;;
    boolean combinedSearch=false;
	
    String parent;
	
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		
		
		this.description = getUTF8String(description);
	}
	
	Map<String,AnnoInfo> map=new HashMap<String,AnnoInfo>();
	List<AnnoInfo> annoInfoes=new ArrayList<AnnoInfo>();
	/*public void addField(Property p,FieldAnnoExtend fae){
		AnnoInfo anno=new AnnoInfo();
		anno.setChildModel(fae.childModel());
		anno.setEnumCode(fae.enumCode());
		anno.setFixedPropertyCode(fae.fixedPropertyCode());
		anno.setType(fae.type());
		
		anno.setRequired(fae.required());
		anno.setMaxlength(fae.maxlength());
		
		anno.setProperty(p);
		
		annoInfoes.add(anno);
		
		map.put(p.getName(), anno);
	}*/
	public void addField(Field f,FieldAnnoExtend fae){
		AnnoInfo anno=new AnnoInfo(f,fae);
		//anno.setChildModel(fae.childModel());
		//anno.setEnumCode(fae.enumCode());
		//anno.setFixedPropertyCode(fae.fixedPropertyCode());
		//anno.setType(fae.type());
		
		//anno.setProperty(p);
		
		annoInfoes.add(anno);
		
		anno.setProperty(allPropertyMap.get(f.getName()));
		map.put(f.getName(), anno);
	}
	public void addProperty(Property p){
		allPropertyList.add(p);
		allPropertyMap.put(p.getName(), p);
		//map.get(p.getName()).setProperty(p);
	}
	public List<AnnoInfo> getAnnoInfoes() {
		return annoInfoes;
	}
	public void setAnnoInfoes(List<AnnoInfo> annoInfoes) {
		this.annoInfoes = annoInfoes;
	}
	
	public boolean isChildProperty(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==5){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isTreeParentKey(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==7){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isBaseProperty(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==0){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public String getFieldDescription(String name){
		if(map.containsKey(name)){
			return getUTF8String(map.get(name).getDescription());
		}else{
			return name;
		}
	}
	public AnnoInfo getAnnoInfo(Property p){
		return map.get(p.getName());
	}
	public boolean isFixedProperty(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==2 || map.get(p.getName()).getType()==3 || map.get(p.getName()).getType()==4){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isEnumProperty(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==1){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isCustomProperty(Property p){
		
		if("customPropertyMap".equals(p.getName())){
			return true;
		}else{
			return false;
		}
	}
	public boolean isForeignKey(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==6){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isCommonForeignKey(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==9){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isFileKey(Property p){
		if(map.containsKey(p.getName())){
			if(map.get(p.getName()).getType()==10){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	public boolean isCollection(Property property) {
        return property.getValue() instanceof Collection;
    }
	@Override
	public String toString() {
		return "AnnoFieldUtil [map=" + map + ", annoInfoes=" + annoInfoes + "]";
	}
	abstract public String getTextSearchStr();
	abstract public String getConditionSearchStr();
}
