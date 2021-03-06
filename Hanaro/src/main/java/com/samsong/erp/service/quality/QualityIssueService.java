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

	public String acceptIssue(String regNo, Locale locale, String user);

	public List<Map<String, Object>> getClaimList(String approvalNo,
			Locale locale);

	public List<Map<String, Object>> get4mTreeData(Locale locale);

	public List<Map<String, Object>> getClaimItemAssistantList(Locale locale);

	public List<Map<String, Object>> getDoneIssueList(Date fromDate,
			Date toDate, String item, Locale locale);

	public IssueApproval getApproval(String approvalNo, Locale locale);

	public IssueApproval updateApproval( IssueApproval approval,Locale locale);

	public void deletePartnerClaim(String approvalNo, String partner,Locale locale);
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



	public void updateClaim(String approvalNo, String partner, double rate,
			String item,String lot, String reason1, String reason2, String reason3,
			String remark, MultipartFile pic1, String pic1id, MultipartFile pic2,
			String pic2id, MultipartFile ref,String refid,String ncr,String reqDate,String request, Locale locale);

	public Map<String, Object> getClaimAttachment(String id);

	public void addClaim(String approvalNo, String partner,
			double rate, String item, String lot, String reason1,
			String reason2, String reason3, String remark, MultipartFile pic1,
			MultipartFile pic2, MultipartFile ref, String ncr, String reqDate,
			String request, Locale locale);

	public Map<String, String> getClaimItemSuppliers(String item, Locale locale);

	
	public List<Map<String,Object>> getNCRList(Locale locale,String division, String occurSite,
			String stdDt, String endDt, String reasonCust, String publishCust);	


	public void cancelApproval(String approvalNo, Locale locale);
	
	public Map<String,Object> getNcrDetailChart(String ncrNo);
	
	public List<Map<String,Object>> getNcrStatus(Locale locale,Map<String,Object> params);
	
	public List<Map<String,Object>> getNcrStatusList(Locale locale, Map<String,Object> params);

	public String readyToAcceptIssue(String regNo, Locale locale,
			String username);

	public IssueApproval getTempApproval(String tempApprovalNo, Locale locale);
 
	public List<Map<String, Object>> getTempClaimList(String approvalNo,
			Locale locale);

	public IssueApproval updateTempApproval(String regNo, IssueApproval approval, Locale locale);

	public void addTempClaim(String approvalNo, String partner, double rate,
			String item, String lot, String reason1, String reason2,
			String reason3, String remark, MultipartFile pic1,
			MultipartFile pic2, MultipartFile ref, String ncr, String reqDate,
			String request, Locale locale);

	public void updateTempClaim(String approvalNo, String partner, double rate,
			String item, String lot, String reason1, String reason2,
			String reason3, String remark, MultipartFile pic1, String pic1id,
			MultipartFile pic2, String pic2id, MultipartFile ref, String refid,
			String ncr, String reqDate, String request, Locale locale);

	public void deletePartnerTempClaim(String approvalNo, String partner,
			Locale locale);

	public Map<String, Object> getTempClaimAttachment(String id);


	public void persistApproval(String regNo,String approvalNo,String username, Locale locale);
	
	public List<Map<String,Object>> getIssueSummary(String occurSite,String searchType,String stdYear,String stdMonth,String stdDay,String endYear,String endMonth,String endDay,String searchLocale,Locale locale);
	
	public Integer getWeekOfYear(String date);
	
	public List<Map<String,Object>> getIssueSummaryDetail(String dateType,String stdYear, String stdMonth,String stdDay,String type,String machineType, String searchLocale, Locale locale);
	
	public Map<String,Object> getCodeMachineType();
	
	public List<Map<String,Object>> getIssueSummaryDetailPOP(String dateType,String stdYear,String stdMonth,String endYear, String endMonth, String machineType, String errorType, String partNo, String custCode, String searchLocale,Locale locale);
		
	public List<Map<String,Object>> getIssueSummaryInoutData(String stdYear,String stdMonth,Locale locale);
	
	public String procIssueSummaryInoutData(final String[] p1, final String[] p2,final  String[] p3,final  String[] p4,final String[] p5, final Locale locale);


	
}
