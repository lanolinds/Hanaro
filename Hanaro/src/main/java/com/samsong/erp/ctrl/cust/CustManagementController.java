package com.samsong.erp.ctrl.cust;

import java.io.IOException;
import java.security.Principal;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.ctrl.cust.CustManagementController;
import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.model.cust.CustInfo;
import com.samsong.erp.model.empInfo.EmployeeInfo;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/custDivision/custInfo")
public class CustManagementController {
	
	private String prefix ="/custDivision/custInfo"; 
	private static final Logger logger = Logger.getLogger(CustManagementController.class);
	
	
	@Autowired
	private CustManagementService service;
	
	
	@Autowired
	private MessageSource message;
	
	//사원정보등록 메뉴이동
	@RequestMapping(value="/createForm", method=RequestMethod.GET)
	public String menuCustReg(Model model,Authentication auth, LocalDate date){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> custTypeList = service.getCodeCustType(user.getLocale());
	    model.addAttribute("custTypeList",custTypeList);

		CustInfo info = new CustInfo();
		info.setCustCd(message.getMessage("ui.label.AutoCreate",null, user.getLocale()));
		model.addAttribute("custInfo",info);
		return prefix+"/createForm";
	}
	
	//업체정보등록
	@RequestMapping(value="/addCustInfo", method=RequestMethod.POST )
	public String addCustInfo(String setType,Authentication auth, CustInfo info,Model model){
	  
	  HanaroUser user = (HanaroUser)auth.getPrincipal();
	  
	  try {  
		 service.setCustInfo(setType, user.getLocale(), info, user.getUsername());
	  } catch (Exception e) {
		e.printStackTrace();
	  }	  
	   model.addAttribute("status","success");
	   return "redirect:"+prefix+"/createForm";
	}	
	
	//사원정보등록 메뉴의 등록된 목록조회
	@RequestMapping(value="/getCustList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getCustRegList(Authentication auth, 
			@RequestParam(value="keyfield",required=false) String keyfield,
			@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getCusteRegList(user.getLocale(), keyfield);
	
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
	
	//업체정보 검색 목록조회
	@RequestMapping(value="/getCustSearchList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getCustSearchList(Authentication auth, 
			@RequestParam(value="keyfield",required=false) String keyfield,
			@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getCusteRegList(user.getLocale(),keyfield);
	
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
	
	//업체정보등록 메뉴이동
	@RequestMapping(value="/list", method=RequestMethod.GET)
	public String getCustDefaultList(Model model,Authentication auth, LocalDate date){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		model.addAttribute("user",user.getUsername());
		return prefix+"/list";
	}	
	
	@RequestMapping(value="/viewCustInfo", method=RequestMethod.POST)
	public String accept(@RequestParam("custCd") String custCd,Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> custTypeList = service.getCodeCustType(user.getLocale());
	    //업체상세정보
	  	Map<String,Object> custView = service.getCustView(custCd, user.getLocale());
	  		
		model.addAttribute("custTypeList",custTypeList);
		model.addAttribute("view",custView);
		
		CustInfo info = new CustInfo();
		model.addAttribute("custInfo",info);
		
		return prefix+"/viewInfo";
	}

	//사원정보등록
	@RequestMapping(value="/updateCustInfo", method=RequestMethod.POST )
	public String updateCustInfo(String setType,CustInfo info,Model model,@RequestParam("custCd") String custCd,Authentication auth){
		  HanaroUser user = (HanaroUser)auth.getPrincipal();
		  try {
		   //선택된 파일객체는 직접 입력한다.	   
			service.setCustInfo(setType, user.getLocale(), info, user.getUsername());
			
		  } catch (Exception e) {
			e.printStackTrace();
		  }	  
		Map<String,Object> custTypeList = service.getCodeCustType(user.getLocale());
		  //업체상세정보
	  	Map<String,Object> custView = service.getCustView(custCd, user.getLocale());
	  		
		model.addAttribute("custTypeList",custTypeList);
		model.addAttribute("view",custView);
		
		model.addAttribute("custInfo",info);
		return prefix+"/viewInfo";
	}
}
