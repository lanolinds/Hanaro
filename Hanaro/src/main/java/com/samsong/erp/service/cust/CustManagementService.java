package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.samsong.erp.model.cust.CustInfo;




public interface CustManagementService {

	public Map<Object,Object> getSupplierOptionByPartCode(Locale locale,String partCode);
	
	public List<Map<String, Object>> getCustOption(Locale locale,String searchType ,String q);
	
	public Map<String,String> getLineProcList(Locale locale, String custCode, String lineCode);
	//업체구분코드 목록
	public Map<String, Object> getCodeCustType(Locale locale);
	//업체정보 등록
	public void setCustInfo(String setType, Locale locale, CustInfo info, String user);
	public List<Map<String, Object>> getCusteRegList(Locale locale, String keyfield);
	public Map<String, Object> getCustView(String custCd, Locale locale);
}
