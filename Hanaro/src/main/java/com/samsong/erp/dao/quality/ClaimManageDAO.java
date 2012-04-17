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
import org.springframework.web.multipart.MultipartFile;

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
								String machineType,String workerCount,String issueTime,String failAmount,String inputBy,String p1,String p2,String p3,String p4,
								String p5,String p6,String p7,String p8,String lotNo,String file1Name,String file2Name,String file3Name,String file4Name,String file5Name,
								byte[] file1, byte[] file2,byte[] file3,byte[] file4,byte[] file5,String file1Type,String file2Type,String file3Type,String file4Type,String file5Type){
		String query ="exec [ClaimManageDAO_prodClaimManage] ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"; 
		jdbc.update(query, new Object[]{locale.getCountry(),prodType,classType,claimNo,invoiceNo,claimCost,issueCust,issueTeam,cost,partType,rPartCode,rPartName,
				issueDate,claimContent,carType,machineType,workerCount,issueTime,failAmount,inputBy,p1,p2,p3,p4,p5,p6,p7,p8,lotNo,file1Name,file2Name,file3Name,file4Name,
				file5Name,file1,file2,file3,file4,file5,file1Type,file2Type,file3Type,file4Type,file5Type});
	}
	
	public List<Map<String,Object>> getClaimRegList(Locale locale, String classType,String stdDt,String endDt,String partCode,String searchLocale){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",(locale.getCountry().equalsIgnoreCase("KR"))?searchLocale:locale.getCountry())
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
	
	public List<Map<String,Object>> getClaimAgreeList(Locale locale,String selLocale,String regStdDt,String regEndDt,String regPartNo, String invoiceNo
			,String car, String model, String type, String inputBy, String deptCode, String state, String agreeStdDt, String agreeEndDt,String agreeBy){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params  = new MapSqlParameterSource()
		.addValue("locale",(locale.getCountry().equalsIgnoreCase("KR"))?selLocale:locale.getCountry())
		.addValue("regStdDt",regStdDt)
		.addValue("regEndDt",regEndDt)
		.addValue("regPartNo",regPartNo)
		.addValue("invoiceNo",invoiceNo)
		.addValue("car",car)
		.addValue("model",model)
		.addValue("type",type)
		.addValue("inputBy",inputBy)
		.addValue("deptCode",deptCode)
		.addValue("state",state)
		.addValue("agreeStdDt",agreeStdDt)
		.addValue("agreeEndDt",agreeEndDt)
		.addValue("agreeBy",agreeBy);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ClaimManageDAO_getClaimAgreeList").returningResultSet("realAgreeList",new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				for(int x=0;x<rs.getMetaData().getColumnCount();x++)
					m.put("DATA"+x,rs.getObject((1+x)));
				list.add(m);
				return null;
			}
		});
		
		sp.execute(params);
		return list;
	}
	
	public List<Map<String,Object>> getClaimActionItem(Locale locale, String type, String q){
		return jdbc.queryForList("exec [ClaimManageDAO_getClaimActionItem] ?,?,?",locale.getCountry(),type,q);
	}
	
	public byte[] getClaimFile(String claimNo,String fileSeq) {
		String sql = "select [file] from qis_real_claim_file where  claimNo =   ?   AND  [fileSeq] = ?";

		return jdbc.queryForObject(sql, new Object[] { claimNo, fileSeq }, new RowMapper<byte[]>() {
			@Override
			public byte[] mapRow(ResultSet rs, int rowNum) throws SQLException {
				return rs.getBytes(1);
			}

		});

	}	


}
