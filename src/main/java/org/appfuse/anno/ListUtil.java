package org.appfuse.anno;

import java.util.ArrayList;
import java.util.List;

public class ListUtil {
	public static List pasreList(Object[] t){
		List list=new ArrayList();
		if(t!=null){
			for(Object obj:t){
				list.add(obj);
			}
		}
		return list;
	}
	public static String toString(List list){
		return ListUtil.toString(list,",");
	}
	public static String toString(List list,String split){
		String str="";
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				if(i==0){
					str=(list.get(i)==null?"":list.get(i).toString());
				}else{
					str=str+split+(list.get(i)==null?"":list.get(i).toString());

				}
			}
		}
		return str;
	}
	
}
