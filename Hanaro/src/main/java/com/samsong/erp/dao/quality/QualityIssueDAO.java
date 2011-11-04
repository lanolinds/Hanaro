package com.samsong.erp.dao.quality;

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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
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
	
	
	public void procQualityIssueReg(String procType, Locale locale, QualityIssueRegSheet sheet, String user, byte[] files1, byte[] files2){
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
		   params.put("file1Name",sheet.getFile1());
		   params.put("file2Name",sheet.getFile2());		   
		   params.put("file1",files1);
		   params.put("file2",files2);
		   params.put("user",user);
		   sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_procQualityIssueReg");		
		   sp.execute(params);   	
     }
	
	//처리 안 된 품질문제 리스트를 가져온다.
	public List<Map<String,Object>> getUndoneIssueList(Date fromDate, Date toDate, String item, Locale locale){
		final SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		return jdbc.query("exec QualityIssueDAO_getUndoneIssueList ?,?,?,?",new Object[] {fromDate,toDate,item, locale.getCountry()},
				new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int index)
					throws SQLException {
				Map<String,Object> m = new HashMap<String,Object>();
				m.put("regNo",rs.getString(1));
				m.put("date",fmt.format(rs.getObject(2)));
				m.put("place", rs.getString(3));
				m.put("placeCode", rs.getString(4));
				m.put("item",rs.getString(5));
				m.put("count",rs.getInt(6));
				m.put("remark",rs.getString(7));
				return m;
			}
		});
	}

	public List<Map<String, Object>> getAssistItemList(Locale locale,String status) {
		return jdbc.query("exec QualityIssueDAO_getAssistItemList ?,?",new Object[]{locale.getCountry(),status},
				new RowMapper<Map<String,Object>>(){

					@Override
					public Map<String, Object> mapRow(ResultSet rs, int i)
							throws SQLException {
						Map<String,Object> m = new HashMap<String,Object>();
						m.put("item", rs.getString("item"));
						m.put("name", rs.getString("name"));
						m.put("car", rs.getString("car"));
						m.put("model", rs.getString("model"));
						return m;
					}
			
		});
	}
	
	
	//품질등록리스트를 조회한다.
	public List<Map<String,Object>> getQualityIssueRegList(Locale locale,String division, String occurSite, String stdDt, String endDt){
		final List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",locale.getCountry())
		.addValue("division",division)
		.addValue("occurSite",occurSite)
		.addValue("occurDateStd",stdDt)
		.addValue("occurDateEnd",endDt);		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_getQualityIssueRegList").returningResultSet("issueRegList", new RowMapper<Map<String,Object>>(){			
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int i)
					throws SQLException {				
				Map<String,Object> m = new HashMap<String,Object>();
				for(int x=0;x<rs.getMetaData().getColumnCount();x++){
					m.put("DATA"+x,rs.getObject((x+1)));
				}
				resultList.add(m);
				return null;
			}
		});
		sp.execute(params);
		return resultList;
	}
	
	// 품질 파일을 조회한다.
	public byte[] getQualityIssueFile(Locale locale, String regNo, String fileSeq){
		String sql = "select [file] from qis_quality_defect_file where  LOCALE =   ?   AND  REG_NO = ?   AND  [file_seq] = ?";
		
		return  jdbc.queryForObject(sql,new Object[]{locale.getCountry(),regNo,fileSeq},new RowMapper<byte[]>(){
			@Override
			public byte[] mapRow(ResultSet rs, int rowNum) throws SQLException {		
				 return rs.getBytes(1);
			}
			 
		 });
		
	}

	public Map<String, Object> getIssueDetails(String regNo, Locale locale) {
		return jdbc.queryForMap("exec QualityIssueDAO_getIssueDetails ?,?; ", new Object[]{regNo,locale.getCountry()});
	}

	public List<Map<String, Object>> getDefectTreeData(Locale locale) {
		// 테이블 구성이 tree에 적합하지 않음. 재귀함수 적용 포기.
		
		String country=locale.getCountry();
		//1단계
		String sql = "select code, name from code_defect where locale=? and (len(code) - len(replace(code,'-','')))=?;";
		List<Map<String,Object>> level0=jdbc.query(sql,new Object[]{country,0}, new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int i)
					throws SQLException {
				Map<String,Object> node = new HashMap<String,Object>();
				List<Map<String,Object>> children = new ArrayList<Map<String,Object>>();
				node.put("id", rs.getString(1));
				node.put("text", rs.getString(2));
				node.put("state","closed");
				node.put("iconCls", "icon-brick-add");
				node.put("children", children);
				return node;
			}
		});
		//2단계
			List<Map<String,Object>> level1=jdbc.query(sql,new Object[]{country,1}, new RowMapper<Map<String,Object>>(){

				@Override
				public Map<String, Object> mapRow(ResultSet rs, int i)
						throws SQLException {
					Map<String,Object> node = new HashMap<String,Object>();
					List<Map<String,Object>> children = new ArrayList<Map<String,Object>>();
					node.put("id", rs.getString(1));
					node.put("text", rs.getString(2));
					node.put("state","closed");
					node.put("iconCls", "icon-error-add");
					node.put("children", children);
					return node;
				}
			});
		//3단계
		List<Map<String,Object>> level2=jdbc.query(sql,new Object[]{country,2}, new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int i)
					throws SQLException {
				Map<String,Object> node = new HashMap<String,Object>();
				node.put("id", rs.getString(1));
				node.put("text", rs.getString(2));
				node.put("iconCls", "icon-bullet-error");
				node.put("checked", true);
				return node;
			}
		});
		
		//3단계를 2단계에 넣기.
		for(Map<String,Object> node: level2){
			String parent =(String)node.get("id");
			parent = parent.substring(0,parent.lastIndexOf("-"));
			for(Map<String,Object> n: level1){
				if(n.get("id").equals(parent)){
					((List<Map<String,Object>>)n.get("children")).add(node);
					break;
				}
			}
		}
		
		//2단계를 1단계에 넣기.
		for(Map<String,Object> node: level1){
			String parent =(String)node.get("id");
			parent = parent.substring(0,parent.lastIndexOf("-"));
			for(Map<String,Object> n: level0){
				if(n.get("id").equals(parent)){
					((List<Map<String,Object>>)n.get("children")).add(node);
					break;
				}
			}
		}
		return level0;
	}

}
