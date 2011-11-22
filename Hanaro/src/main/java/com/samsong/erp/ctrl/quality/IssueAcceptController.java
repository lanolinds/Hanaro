package com.samsong.erp.ctrl.quality;

import java.io.IOException;
import java.io.OutputStream;
import java.security.Principal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.model.quality.IssueApproval;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.ClientFileNameEncoder;

@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class IssueAcceptController {
	
	private Logger logger = Logger.getLogger(IssueAcceptController.class);
	@Autowired
	private QualityIssueService service;
	@Autowired
	private CustManagementService partnerService;
	@Autowired
	private MessageSource message;
	
	@RequestMapping(value="/cancelAccept", method=RequestMethod.POST)
	public String cancelAccept(@RequestParam("regNo") String regNo,@RequestParam(value="no",required=false) String approvalNo,Model model, Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		service.cancelApproval(approvalNo,user.getLocale());
		
		return "redirect:/qualityDivision/qualityIssue/list";
	}
	
	
	@RequestMapping(value="/acceptIssues", method=RequestMethod.POST)
	public String accept(@RequestParam("regNo") String regNo,@RequestParam(value="no",required=false) String approvalNo,Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		
		//등록된 품질문제 상세 내역을 얻는다.
		Map<String,Object> details = service.getIssueDetails(regNo, user.getLocale());
		
		//출처별 처리 방법을 얻는다.
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,user.getLocale());
		
		//기본 처리 내역을 얻는다.
		if(approvalNo==null)
			approvalNo=service.acceptIssue(regNo,user.getLocale(), user.getUsername());
		IssueApproval approval = service.getApproval(approvalNo, user.getLocale());
		
		//원인품번 납품처 리스트
		String item = (String)details.get("item");
		Map<String,String> suppliers = service.getClaimItemSuppliers(item,user.getLocale());
		
		
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(user.getLocale(), "qisall", ""));
		model.addAttribute("suppliers",suppliers);
		return "qualityDivision/qualityIssue/acceptIssues";
	}
	@RequestMapping("/issueDetailCallback")
	public @ResponseBody Map<String,Object> getIssueDetails(@RequestParam("no") String regNo,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getIssueDetails(regNo, user.getLocale());
	}
	
	
	private Map<String,String> getHandleMethods(String code,Locale locale){
		Map<String,String> m = new LinkedHashMap<String,String>();
		if(code.equalsIgnoreCase("CD")){
			m.put("resend", message.getMessage("system.option.resend",null,locale));
		}
		else{
			m.put("abandon", message.getMessage("system.option.abandon",null,locale));
			m.put("rework", message.getMessage("system.option.rework",null,locale));
			m.put("reuse", message.getMessage("system.option.reuse",null,locale));
		}
		return m;
	}
	
	@RequestMapping("/acceptIssues/downloadFile")
	public void downloadFile(@RequestParam("seq") int seq,@RequestParam("no") String regNo,@RequestParam("name") String name,
			Authentication auth,HttpServletRequest req, HttpServletResponse res){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		try{
			name = ClientFileNameEncoder.encodeFileName(name, req.getHeader("User-Agent"));
			byte[] binary =service.getQualityIssueFile(user.getLocale(), regNo, Integer.toString(seq));
			res.setHeader("Content-Disposition", "inline;filename=" + name);
			res.setContentType("application/octet-stream");
			res.setContentLength(binary.length);
			OutputStream out = res.getOutputStream();
			out.write(binary);
			out.flush();
		}catch(IOException ex){
			logger.error("파일 다운로드 중 다음 에러 발생:"+ex.getMessage());
		}
		
	}
	@RequestMapping("/acceptIssues/defectTreeCallback")
	public @ResponseBody List<Map<String,Object>> getDefectTreeData(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getDefectTreeData(user.getLocale());
	}
	
	@RequestMapping("/acceptIssues/4mTreeCallback")
	public @ResponseBody List<Map<String,Object>> get4mTreeData(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.get4mTreeData(user.getLocale());
	}
	
	@RequestMapping("/acceptIssues/itemAssistCallback")
	public @ResponseBody List<Map<String,Object>> getItemAssistant(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getClaimItemAssistantList(user.getLocale());
	}
	
	@RequestMapping("/acceptIssues/claimListGridCallback")
	public @ResponseBody Map<String,Object> getClaimPartnerList(@RequestParam("approvalNo") String approvalNo,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> claims =service.getClaimList(approvalNo,user.getLocale());
		double claimTotal = 0d;
		NumberFormat fmt = NumberFormat.getInstance();
		fmt.setMaximumFractionDigits(2);
		
		for(Map<String,Object> claim : claims){			
			double money =  Double.parseDouble(claim.get("claim").toString());
			claimTotal +=money;
			claim.put("claim",fmt.format(money));
		}
		List<Map<String,Object>> footers = new ArrayList<Map<String,Object>>();
		Map<String,Object> footer = new HashMap<String,Object>();
		footer.put("code", "Total");
		footer.put("claim", fmt.format(claimTotal));
		footers.add(footer);
		Map<String,Object> json = new HashMap<String, Object>();
		if(claims!=null){
			json.put("total",claims.size());
			json.put("rows", claims);
			json.put("footer",footers);
		}
		else
		{
			json.put("total", 0);
			json.put("rows", 0);
			json.put("footer",footers);
		}
		return json;
	}
	@RequestMapping(value="/approval",method=RequestMethod.POST )
	public String updateApproval(
			@RequestParam("regNo") String regNo,
			@RequestParam("approvalNo") String approvalNo,
			@RequestParam("finalCausePartner") String causePartner,
			@RequestParam("reason1") String reason1,
			@RequestParam("reason2") String reason2,
			@RequestParam("reason3") String reason3,
			@RequestParam("approvalRemark") String remark,
			@RequestParam("method") String method,
			@RequestParam(value="workCost",required=false) Integer workCost,
			@RequestParam(value="testCost",required=false) Integer testCost,
			Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		int workCostVal = workCost==null?0:workCost.intValue();
		int testCostVal = testCost==null?0:testCost.intValue();
		
		IssueApproval approval =new IssueApproval();
		approval.setApprovalNo(approvalNo);
		approval.setDefect1(reason1);
		approval.setDefect2(reason2);
		approval.setDefect3(reason3);
		approval.setRemark(remark);
		approval.setMethod(method);
		approval.setWorkCost(workCostVal);
		approval.setTestCost(testCostVal);
		approval.setShipType("unit");
		approval.setCausePartner(causePartner);
		
		//처리내역 변경 사항을 업데이트한다.
		approval =service.updateApproval(approval); 
		logger.info(approval);
		
		Map<String,Object> details = service.getIssueDetails(regNo, user.getLocale());
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,user.getLocale());
		String item = (String)details.get("item");
		Map<String,String> suppliers = service.getClaimItemSuppliers(item,user.getLocale());
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(user.getLocale(), "qisall", ""));
		model.addAttribute("suppliers",suppliers);
		return "qualityDivision/qualityIssue/acceptIssues";
	}
	
	
	@RequestMapping(value="/updateClaim",method=RequestMethod.POST )
	public String updateClaim(@RequestParam("action") String action,
			@RequestParam("regNo") String regNo,
			@RequestParam("approvalNo") String approvalNo,
			@RequestParam("claimPartner") String partner,
			@RequestParam("claimRate") double rate,
			@RequestParam("claimItem") String item,
			@RequestParam("claimLot") String lot,
			@RequestParam("reason1") String reason1,
			@RequestParam("reason2") String reason2,
			@RequestParam("claim4m") String reason3,
			@RequestParam("claimRemark") String remark,
			@RequestParam("pic1") MultipartFile pic1,
			@RequestParam("pic1id") String pic1id,
			@RequestParam("pic2") MultipartFile pic2,
			@RequestParam("pic2id") String pic2id,
			@RequestParam("ref") MultipartFile ref,
			@RequestParam("refid") String refid,
			@RequestParam("ncr") String ncr,
			@RequestParam("reqDate") String reqDate,
			@RequestParam("request") String request,
			Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		pic1id = pic1id.trim().length()==0?null:pic1id;
		pic2id = pic2id.trim().length()==0?null:pic2id;
		refid = refid.trim().length()==0?null:refid;
		
		if(action.equals("add")){
			service.addClaim(approvalNo,partner,rate,item,lot,reason1,reason2,reason3,remark,pic1,pic2,ref,ncr,reqDate,request,user.getLocale());
		}
		else if (action.equals("edit")){
			//service.updateClaim(approvalNo,partner,rate,item,lot,reason1,reason2,reason3,remark,pic1,pic1id,pic2,pic2id,ref,refid,locale);
			service.updateClaim(approvalNo, partner, rate, item, lot, reason1, reason2, reason3, remark, pic1, pic1id, pic2, pic2id, ref, refid,ncr,reqDate,request,user.getLocale());
		}
		else if(action.equals("delete")){
			service.deletePartnerClaim(approvalNo,partner,user.getLocale()); 
		}
		else
		{
			; //do nothing.
		}
		IssueApproval approval = service.getApproval(approvalNo, user.getLocale());
		Map<String,Object> details = service.getIssueDetails(regNo, user.getLocale());
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,user.getLocale());
		String claimItem = (String)details.get("item");
		Map<String,String> suppliers = service.getClaimItemSuppliers(claimItem,user.getLocale());
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(user.getLocale(), "qisall", ""));
		model.addAttribute("suppliers",suppliers);
		return "qualityDivision/qualityIssue/acceptIssues";
	}
	 
	@RequestMapping("/acceptIssues/downloadClaimRef")
	public void downloadClaimRef(@RequestParam("id") String id,HttpServletRequest req,HttpServletResponse res){
		Map<String,Object> attach = service.getClaimAttachment(id);
		String name = (String)attach.get("fileName");
		String contentType=(String)attach.get("contentType");
		byte[] binary = (byte[])attach.get("binary");
		try{
			name = ClientFileNameEncoder.encodeFileName(name, req.getHeader("User-Agent"));
			res.setHeader("Content-Disposition", "inline;filename=" + name);
			res.setContentType(contentType);
			res.setContentLength(binary.length);
			OutputStream out = res.getOutputStream();
			out.write(binary);
			out.flush();
		}catch(IOException ex){
			logger.error("파일 다운로드 중 다음 에러 발생:"+ex.getMessage());
		}
	}

}
