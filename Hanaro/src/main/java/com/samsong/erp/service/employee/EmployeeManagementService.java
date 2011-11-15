package com.samsong.erp.service.employee;

import java.util.List;
import java.util.Locale;
import java.util.Map;

public interface EmployeeManagementService {	
	public List<Map<String,Object>> getUserInfo(Locale locale,String user);
}
