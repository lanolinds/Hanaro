package com.samsong.erp.ctrl.basic;



import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.LineService;


@Controller
@RequestMapping("/basicDivision/line")
public class ProcessMasterController {
	
	private static Logger logger = Logger.getLogger(ProcessMasterController.class);
	
	private String prefix = "/basicDivision/line";
	
	@Autowired
	LineService service;
	

	@RequestMapping(value="/processMaster",method = RequestMethod.GET)
	public String menuProcessMaster(){
		return prefix+"/processMaster";
	}
	
	@RequestMapping(value="/getProcessMasterList",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getProcessMasterList(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getProcessMasterList(user.getLocale());
	}
	
	@RequestMapping(value="processMaster",method=RequestMethod.POST)
	public String updateProcessMaster(Authentication auth,
			@RequestParam("procType") String procType,
			@RequestParam("procCode") String procCode,
			@RequestParam("procName") String procName,
			@RequestParam(value="procRemark",required=false) String procRemark,
			@RequestParam(value="useYn",required=false) String useYn){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		service.updateProcessMaster(user.getLocale(), procType, procCode, procName, procRemark, useYn,user.getUsername());
		
		return "redirect:"+prefix+"/processMaster";
		
	}
}
