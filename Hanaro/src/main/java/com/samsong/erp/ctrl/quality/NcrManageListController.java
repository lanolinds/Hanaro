package com.samsong.erp.ctrl.quality;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.model.quality.NcrMeasureReportSheet1;
import com.samsong.erp.model.quality.NcrMeasureReportSheet2;
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
	
		
		model.addAttribute("ncrInForm",new NcrInformSheet());
		model.addAttribute("measure1",new NcrMeasureReportSheet1());
		model.addAttribute("measure2", new NcrMeasureReportSheet2());
		return prefix+"/ncrManageDetail";
	}
	
}
