package com.samsong.erp.dao.basic;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ItemDAO {
	
	private JdbcTemplate jdbc;
	
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
	
}
