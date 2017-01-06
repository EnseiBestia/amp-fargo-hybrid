package org.appfuse.anno;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.mapping.Property;

public class AnnoFieldUtilMongodb extends AnnoFieldUtil {
	public String getTextSearchStr(){
		List<String> list=new ArrayList<String>();
		for(Property p1:allPropertyList){
			//Property p1 = (Property) iterator2.next();
			if(!(isCollection(p1) || isChildProperty(p1) || isTreeParentKey(p1) || isCustomProperty(p1) ||isForeignKey(p1))){
				try{
					System.out.println(p1.getValue().getType().getName());
					if(p1.getValue().getType().getName().equals("java.lang.String") || p1.getValue().getType().getName().equals("String") || p1.getValue().getType().getName().equals("string")){
						list.add("q.criteria(\""+p1.getName()+"\").contains(searchValue.getTextValue())");
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
    	}
		System.out.println(list);
		String str=ListUtil.toString(list,",");
		if(list.size()>0){
			return "q.or("+str+")";
		}else{
			return "";
		}
	}
	public String getConditionSearchStr(){
		List<String> list=new ArrayList<String>();
		list.add("\r\n		if(searchValue!=null && searchValue.getCombinedConditionValue()!=null){");
		for(Property p1:allPropertyList){
			AnnoInfo anno=map.get(p1.getName());
			if(anno!=null){
				if(anno.combinedSearch){
					list.add("			if(searchValue.getCombinedConditionValue().containsKey(\""+p1.getName()+"\")){");
					list.add("				Object cvalue=searchValue.getCombinedConditionValue().get(\""+p1.getName()+"\");");
					list.add("				if(cvalue!=null && !cvalue.toString().trim().equals(\"\")){");
					if(anno.getType()==1 ){
						list.add("					q.and(q.criteria(\""+p1.getName()+"\").in(ListUtil.pasreStringList(cvalue.toString(),\",\")));");
					}else if( anno.getType()==2 ||anno.getType()==4 || anno.getType()==6 || anno.getType()==9){
						list.add("					q.and(q.criteria(\""+p1.getName()+"\").in(ListUtil.pasreLongList(cvalue.toString(),\",\")));");
					}else if(anno.getType()==3){
						list.add("					q.and(q.criteria(\""+p1.getName()+".id\").in(ListUtil.pasreStringList(cvalue.toString(),\",\")));");
					}else{
						list.add("					q.and(q.criteria(\""+p1.getName()+"\").equal(new Long(cvalue.toString())));");
					}
					list.add("				}");
					list.add("			}");
				}
				if(anno.textSearch){
					list.add("			if(searchValue.getCombinedConditionValue().containsKey(\""+p1.getName()+"\")){");
					list.add("				Object cvalue=searchValue.getCombinedConditionValue().get(\""+p1.getName()+"\");");
					list.add("				if(cvalue!=null && !cvalue.toString().trim().equals(\"\")){");
					list.add("					q.and(q.criteria(\""+p1.getName()+"\").contains(cvalue.toString().trim()));");
					list.add("				}");
					list.add("			}");
				}
			}
    	}
		list.add("		}");
		list.add("		doCustomPropertySearchCondation(searchValue,q);");
		/*list.add("		if(searchValue.getCustomPropertyValue()!=null){");
		list.add("				for(String one:searchValue.getCustomPropertyValue().keySet()){");
		list.add("					Object cvalue=searchValue.getCustomPropertyValue().get(one);");
		list.add("					if(cvalue!=null && !cvalue.toString().trim().equals(\"\")){");
		list.add("						q.and(q.criteria(\"customPropertyMap.\"+one+\"\").hasThisOne(cvalue));");
		list.add("					}");
		list.add("				}");
		list.add("		}");*/
		String str=ListUtil.toString(list,"\r\n");
		return str;
	}
	
}
