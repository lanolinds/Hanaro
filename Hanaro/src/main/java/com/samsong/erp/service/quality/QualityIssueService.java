package com.samsong.erp.service.quality;

import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.samsong.erp.model.quality.IssueApproval;
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

	public Map<String, Object> getIssueDetails(String regNo, Locale locale);

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
	
}
