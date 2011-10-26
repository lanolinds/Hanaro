package com.samsong.erp.service;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.HomeDAO;

@Service
public class HomeServiceImpl implements HomeService {

	@Autowired
	private HomeDAO dao;
	
	private JdbcTemplate jdbc;
	
	@Autowired
	public void setDataSource(DataSource dataSource){
		this.jdbc = new JdbcTemplate(dataSource);
	}
	
	public String getMyName(String empNo) {
		return dao.getMyName("080504");
	}

	public void insertBulkData() {
		dao.insertBulkData();
		
	}

}
