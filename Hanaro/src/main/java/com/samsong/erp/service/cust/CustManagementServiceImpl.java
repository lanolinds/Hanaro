package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.cust.CustManagementDAO;
import com.samsong.erp.model.cust.CustInfo;

@Service
public class CustManagementServiceImpl implements CustManagementService {
	
	@Autowired
	CustManagementDAO dao;
	
	public Map<Object, Object> getSupplierOptionByPartCode(Locale locale,String partCode) {
		return dao.getSupplierOptionByPartCode(locale,partCode);
	}

	public List<Map<String, Object>> getCustOption(Locale locale, String searchType,String q) {
		return dao.getCustOption(locale,searchType,q);
	}

	public Map<String, String> getLineProcList(Locale locale, String custCode,
			String lineCode) {
		
		return dao.getLineOption(locale, custCode, lineCode);
	}

	@Override
	//업체구분코드 목록
	public Map<String, Object> getCodeCustType(Locale locale){
		return dao.getCodeCustType(locale);
	}
	
	@Override
	//업체정보 등록
	public void setCustInfo(String setType, Locale locale, CustInfo info, String user){
		 dao.setCustInfo(setType, locale, info, user);
	}
	
	@Override
	public List<Map<String, Object>> getCusteRegList(Locale locale, String keyfield){
		return dao.getCusteRegList(locale, keyfield);
	}
	
	@Override
	public Map<String, Object> getCustView(String custCd, Locale locale){
		return dao.getCustView(custCd, locale);
	}
	
	public List<Map<String, Object>> getCustOptionLong(Locale locale, String searchType,String q) {
		return dao.getCustOptionLong(locale, searchType, q);
	}	
}
