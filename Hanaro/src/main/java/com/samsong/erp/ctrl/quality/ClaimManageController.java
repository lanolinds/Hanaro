package com.samsong.erp.ctrl.quality;




import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
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
import com.samsong.erp.service.empInfo.EmployeeInfoService;
import com.samsong.erp.service.quality.ClaimManageService;
import com.samsong.erp.util.HashMapComparator;


@Controller
@RequestMapping("/qualityDivision/claimManage")
public class ClaimManageController {
	private String prefix = "/qualityDivision/claimManage";
	private static final Logger logger = Logger.getLogger(ClaimManageController.class);
	private JdbcTemplate sp;
	
	@Autowired
	private ClaimManageService service;
	
	@Autowired
	private EmployeeInfoService serviceEmp;
	
	
	@Autowired
	private CustManagementService serviceCust;
	
	@Autowired
	private ItemService serviceItem;
	
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
		
		List<Map<String,Object>> bomCar = serviceItem.getEbomItemList("CAR","",user.getLocale(),"","");
		List<Map<String,Object>> bomModel = serviceItem.getEbomItemList("MODEL","",user.getLocale(),"","");
		model.addAttribute("bomCar",bomCar);
		model.addAttribute("bomModel",bomModel);
		model.addAttribute("cLocale",user.getLocale().getCountry());
		return prefix+"/claimManage";
	}
	
	@RequestMapping(value="/codeCustOptionLongCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Authentication auth ,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getCustOptionLong(user.getLocale(), searchType, q);
	}
	
	@RequestMapping(value="/getEbomItem",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getEbomItem(
			@RequestParam(value="type",required=false)String type,
			@RequestParam(value="partCode",required=false)String partCode,
			Authentication auth,
			@RequestParam(value="car",required=false)String car,
			@RequestParam(value="model",required=false)String model){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return serviceItem.getEbomItemList(type, partCode, user.getLocale(), car, model);
	}
	
	
	@RequestMapping(value="/getEbom",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getEbom(			
			@RequestParam(value="partCode",required=false)String partCode,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return serviceItem.getEbom(partCode, user.getLocale());
	}
	
	
	@RequestMapping(value="/claimManage",method=RequestMethod.POST)
	public String  prodClaimManage(Locale locale,
			@RequestParam(value="prodType")String prodType,
			@RequestParam(value="classType")String classType,
			@RequestParam(value="claimNo")String claimNo,
			@RequestParam(value="invoiceNo")String invoiceNo,
			@RequestParam(value="claimCost")String claimCost,
			@RequestParam(value="issueCust")String issueCust,
			@RequestParam(value="issueTeam")String issueTeam,
			@RequestParam(value="cost")String cost,
			@RequestParam(value="partType1")String partType,
			@RequestParam(value="rPartCode")String rPartCode,
			@RequestParam(value="rPartName")String rPartName,
			@RequestParam(value="issueDate")String issueDate,
			@RequestParam(value="claimContent")String claimContent,
			@RequestParam(value="carType")String carType,
			@RequestParam(value="machineType")String machineType,
			@RequestParam(value="workerCount")String workerCount,
			@RequestParam(value="issueTime")String issueTime,
			Authentication auth,
			@RequestParam(value="p1", required=false)String p1,
			@RequestParam(value="p2", required=false)String p2,
			@RequestParam(value="p3", required=false)String p3,
			@RequestParam(value="p4", required=false)String p4,
			@RequestParam(value="p5", required=false)String p5,
			@RequestParam(value="p6", required=false)String p6,
			@RequestParam(value="p7", required=false)String p7
			){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		service.prodClaimManage(user.getLocale(), prodType, classType, claimNo, invoiceNo, claimCost, issueCust, issueTeam, cost,
								partType, rPartCode, rPartName, issueDate, claimContent, carType, machineType, workerCount, issueTime,
								user.getUsername(), p1, p2, p3, p4, p5, p6, p7);
		return "redirect:"+prefix+"/claimManage";		
	}
	
	
	
	@RequestMapping(value="/getClaimRegList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getClaimRegList(
			Authentication auth,
			@RequestParam("classType") String classType,			
			@RequestParam(value="stdDt",required=false) String stdDt,
			@RequestParam(value="endDt",required=false) String endDt,
			@RequestParam(value="partCode",required=false) String partCode,
			@RequestParam("page") int page,@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getClaimRegList(user.getLocale(), classType, stdDt, endDt, partCode);
				
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
	
	
	
	


}
