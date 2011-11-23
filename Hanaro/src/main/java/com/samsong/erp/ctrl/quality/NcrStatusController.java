package com.samsong.erp.ctrl.quality;

import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class NcrStatusController {
	private String prefix = "/qualityDivision/qualityIssue";
	private static final Logger logger = Logger.getLogger(NcrStatusController.class);
	
	@Autowired
	private QualityIssueService service;
	
	@RequestMapping(value="/ncrStatus",method=RequestMethod.GET)
	public String menuNcrStatus(LocalDate date,Model model){
		int[] years = new int[10];
		for(int x=0;x<10;x++)
			years[x] = date.getYear()-x;
		model.addAttribute("years",years);
		
		return prefix+"/ncrStatus";
	}
	@RequestMapping(value="/getWeekOfYear",method=RequestMethod.GET)
	public @ResponseBody int getWeekOfYear(@RequestParam("year") int year,@RequestParam("month") int month, @RequestParam("day") int day){
		int weekOfYear=0;		
		Calendar date = Calendar.getInstance();
		date.set(year, month, day);
		weekOfYear = date.get(Calendar.WEEK_OF_YEAR);		
		return weekOfYear; 
	};
	
	@RequestMapping(value="/getNcrStatus")
	public @ResponseBody Map<String,Object> getNcrStatus(Authentication auth,@RequestParam(value="searchType",required=false) String searchType
			,@RequestParam(value="searchTab",required=false) String searchTab, @RequestParam(value="regStdYear",required=false) String regStdYear
			,@RequestParam(value="regStdDate",required=false) String regStdDate, @RequestParam(value="regEndYear",required=false) String regEndYear
			,@RequestParam(value="regEndDate",required=false) String regEndDate, @RequestParam(value="ncrStdYear",required=false) String ncrStdYear
			,@RequestParam(value="ncrStdDate",required=false) String ncrStdDate, @RequestParam(value="ncrEndYear",required=false) String ncrEndYear
			,@RequestParam(value="ncrEndDate",required=false) String ncrEndDate){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("searchType",searchType);
		param.put("searchTab",searchTab);
		param.put("regStdYear",(regStdYear==null)?"":regStdYear);
		param.put("regStdDate",(regStdDate==null)?"":regStdDate);
		param.put("regEndYear",(regEndYear==null)?"":regEndYear);
		param.put("regEndDate",(regEndDate==null)?"":regEndDate);
		param.put("ncrStdYear",(ncrStdYear==null)?"":ncrStdYear);
		param.put("ncrStdDate",(ncrStdDate==null)?"":ncrStdDate);
		param.put("ncrEndYear",(ncrEndYear==null)?"":ncrEndYear);
		param.put("ncrEndDate",(ncrEndDate==null)?"":ncrEndDate);
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getNcrStatus(user.getLocale(), param);
				
		if(resultList!=null){
			table.put("total",resultList.size());
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;		
	
	}
	
	@RequestMapping(value="/getNcrStatusList")
	public @ResponseBody Map<String,Object> getNcrStatusList(Authentication auth,@RequestParam(value="searchType",required=false) String searchType
			,@RequestParam(value="regStdYear",required=false) String regStdYear
			,@RequestParam(value="regStdDate",required=false) String regStdDate, @RequestParam(value="regEndYear",required=false) String regEndYear
			,@RequestParam(value="regEndDate",required=false) String regEndDate, @RequestParam(value="ncrStdYear",required=false) String ncrStdYear
			,@RequestParam(value="ncrStdDate",required=false) String ncrStdDate, @RequestParam(value="ncrEndYear",required=false) String ncrEndYear
			,@RequestParam(value="ncrEndDate",required=false) String ncrEndDate,@RequestParam(value="type_date",required=false) String typeDate
			,@RequestParam(value="occurSite",required=false) String occurSite, @RequestParam(value="reasonCode",required=false)String reasonCode
			,@RequestParam(value="defectS",required=false) String defectS){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("searchType",searchType);		
		param.put("regStdYear",(regStdYear==null)?"":regStdYear);
		param.put("regStdDate",(regStdDate==null)?"":regStdDate);
		param.put("regEndYear",(regEndYear==null)?"":regEndYear);
		param.put("regEndDate",(regEndDate==null)?"":regEndDate);
		param.put("ncrStdYear",(ncrStdYear==null)?"":ncrStdYear);
		param.put("ncrStdDate",(ncrStdDate==null)?"":ncrStdDate);
		param.put("ncrEndYear",(ncrEndYear==null)?"":ncrEndYear);
		param.put("ncrEndDate",(ncrEndDate==null)?"":ncrEndDate);
		param.put("type_date",(typeDate==null)?"":typeDate);
		param.put("occurSite",(occurSite==null)?"":occurSite);
		param.put("reasonCode",(reasonCode==null)?"":reasonCode);
		param.put("defectS",(defectS==null)?"":defectS);
		
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getNcrStatusList(user.getLocale(), param);
				
		if(resultList!=null &&( regStdYear!=null || ncrStdYear!=null)){
			table.put("total",resultList.size());
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;		
	
	}	
	
	
}
