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
	
	public List<Map<String,Object>> getLineProcConfiguration(Locale locale,String custCode,String lineCode){
		String query = "exec ItemDAO_getLineProcConfiguration ?,?,?";
		return jdbc.queryForList(query,new Object[]{locale.getCountry(),custCode,lineCode});
	}
	
	public String getCheckUnique(Locale locale, String checkItem, String checkKey, String checkKey2){
		String query = "";
		if(checkItem.equals("line")){
			query = "if exists (select line_code from master_link_cust_line where locale = ? and line_code = ?)select 'Y' else select 'N';";
			return jdbc.queryForObject(query, new Object[]{locale.getCountry(),checkKey},String.class);
		}
		else{
			query = "if exists (select proc_cd from master_link_line_proc where locale = ? and proc_cd = ? and line_code = ?)select 'Y'else select  'N';";
			return jdbc.queryForObject(query, new Object[]{locale.getCountry(),checkKey,checkKey2},String.class);
		}
		
		 
	}
	
	public void updateLineProcConfiguration(Locale locale,String procCate,String procType,String custCode,
			String lineCode,String procCode, String procSeq, String useYn, String user){
		SqlParameterSource param = new MapSqlParameterSource()
			.addValue("locale",locale.getCountry())
			.addValue("procCate",procCate)
			.addValue("proctype",procType)
			.addValue("custCode",custCode)
			.addValue("lineCode",lineCode)
			.addValue("procCode",procCode)
			.addValue("procSeq",procSeq)
			.addValue("useYn",useYn)
			.addValue("user",user);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ItemDAO_updateLineProcConfiguration");
		sp.execute(param);
	}
	
	public List<Map<String,Object>> getProcOption(Locale locale){
		String query = "select proc_cd,proc_nm,proc_remark from union_master_process where locale = ? and use_yn = 'Y' order by proc_nm;";
		return jdbc.query(query,new Object[]{locale.getCountry()},new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int arg1)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				m.put("procCode",rs.getString(1));
				m.put("procName",rs.getString(2));
				m.put("procRemark",rs.getString(3));
				return m;
			}
			
		});
	}
	
	
	
}
