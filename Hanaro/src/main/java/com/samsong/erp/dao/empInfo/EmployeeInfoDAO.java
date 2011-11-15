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
		sp = new SimpleJdbcCall(jdbc).withProcedureName("EmployeeInfoDAO_setEmployeeInfo");
		sp.execute(params);
	}
}
