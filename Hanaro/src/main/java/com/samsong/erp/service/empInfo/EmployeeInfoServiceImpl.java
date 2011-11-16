package com.samsong.erp.service.empInfo;

import java.util.ArrayList;


import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


import org.apache.log4j.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.web.multipart.MultipartFile;


import com.samsong.erp.model.empInfo.EmployeeInfo;
import com.samsong.erp.dao.empInfo.EmployeeInfoDAO;

import com.samsong.erp.model.quality.IssueApproval;

import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.model.quality.QualityIssueRegSheet;

@Service
public class EmployeeInfoServiceImpl implements EmployeeInfoService {
	
	@Autowired
	private EmployeeInfoDAO dao;
	
	@Override
	public Map<String, Object> getCodeDept(Locale locale){
		return dao.getCodeDept(locale);
	}
	
	@Override
	public Map<String, Object> getCodePosition(Locale locale){
		return dao.getCodePosition(locale);
	}
	
	@Override
	public Map<String, Object> getCodeRole(Locale locale){
		return dao.getCodeRole(locale);
	}
	@Override
	public void setEmployeeInfo(String setType, Locale locale,EmployeeInfo info, String user, byte[] photo){
		dao.setEmployeeInfo( setType ,locale, info, user, photo);
	}
	
	@Override
	public List<Map<String, Object>> getUserInfo(Locale locale, String user) {
		return dao.getUserInfo(locale, user);
	}	

}
