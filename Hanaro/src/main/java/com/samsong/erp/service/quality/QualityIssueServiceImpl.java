package com.samsong.erp.service.quality;



import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.dao.quality.QualityIssueDAO;
import com.samsong.erp.model.quality.IssueApproval;
import com.samsong.erp.model.quality.NcrInformSheet;
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
	public String acceptIssue(String regNo, Locale locale,String user) {
		//기본값으로 등록.
		String approvalNo = dao.acceptIssue(regNo,locale,user); 
		
		Map<String,Object> claimParams = dao.getClaimParams(approvalNo);
		double claim = this.calculateClaim(claimParams);
		
		dao.updateTotalClaim(approvalNo,claim);
		
		dao.updateAllSharedClaim(approvalNo);
		
		return approvalNo;
	}
	
	private double calculateClaim(Map<String,Object> params){
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
		
		String method = (String)params.get("method");
		double workCost = (Integer)params.get("workCost");
		int testCost = (Integer)params.get("testCost");
		String shipType = (String)params.get("shipType");
		
		String origin = (String)params.get("origin");
		int count = (Integer)params.get("count");
		double unitPrice =  ((BigDecimal)params.get("price")).doubleValue();
		
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
		
		return claim;
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
	public IssueApproval updateApproval(IssueApproval approval) {
		
		//변경사항 저장.
		dao.updateApproval(approval);
		
		//변경사항에 맞게 클래임을 다시 계산한다.
		Map<String,Object> params = dao.getClaimParams(approval.getApprovalNo());
		double claim = this.calculateClaim(params);
		approval.setClaim(claim);
		//클레임 가격 저장.
		dao.updateTotalClaim(approval.getApprovalNo(), claim);
		
		// 배분한 귀책처들 배분값 다시 계산.
		dao.updateAllSharedClaim(approval.getApprovalNo());
		
		return approval;
	}

	@Override
	public void deletePartnerClaim(String approvalNo, String partner,Locale locale) {
		String ncrNo = dao.deletePartnerClaim(approvalNo,partner);
		NcrInformSheet sheet =new NcrInformSheet();
		sheet.setNcrNo(ncrNo);
		dao.deleteNcrMeasure(locale,sheet);
	}
	
	public void addNcrMeasure(Locale locale, String user, NcrInformSheet sheet,
			byte[] measureFile,  byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			MultipartFile[] inputAddFile, MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType) {
		dao.addNcrMeasure(locale, sheet, user, measureFile, imgReason1, imgReason2, imgTempMeasure,
				imgMeasure1, imgMeasure2,inputAddFile, inputChangeFile, stanFile
				,imgReasonFile1ContentType,  imgReasonFile2ContentType, imgTempNameFileContentType,
				imgMeasureName1FileContentType, imgMeasureName2FileContentType);
		
	}

	@Override
	public void deleteNcrMeasure(Locale locale, NcrInformSheet sheet) {
		dao.deleteNcrMeasure(locale, sheet);
	}

	@Override
	public void updateNcrMeasure(Locale locale, String user,
			NcrInformSheet sheet, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1,
			byte[] imgMeasure2, MultipartFile[] inputAddFile,
			MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType) {
			dao.updateNcrMeasure(locale, sheet, user, measureFile, imgReason1, imgReason2,
					imgTempMeasure, imgMeasure1, imgMeasure2, inputAddFile, inputChangeFile, stanFile
					,imgReasonFile1ContentType,  imgReasonFile2ContentType, imgTempNameFileContentType,
					imgMeasureName1FileContentType, imgMeasureName2FileContentType);
		
	}

	@Override
	public List<Map<String, Object>> getNcrMeasureDataGrid(Locale locale,
			String ncrNo, String gridType) {
			return dao.getNcrMeasureDataGrid(locale, ncrNo, gridType);
	}

	@Override
	public List<Map<String, Object>> getNcrDetail(Locale locale, String ncrNo) {
			return dao.getNcrDetail(locale, ncrNo);
	}

	@Override
	public byte[] getNcrMeasureFile(Locale locale, String ncrNo) {
			return dao.getNcrMeasureFile(locale, ncrNo);
	}

	@Override
	public byte[] getNcrMeasureReasonFile(Locale locale, String ncrNo,
			String fileSeq) {
			return dao.getNcrMeasureReasonFile(locale, ncrNo, fileSeq);
	}

	@Override
	public byte[] getNcrMeasureStandardFile(Locale locale, String ncrNo,
			String fileSeq) {
			return dao.getNcrMeasureStandardFile(locale, ncrNo, fileSeq);
	}

	@Override
	public List<Map<String,Object>> getNcrMeasureImg(Locale locale, String ncrNo, String fileSeq) {
			return dao.getNcrMeasureImg(locale, ncrNo, fileSeq);
	}

	@Override


	public void updateNCRMeasureProcedure(Locale locale, String ncrNo,
			String updateType, String comment, String date1, String date2,
			String date3, String date4, String date5, String manager,
			String confirmer, String approver, String fileName, byte[] file,
			String resultEvaluation, String user) {
		dao.updateNCRMeasureProcedure(locale, ncrNo, updateType, comment, date1, date2, date3, date4, date5, manager, confirmer, approver, fileName, file, resultEvaluation, user);
		
	}

	@Override
	public byte[] getNCREvaluationFile(Locale locale, String ncrNo) {
		return dao.getNCREvaluationFile(locale, ncrNo);
	}



	

	public void updateClaim(String approvalNo, String partner, double rate,

			String item,String lot, String reason1, String reason2, String reason3,
			String remark, MultipartFile pic1,String pic1id, MultipartFile pic2,String pic2id,
			MultipartFile ref,String refid,Locale locale) {
		
		if(pic1.getSize()>0){
			pic1id = dao.updateClaimAttach(pic1id,pic1);
		}
		if(pic2.getSize()>0){
			pic2id = dao.updateClaimAttach(pic2id,pic2);
		}
		if(ref.getSize()>0){
			refid = dao.updateClaimAttach(refid,ref);
		}
		
		//변경된 요율을 적용한다.
		IssueApproval issue = dao.getApproval(approvalNo, locale);
		double share = issue.getClaim()*(rate/100d);
		
		dao.updateClaim(approvalNo, partner, rate,share,item, lot, reason1, reason2, reason3, remark, pic1id, pic2id, refid);
	}

	@Override
	public Map<String, Object> getClaimAttachment(String id) {
		return dao.getClaimAttachment(id);
	}

	@Override
	public void addClaim(String approvalNo, String partner,
			double rate, String item, String lot, String reason1,
			String reason2, String reason3, String remark, MultipartFile pic1,
			MultipartFile pic2, MultipartFile ref, String ncr, String reqDate,
			String request, Locale locale) {
		
		
		//첨부파일 있으면 외래키 확보.
		String pic1id = null;
		String pic2id = null;
		String refid = null;
		if(pic1.getSize()>0){
			pic1id = dao.updateClaimAttach(pic1id,pic1);
		}
		if(pic2.getSize()>0){
			pic2id = dao.updateClaimAttach(pic2id,pic2);
		}
		if(ref.getSize()>0){
			refid = dao.updateClaimAttach(refid,ref);
		}
		
		//NCR 발행하면 외래키 확보
		String ncrNo = null;
		if(ncr!=null && ncr.equalsIgnoreCase("Y")){
			ncrNo =dao.publishNcr(reqDate,request);
		}
		
		
		//업체 클래임 금액 계산.
		IssueApproval approval = dao.getApproval(approvalNo, locale);
		double share = approval.getClaim()*(rate/100d);
		dao.addClaimPartner(approvalNo, partner, item, lot, reason1, reason2, reason3, rate, share, remark, pic1id, pic2id,refid, ncrNo, locale);
	}

	@Override
	public Map<String, String> getClaimItemSuppliers(String item, Locale locale) {
		return dao.getClaimItemSuppliers(item,locale);
	}

	@Override

	public List<Map<String, Object>> getNCRList(Locale locale, String division,
			String occurSite, String stdDt, String endDt, String reasonCust,
			String publishCust) {
		return dao.getNCRList(locale, division, occurSite, stdDt, endDt, reasonCust, publishCust);
	}


	public void cancelApproval(String approvalNo, Locale locale) {
		List<String> partners =dao.getClaimSharedPartnerList(approvalNo);
		for(String partner : partners){
			this.deletePartnerClaim(approvalNo, partner, locale);
		}
		dao.rollbackIssue(approvalNo);
	}

	@Override
	public Map<String, Object> getNcrDetailChart(String ncrNo) {
		return dao.getNcrDetailChart(ncrNo);
	}

	@Override
	public List<Map<String, Object>> getNcrStatus(Locale locale,
			Map<String, Object> params) {
		return dao.getNcrStatus(locale, params);
	}

	@Override
	public List<Map<String, Object>> getNcrStatusList(Locale locale,
			Map<String, Object> params) {
		return dao.getNcrStatusList(locale, params);
	}


}
