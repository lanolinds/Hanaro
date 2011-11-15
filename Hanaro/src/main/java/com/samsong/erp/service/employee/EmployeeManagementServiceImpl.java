package com.samsong.erp.service.employee;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.employee.EmployeeManagementDAO;

@Service
public class EmployeeManagementServiceImpl implements EmployeeManagementService{

	@Autowired
	EmployeeManagementDAO dao;

	@Override
	public List<Map<String, Object>> getUserInfo(Locale locale, String user) {
		return dao.getUserInfo(locale, user);
	}
	
}
