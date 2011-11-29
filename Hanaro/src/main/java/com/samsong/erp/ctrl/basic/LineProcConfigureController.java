package com.samsong.erp.ctrl.basic;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;
import com.samsong.erp.service.cust.CustManagementService;

@Controller
@RequestMapping("/basicDivision/line")
public class LineProcConfigureController {
	
	private static Logger logger = Logger.getLogger(LineProcConfigureController.class);
	private String prefix = "/basicDivision/line";
	
	@Autowired
	ItemService service;
	
	@Autowired
	CustManagementService serviceCust;
	
	@RequestMapping(value="/lineProcConfigure",method=RequestMethod.GET)
	public String menuLineProcConfigure(Authentication auth,Model model){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> listCust;
		listCust = serviceCust.getCustOption(user.getLocale(), "LOCALECUST","");
		model.addAttribute("custOption",listCust);
		return prefix+"/lineProcConfigure"; 
	}
	@RequestMapping(value="/lineProcConfigure",method=RequestMethod.POST)
	public String procLineProcConfigure(Authentication auth, Model model,
			@RequestParam("procCate") String procCate,
			@RequestParam("procType") String procType,
			@RequestParam(value="custCode", required=false) String custCode,
			@RequestParam(value="lineCode", required=false) String lineCode,
			@RequestParam(value="procCode", required=false) String procCode,
			@RequestParam(value="procSeq", required=false) String procSeq,
			@RequestParam(value="useYn", required=false) String useYn){		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		logger.info("procCate="+procCate+",procType="+procType+",custCode="+custCode+",lineCode="+lineCode+",procCode="+procCode+",procSeq="+procSeq+",useYn="+useYn);
		service.updateLineProcConfiguration(user.getLocale(), procCate, procType, custCode, lineCode, procCode, procSeq, useYn, user.getUsername());	
		List<Map<String,Object>> listCust;
		listCust = serviceCust.getCustOption(user.getLocale(), "LOCALECUST","");
		model.addAttribute("custOption",listCust);		
		return "redirect:"+prefix+"/lineProcConfigure";
	}
	
	@RequestMapping(value="/getLineProcConfiguration",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getLineProcConfiguration(Authentication auth, @RequestParam(value="custCode",required=false) String custCode, @RequestParam(value="lineCode",required=false) String lineCode){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getLineProcConfiguration(user.getLocale(), custCode, lineCode);
	}
	
	@RequestMapping(value="/getCheckUnique", method=RequestMethod.GET)
	public @ResponseBody String getCheckUnique(Authentication auth, @RequestParam("checkItem")String checkItem
			,@RequestParam("checkKey") String checkKey
			,@RequestParam(value="checkKey2",required=false) String checkKey2){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getCheckUnique(user.getLocale(), checkItem, checkKey, checkKey2);
	}
	
	@RequestMapping(value="/getProcOption",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getProcOption(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getProcOption(user.getLocale());
	}

}
