package com.samsong.erp.dao.quality;

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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.quality.NcrInformSheet;
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
	
	
	public void addNcrMeasure(Locale locale, final NcrInformSheet sheet, String user, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			final MultipartFile[] inputAddFile, final MultipartFile[] inputChangeFile, final MultipartFile[] stanFile){
		
		   String sqlHead = "UPDATE [qis_ncr_step1_head] SET [locale] = ? , [title] = ?";
		   sqlHead+=" ,[custManager] = ?, [custConfirmer] = ? ,[custApprover] = ? ,[measureReportName] = ?";
		   sqlHead+=" ,[status] = 'REG', [rejectCount] = 0 ,[inputBy] = ?, [inputDt] = getdate()";
		   sqlHead+=" WHERE ncrNo = ?";		   
		   jdbc.update(sqlHead,new Object[]{locale.getCountry(),sheet.getTitle()
				   ,sheet.getCustManager(),sheet.getCustConfirmer(),sheet.getCustAppover()
				   ,sheet.getMeasureFileName(),user,sheet.getNcrNo()});
		   
		   String sqlHeadFile ="INSERT INTO [qis_ncr_step1_head_measure_file] ([ncrNo],[measureReport])";
		   sqlHeadFile+=" VALUES (?,?)";
		   jdbc.update(sqlHeadFile,new Object[]{sheet.getNcrNo(),measureFile});	   
		   		   
		   String sqlMeasureReason="INSERT INTO [qis_ncr_step1_measure_reason] ([ncrNo],[occurReason] ";
		   sqlMeasureReason+=",[otherReason] ,[imgReason1] ,[imgReason2] ,[imgTempMeasure] ,[imgMeasure1] ,[imgMeasure2])";
		   sqlMeasureReason+=" VALUES (?,?,?,?,?,?,?,?)";
		   jdbc.update(sqlMeasureReason, new Object[]{sheet.getNcrNo(),sheet.getReasonIssue(),sheet.getReasonOutflow(),
				   sheet.getImgReason1FileName(),sheet.getImgReason2FileName(),sheet.getImgTempMeasureFileName(),
				   sheet.getImgMeasure1FileName(),sheet.getImgMeasure2FileName()});		   
		   
		   String sqlMeasureReasonFile="INSERT INTO [qis_ncr_step1_measure_reason_file] ";
		   sqlMeasureReasonFile+="([ncrNo],[imgReason1],[imgReason2],[imgTempMeasure],[imgMeasure1],[imaMeasure2])";
		   sqlMeasureReasonFile+=" VALUES (?,?,?,?,?,?)";
		   jdbc.update(sqlMeasureReasonFile,new Object[]{sheet.getNcrNo(),imgReason1,imgReason2,imgTempMeasure,imgMeasure1,imgMeasure2});
		   
		   
		   if(inputAddFile!=null){
			   String sqlReasonFile="INSERT INTO [qis_ncr_step1_reason_file]([ncrNo],[file],[fileName])";
			   sqlReasonFile+=" VALUES (?,?,?)";
			   jdbc.batchUpdate(sqlReasonFile,new BatchPreparedStatementSetter() {			
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						try {
							ps.setString(1,sheet.getNcrNo());
							ps.setBytes(2, inputAddFile[i].getBytes());
							ps.setString(3, inputAddFile[i].getOriginalFilename());
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					@Override
					public int getBatchSize() {
						return inputAddFile.length;
					}
			   	});
		   }
		   
		   if(sheet.getTempMeasure()!=null){
			   String sqlTempMeasure="INSERT INTO [qis_ncr_step1_temp_measure]([ncrNo],[contents],[date])";
			   sqlTempMeasure+=" VALUES (?,?,?)";
				   jdbc.batchUpdate(sqlTempMeasure,new BatchPreparedStatementSetter() {
					
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getTempMeasure()[i]);
						ps.setString(3,(sheet.getTempMeasureDate()[i].trim().equals(""))?null:sheet.getTempMeasureDate()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getTempMeasure().length;
					}
				});
		   }
			   
		   if(sheet.getMeasure()!=null){
				String sqlLastMeasure="INSERT INTO [qis_ncr_step1_last_measure]([ncrNo],[contens],[date])";
				sqlLastMeasure+=" VALUES(?,?,?)";
				jdbc.batchUpdate(sqlLastMeasure, new BatchPreparedStatementSetter() {
					
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
							ps.setString(1,sheet.getNcrNo());
							ps.setString(2,sheet.getMeasure()[i]);
							ps.setString(3,(sheet.getMeasureDate()[i].trim().equals(""))?null:sheet.getMeasureDate()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getMeasure().length;
					}
				});
		   }
			
		   if(sheet.getLotNo()!=null){
				String sqlLotConfirm="INSERT INTO [qis_ncr_step1_confirm_lotno]([ncrNo],[lotNo],[contents],[remark])";
				sqlLotConfirm+=" VALUES(?,?,?,?)";
				jdbc.batchUpdate(sqlLotConfirm,new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getLotNo()[i]);
						ps.setString(3,sheet.getConfirm()[i]);
						ps.setString(4,sheet.getRemark()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getLotNo().length;
					}
				});
		   }
		    
		   if(sheet.getInputBeforChange()!=null){
			   String sqlStandard="INSERT INTO [qis_ncr_step1_standard]([ncrNo],[before],[after],[changeDate],[fileSeq],[standardSeq],[fileName])";
			   sqlStandard+=" VALUES(?,?,?,?,?,?,?)";
			   jdbc.batchUpdate(sqlStandard,new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getInputBeforChange()[i]);
						ps.setString(3,sheet.getInputAfterChange()[i]);
						ps.setString(4,(sheet.getInputChangeDate()[i].trim().equals(""))?null:sheet.getInputChangeDate()[i]);
						ps.setInt(5,sheet.getInputStandardSeq()[i]);
						ps.setInt(6,sheet.getInputStandardSeq()[i]);
						ps.setString(7,inputChangeFile[i].getOriginalFilename());
					}
					
					@Override
					public int getBatchSize() {
						return sheet.getInputBeforChange().length;
					}
				});			   
		 
			   String sqlStandardFile1="INSERT INTO [qis_ncr_step1_standard_file]([ncrNo],[fileSeq],[file])";
			   sqlStandardFile1+=" VALUES(?,?,?)";			   
			   
			   jdbc.batchUpdate(sqlStandardFile1, new BatchPreparedStatementSetter() {
				
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
							try {
								ps.setString(1,sheet.getNcrNo());
								ps.setInt(2,sheet.getInputStandardSeq()[i]);
								ps.setBytes(3,inputChangeFile[i].getBytes());
							} catch (IOException e) {
								e.printStackTrace();
							}
					}
					
					@Override
					public int getBatchSize() {
						return inputChangeFile.length;
					}
				});
		   }
		   
		   if(sheet.getStanContents()!=null){
			   String sqlStandardEtc="INSERT INTO [qis_ncr_step1_standard_etc]([ncrNo],[contents],[fileSeq],[fileName])";
			   sqlStandardEtc+=" VALUES(?,?,?,?)";
			   jdbc.batchUpdate(sqlStandardEtc,new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getStanContents()[i]);
						ps.setInt(3,(i+5));
						ps.setString(4,stanFile[i].getOriginalFilename());
					}
					
					@Override
					public int getBatchSize() {
						return sheet.getStanContents().length;
					}
				});
			   
			   String sqlStandardFile2="INSERT INTO [qis_ncr_step1_standard_file]([ncrNo],[fileSeq],[file])";
			   sqlStandardFile2+=" VALUES(?,?,?)";
			   jdbc.batchUpdate(sqlStandardFile2,new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						try {
							ps.setString(1,sheet.getNcrNo());
							ps.setInt(2,(i+5));							
							ps.setBytes(3,stanFile[i].getBytes());
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					
					@Override
					public int getBatchSize() {
						return sheet.getStanContents().length;
					}
				});			   
		   }
		   
	}
	
	public void updateNcrMeasure(Locale locale, final NcrInformSheet sheet, String user, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			final MultipartFile[] inputAddFile, final MultipartFile[] inputChangeFile, final MultipartFile[] stanFile){
		
		   String sqlHead = "UPDATE [qis_ncr_step1_head] SET [locale] = ? , [title] = ?";
		   sqlHead+=" ,[custManager] = ?, [custConfirmer] = ? ,[custApprover] = ?";
		   sqlHead+=" ,[status] = 'REG', [rejectCount] = 0 ,[updateBy] = ?, [updateDt] = getdate()";
		   sqlHead+=" WHERE ncrNo = ?";		   
		   jdbc.update(sqlHead,new Object[]{locale.getCountry(),sheet.getTitle()
				   ,sheet.getCustManager(),sheet.getCustConfirmer(),sheet.getCustAppover()
				   ,user,sheet.getNcrNo()});
		   
		   if(!sheet.getMeasureFileName().equals("")){
			   String sqlHeadFile ="UPDATE [qis_ncr_step1_head_measure_file] SET [measureReport] = ?";
			   sqlHeadFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlHeadFile,new Object[]{measureFile,sheet.getNcrNo()});
			   sqlHeadFile =" UPDATE [qis_ncr_step1_head] SET [measureReportName] = ?";
			   sqlHeadFile+=" WHERE ncrNo = ?";				   
			   jdbc.update(sqlHeadFile,new Object[]{sheet.getMeasureFileName(),sheet.getNcrNo()});
		   }
		   
		   String sqlMeasureReason="UPDATE [qis_ncr_step1_measure_reason] SET [occurReason] = ?,[otherReason] = ?";
		   sqlMeasureReason+=" WHERE ncrNo = ?";
		   jdbc.update(sqlMeasureReason, new Object[]{sheet.getReasonIssue(),sheet.getReasonOutflow(),sheet.getNcrNo()});
		   
		   if(!sheet.getImgReason1FileName().equals("")){
			   String sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason] SET [imgReason1] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{sheet.getImgReason1FileName(),sheet.getNcrNo()});
			   sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason_file] SET [imgReason1] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{imgReason1,sheet.getNcrNo()});
		   }
		   if(!sheet.getImgReason2FileName().equals("")){
			   String sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason] SET [imgReason2] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{sheet.getImgReason2FileName(),sheet.getNcrNo()});
			   sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason_file] SET [imgReason2] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{imgReason2,sheet.getNcrNo()});
		   }
		   if(!sheet.getImgTempMeasureFileName().equals("")){
			   String sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason] SET [imgTempMeasure] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{sheet.getImgTempMeasureFileName(),sheet.getNcrNo()});
			   sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason_file] SET [imgTempMeasure] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{imgTempMeasure,sheet.getNcrNo()});
		   }		   
		   if(!sheet.getImgMeasure1FileName().equals("")){
			   String sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason] SET [imgMeasure1] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{sheet.getImgMeasure1FileName(),sheet.getNcrNo()});
			   sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason_file] SET [imgMeasure1] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{imgMeasure1,sheet.getNcrNo()});
		   }
		   if(!sheet.getImgMeasure2FileName().equals("")){
			   String sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason] SET [imgMeasure2] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{sheet.getImgMeasure2FileName(),sheet.getNcrNo()});
			   sqlMeasureReasonFile="UPDATE [qis_ncr_step1_measure_reason_file] SET [imgMeasure2] = ?";
			   sqlMeasureReasonFile+=" WHERE ncrNo = ?";
			   jdbc.update(sqlMeasureReasonFile, new Object[]{imgMeasure2,sheet.getNcrNo()});
		   }		   		   		   

		   
		   if(sheet.getReasonFileSeq()!=null){
			  for(int i=0;i<sheet.getReasonFileSeq().length;i++){
				  String sql="";
				  if(sheet.getReasonFileState()[i].equals("a")){
					  sql = "INSERT INTO [qis_ncr_step1_reason_file]([ncrNo],[file],[fileName])";
				  	  sql+=" VALUES(?,?,?)";
				  	  try {
						jdbc.update(sql, new Object[]{sheet.getNcrNo(),inputAddFile[i].getBytes(),inputAddFile[i].getOriginalFilename()});
					} catch (Exception e) {
						e.printStackTrace();
					}   
				  }
				  else if(sheet.getReasonFileState()[i].equals("u")){
					  sql="UPDATE [qis_ncr_step1_reason_file] SET [file] = ?, [fileName] = ?";
					  sql+=" WHERE ncrNo = ? and fileSeq = ?";
					  try {
						jdbc.update(sql, new Object[]{inputAddFile[i].getBytes(),inputAddFile[i].getOriginalFilename(),sheet.getNcrNo(),sheet.getReasonFileSeq()[i]});
					}  catch (Exception e) {
						e.printStackTrace();
					}  
				  }
				  else if(sheet.getReasonFileState()[i].equals("d")){
					 sql="DELETE FROM [qis_ncr_step1_reason_file] WHERE ncrNo = ? and fileSeq = ?";
					 jdbc.update(sql, new Object[]{sheet.getNcrNo(),sheet.getReasonFileSeq()[i]});
				  }
				  	    
			  }
		   }
		   
		   String sqlTempMeasureDelete="DELETE FROM [qis_ncr_step1_temp_measure] WHERE ncrNo = ? ";
		   jdbc.update(sqlTempMeasureDelete, new Object[]{sheet.getNcrNo()});
		   
		   if(sheet.getTempMeasure()!=null){
			   String sqlTempMeasure="INSERT INTO [qis_ncr_step1_temp_measure]([ncrNo],[contents],[date])";
			   sqlTempMeasure+=" VALUES (?,?,?)";
				   jdbc.batchUpdate(sqlTempMeasure,new BatchPreparedStatementSetter() {
					
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getTempMeasure()[i]);
						ps.setString(3,(sheet.getTempMeasureDate()[i].trim().equals(""))?null:sheet.getTempMeasureDate()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getTempMeasure().length;
					}
				});
		   }
		   
		   String sqlMeasureDelete="DELETE FROM [qis_ncr_step1_last_measure] WHERE ncrNo = ? ";
		   jdbc.update(sqlMeasureDelete, new Object[]{sheet.getNcrNo()});		   
			   
		   if(sheet.getMeasure()!=null){
				String sqlLastMeasure="INSERT INTO [qis_ncr_step1_last_measure]([ncrNo],[contens],[date])";
				sqlLastMeasure+=" VALUES(?,?,?)";
				jdbc.batchUpdate(sqlLastMeasure, new BatchPreparedStatementSetter() {
					
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
							ps.setString(1,sheet.getNcrNo());
							ps.setString(2,sheet.getMeasure()[i]);
							ps.setString(3,(sheet.getMeasureDate()[i].trim().equals(""))?null:sheet.getMeasureDate()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getMeasure().length;
					}
				});
		   }
		   
		   String sqlLotDelete="DELETE FROM [qis_ncr_step1_confirm_lotno] WHERE ncrNo = ? ";
		   jdbc.update(sqlLotDelete, new Object[]{sheet.getNcrNo()});			   
			
		   if(sheet.getLotNo()!=null){
				String sqlLotConfirm="INSERT INTO [qis_ncr_step1_confirm_lotno]([ncrNo],[lotNo],[contents],[remark])";
				sqlLotConfirm+=" VALUES(?,?,?,?)";
				jdbc.batchUpdate(sqlLotConfirm,new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1,sheet.getNcrNo());
						ps.setString(2,sheet.getLotNo()[i]);
						ps.setString(3,sheet.getConfirm()[i]);
						ps.setString(4,sheet.getRemark()[i]);
					}
					@Override
					public int getBatchSize() {
						return sheet.getLotNo().length;
					}
				});
		   }
		   
		   
		    
		   if(sheet.getInputBeforChange()!=null){
			   for(int i=0;i<4;i++){
				   String sqlStandard="UPDATE [qis_ncr_step1_standard] set [before] = ?,[after]=?,[changeDate]=?";
				   sqlStandard+=" WHERE ncrNo=? and [standardSeq] = ?";
				   jdbc.update(sqlStandard, new Object[]{
						   sheet.getInputBeforChange()[i],
						   sheet.getInputAfterChange()[i],
						   (sheet.getInputChangeDate()[i].trim().equals(""))?null:sheet.getInputChangeDate()[i],								   
						   sheet.getNcrNo(),
						   sheet.getInputStandardSeq()[i]});
				   
				   
				   
				   if(sheet.getInputChangeState()[i].equals("d")){
					   String sqlDelete="UPDATE [qis_ncr_step1_standard] set [fileName] = ''  WHERE ncrNo=? and [standardSeq] = ?";
					   jdbc.update(sqlDelete, new Object[]{sheet.getNcrNo(),sheet.getInputStandardSeq()[i]});
					   sqlDelete = "UPDATE [qis_ncr_step1_standard_file] set [file] = null  WHERE ncrNo=? and [fileSeq] = ?";
					   jdbc.update(sqlDelete, new Object[]{sheet.getNcrNo(),sheet.getInputStandardSeq()[i]});
				   }else if(!inputChangeFile[i].getOriginalFilename().equals("")){
					   try {
						   String sqlDelete="UPDATE [qis_ncr_step1_standard] set [fileName] = ?  WHERE ncrNo=? and [standardSeq] = ?";
						   jdbc.update(sqlDelete, new Object[]{inputChangeFile[i].getOriginalFilename(),sheet.getNcrNo(),sheet.getInputStandardSeq()[i]});
						   sqlDelete = "UPDATE [qis_ncr_step1_standard_file] set [file] = ?  WHERE ncrNo=? and [fileSeq] = ?";						   
						jdbc.update(sqlDelete, new Object[]{inputChangeFile[i].getBytes(),sheet.getNcrNo(),sheet.getInputStandardSeq()[i]});
						} catch (Exception e) {
							e.printStackTrace();
						}
				   }
			   }
		   }
		   
		   if(sheet.getStanContents()!=null){			   
			   for(int i=0;i<sheet.getStanContents().length;i++){
				   String sqlStandardEtc="";
				   int maxNum = 0;
				   
				   String sqlMax ="SELECT max([fileSeq]) FROM [qis_ncr_step1_standard_etc]";
				   sqlMax+=" WHERE ncrNo=?";
				   
				   maxNum =  jdbc.queryForObject(sqlMax,new Object[]{sheet.getNcrNo()},new RowMapper<Integer>(){
						@Override
						public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {		
							 return rs.getInt(1);
						}
						 
				    });
				   
				   if(sheet.getStandardState()[i].equals("d")){
					   sqlStandardEtc="DELETE FROM [qis_ncr_step1_standard_etc]";
					   sqlStandardEtc+=" WHERE ncrNo=? and [fileSeq] = ?";
					   jdbc.update(sqlStandardEtc, new Object[]{sheet.getNcrNo(),sheet.getStandardEtcSeq()[i]});
					   sqlStandardEtc="DELETE FROM [qis_ncr_step1_standard_file]";
					   sqlStandardEtc+=" WHERE ncrNo=? and [fileSeq] = ?";
					   jdbc.update(sqlStandardEtc, new Object[]{sheet.getNcrNo(),sheet.getStandardEtcSeq()[i]});
				   }else if(sheet.getStandardState()[i].equals("u")){
					   sqlStandardEtc="UPDATE [qis_ncr_step1_standard_etc] set [contents]= ?, [fileName] = ?";
					   sqlStandardEtc+=" WHERE ncrNo=? and [fileSeq] = ?";
					   jdbc.update(sqlStandardEtc, new Object[]{sheet.getStanContents()[i],stanFile[i].getOriginalFilename(),sheet.getNcrNo(),sheet.getStandardEtcSeq()[i]});
					   try {
					    sqlStandardEtc="UPDATE [qis_ncr_step1_standard_file] set [file] = ?";
					    sqlStandardEtc+=" WHERE ncrNo=? and [fileSeq] = ?";						   
						jdbc.update(sqlStandardEtc, new Object[]{stanFile[i].getBytes(),sheet.getNcrNo(),sheet.getStandardEtcSeq()[i]});
					   } catch (Exception e) {
						e.printStackTrace();
					   }			
				   }else if(sheet.getStandardState()[i].equals("a")){
					   sqlStandardEtc="INSERT INTO [qis_ncr_step1_standard_etc]([ncrNo],[contents],[fileSeq],[fileName])";
					   sqlStandardEtc+=" VALUES(?,?,?,?)";
					   jdbc.update(sqlStandardEtc, new Object[]{sheet.getNcrNo(),sheet.getStanContents()[i],maxNum+1,stanFile[i].getOriginalFilename()});
					   try {
						   sqlStandardEtc="INSERT INTO [qis_ncr_step1_standard_file]([ncrNo],[fileSeq],[file])";
						   sqlStandardEtc+=" VALUES(?,?,?)";						   
							jdbc.update(sqlStandardEtc, new Object[]{sheet.getNcrNo(),maxNum+1,stanFile[i].getBytes()});
						} catch (Exception e) {
							e.printStackTrace();
						}					   
				   }
			   }
					   
		   }
		   
	}
	
	public void deleteNcrMeasure(Locale locale, NcrInformSheet sheet){
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("locale",locale.getCountry());
		param.put("ncrNo",sheet.getNcrNo());
		sp = new SimpleJdbcCall(jdbc).withProcedureName("QualityIssueDAO_deleteNCRMeasure");
		sp.execute(param);
	}
	
	//NCR대책서 GRID를 조회한다.
	public List<Map<String,Object>> getNcrMeasureDataGrid(Locale locale,String ncrNo,String gridType){
		String sql ="";
		if(gridType.equals("reasonFile")){
			sql= "SELECT [fileName],[fileSeq] FROM [qis_ncr_step1_reason_file]";
			sql+=" WHERE ncrNo=?";
		}else if(gridType.equals("tempMeasure")){
			sql= "SELECT [contents],convert(nvarchar(10),[date],121) FROM [qis_ncr_step1_temp_measure]";
			sql+=" WHERE ncrNo=?";
		}else if(gridType.equals("measure")){
			sql= "SELECT [contens],convert(nvarchar(10),[date],121) FROM [qis_ncr_step1_last_measure]";
			sql+=" WHERE ncrNo=?";
		}else if(gridType.equals("lotConfirm")){
			sql= "SELECT [lotNo],[contents],[remark] FROM [qis_ncr_step1_confirm_lotno]";
			sql+=" WHERE ncrNo=?";
		}else if(gridType.equals("standard")){
			sql= "SELECT [before],[after],convert(nvarchar(10),[changeDate],121),[fileName] FROM [qis_ncr_step1_standard]";
			sql+=" WHERE ncrNo=? order by [standardSeq] asc";
		}else if(gridType.equals("standardEtc")){
			sql= "SELECT [contents],[fileName],[fileSeq] FROM [qis_ncr_step1_standard_etc]";
			sql+=" WHERE ncrNo=? order by [fileSeq] asc";
		}
		return jdbc.query(sql, new Object[]{ncrNo}, new RowMapper<Map<String,Object>>(){

			@Override
			public Map<String, Object> mapRow(ResultSet rs, int rowNum)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				for(int x=0;x<rs.getMetaData().getColumnCount();x++){
					m.put("DATA"+x,rs.getObject(x+1));
				}
				return m;
				
			}
			
		});
		
	}


}
