package org.appfuse.anno;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.criterion.MatchMode;
import org.hibernate.mapping.Property;

public class AnnoFieldUtilHibernate extends AnnoFieldUtil {

	@Override
	public String getTextSearchStr() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getConditionSearchStr() {
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
						list.add("					cr.add(Restrictions.in(\""+p1.getName()+"\",ListUtil.pasreStringList(cvalue.toString(),\",\")));");
					}else if( anno.getType()==2 ||anno.getType()==4 || anno.getType()==6 || anno.getType()==9){
						list.add("					cr.add(Restrictions.in(\""+p1.getName()+"\",ListUtil.pasreLongList(cvalue.toString(),\",\"));");
					}else if(anno.getType()==3){
						list.add("					cr.add(Restrictions.in(\""+p1.getName()+"\",ListUtil.pasreStringList(cvalue.toString(),\",\"));");
					}else{
						list.add("					cr.add(Restrictions.eq(\""+p1.getName()+"\",(new Long(cvalue.toString()))));");
					}
					list.add("				}");
					list.add("			}");
				}
				if(anno.textSearch){
					list.add("			if(searchValue.getCombinedConditionValue().containsKey(\""+p1.getName()+"\")){");
					list.add("				Object cvalue=searchValue.getCombinedConditionValue().get(\""+p1.getName()+"\");");
					list.add("				if(cvalue!=null && !cvalue.toString().trim().equals(\"\")){");
					list.add("					cr.add(Restrictions.like(\""+p1.getName()+"\",cvalue.toString().trim(),MatchMode.ANYWHERE));");
					list.add("				}");
					list.add("			}");
				}
			}
    	}
		list.add("		}");
/*		list.add("		doCustomPropertySearchCondation(searchValue,q);");*/
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
