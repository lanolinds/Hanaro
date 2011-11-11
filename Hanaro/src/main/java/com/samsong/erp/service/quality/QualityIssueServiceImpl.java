package com.samsong.erp.service.quality;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.quality.QualityIssueDAO;
import com.samsong.erp.model.quality.IssueApproval;
import com.samsong.erp.model.quality.QualityIssueRegSheet;

@Service
public class QualityIssueServiceImpl implements QualityIssueService {
 
	@Autowired
	private QualityIssueDAO dao;
	
	private static Logger logger = Logger.getLogger(QualityIssueServiceImpl.class);
	
	public Map<String,Object>  getCodeDefectSource(Locale locale, String parentCode) {		
		return dao.getCodeDefectSource(locale, parentCode);
	}

	public List<Map<String, Object>> getOccurPartListForReg(Locale locale,
			String uid, String partType, String q) {		 
		return dao.getOccurPartListForReg(locale, uid, partType, q);
	}

	@Override
	public Map<String, Object> getCodeDefect(Locale locale, int searchLevel,
			String code) {
		return dao.getCodeDefect(locale, searchLevel, code);
	}

	@Override
	public void procQualityIssueReg(String procType, Locale locale, QualityIssueRegSheet sheet, String user, byte[] files1, byte[] files2) { 
		dao.procQualityIssueReg(procType, locale, sheet, user, files1, files2);
	}

	@Override
	public List<Map<String, Object>> getAssistItemList(Locale locale,String status) {
		return dao.getAssistItemList(locale,status);
	}

	@Override
	public List<Map<String, Object>> getUndoneIssueList(Date fromDate,
			Date toDate, String item, Locale locale) {
		return dao.getUndoneIssueList(fromDate,toDate,item,locale);
	}

	@Override
	public List<Map<String, Object>> getQualityIssueRegList(Locale locale, String division, String occurSite, String stdDt, String endDt) {
			return dao.getQualityIssueRegList(locale, division, occurSite, stdDt, endDt);
	}

	@Override
	public byte[] getQualityIssueFile(Locale locale, String regNo,
			String fileSeq) {
		return dao.getQualityIssueFile(locale, regNo, fileSeq);
	}

	@Override
	public Map<String, Object> getIssueDetails(String regNo, Locale locale) {
		return dao.getIssueDetails(regNo,locale);
	}

	@Override
	public List<Map<String, Object>> getDefectTreeData(Locale locale) {
		return dao.getDefectTreeData(locale);
	}

	@Override
	public IssueApproval acceptIssue(String regNo, String method,
			int workCost, int testCost,
			String shipType, Locale locale,String user) {
		//기본값으로 등록.
		IssueApproval approval = dao.acceptIssue(regNo,method,workCost,testCost,shipType,locale,user);
		Map <String,Object> details = dao.getIssueDetails(regNo, locale);
		String partner =(String)details.get("partnerCode");
		//예상 귀책업체가 있으면 클래임을 부여한다. 
		if(partner!=null && !partner.equals("")){
			String item=(String)details.get("item");
			String lot = (String)details.get("lot");
			Map<String,Object> m = dao.getPartnerClaimBaseInfo(regNo, partner, locale);
			double claim = this.calculatePartnerClaim(partner, 100d, m, approval);
			dao.addClaimPartner(approval.getApprovalNo(),partner,item,lot,null,null,null,100d,claim,null,null,null,null,null,locale);
		}
		return approval;
	}
	
	
	private double calculatePartnerClaim(String partner,double rate,Map<String,Object> meta,IssueApproval approval) {
		double claim = 0d;
			
		Map<String,Double> manageRates = new HashMap<String,Double>();
		manageRates.put("AA",1.5d);
		manageRates.put("AB",1.5d);
		manageRates.put("AC",1.5d);
		manageRates.put("AD",2d);
		manageRates.put("CA",1.3d);
		manageRates.put("CB",1.5d);
		manageRates.put("CC",1.2d);
		manageRates.put("CD",0.1d);
		manageRates.put("DA",1.3d);
		manageRates.put("DB",1.3d);	
		
		String method = approval.getMethod();
		double workCost = approval.getWorkCost();
		int testCost = approval.getTestCost();
		String shipType = approval.getShipType();
		
		String origin = (String)meta.get("origin");
		int count = (Integer)meta.get("count");
		double unitPrice = Double.parseDouble(meta.get("price").toString());
		
		if(method.equals("abandon")){
			claim = count*unitPrice*manageRates.get(origin)*0.9d;
			if(origin.equals("CA")){
				claim *=2000;  // 초기유동이면 개당 2000원 검사비용.
			}
			if(origin.startsWith("D")){
				claim +=testCost;  // 출처가 시험실이면 검사비 추가
			}
		}
		else if(method.equals("resend")){
			claim= count*unitPrice*manageRates.get(origin);
		}
		else if(method.equals("rework")){
			claim=count*unitPrice*manageRates.get(origin)*0.9*workCost;
			if(origin.startsWith("A")){
				claim += 100000;  //출처가 고객이면 기회비용 십만원 추가.
			}
		}
		else{
			claim = 0d;
		}
		
		return claim*(rate/100d);
	}

	@Override
	public List<Map<String, Object>> getClaimList(String approvalNo,
			Locale locale) {
		return dao.getClaimList(approvalNo,locale);
	}

	@Override
	public List<Map<String, Object>> get4mTreeData(Locale locale) {
		return dao.get4mTreeData(locale);
	}

	@Override
	public List<Map<String, Object>> getClaimItemAssistantList(Locale locale) {
		return dao.getClaimItemAssistantList(locale);
	}

	@Override
	public List<Map<String, Object>> getDoneIssueList(Date fromDate,
			Date toDate, String item, Locale locale) {
		return dao.getDoneIssueList(fromDate,toDate,item,locale);
	}

	@Override
	public IssueApproval getApproval(String approvalNo, Locale locale) {
		return dao.getApproval(approvalNo,locale);
	}

	@Override
	public void updateApproval(String regNo,IssueApproval approval,Locale locale) {
		dao.updateApproval(approval);
		List<Map<String,Object>> claimPartners = dao.getClaimList(approval.getApprovalNo(), locale);
		List<Map<String,Object>> newClaimInfoList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> partner : claimPartners){
			String partnerCode = (String)partner.get("code");
			double rate = Double.parseDouble(partner.get("rate").toString());
			Map<String,Object> meta = dao.getPartnerClaimBaseInfo(regNo, partnerCode, locale);
			double newClaim = this.calculatePartnerClaim(partnerCode, rate, meta, approval);
			logger.info("newClaim:"+newClaim);
			logger.info("code:"+partnerCode);
			Map<String,Object> claimInfo = new HashMap<String,Object>();
			claimInfo.put("code",partnerCode);
			claimInfo.put("claim",newClaim);
			newClaimInfoList.add(claimInfo);
		}
		dao.batchUpdatePartnerClaimValue(approval.getApprovalNo(),newClaimInfoList,locale);
	}

	@Override
	public void deletePartnerClaim(String approvalNo, String partner) {
		dao.deletePartnerClaim(approvalNo,partner);
	}
}
