package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.quality.ClaimManageDAO;

@Service
public class ClaimManageServiceImpl implements ClaimManageService {

	@Autowired
	private ClaimManageDAO dao;
	
	@Autowired
	private MessageSource message;
	
	
	private static final Logger logger  = Logger.getLogger(ClaimManageServiceImpl.class);
	
	@Override
	public List<Map<String, Object>> getClaimCode(String type, Locale locale) {
		return dao.getClaimCode(type, locale);
	}
	

	    

	@Override
	public void prodClaimManage(Locale locale,String prodType,String classType,String claimNo,String invoiceNo,String claimCost,String issueCust,String issueTeam,String cost,
			String partType,String rPartCode,String rPartName,String issueDate,String claimContent,String carType,
			String machineType,String workerCount,String issueTime,String failAmount,String inputBy,String p1,String p2,String p3,String p4,
			String p5,String p6,String p7,String p8,String lotNo,String file1Name,String file2Name,String file3Name,String file4Name,String file5Name,
			byte[] file1, byte[] file2,byte[] file3,byte[] file4,byte[] file5,String file1Type,String file2Type,String file3Type,String file4Type,String file5Type,
			String tripCost,String prodCost){
		dao.prodClaimManage(locale, prodType, classType, claimNo, invoiceNo, claimCost, issueCust, issueTeam, cost, partType, rPartCode, rPartName, issueDate, claimContent, carType, machineType, workerCount, issueTime,failAmount, inputBy, p1, p2, p3, p4, p5, p6, p7,p8,lotNo,file1Name,file2Name,file3Name,file4Name,file5Name,
				file1,file2,file3,file4,file5,file1Type,file2Type,file3Type,file4Type,file5Type,tripCost,prodCost);
		
	}

	@Override
	public List<Map<String, Object>> getClaimRegList(Locale locale,
			String classType, String stdDt, String endDt, String partCode,String searchLocale) {
		return dao.getClaimRegList(locale, classType, stdDt, endDt, partCode,searchLocale);
	}

	@Override
	public List<Map<String, Object>> getClaimAgreeList(Locale locale,String selLocale,
			String regStdDt, String regEndDt, String regPartNo,
			String invoiceNo, String car, String model, String type,
			String inputBy, String deptCode, String state, String agreeStdDt,
			String agreeEndDt, String agreeBy) {
		return dao.getClaimAgreeList(locale,selLocale, regStdDt, regEndDt, regPartNo, invoiceNo, car, model, type, inputBy, deptCode, state, agreeStdDt, agreeEndDt, agreeBy);
	}

	@Override
	public List<Map<String, Object>> getClaimActionItem(Locale locale,
			String type, String q) {
		return dao.getClaimActionItem(locale, type, q);
	}

	@Override
	public byte[] getClaimFile(String claimNo, String fileSeq) {
		return dao.getClaimFile(claimNo, fileSeq);
	}

	@Override
	public List<Map<String, Object>> getClaimAgreeInfo(String claimNo) {
		return dao.getClaimAgreeInfo(claimNo);
	}

	@Override
	public void prodClaimAgree(String procType,String claimNo, String state, String content,
			String rate, String claim, String user,Locale locale) {
		List<Map<String,Object>> mailData = dao.getClaimRegInfo(claimNo);
		dao.prodClaimAgree(procType,claimNo, state, content, rate, claim, user);
		List<Map<String,Object>> mailInfo = dao.getClaimAgreeMail(claimNo);
		JavaMailSenderImpl sender = new JavaMailSenderImpl();
		sender.setHost("mail.samsong.co.kr");
		sender.setDefaultEncoding("UTF-8");
	
		
		if(mailInfo !=null && mailInfo.size()>0){
			int count0 = 0;
			int count1 = 0;
			for(int i=0;i<mailInfo.size();i++){
				if(((Map<String,Object>)mailInfo.get(i)).get("mailType").toString().equals("0"))
					count0++;
				else
					count1++;
			}
			
	
			String[] mailTo0 = new String[count0];
			String[] mailTo1 = new String[count1];
			for(int i=0;i<mailInfo.size();i++){
				if(((Map<String,Object>)mailInfo.get(i)).get("mailType").toString().equals("0"))
					mailTo0[i] = ((Map<String,Object>)mailInfo.get(i)).get("email").toString();
				else
					mailTo1[i-count0] = ((Map<String,Object>)mailInfo.get(i)).get("email").toString();
			}				
			
						
			String p1 = message.getMessage("ui.label.contents",null,locale);
			String p2 = message.getMessage("ui.label.mailClaimIssue",null,locale);
			String p3 = message.getMessage("ui.label.detailStatus",null,locale);
			String p4 = message.getMessage("info.claimIssueSS",null,locale);
			String d1 = message.getMessage("info.cancelClaim",null,locale);
					
			
			
			
			if((!((Map<String,Object>)mailData.get(0)).get("DATA24").toString().equals("AGREE") && state.equals("AGREE")) || (procType.equals("DELETE") && ((Map<String,Object>)mailData.get(0)).get("DATA24").toString().equals("AGREE"))){
				
				Map<String,Object> dataMap = (Map<String,Object>)mailData.get(0);
				/*
				String claimAdd = "";
				float cost = Float.parseFloat(dataMap.get("DATA9").toString());
				float totalClaim = Float.parseFloat(claim);
				if(cost<=0)
					claimAdd = claim;
				else
					claimAdd = String.valueOf((totalClaim/cost));
				*/
				
				StringBuilder cnt0 = new StringBuilder();
				StringBuilder cnt1 = new StringBuilder();
				
				cnt0.append("<html><head><style type='text/css'>");
				cnt0.append("table{border-collapse:collapse;font-size:13px;}");
				cnt0.append("th {border:1px solid silver;background-color: #E5E9EA;height:45px; text-align: left; white-space:nowrap;width: 130px;padding:5px;}");			
				cnt0.append(".none{border:0px;width:680px;}");			
				cnt0.append("td {border:1px solid silver;padding:5px;}");
				cnt0.append(".cnt{width:550px;}");
				cnt0.append("</style></head><body><table>");
				cnt0.append("<tr><td class='none' colspan='2' align='left'><b>a. "+p1+"</b></td></tr>");
				if(procType.equals("DELETE"))
					cnt0.append("<tr><td class='none' colspan='2' align='left'> - "+d1+"</td></tr>");
				else
					cnt0.append("<tr><td class='none' colspan='2' align='left'> - "+p2+"</td></tr>");
				cnt0.append("<tr><td class='none' colspan='2' align='left' style='height:30px;'>&nbsp;</td></tr>");
				cnt0.append("<tr><td class='none' colspan='2' align='left'><b>b. "+p3+"</b></td></tr>");
				
				
				cnt0.append("<tr><td class='none' colspan='2' align='center' style='background-color:#415262;color:#FFFFFF;font-weight:bold;font-size:25px;padding:0px;'>");
				cnt0.append("<img src='http://210.216.217.226:8181/Hanaro/resources/images/cR.png'/></td></tr>");
				
				cnt0.append("<tr><td class='none' colspan='2' align='right' style='font-size:13px;padding:8px;'>"+dataMap.get("DATA13")+"</td></tr>");
				cnt0.append("<tr><th>FROM</th><td class='cnt'>"+claimNo.split("-")[0]+"</td></tr>");
				cnt0.append("<tr><th>TO</th><td class='cnt'>&nbsp;</td></tr>");
				cnt0.append("<tr><th>INVOICE NO</th><td class='cnt'>"+dataMap.get("DATA3")+"</td></tr>");
				cnt0.append("<tr><th>PART NO</th><td class='cnt'>"+dataMap.get("DATA11")+"</td></tr>");
				cnt0.append("<tr><th>PART NAME</th><td class='cnt'>"+dataMap.get("DATA12")+"</td></tr>");
				cnt0.append("<tr><th>PROGRESSING</th><td class='cnt'>"+dataMap.get("DATA22")+"</td></tr>");
				cnt0.append("<tr><th style='height:200px;'>CAUSE BY</th><td class='cnt'>"+content+"</td></tr>");
				cnt0.append("<tr><th>CLAIM 보상</th><td class='cnt'>"+claim+"</td></tr>");
				cnt0.append("</table></body></html>");
				
				cnt1.append("<html><head><style type='text/css'>");
				cnt1.append("table{border-collapse:collapse;font-size:13px;}");
				cnt1.append("th {border:1px solid silver;background-color: #E5E9EA;height:45px; text-align: left; white-space:nowrap;width: 130px;padding:5px;}");			
				cnt1.append(".none{border:0px;width:680px;}");			
				cnt1.append("td {border:1px solid silver;padding:5px;}");
				cnt1.append(".cnt{width:550px;}");
				cnt1.append("</style></head><body><table>");
				cnt1.append("<tr><td class='none' colspan='2' align='left'><b>a. "+p1+"</b></td></tr>");
				if(procType.equals("DELETE"))
					cnt1.append("<tr><td class='none' colspan='2' align='left'> - "+d1+"</td></tr>");
				else
					cnt1.append("<tr><td class='none' colspan='2' align='left'> - "+p4+"</td></tr>");
				cnt1.append("<tr><td class='none' colspan='2' align='left' style='height:30px;'>&nbsp;</td></tr>");
				cnt1.append("<tr><td class='none' colspan='2' align='left'><b>b. "+p3+"</b></td></tr>");				
				cnt1.append("<tr><td class='none' colspan='2' align='center' style='background-color:#415262;color:#FFFFFF;font-weight:bold;font-size:25px;padding:0px;'>");
				cnt1.append("<img src='http://210.216.217.226:8181/Hanaro/resources/images/cR.png'/></td></tr>");				
				cnt1.append("<tr><td class='none' colspan='2' align='right' style='font-size:13px;padding:8px;'>"+dataMap.get("DATA13")+"</td></tr>");
				cnt1.append("<tr><th>FROM</th><td class='cnt'>"+claimNo.split("-")[0]+"</td></tr>");
				cnt1.append("<tr><th>TO</th><td class='cnt'>"+dataMap.get("DATA6")+"</td></tr>");				
				cnt1.append("<tr><th>PART NO</th><td class='cnt'>"+dataMap.get("DATA11")+"</td></tr>");
				cnt1.append("<tr><th>PART NAME</th><td class='cnt'>"+dataMap.get("DATA12")+"</td></tr>");
				cnt1.append("<tr><th>PROGRESSING</th><td class='cnt'>"+dataMap.get("DATA22")+"</td></tr>");
				cnt1.append("<tr><th style='height:200px;'>CAUSE BY</th><td class='cnt'>"+content+"</td></tr>");
				cnt1.append("<tr><th>CLAIM 보상</th><td class='cnt'>"+claim+"</td></tr>");
				cnt1.append("</table></body></html>");				
				
				if(count0>0){
					try {
						MimeMessage messageCn = sender.createMimeMessage();						
						MimeMessageHelper helper = new MimeMessageHelper(messageCn);						
						helper.setTo(mailTo0);					
						helper.setFrom("hanaro@samsong.co.kr");
						helper.setSubject("Hanaro System Claim ["+claimNo+"]");
						helper.setText(cnt0.toString(),true);
						sender.send(messageCn);
					} catch (MessagingException e) {
						logger.info("메일발송에러");
					}
				}
				if(count1>0){
					try {
						MimeMessage messageCn = sender.createMimeMessage();						
						MimeMessageHelper helper = new MimeMessageHelper(messageCn);
						helper.setTo(mailTo1);					
						helper.setFrom("hanaro@samsong.co.kr");
						helper.setSubject("Hanaro System Claim ["+claimNo+"]");
						helper.setText(cnt1.toString(),true);
						sender.send(messageCn);
					} catch (MessagingException e) {
						logger.info("메일발송에러");
					}
				}      			
			}
		}

	}

	@Override
	public List<Map<String, Object>> getClaimAgreeMail(String claimNo) {
		return dao.getClaimAgreeMail(claimNo);
	}




	@Override
	public List<Map<String, Object>> getClaimStatusMain(Locale locale,
			String selLocale, String tab, String dateType, String stdYy,
			String stdDt, String endYy, String endDt) {
		return dao.getClaimStatusMain(locale, selLocale, tab, dateType, stdYy, stdDt, endYy, endDt);
	}




	@Override
	public List<Map<String, Object>> getClaimStatusSub(Locale locale,
			String selLocale, String dateType, String stdYy, String stdDt,
			String endYy, String endDt, String q1, String q2, String q3,
			String q4) {
		return dao.getClaimStatusSub(locale, selLocale, dateType, stdYy, stdDt, endYy, endDt, q1, q2, q3, q4);
	}

	


}
