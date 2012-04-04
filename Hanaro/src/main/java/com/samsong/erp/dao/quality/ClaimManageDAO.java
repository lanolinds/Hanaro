package com.samsong.erp.dao.quality;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
public class ClaimManageDAO {
	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;
	
	@Autowired
	public void init(DataSource ds) {
		jdbc = new JdbcTemplate(ds);
	}

	public List<Map<String,Object>> getClaimCode(String type,Locale locale){		
		return jdbc.queryForList("select * from code_real_claim where locale = ? and [type] = ? order by code asc;",locale.getCountry(),type);
	}
	


}
