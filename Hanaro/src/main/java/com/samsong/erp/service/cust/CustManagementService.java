package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;




public interface CustManagementService {

	public Map<Object,Object> getSupplierOptionByPartCode(Locale locale,String partCode);
	
	public List<Map<String, Object>> getCustOption(Locale locale,String searchType ,String q);
	
	public Map<String,String> getLineProcList(Locale locale, String custCode, String lineCode);

}
