package com.samsong.erp.dao.basic;

import java.sql.ResultSet;
import java.sql.SQLException;
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
public class ItemDAO {
	
	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;
	
	@Autowired
	public void setDataSource(DataSource ds){
		this.jdbc = new JdbcTemplate(ds);
		
	}

	public List<Map<String, Object>> getLocalizedItemList(Locale locale, String item, String cate, String localized) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalizedItemList ?,?,?,?;";
		return jdbc.queryForList(sql, country,item,cate,localized);
	}

	public void updateLocalItem(String item, String type, double p,
			String currency, String enabled, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_updateLocalItem ?,?,?,?,?,?;";
		jdbc.update(sql, item,type,p,currency,enabled,country);
	}

	public Map<String, Object> getLocalItemInfo(String item, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalItemInfo ?,?;";
		return jdbc.queryForMap(sql, item,country);
	}

	public List<Map<String, Object>> getLocalItemPricePerPartnerList(
			String item, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalItemPricePerPartnerList ?,?;";
		return jdbc.queryForList(sql, item,country);
	}

	public void updateLocalItemPrice(String action, String item,
			String partner, double price, String currency, String enabled,
			String username, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_updateLocalItemPrice ?,?,?,?,?,?,?,?;";
		jdbc.update(sql, action,item,partner,price,currency,enabled,username,country);
	}
	
	public List<Map<String,Object>> getEbomItemList(String type,String partCode,Locale locale,
			String car,String model){		
		String query = "exec ItemDAO_getEbomItemList ?,?,?,?,?";
		return jdbc.queryForList(query,type,partCode,locale.getCountry(),car,model);
	}
	
	public List<Map<String,Object>> getEbom(String partNo,Locale locale){
		String query = "exec [ItemDAO_getEbom] ?,?";
		return jdbc.queryForList(query,partNo,locale.getCountry());
	}
	
  
	
	
	
}
