package com.samsong.erp.util;

import java.util.Comparator;
import java.util.Date;
import java.util.Map;

public class HashMapComparator implements Comparator<Map<String, Object>> {

	private String sortKey;
	private boolean ascendant=true;
	public HashMapComparator(String sortKey,boolean asc){
		this.sortKey = sortKey;
		this.ascendant = asc;
	}
	
	public int compare(Map<String, Object> m1, Map<String, Object> m2) {
		Object val1 = m1.get(sortKey);
		Object val2 = m2.get(sortKey);
		
		if(val1==null || val2 ==null){
			return 0;
		}
		
		if(val1 instanceof Number){
			return (int) ((ascendant?1:-1)*(((Number) val1).doubleValue()-((Number) val2).doubleValue()));
		}
		else if(val1 instanceof Date){
			return (ascendant?1:-1)*(((Date) val1).compareTo((Date)val2));
		}
		else{
			return (ascendant?1:-1)*(val1.toString().compareTo(val2.toString()));
		}
	}

}
