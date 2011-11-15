package com.samsong.erp.dao.employee;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

@Repository
public class EmployeeManagementDAO {
	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;
	
	@Autowired
	public void init(DataSource ds){
		jdbc = new JdbcTemplate(ds);
	}
	
	//접속된 계정에 대한 정보를 가져온다.
	public List<Map<String,Object>> getUserInfo(Locale locale,String user){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry())
				.addValue("user",user);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("EmployeeManagementDAO_getUserInfo").returningResultSet("userInfo", new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int rowNum)
					throws SQLException {
				Map<String,Object> m = new HashMap<String,Object>();
					for(int x = 0;x<rs.getMetaData().getColumnCount();x++)
					m.put("DATA"+x,rs.getObject(x+1));
				list.add(m);
				return null;
			}
		});
		sp.execute(params);
		return list;
	}
	
}
