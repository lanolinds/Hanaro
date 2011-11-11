package com.samsong.erp.ctrl.quality;

import java.io.IOException;
import java.io.OutputStream;
import java.security.Principal;
import java.text.NumberFormat;
import java.util.ArrayList;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	
	@RequestMapping(value="/acceptIssues", method=RequestMethod.POST)
	public String accept(@RequestParam("regNo") String regNo,@RequestParam("action") String action,Model model, Locale locale,Principal p){
		
		Map<String,Object> details = service.getIssueDetails(regNo, locale);
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,locale);
		
		IssueApproval approval =null;
		if(action.equals("new")){
			String defaultMethod = originCode.equals("CD")?"resend":"abandon";
			int defaultWorkCost = 100;
			int defaultTestCost = 10000;
			String defaultShipType = "unit";
			approval =service.acceptIssue(regNo,defaultMethod,defaultWorkCost,defaultTestCost,defaultShipType,locale,p.getName());
		}
		else{
			approval =service.getApproval(action,locale);
		}
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(locale, "qisall", ""));
		
		return "qualityDivision/qualityIssue/acceptIssues";
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
			Locale locale,HttpServletRequest req, HttpServletResponse res){
		
		try{
			name = ClientFileNameEncoder.encodeFileName(name, req.getHeader("User-Agent"));
			byte[] binary =service.getQualityIssueFile(locale, regNo, Integer.toString(seq));
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
	public @ResponseBody List<Map<String,Object>> getDefectTreeData(Locale locale){
		return service.getDefectTreeData(locale);
	}
	
	@RequestMapping("/acceptIssues/4mTreeCallback")
	public @ResponseBody List<Map<String,Object>> get4mTreeData(Locale locale){
		return service.get4mTreeData(locale);
	}
	
	@RequestMapping("/acceptIssues/itemAssistCallback")
	public @ResponseBody List<Map<String,Object>> getItemAssistant(Locale locale){
		return service.getClaimItemAssistantList(locale);
	}
	
	@RequestMapping("/acceptIssues/claimListGridCallback")
	public @ResponseBody Map<String,Object> getClaimPartnerList(@RequestParam("approvalNo") String approvalNo,Locale locale){
		
		List<Map<String,Object>> claims =service.getClaimList(approvalNo,locale);
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
			@RequestParam("reason1") String reason1,
			@RequestParam("reason2") String reason2,
			@RequestParam("reason3") String reason3,
			@RequestParam("approvalRemark") String remark,
			@RequestParam("method") String method,
			@RequestParam("workCost") int workCost,
			@RequestParam("testCost") int testCost,
			Model model,Locale locale){
				
		IssueApproval approval =new IssueApproval();
		approval.setApprovalNo(approvalNo);
		approval.setDefect1(reason1);
		approval.setDefect2(reason2);
		approval.setDefect3(reason3);
		approval.setRemark(remark);
		approval.setMethod(method);
		approval.setWorkCost(workCost);
		approval.setTestCost(testCost);
		approval.setShipType("unit");
		
		//처리내역 변경 사항을 업데이트한다.
		service.updateApproval(regNo,approval,locale); 
		
		
		Map<String,Object> details = service.getIssueDetails(regNo, locale);
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,locale);
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(locale, "qisall", ""));
		
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
			@RequestParam("pic2") MultipartFile pic2,
			@RequestParam("ref") MultipartFile ref,
			@RequestParam("ncr") String ncr,
			@RequestParam("reqDate") String reqDate,
			@RequestParam("request") String request,
			Model model,Locale locale){
		
		if(action.equals("delete")){
			service.deletePartnerClaim(approvalNo,partner); 
		}
		
		logger.info("action:"+action);
		logger.info("claimPartner:"+partner);
		logger.info("claimRate:"+rate);
		logger.info("claimItem:"+item);
		logger.info("claimLot:"+lot);
		logger.info("reason1:"+reason1);
		logger.info("reason2:"+reason2);
		logger.info("reason3:"+reason3);
		logger.info("claimRemark:"+remark);
		logger.info("pic1:"+pic1.getSize());
		logger.info("pic2:"+pic2.getSize());
		logger.info("pic3:"+ref.getSize());
		logger.info("ncr:"+ncr);
		logger.info("reqDate:"+reqDate);
		logger.info("request:"+request);
		
		IssueApproval approval =service.getApproval(approvalNo,locale);
		
		Map<String,Object> details = service.getIssueDetails(regNo, locale);
		String originCode =(String)details.get("originCode");
		Map<String,String> methods = getHandleMethods(originCode,locale);
		
		model.addAttribute("issue",details);
		model.addAttribute("methods",methods);
		model.addAttribute("approval",approval);
		model.addAttribute("partners",partnerService.getCustOption(locale, "qisall", ""));
		
		return "qualityDivision/qualityIssue/acceptIssues";
	}

}
