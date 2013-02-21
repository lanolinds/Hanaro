package com.samsong.erp.service.quality;
 
 

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.dao.DataAccessException;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.dao.quality.QualityIssueDAO;
import com.samsong.erp.model.quality.IssueApproval;
import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.model.quality.QualityIssueRegSheet;
 
@Service
public class QualityIssueServiceImpl implements QualityIssueService {
 
	@Autowired
	private QualityIssueDAO dao;
	
	@Autowired
	private MessageSource message;	
	
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
		String regNo="";
		regNo = dao.procQualityIssueReg(procType, locale, sheet, user, files1, files2);
		
		
		//입고검사시에만 메일 발송
		if(procType.equals("INSERT") && sheet.getOccurSite().equals("CD") && !regNo.equals("")){
			JavaMailSenderImpl sender = new JavaMailSenderImpl();
			List<Map<String,Object>> mailList = dao.getIssueMailList("Q_REG", regNo);
			List<Map<String,Object>> mailData = dao.getIssueMailDataForReg(regNo);
		
			
			sender.setHost("mail.samsong.co.kr");
			sender.setUsername("hanaro");
			sender.setPassword("hanaro");
			sender.setDefaultEncoding("UTF-8");
			
			if(mailList !=null && mailList.size()>0){
				String[] mailTo = new String[mailList.size()];
				for(int i=0;i<mailList.size();i++){					
						mailTo[i]= ((Map<String,Object>)mailList.get(i)).get("DATA0").toString();
				}				
				StringBuilder content = new StringBuilder();
				
				Map<String,Object> dataMap = (Map<String,Object>)mailData.get(0);
				
				String hregNo = message.getMessage("ui.label.RegNo",null,locale);
				String hdivision = message.getMessage("ui.label.QualityIssue.Division",null,locale);
				String hOccurSite = message.getMessage("ui.label.QualityIssue.OccurSite",null,locale);
				String hOccurDate = message.getMessage("ui.label.OccurDate",null,locale);
				String hOccurAmPm = message.getMessage("ui.label.OccurAmPm",null,locale);
				String hOccurHour = message.getMessage("ui.label.OccurHour",null,locale);
				String hOccurPartNo = message.getMessage("ui.label.QualityIssue.OccurPartNo",null,locale);
				String hOccurPartNm = message.getMessage("ui.label.QualityIssue.OccurPartNm",null,locale);
				String hCar = message.getMessage("ui.label.Car",null,locale);
				String hModel = message.getMessage("ui.label.Model",null,locale);
				String hPartSupplier = message.getMessage("ui.label.PartSupplier",null,locale);
				String hOccurPlace = message.getMessage("ui.label.QualityIssue.OccurPlace",null,locale);
				String hOccurLine = message.getMessage("ui.label.QualityIssue.OccurLine",null,locale);
				String hOccurProc = message.getMessage("ui.label.QualityIssue.OccurProc",null,locale);
				String hLotNo = message.getMessage("ui.label.LotNo",null,locale);
				String hDefectL = message.getMessage("ui.label.QualityIssue.DefectL",null,locale);
				String hDefectM = message.getMessage("ui.label.QualityIssue.DefectM",null,locale);
				String hDefectS = message.getMessage("ui.label.QualityIssue.DefectS",null,locale);
				String hDefectAmount = message.getMessage("ui.label.QualityIssue.DefectAmount",null,locale);
				String hExplanation = message.getMessage("ui.label.QualityIssue.Explanation",null,locale);				
				
				content.append("<HTML><HEAD><style type='text/css'>");
				content.append("table{border-collapse:collapse;font-size:13px;}");
				content.append("th {border:1px solid silver;background-color: #E5E9EA;height:25px; text-align: left; white-space:nowrap;width: 120px;padding:5px;}");
				content.append("td {border:1px solid silver;padding:5px;width: 350px;}");
				content.append("</style></HEAD><BODY>");
				content.append("<table><tr><th>"+hregNo+"</th><td>"+dataMap.get("DATA0")+"</td><th>"+hdivision+"</th><td>"+dataMap.get("DATA1")+"</td></tr>");
				content.append("<tr><th>"+hOccurSite+"</th><td>"+dataMap.get("DATA2")+"</td><th>"+hOccurDate+"</th><td>"+dataMap.get("DATA3")+"</td></tr>");
				content.append("<tr><th>"+hOccurAmPm+"</th><td>"+dataMap.get("DATA4")+"</td><th>"+hOccurHour+"</th><td>"+dataMap.get("DATA5")+"</td></tr>");
				content.append("<tr><th>"+hOccurPartNo+"</th><td>"+dataMap.get("DATA6")+"</td><th>"+hOccurPartNm+"</th><td>"+dataMap.get("DATA7")+"</td></tr>");
				content.append("<tr><th>"+hCar+"</th><td>"+dataMap.get("DATA8")+"</td><th>"+hModel+"</th><td>"+dataMap.get("DATA9")+"</td></tr>");
				content.append("<tr><th>"+hPartSupplier+"</th><td>"+dataMap.get("DATA10")+"</td><th>"+hOccurPlace+"</th><td>"+dataMap.get("DATA11")+"</td></tr>");
				content.append("<tr><th>"+hOccurLine+"</th><td>"+dataMap.get("DATA12")+"</td><th>"+hOccurProc+"</th><td>"+dataMap.get("DATA13")+"</td></tr>");
				content.append("<tr><th>"+hLotNo+"</th><td>"+dataMap.get("DATA14")+"</td><th>"+hDefectL+"</th><td>"+dataMap.get("DATA15")+"</td></tr>");
				content.append("<tr><th>"+hDefectM+"</th><td>"+dataMap.get("DATA16")+"</td><th>"+hDefectS+"</th><td>"+dataMap.get("DATA17")+"</td></tr>");
				content.append("<tr><th>"+hDefectAmount+"</th><td>"+dataMap.get("DATA18")+"</td><th>"+hExplanation+"</th><td>"+dataMap.get("DATA19")+"</td></tr>");
				content.append("</table></BODY></HTML>");
				
				try {
					MimeMessage messageCn = sender.createMimeMessage();						
					MimeMessageHelper helper = new MimeMessageHelper(messageCn);						
					helper.setTo(mailTo);					
					helper.setFrom("hanaro@samsong.com");
					helper.setSubject("Hanaro System Claim [Quality  Issue]");
					helper.setText(content.toString(),true);
					sender.send(messageCn);
				} catch (MessagingException e) {
					logger.info("메일발송에러");
				}
			}
		}
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
	public IssueApproval updateApproval(IssueApproval approval,Locale locale) {
		
		//변경사항 저장.
		dao.updateApproval(approval);
		
		
		//변경사항에 맞게 클래임을 다시 계산한다.
		Map<String,Object> params = dao.getClaimParams(approval.getApprovalNo());
		double claim = this.calculateClaim(params);
		approval.setClaim(claim);
		//클레임 가격 저장.
		dao.updateTotalClaim(approval.getApprovalNo(), claim);
		
		if(approval.getMethod().equals("reuse")){
			List<String> partners =dao.getClaimSharedPartnerList(approval.getApprovalNo());
			for(String partner : partners){
				this.deletePartnerClaim(approval.getApprovalNo(), partner, locale);
			}
		}
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
		
		if(updateType.equals("do_plan")){
			
			List<Map<String,Object>> ncrList = dao.getRegNcrList("ncr",ncrNo);
			//ncr등록되었을때만 발송한다.
			if(ncrList!=null && ncrList.size()>0){
				if(ncrList.get(0).get("occur_site").toString().trim().equals("CD")){
					JavaMailSenderImpl sender  = new JavaMailSenderImpl();
					sender.setHost("mail.samsong.co.kr");
					sender.setUsername("hanaro");
					sender.setPassword("hanaro");
					sender.setDefaultEncoding("UTF-8");
					
					Map<String,Object> mailData = ncrList.get(0);
					
					String occurSiteName = mailData.get("occur_site_name").toString();
					String partner = mailData.get("partner").toString();
					List<Map<String,Object>> mailList = dao.getIssueMailList("NCR_REG",ncrNo);
					
					String[] mailTo = new String[mailList.size()];
					for(int i=0;i<mailList.size();i++){					
							mailTo[i]= ((Map<String,Object>)mailList.get(i)).get("DATA0").toString();
					}				
					StringBuilder content = new StringBuilder();
					
					
					
					String hncr = "NCR NO";					
					String hOccurSite = message.getMessage("ui.label.QualityIssue.OccurSite",null,locale);
					String hReasonOrgan = message.getMessage("ui.label.qualityIssue.reasonOrgan",null,locale);
					String hTitle =  message.getMessage("ui.label.ncrInformReportMessage",null,locale);
					
					content.append("<HTML><HEAD><style type='text/css'>");
					content.append("table{border-collapse:collapse;font-size:13px;}");
					content.append("th {border:1px solid silver;background-color: #E5E9EA;height:25px; text-align: left; white-space:nowrap;width: 120px;padding:5px;}");
					content.append("td {border:1px solid silver;padding:5px;width: 350px;}");
					content.append("a{color:blue;cursor:pointer;}");
					content.append("</style></HEAD><BODY>");
					content.append("<table><tr><th colspan='2'>"+hTitle+"</th></tr><tr><th>"+hncr+"</th><td>"+ncrNo+"</td></tr>");
					content.append("<tr><th>"+hOccurSite+"</th><td>"+occurSiteName+"</td></tr>");
					content.append("<tr><th>"+hReasonOrgan+"</th><td>"+partner+"</td></tr>");
					content.append("<tr><th>LINK</th><td><a href='http://app.samsong.co.kr:8080/Hanaro/qualityDivision/qualityIssue/ncrManageDetail?ncrNo="+ncrNo+"' target='_blank'>"+ncrNo+"<a>");
					content.append("</td></tr></table></BODY></HTML>");
					
					try {
						MimeMessage messageCn = sender.createMimeMessage();						
						MimeMessageHelper helper = new MimeMessageHelper(messageCn);						
						helper.setTo(mailTo);					
						helper.setFrom("hanaro@samsong.com");
						helper.setSubject("Hanaro System Claim [Quality NCR  Issue]");
						helper.setText(content.toString(),true);
						sender.send(messageCn);
					} catch (MessagingException e) {
						logger.info("메일발송에러");
					}
					
					
				}
			}
		}
	}

	@Override
	public byte[] getNCREvaluationFile(Locale locale, String ncrNo) {
		return dao.getNCREvaluationFile(locale, ncrNo);
	}



	

	public void updateClaim(String approvalNo, String partner, double rate,

			String item,String lot, String reason1, String reason2, String reason3,
			String remark, MultipartFile pic1,String pic1id, MultipartFile pic2,String pic2id,
			MultipartFile ref,String refid,String ncr, String reqDate,
			String request,Locale locale) {
		
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
		if(ncr!=null && ncr.toUpperCase().equals("Y")){
			ncrNo =dao.publishNcr(reqDate,request);
		}
		else if(ncr!=null && ncr.toUpperCase().equals("N")){
			ncrNo=null;
		}
		else{
			ncrNo=ncr;
		}
		//변경된 요율을 적용한다.
		IssueApproval issue = dao.getApproval(approvalNo, locale);
		double share = issue.getClaim()*(rate/100d);
		
		dao.updateClaim(approvalNo, partner, rate,share,item, lot, reason1, reason2, reason3, remark, pic1id, pic2id, refid,ncrNo);
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
		if(ncr!=null && ncr.toUpperCase().equals("Y")){
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

	@Override
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

	@Override
	public String readyToAcceptIssue(String regNo, Locale locale,
			String username) {
		String tempApprovalNo = dao.readyToAcceptIssue(regNo, locale, username);
		Map<String,Object> claimParams = dao.getTempClaimParams(tempApprovalNo,regNo,locale);
		double claim = this.calculateClaim(claimParams);
		
		dao.updateTempApprovalTotalClaim(tempApprovalNo,claim);
		
		dao.updateAllTempSharedClaim(tempApprovalNo);
		
		return tempApprovalNo;
	}

	@Override
	public IssueApproval getTempApproval(String tempApprovalNo, Locale locale) {
		return dao.getTempApproval(tempApprovalNo,locale);
	}

	@Override
	public List<Map<String, Object>> getTempClaimList(String approvalNo,
			Locale locale) {
		return dao.getTempClaimList(approvalNo,locale);
	}

	@Override
	public IssueApproval updateTempApproval(String regNo,IssueApproval approval,Locale locale) {
		
		dao.updateTempApproval(approval);
		//변경사항에 맞게 클래임을 다시 계산한다.
		Map<String,Object> params = dao.getTempClaimParams(approval.getApprovalNo(), regNo, locale);
		double claim = this.calculateClaim(params);
		approval.setClaim(claim);
		//클레임 가격 저장.
		dao.updateTempApprovalTotalClaim(approval.getApprovalNo(), claim);
		
		// 배분한 귀책처들 배분값 다시 계산.
		dao.updateAllTempSharedClaim(approval.getApprovalNo());
		
		return approval;
	}

	@Override
	public void addTempClaim(String approvalNo, String partner, double rate,
			String item, String lot, String reason1, String reason2,
			String reason3, String remark, MultipartFile pic1,
			MultipartFile pic2, MultipartFile ref, String ncr, String reqDate,
			String request, Locale locale) {
		//첨부파일 있으면 외래키 확보.
				String pic1id = null;
				String pic2id = null;
				String refid = null;
				if(pic1.getSize()>0){
					pic1id = dao.updateTempClaimAttach(pic1id,pic1);
				}
				if(pic2.getSize()>0){
					pic2id = dao.updateTempClaimAttach(pic2id,pic2);
				}
				if(ref.getSize()>0){
					refid = dao.updateTempClaimAttach(refid,ref);
				}
				
				//NCR 발행하면 외래키 확보
				String ncrNo = null;
				if(ncr!=null && ncr.toUpperCase().equals("Y")){
					ncrNo =dao.publishTempNcr(reqDate,request);
				}
				
				
				
				
				//업체 클래임 금액 계산.
				IssueApproval approval = dao.getTempApproval(approvalNo, locale);
				double share = approval.getClaim()*(rate/100d);
				dao.addTempClaimPartner(approvalNo, partner, item, lot, reason1, reason2, reason3, rate, share, remark, pic1id, pic2id,refid, ncrNo, locale);
		
	}

	@Override
	public void updateTempClaim(String approvalNo, String partner, double rate,
			String item, String lot, String reason1, String reason2,
			String reason3, String remark, MultipartFile pic1, String pic1id,
			MultipartFile pic2, String pic2id, MultipartFile ref, String refid,
			String ncr, String reqDate, String request, Locale locale) {
		if(pic1.getSize()>0){
			pic1id = dao.updateTempClaimAttach(pic1id,pic1);
		}
		if(pic2.getSize()>0){
			pic2id = dao.updateTempClaimAttach(pic2id,pic2);
		}
		if(ref.getSize()>0){
			refid = dao.updateTempClaimAttach(refid,ref);
		}
		
		//NCR 발행하면 외래키 확보
		String ncrNo = null;
		if(ncr!=null && ncr.toUpperCase().equals("Y")){
			ncrNo =dao.publishTempNcr(reqDate,request);
		}
		else if(ncr!=null && ncr.toUpperCase().equals("N")){
			ncrNo=null;
		}
		else{
			ncrNo=ncr;
		}
		//변경된 요율을 적용한다.
		IssueApproval issue = dao.getTempApproval(approvalNo, locale);
		double share = issue.getClaim()*(rate/100d);
		
		dao.updateTempClaim(approvalNo, partner, rate,share,item, lot, reason1, reason2, reason3, remark, pic1id, pic2id, refid,ncrNo);
		
	}

	@Override
	public void deletePartnerTempClaim(String approvalNo, String partner,
			Locale locale) {
		String ncrNo = dao.deletePartnerTempClaim(approvalNo,partner);
		//dao.deleteTempNcr(ncrNo);
	}

	@Override
	public Map<String, Object> getTempClaimAttachment(String id) {
		return dao.getTempClaimAttachment(id);
	}

	@Override
	public void persistApproval(String regNo,String approvalNo,String username, Locale locale) {
		dao.persistApproval(regNo,approvalNo,username,locale);
		List<Map<String,Object>> ncrList = dao.getRegNcrList("action",approvalNo);
		//ncr등록되었을때만 발송한다.
		if(ncrList!=null && ncrList.size()>0){
			if(ncrList.get(0).get("occur_site").toString().trim().equals("CD")){
				JavaMailSenderImpl sender  = new JavaMailSenderImpl();
				sender.setHost("mail.samsong.co.kr");
				sender.setUsername("hanaro");
				sender.setPassword("hanaro");
				sender.setDefaultEncoding("UTF-8");
				
				for(int ncr = 0;ncr<ncrList.size();ncr++){		
					Map<String,Object> mailData = ncrList.get(ncr);
					String ncrNo = mailData.get("ncr").toString();					
					String occurSiteName = mailData.get("occur_site_name").toString();
					String partner = mailData.get("partner").toString();
					List<Map<String,Object>> mailList = dao.getIssueMailList("NCR_REG",ncrNo);
					
					String[] mailTo = new String[mailList.size()];
					for(int i=0;i<mailList.size();i++){					
							mailTo[i]= ((Map<String,Object>)mailList.get(i)).get("DATA0").toString();
					}				
					StringBuilder content = new StringBuilder();
					
					
					
					String hncr = "NCR NO";					
					String hOccurSite = message.getMessage("ui.label.QualityIssue.OccurSite",null,locale);
					String hReasonOrgan = message.getMessage("ui.label.qualityIssue.reasonOrgan",null,locale);
					String hTitle =  message.getMessage("ui.label.ui.label.ncrTreatReportMessage",null,locale);
					
					content.append("<HTML><HEAD><style type='text/css'>");
					content.append("table{border-collapse:collapse;font-size:13px;}");
					content.append("th {border:1px solid silver;background-color: #E5E9EA;height:25px; text-align: left; white-space:nowrap;width: 120px;padding:5px;}");
					content.append("td {border:1px solid silver;padding:5px;width: 350px;}");
					content.append("a{color:blue;cursor:pointer;}");
					content.append("</style></HEAD><BODY>");
					content.append("<table><tr><th colspan='2'>"+hTitle+"</th></tr><tr><th>"+hncr+"</th><td>"+ncrNo+"</td></tr>");
					content.append("<tr><th>"+hOccurSite+"</th><td>"+occurSiteName+"</td></tr>");
					content.append("<tr><th>"+hReasonOrgan+"</th><td>"+partner+"</td></tr>");
					content.append("<tr><th>LINK</th><td><a href='http://app.samsong.co.kr:8080/Hanaro/qualityDivision/qualityIssue/ncrManageDetail?ncrNo="+ncrNo+"' target='_blank'>"+ncrNo+"<a>");
					content.append("</td></tr></table></BODY></HTML>");
					
					try {
						MimeMessage messageCn = sender.createMimeMessage();						
						MimeMessageHelper helper = new MimeMessageHelper(messageCn);						
						helper.setTo(mailTo);					
						helper.setFrom("hanaro@samsong.com");
						helper.setSubject("Hanaro System Claim [Quality NCR  Issue]");
						helper.setText(content.toString(),true);
						sender.send(messageCn);
					} catch (MessagingException e) {
						logger.info("메일발송에러");
					}
					
				}		
			}
		}
	}

	@Override
	public List<Map<String, Object>> getIssueSummary(String occurSite,
			String searchType, String stdYear, String stdMonth, String stdDay,
			String endYear, String endMonth, String endDay,String searchLocale, Locale locale) {
		return dao.getIssueSummary(occurSite, searchType, stdYear, stdMonth, stdDay, endYear, endMonth, endDay,searchLocale, locale);
	}

	@Override
	public Integer getWeekOfYear(String date) {
		return dao.getWeekOfYear(date);
	} 

	@Override
	public List<Map<String, Object>> getIssueSummaryDetail(String dateType,
			String stdYear, String stdMonth, String stdDay, String type,
			String machineType, String searchLocale, Locale locale) {
		return dao.getIssueSummaryDetail(dateType, stdYear, stdMonth, stdDay, type, machineType, searchLocale, locale);
	}

	@Override
	public Map<String, Object> getCodeMachineType() {
		return dao.getCodeMachineType();
	}

	@Override
	public List<Map<String, Object>> getIssueSummaryDetailPOP(String dateType,
			String stdYear, String stdMonth, String endYear, String endMonth,
			String machineType, String errorType, String partNo,
			String custCode, String searchLocale, Locale locale) {
		return dao.getIssueSummaryDetailPOP(dateType, stdYear, stdMonth, endYear, endMonth, machineType, errorType, partNo, custCode, searchLocale, locale);
	}



}
