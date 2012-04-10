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
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

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
	
	public void prodClaimManage(Locale locale,String prodType,String classType,String claimNo,String invoiceNo,String claimCost,String issueCust,String issueTeam,String cost,
								String partType,String rPartCode,String rPartName,String issueDate,String claimContent,String carType,
								String machineType,String workerCount,String issueTime,String inputBy,String p1,String p2,String p3,String p4,
								String p5,String p6,String p7){
		String query ="exec [ClaimManageDAO_prodClaimManage] ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"; 
		jdbc.update(query, new Object[]{locale.getCountry(),prodType,classType,claimNo,invoiceNo,claimCost,issueCust,issueTeam,cost,partType,rPartCode,rPartName,
				issueDate,claimContent,carType,machineType,workerCount,issueTime,inputBy,p1,p2,p3,p4,p5,p6,p7});
	}
	
	public List<Map<String,Object>> getClaimRegList(Locale locale, String classType,String stdDt,String endDt,String partCode){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",locale.getCountry())
		.addValue("classType",classType)
		.addValue("stdDt",stdDt)
		.addValue("endDt",endDt)
		.addValue("partNo",partCode);
		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ClaimManageDAO_getClaimRegList").returningResultSet("listRegClaim",new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String, Object>();
				for(int x=0;x<rs.getMetaData().getColumnCount();x++)
					m.put("DATA"+x,rs.getObject((x+1)));
				list.add(m);
				return null;
			}
		});
		sp.execute(params);
		return list;
		
	}
	


}
