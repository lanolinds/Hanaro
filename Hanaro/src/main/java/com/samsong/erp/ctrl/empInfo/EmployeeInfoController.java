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
		  System.out.println(photoImg.getOriginalFilename());
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
	
	//사원정보등록 메뉴의 등록된 목록조회
	@RequestMapping(value="/getEmployeeList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getQualityIssueRegList(Locale locale, 
			@RequestParam(value="keyword",required=false) String keyword,
			@RequestParam(value="keyfield",required=false) String keyfield,
			@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getEmployeeRegList(locale,keyword,keyfield);
	
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}
			
			table.put("total",resultList.size());
			int start =  (page-1)*rows;
			int end  = start +rows;
			if(end>resultList.size())end = resultList.size();
			table.put("rows",resultList.subList(start,end));
		}else{
			table.put("total",0);
		}
		return table;
	}
	
	//품질 파일 다운
	@RequestMapping(value="/getEmployeeFile", method=RequestMethod.GET)
	public  void  getEmployeeFile(Locale locale, @RequestParam("empNo") String empNo, @RequestParam("fileName") String fileName, HttpServletResponse response){		
	
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getEmployeeFile(locale, empNo);	    

		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
