package com.samsong.erp.ctrl.empInfo;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.empInfo.EmployeeInfo;
import com.samsong.erp.service.empInfo.EmployeeInfoService;
import com.samsong.erp.model.quality.QualityIssueRegSheet;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/humanDivision/employeeInfo")
public class EmployeeInfoController {

	private String prefix ="/humanDivision/employeeInfo"; 
	private static final Logger logger = Logger.getLogger(EmployeeInfoController.class);
	
	
	@Autowired
	private EmployeeInfoService service;
	
	
	@Autowired
	private MessageSource message;
	
	//사원정보등록 메뉴이동
	@RequestMapping(value="/createForm", method=RequestMethod.GET)
	public String menuQualityIssueReg(Model model,Locale locale, LocalDate date){				
		Map<String,Object> deptList = service.getCodeDept(locale);
		Map<String,Object> positionList = service.getCodePosition(locale);	
		Map<String,Object> roleList = service.getCodeRole(locale);		
	    model.addAttribute("deptList",deptList);
		model.addAttribute("positionList", positionList);
		model.addAttribute("roleList",roleList);
		EmployeeInfo info = new EmployeeInfo();
		info.setEmpNo(message.getMessage("ui.label.AutoCreate",null, locale));
		model.addAttribute("employeeInfo",info);
		return prefix+"/createForm";
	}	
	
	//사원정보등록
	@RequestMapping(value="/addEmployeeInfo", method=RequestMethod.POST )
	public String addEmployeeInfo(String setType,Locale locale, EmployeeInfo info,Principal prin,Model model, @RequestParam("photoImg") MultipartFile photoImg){
	   String user =prin.getName();
	  try {
	   //선택된 파일이름은 모델에 담는다.		  
	   info.setPhoto(photoImg.getOriginalFilename());

	   //선택된 파일객체는 직접 입력한다.	   
		service.setEmployeeInfo(setType, locale, info, user, photoImg.getBytes());
	  } catch (IOException e) {
		e.printStackTrace();
	  }	  
	   model.addAttribute("status","success");
	   return "redirect:"+prefix+"/createForm";
	}	
}
