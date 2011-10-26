package com.samsong.erp.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository 
public class HomeDAO {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void init(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	public String getMyName(String empNo){
		String name = "NONE";
		name = jdbcTemplate.queryForObject("select name from Test where id =?",new Object[]{empNo},String.class);
		return name;
	}

	public void insertBulkData() throws DataAccessException{
		final String[] ids = {"a","b","c","d","e"};
		final String[] names ={"aaa","bbb","ccddddddddddddddddddddddddddddddddddddddddc","ddd","eee"};
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert Test values(?,?);");
		
		int[] counts =jdbcTemplate.batchUpdate(sql.toString(), new BatchPreparedStatementSetter() {
			
			public void setValues(PreparedStatement st, int i) throws SQLException {
				st.setString(1, ids[i]);
				st.setString(2,names[i]);
			}
			
			public int getBatchSize() {
				return ids.length;
			}
		});
	}

}
