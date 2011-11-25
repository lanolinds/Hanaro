package com.samsong.erp.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Repository;

@Repository 
public class HomeDAO {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void init(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public int changePassword(String user,String cntPwd, String newPwd){
		String query = "update users set password = ? where username = ? and enabled = 1 and password = ?;";
		return jdbcTemplate.update(query,new Object[]{newPwd,user,cntPwd});
	}
	
}
