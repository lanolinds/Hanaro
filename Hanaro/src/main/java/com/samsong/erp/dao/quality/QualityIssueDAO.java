package com.samsong.erp.dao.quality;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import com.samsong.erp.model.quality.QualityIssueRegSheet;

@Repository
public class QualityIssueDAO {
		
	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;
	
	@Autowired
	public void init(DataSource ds){
		jdbc = new JdbcTemplate(ds);
	}
	
	public Map<String,Object> getCodeDefectSource(Locale locale, String parentCode){
		
		final Map<String,Object> defects = new LinkedHashMap<String,Object>();
		SqlParameterSource params = new MapSqlParameterSource()
				.addValue("locale", locale.getCountry())
				.addValue("parentCode",parentCode);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_getCodeDefectSource").returningResultSet("category", new RowMapper(){
			public Map<String,String> mapRow(ResultSet rs, int i) throws SQLException {
				defects.put(rs.getString("code"),rs.getString("name"));
				return null;
			}
		});
		sp.execute(params);
		return defects;		
	}	
	
	public List<Map<String,Object>> getOccurPartListForReg(Locale locale, String uid,String partType, String q){
		
		final List<Map<String,Object>> partList = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
				.addValue("locale", locale.getCountry())
				.addValue("uid",uid)
				.addValue("partType",partType)
				.addValue("term",q);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_getOccurPartListForReg").returningResultSet("partList", new RowMapper<List<Map<String,Object>>>(){

			public List<Map<String,Object>> mapRow(ResultSet rs, int i) throws SQLException {
				 Map<String,Object> cell = new LinkedHashMap<String,Object>();
				 cell.put("partNo",rs.getString(1));
				 cell.put("partName",rs.getString(2));
				 cell.put("car",rs.getString(3));
				 cell.put("model",rs.getString(4));
				 partList.add(cell);
				return null;
			}
			 
		});
		sp.execute(params);
		return partList;		
	}
	
	public Map<String,Object> getCodeDefect(Locale locale, int searchLevel, String code){
		String sql = "select code,name from code_defect where locale = ? and len(code) - len(replace(code,'-','')) = ? and code like case(?) when '' then '%%' else ?+'%' end;";
		final Map<String,Object> map  = new LinkedHashMap<String,Object>();
			
			jdbc.query(sql,new Object[]{locale.getCountry(),searchLevel,code,code},new RowCallbackHandler() {
				@Override
				public void processRow(ResultSet rs) throws SQLException {
					map.put(rs.getString(1),rs.getString(2));
				}
			});
		return map;
	}
	
	
	public void procQualityIssueReg(String procType, Locale locale, QualityIssueRegSheet sheet, String user){
		   Map<String ,Object> params = new HashMap<String,Object>();
		   params.put("procType",procType);
		   params.put("locale",locale.getCountry());
		   params.put("regNo",sheet.getRegNo());
		   params.put("division",sheet.getDivision());
		   params.put("occurSite",sheet.getOccurSite());
		   params.put("occurDate",sheet.getOccurDate());
		   params.put("occurAmPm",sheet.getOccurAmPm());
		   params.put("occurHour",sheet.getOccurHour());
		   params.put("occurPartNo",sheet.getOccurPartNo());
		   params.put("partSupplier",sheet.getPartSupplier());
		   params.put("occurPlace",sheet.getOccurPlace());
		   params.put("occurLine",sheet.getOccurLine());
		   params.put("occurProc",sheet.getOccurProc());
		   params.put("lotNo",sheet.getLotNo());
		   params.put("defectL",sheet.getDefectL());
		   params.put("defectM",sheet.getDefectM());
		   params.put("defectS",sheet.getDefectS());
		   params.put("defectAmount",sheet.getDefectAmount());
		   params.put("explanation",sheet.getExplanation());
		   params.put("file1",sheet.getFile1());
		   params.put("file2",sheet.getFile2());
		   params.put("user",user);		
		   sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_procQualityIssueReg");		
		   sp.execute(params);   	
     }
	
	//처리 안 된 품질문제 리스트를 가져온다.
	public List<Map<String,Object>> getUndoneIssueList(Locale locale){
		final SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		return jdbc.query("exec QualityIssueDAO_getUndoneIssueList ?",new Object[] { locale.getCountry()}, new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int index)
					throws SQLException {
				Map<String,Object> m = new HashMap<String,Object>();
				m.put("regNo",rs.getString(1));
				m.put("date",fmt.format(rs.getObject(2)));
				m.put("item",rs.getString(3));
				m.put("count",rs.getInt(4));
				m.put("remark",rs.getString(5));
				return m;
			}
		});
	}
	

}
