package com.samsong.erp.ctrl.quality;

import java.security.Principal;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.service.quality.QualityIssueService;


@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class NcrManageListController {
	private String prefix = "/qualityDivision/qualityIssue";	
	private static final Logger logger = Logger.getLogger(NcrManageListController.class);
	
	@Autowired
	QualityIssueService service;
	
	@RequestMapping(value="/ncrManageList", method=RequestMethod.GET)
	public String menuNcrManageList(){		
		return prefix+"/ncrManageList"; 
	}
	@RequestMapping(value="/ncrManageDetail", method=RequestMethod.GET)
	public String menuNcrManageDetail(Model model){
		String[] standardNames = {"ui.label.quality.fmea","ui.label.quality.managePlan","ui.label.quality.workStandard","ui.label.quality.csheet"};
		model.addAttribute("stanNames",standardNames);
		model.addAttribute("ncrInForm",new NcrInformSheet());
		Map<String,Object> head = new HashMap<String,Object>();
		head.put("status","");
		model.addAttribute("viewData",head);

		return prefix+"/ncrManageDetail";
	}
	//대책서머리를 등록한다.
	@RequestMapping(value="/addNcrMeasureForm",method=RequestMethod.POST)
	public String addNcrMeasureForm(NcrInformSheet sheet,Locale locale,Principal prin){
		String user = prin.getName();
		
		logger.info(sheet.toString());
		
		
		return "redirect:"+prefix+"/ncrManageDetail";
	}
	
}
