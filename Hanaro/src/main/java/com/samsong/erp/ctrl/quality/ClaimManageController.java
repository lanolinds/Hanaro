package com.samsong.erp.ctrl.quality;



import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.empInfo.EmployeeInfoService;
import com.samsong.erp.service.quality.ClaimManageService;


@Controller
@RequestMapping("/qualityDivision/claimManage")
public class ClaimManageController {
	private String prefix = "/qualityDivision/claimManage";
	private static final Logger logger = Logger.getLogger(ClaimManageController.class);
	
	@Autowired
	private ClaimManageService service;
	
	@Autowired
	private EmployeeInfoService serviceEmp;
	
	
	@Autowired
	private CustManagementService serviceCust;
	
	@Autowired
	private MessageSource message;
	
	
	@RequestMapping(value="/claimManage",method=RequestMethod.GET)
	public String menuClaimManage(Model model,Locale locale,Authentication auth,LocalDate date){
		HanaroUser user =  (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> listClaimType = service.getClaimCode("CLAIMTYPE", user.getLocale());
		List<Map<String,Object>> listLSType = service.getClaimCode("LSTYPE", user.getLocale());
		List<Map<String,Object>> listIssueLine = service.getClaimCode("ISSUELINE", user.getLocale());
		List<Map<String,Object>> listModel = service.getClaimCode("MODEL", user.getLocale());
		List<Map<String,Object>> listSwtype = service.getClaimCode("SWTYPE", user.getLocale());
		model.addAttribute("claimType",listClaimType);
		model.addAttribute("lsType",listLSType);
		model.addAttribute("issueLine",listIssueLine);
		model.addAttribute("model",listModel);
		model.addAttribute("swtype",listSwtype);
		model.addAttribute("autoCreate",message.getMessage("ui.label.AutoCreate",null,locale));
		model.addAttribute("autoCarType",message.getMessage("alert.autoInputByPartNo",null,locale));
		
		List<Map<String,Object>> empInfo = serviceEmp.getUserInfo(user.getLocale(), user.getUsername());
		List<Map<String,Object>> claimDept = service.getClaimCode("REFTEAM",user.getLocale());
		model.addAttribute("claimDept", claimDept);
		model.addAttribute("writer",empInfo.get(0).get("DATA3"));
		model.addAttribute("today",date);
		
		return prefix+"/claimManage";
	}
	
	@RequestMapping(value="/codeCustOptionLongCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Authentication auth ,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getCustOptionLong(user.getLocale(), searchType, q);
	}
	

}
