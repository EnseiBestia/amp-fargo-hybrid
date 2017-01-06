package org.appfuse.anno;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.mapping.Property;
import org.hibernate.tool.hbm2x.pojo.POJOClass;

public class POJOAnno {
	private POJOClass pojo;
	
	private String parentName;
	private String foreignParentName;
	
	private Map<String,POJOClass> allPOJOMap=new HashMap<String,POJOClass>();
	private List<String> childrenList=new ArrayList<String>();
	private List<POJOClass> childrenPOJOList=new ArrayList<POJOClass>();
	private Map<String,POJOClass> childrenPOJOMap=new HashMap<String,POJOClass>();
	private Map<String,Property> childrenKeyMap=new HashMap<String,Property>();
	private POJOClass parentPOJO;
	private POJOClass foreignParentPOJO;
	private Property childPropInParent; //<- parentForeignKey
	private String parentIdInChild;
	private AnnoFieldUtil annoFieldUtil;

	
	public Property getChildPropInParent() {
		return childPropInParent;
	}
	public void setChildPropInParent(Property childPropInParent) {
		this.childPropInParent = childPropInParent;
	}
	public POJOClass getPojo() {
		return pojo;
	}
	public void setPojo(POJOClass pojo) {
		this.pojo = pojo;
	}
	public POJOClass getForeignParentPOJO() {
		return foreignParentPOJO;
	}
	public void setForeignParentPOJO(POJOClass foreignParentPOJO) {
		this.foreignParentPOJO = foreignParentPOJO;
	}
	
	public String getParentName() {
		return parentName;
	}
	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	public String getForeignParentName() {
		return foreignParentName;
	}
	public void setForeignParentName(String foreignParentName) {
		this.foreignParentName = foreignParentName;
	}
	public AnnoFieldUtil getAnnoFieldUtil() {
		return annoFieldUtil;
	}
	public void setAnnoFieldUtil(AnnoFieldUtil annoFieldUtil) {
		this.annoFieldUtil = annoFieldUtil;
	}
	public Map<String, POJOClass> getAllPOJOMap() {
		return allPOJOMap;
	}
	public void setAllPOJOMap(Map<String, POJOClass> allPOJOMap) {
		this.allPOJOMap = allPOJOMap;
	}
	public List<String> getChildrenList() {
		return childrenList;
	}
	public void setChildrenList(List<String> childrenList) {
		this.childrenList = childrenList;
	}
	public List<POJOClass> getChildrenPOJOList() {
		return childrenPOJOList;
	}
	public void setChildrenPOJOList(List<POJOClass> childrenPOJOList) {
		this.childrenPOJOList = childrenPOJOList;
	}
	public Map<String, POJOClass> getChildrenPOJOMap() {
		return childrenPOJOMap;
	}
	public void setChildrenPOJOMap(Map<String, POJOClass> childrenPOJOMap) {
		this.childrenPOJOMap = childrenPOJOMap;
	}
	public Map<String, Property> getChildrenKeyMap() {
		return childrenKeyMap;
	}
	public void setChildrenKeyMap(Map<String, Property> childrenKeyMap) {
		this.childrenKeyMap = childrenKeyMap;
	}
	public POJOClass getParentPOJO() {
		return parentPOJO;
	}
	public void setParentPOJO(POJOClass parentPOJO) {
		this.parentPOJO = parentPOJO;
	}
	
}
