package com.samsong.erp.dao.cust;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
public class CustManagementDAO {
	private JdbcTemplate jdbc;
	private SimpleJdbcCall  sp;
	
	@Autowired
	public void init(DataSource ds){
		jdbc = new JdbcTemplate(ds);
	}

	
	
	public Map<Object,Object> getSupplierOptionByPartCode (Locale locale,String partCode){
		final Map<Object,Object> map  = new HashMap<Object,Object>();
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry()).addValue("partCode",partCode);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("CustManagementDAO_getSupplierOptionByPartCode").returningResultSet("supplier",new RowMapper<Map<Object,Object>>(){
			public Map<Object, Object> mapRow(ResultSet rs, int i)
					throws SQLException {
				map.put(rs.getString(1),rs.getString(2));
				return null;
			}			
		});
		
		sp.execute(params);
		return map;
	}
	
	public List<Map<String,Object>> getCustOption(Locale locale, String searchType,String q){
		final List<Map<String,Object>> list  = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry())
				.addValue("searchType",searchType).addValue("term",q);
		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("CustManagementDAO_getCustOption").returningResultSet("custList", new RowMapper <List<Map<String,Object>>>(){
			@Override
			public List<Map<String, Object>> mapRow(ResultSet rs, int i)
					throws SQLException {
				Map<String,Object> map = new LinkedHashMap<String,Object>();
				map.put("custCode",rs.getString(1));
				map.put("custName",rs.getString(2));
				list.add(map);
				return null;
			}
		});
		
		sp.execute(params);
		return list;
				
		
	}
	
	public Map<String,String> getLineOption(Locale locale, String custCode, String lineCode){
		final Map<String,String> map = new LinkedHashMap<String,String>();
		
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry())
				.addValue("custCode",custCode)
				.addValue("lineCode",lineCode);
		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("CustManagementDAO_getLineProc").returningResultSet("lineProc",new RowMapper<Map<String,String>>(){

			public Map<String, String> mapRow(ResultSet rs, int i)
					throws SQLException {					
					map.put(rs.getString(1),rs.getString(2));
				return null;
			}

		});
		sp.execute(params);
		return map;
		
	}
	

	
}
