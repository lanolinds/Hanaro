package com.samsong.erp.service.quality;

import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;


import com.samsong.erp.model.quality.IssueApproval;

import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.model.quality.QualityIssueRegSheet;
 
public interface QualityIssueService {
	public Map<String,Object> getCodeDefectSource(Locale locale,String parentCode);
	
	public List<Map<String,Object>> getOccurPartListForReg(Locale locale,String uid,String partType,String q);
	
	public Map<String,Object> getCodeDefect(Locale locale, int searchLevel,String code);
	
	public void procQualityIssueReg (String procType, Locale locale, QualityIssueRegSheet sheet, String user, byte[] files1, byte[] files2);
	
	public List<Map<String,Object>> getUndoneIssueList(Date fromDate, Date toDate, String item, Locale locale);

	public List<Map<String, Object>> getAssistItemList(Locale locale,String status);
	
	public List<Map<String,Object>> getQualityIssueRegList(Locale locale, String division, String occurSite, String stdDt, String endDt);
	
	public byte[]  getQualityIssueFile(Locale locale, String regNo, String fileSeq);	

	public List<Map<String, Object>> getDefectTreeData(Locale locale);

	public IssueApproval acceptIssue(String regNo, String method,
			int workCost, int testCost,
			String shipType, Locale locale, String user);

	public List<Map<String, Object>> getClaimList(String approvalNo,
			Locale locale);

	public List<Map<String, Object>> get4mTreeData(Locale locale);

	public List<Map<String, Object>> getClaimItemAssistantList(Locale locale);

	public List<Map<String, Object>> getDoneIssueList(Date fromDate,
			Date toDate, String item, Locale locale);

	public IssueApproval getApproval(String approvalNo, Locale locale);

	public void updateApproval(String regNo, IssueApproval approval,Locale locale);

	public void deletePartnerClaim(String approvalNo, String partner);
	public Map<String, Object> getIssueDetails(String regNo, Locale locale);
	
	public void addNcrMeasure(Locale locale, String user, NcrInformSheet sheet, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			MultipartFile[] inputAddFile, MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType);
	
	public void updateNcrMeasure(Locale locale, String user, NcrInformSheet sheet, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			MultipartFile[] inputAddFile, MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType);
	
	public void deleteNcrMeasure(Locale locale, NcrInformSheet sheet);
	
	public List<Map<String,Object>> getNcrMeasureDataGrid(Locale locale, String ncrNo, String gridType);
	
	public List<Map<String,Object>> getNcrDetail(Locale locale, String ncrNo);
	
	public byte[] getNcrMeasureFile(Locale locale,String ncrNo);
	
	public byte[] getNcrMeasureReasonFile(Locale locale,String ncrNo,String fileSeq);
	
	public byte[] getNcrMeasureStandardFile(Locale locale, String ncrNo, String fileSeq);
	
	public List<Map<String,Object>> getNcrMeasureImg(Locale locale, String ncrNo, String fileSeq);
	
	public void updateNCRMeasureProcedure(Locale locale, String ncrNo, String updateType,String comment,
			String date1, String date2, String date3, String date4, String date5, String manager,
			String confirmer, String approver, String fileName, byte[] file, String resultEvaluation,
			String user);	
	public byte[] getNCREvaluationFile(Locale locale, String ncrNo);

	
}
