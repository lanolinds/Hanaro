package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.cust.CustManagementDAO;

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


}
