package com.samsong.erp.dao.cust;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.stereotype.Repository;

import com.samsong.erp.model.cust.CustInfo;

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
		
	//업체구분코드 목록
	public Map<String, Object> getCodeCustType(Locale locale) {
		String sql ="select CUST_TYPE_CD,CUST_TYPE_NM FROM CODE_CUST_TYPE WHERE LOCALE=? ";
		final Map<String, Object> map = new LinkedHashMap<String, Object>();
		
		jdbc.query(sql, new Object[] { locale.getCountry() }, new RowCallbackHandler() {
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				map.put(rs.getString(1), rs.getString(2));
			}
		});
		return map;
	}
	
	//업체정보 등록
	public void setCustInfo(String setType, Locale locale, CustInfo info, String user) {
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("setType", setType);
		params.put("locale", locale.getCountry());
		params.put("custType", info.getCustType());
		params.put("custCd", info.getCustCd());
		params.put("custNm", info.getCustNm());
		params.put("chief", info.getChief());
		params.put("custNo", info.getCustNo());
		params.put("mobileChief", info.getMobileChief());
		params.put("phoneOffice", info.getPhoneOffice());
		params.put("phoneFax", info.getPhoneFax());
		params.put("address", info.getAddress());
		params.put("homepage", info.getHomepage());
		params.put("email", info.getEmail());
		params.put("stdDt", info.getStdDt());
		params.put("endDt", info.getEndDt());
		params.put("user", user);

		sp = new SimpleJdbcCall(jdbc).withProcedureName("CustManagementDAO_setCustInfo");
		sp.execute(params);
	}
	
	// 업체등록리스트를 조회한다.
	public List<Map<String, Object>> getCusteRegList(Locale locale, String keyfield) {
		final List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
				.addValue("locale", locale.getCountry())
				.addValue("keyfield", keyfield);
		sp = new SimpleJdbcCall(jdbc).withProcedureName(
				"CustManagementDAO_getCustRegList").returningResultSet(
				"issueRegList", new RowMapper<Map<String, Object>>() {
					@Override
					public Map<String, Object> mapRow(ResultSet rs, int i)
							throws SQLException {
						Map<String, Object> m = new HashMap<String, Object>();
					
						for (int x = 0; x < rs.getMetaData().getColumnCount(); x++) {
							m.put("DATA" + x, rs.getObject((x + 1)));
						}
						resultList.add(m);
						return null;
					}
				});
		sp.execute(params);
		return resultList;
	}
	
	public Map<String, Object> getCustView(String custCd, Locale locale) {
		return jdbc.queryForMap("exec CustManagementDAO_getCustView ?,? ",
				new Object[] { custCd, locale.getCountry() });
	}
	
	public List<Map<String,Object>> getCustOptionLong(Locale locale, String searchType,String q){
		final List<Map<String,Object>> list  = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry())
				.addValue("searchType",searchType).addValue("term",q);
		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("CustManagementDAO_getCustOption").returningResultSet("custList", new RowMapper <List<Map<String,Object>>>(){
			@Override
			public List<Map<String, Object>> mapRow(ResultSet rs, int i)
					throws SQLException {
				Map<String, Object> m = new LinkedHashMap<String, Object>();
				
				for (int x = 0; x < rs.getMetaData().getColumnCount(); x++) {
					m.put("DATA" + x, rs.getObject((x + 1)));
				}
				list.add(m);
				return null;
			}
		});
		
		sp.execute(params);
		return list;
	}		
}
