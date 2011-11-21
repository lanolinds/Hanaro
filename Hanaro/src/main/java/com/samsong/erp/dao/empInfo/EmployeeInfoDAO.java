package com.samsong.erp.dao.empInfo;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.empInfo.EmployeeInfo;

@Repository
public class EmployeeInfoDAO {

	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;

	@Autowired
	public void init(DataSource ds) {
		jdbc = new JdbcTemplate(ds);
	}
	
	//접속된 계정에 대한 정보를 가져온다.
	public List<Map<String,Object>> getUserInfo(Locale locale,String user){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource().addValue("locale",locale.getCountry())
				.addValue("user",user);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("EmployeeInfoDAO_getUserInfo").returningResultSet("userInfo", new RowMapper<Map<String,Object>>() {
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
	
	//부서코드 목록
	public Map<String, Object> getCodeDept(Locale locale) {
		String sql ="select DEPT_CD,DEPT_NM FROM union_master_dept WHERE LOCALE=? AND USE_YN='Y'";
		final Map<String, Object> map = new LinkedHashMap<String, Object>();
		
		jdbc.query(sql, new Object[] { locale.getCountry() }, new RowCallbackHandler() {
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				map.put(rs.getString(1), rs.getString(2));
			}
		});
		return map;
	}
	
	//직위코드목록
	public Map<String, Object> getCodePosition(Locale locale) {
		String sql ="select RANK_CD,RANK_NM FROM master_rank WHERE LOCALE=? AND USE_YN='Y'";
		final Map<String, Object> map = new LinkedHashMap<String, Object>();
		
		jdbc.query(sql, new Object[] { locale.getCountry() }, new RowCallbackHandler() {
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				map.put(rs.getString(1), rs.getString(2));
			}
		});
		return map;
	}
	
	//직무코드목록
		public Map<String, Object> getCodeRole(Locale locale) {
			String sql ="select ROLE_CD,ROLE_NM FROM union_master_role WHERE LOCALE=? AND USE_YN='Y'";
			final Map<String, Object> map = new LinkedHashMap<String, Object>();
			
			jdbc.query(sql, new Object[] { locale.getCountry() }, new RowCallbackHandler() {
				@Override
				public void processRow(ResultSet rs) throws SQLException {
					map.put(rs.getString(1), rs.getString(2));
				}
			});
			return map;
		}
	
	public void setEmployeeInfo(String setType, Locale locale, EmployeeInfo info, String user, byte[] photo) {
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("setType", setType);
		params.put("locale", locale.getCountry());
		params.put("empNo", info.getEmpNo());
		params.put("empNm", info.getEmpNm());
		params.put("gender", info.getGender());
		params.put("ssn", info.getSsn());
		params.put("birthday", info.getBirthday());
		params.put("employDt", info.getEmployDt());
		params.put("phone", info.getPhone());
	//	params.put("inPhone", info.getInPhone());
	//	params.put("directPhone", info.getDirectPhone());
		params.put("cellPhone", info.getCellPhone());
		params.put("deptCd", info.getDeptCd());
		params.put("positionCd", info.getPositionCd());
		params.put("marry", info.getMarry());
		params.put("marryDt", info.getMarryDt());
		params.put("email", info.getEmail());
		params.put("roleCd", info.getRoleCd());
		params.put("photoName",info.getPhoto());
		params.put("photoImg",photo);
		params.put("retireDt", info.getRetireDt());
		params.put("user", user);
		PasswordEncoder encoder = new Md5PasswordEncoder();

		sp = new SimpleJdbcCall(jdbc).withProcedureName("EmployeeInfoDAO_setEmployeeInfo");
		sp.execute(params);
	}
	
	// 사원등록리스트를 조회한다.
	public List<Map<String, Object>> getEmployeeRegList(Locale locale,String keyword, String keyfield) {
		final List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
				.addValue("locale", locale.getCountry())
				.addValue("keyword", keyword)
				.addValue("keyfield", keyfield);
		sp = new SimpleJdbcCall(jdbc).withProcedureName(
				"EmployeeInfoDAO_getEmployeeRegList").returningResultSet(
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
	
	// 사원리스트를 조회한다.
		public List<Map<String, Object>> getEmployeeList(Locale locale,String keyword, String keyfield) {
			final List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
			SqlParameterSource params = new MapSqlParameterSource()
					.addValue("locale", locale.getCountry())
					.addValue("keyword", keyword)
					.addValue("keyfield", keyfield);
			sp = new SimpleJdbcCall(jdbc).withProcedureName(
					"EmployeeInfoDAO_getEmployeeList").returningResultSet(
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
	
	//사원사진 다운받는거
	public byte[] getEmployeeFile(Locale locale, String empNo){
		String sql  = "select PHOTO_IMG from MASTER_EMPLOYEE where LOCALE=? and EMP_NO =?";
		return jdbc.queryForObject(sql,new Object[]{locale.getCountry(),empNo},new RowMapper<byte[]>(){
			@Override
			public byte[] mapRow(ResultSet rs, int rowNum) throws SQLException {
				return rs.getBytes(1);
			}
		});
	}
	
	public Map<String, Object> getEmployView(String empNo, Locale locale) {
		return jdbc.queryForMap("exec EmployeeInfoDAO_getEmployeeView ?,? ",
				new Object[] { empNo, locale.getCountry() });
	}
}
