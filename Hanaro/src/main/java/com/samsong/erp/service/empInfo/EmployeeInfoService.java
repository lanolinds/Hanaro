package com.samsong.erp.service.empInfo;

import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;


import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.empInfo.EmployeeInfo;

public interface EmployeeInfoService {

	public Map<String, Object> getCodeDept(Locale locale);
	public Map<String, Object> getCodePosition(Locale locale);
	public Map<String, Object> getCodeRole(Locale locale);
	public void setEmployeeInfo(String setType, Locale locale,EmployeeInfo info, String user, byte[] photo);
	public List<Map<String,Object>> getUserInfo(Locale locale,String user);	
}
