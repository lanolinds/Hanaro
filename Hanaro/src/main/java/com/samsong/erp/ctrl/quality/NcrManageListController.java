package com.samsong.erp.ctrl.quality;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.samsong.erp.service.quality.QualityIssueService;

@RequestMapping("/qualityDivision/qualityIssue")
@Controller
public class NcrManageListController {
	private String prefix = "/qualityDivision/qualityIssue";	
	private static final Logger logger = Logger.getLogger(NcrManageListController.class);
	
	@Autowired
	QualityIssueService service;
	
	@RequestMapping(value="/ncrManageList", method=RequestMethod.GET)
	public String menuNcrManageList(){		
		return prefix+"/ncrManageList"; 
	}
	
}
