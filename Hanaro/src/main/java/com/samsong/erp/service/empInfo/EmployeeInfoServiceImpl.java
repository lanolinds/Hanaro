package com.samsong.erp.service.empInfo;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.empInfo.EmployeeInfoDAO;
import com.samsong.erp.model.empInfo.EmployeeInfo;

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

	@Override
	public List<Map<String, Object>> getEmployeeRegList(Locale locale,String keyword, String keyfield) {
		return dao.getEmployeeRegList(locale, keyword, keyfield);
	}
	
	@Override
	public byte[] getEmployeeFile(Locale locale, String empNo){
		return dao.getEmployeeFile(locale, empNo);
	}
	
	@Override
	public List<Map<String, Object>> getEmployeeList(Locale locale,String keyword, String keyfield){
		return dao.getEmployeeList(locale, keyword, keyfield);
	}
	
	@Override
	public Map<String, Object> getEmployView(String empNo, Locale locale){
		return dao.getEmployView(empNo, locale);
	}


}
