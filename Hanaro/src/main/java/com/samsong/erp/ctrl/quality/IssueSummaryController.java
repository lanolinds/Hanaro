package com.samsong.erp.ctrl.quality;

import java.util.ArrayList;
import java.util.Collections;
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
public class IssueSummaryController {
	private String prefix = "/qualityDivision/qualityIssue";
	private static final Logger logger = Logger.getLogger(IssueSummaryController.class);
	
	@Autowired
	private QualityIssueService service;
	
	
	@RequestMapping(value="/issueSummary",method=RequestMethod.GET)
	public String menuIssueSummary(Locale locale,LocalDate date,Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		model.addAttribute("authLocale",user.getLocale().getCountry());
		model.addAttribute("today",date);
		return prefix+"/issueSummary";
	}
	
	@RequestMapping(value="/issueSummaryDetail",method=RequestMethod.GET)
	public String menuIssueSummaryDetail(@RequestParam("cate")String cate,
			@RequestParam("term")String term,
			@RequestParam("seg1")String seg1,
			@RequestParam("seg2")String seg2,
			@RequestParam("seg3")String seg3,
			@RequestParam("sLocale")String sLocale,
			Model model){
		Map<String,Object> m = service.getCodeMachineType();
		model.addAttribute("machineType",m);
		model.addAttribute("cate",cate);
		model.addAttribute("term",term);
		model.addAttribute("seq1",seg1);
		model.addAttribute("seq2",seg2);
		model.addAttribute("seq3",seg3);
		model.addAttribute("sLocale",sLocale);
		return prefix+"/issueSummaryDetail";
	}	
	
	@RequestMapping(value="/issueSummaryDetailPop",method=RequestMethod.GET)
	public String menuIssueSummaryDetailPop(@RequestParam("machineType")String machineType,
			@RequestParam("partNo")String partNo,
			@RequestParam("error")String error,
			@RequestParam("rcust")String rcust,
			@RequestParam("errornm")String errornm,
			@RequestParam("rcustnm")String rcustnm,
			@RequestParam("searchLocale")String searchLocale,
			Model model,LocalDate date){			
		model.addAttribute("today",date);
		model.addAttribute("mType",machineType);
		model.addAttribute("partNo",partNo);
		model.addAttribute("error",error);
		model.addAttribute("rcust",rcust);
		model.addAttribute("errornm",errornm);
		model.addAttribute("rcustnm",rcustnm);
		model.addAttribute("searchLocale",searchLocale);
		return prefix+"/issueSummaryDetailPop";
	}		
	
	@RequestMapping(value="/getDateToWeek", method=RequestMethod.GET)
	public @ResponseBody String  getDateToWeek(@RequestParam("date") String date, LocalDate localDate){
		return service.getWeekOfYear(date).toString();
	}
	
	@RequestMapping(value="/getIssueSummaryData",method=RequestMethod.GET)
	public @ResponseBody List<Map<String,Object>> getIssueSummaryData(@RequestParam(value="p1")String p1,
			@RequestParam(value="p2")String p2,
			@RequestParam(value="p3")String p3,
			@RequestParam(value="p4")String p4,
			@RequestParam(value="p5")String p5,
			@RequestParam(value="p6")String p6,
			@RequestParam(value="p7")String p7,
			@RequestParam(value="p8")String p8,
			@RequestParam(value="p9")String p9,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getIssueSummary(p1, p2, p3, p4, p5, p6, p7, p8, p9, user.getLocale());
	}
	
	@RequestMapping(value="/getIssueSummaryDetail",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getIssueSummaryDetail(
			@RequestParam(value="p1")String p1,
			@RequestParam(value="p2")String p2,
			@RequestParam(value="p3")String p3,
			@RequestParam(value="p4")String p4,
			@RequestParam(value="p5")String p5,
			@RequestParam(value="p6")String p6,
			@RequestParam(value="p7")String p7,
			@RequestParam(value="group")String group,
			Authentication auth
			){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList =  service.getIssueSummaryDetail(p1, p2, p3, p4, p5, p6, p7,user.getLocale());
		List<Map<String,Object>> returnList =  new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> returnFooter =  new ArrayList<Map<String,Object>>();
		
		if(resultList!=null){		
			Collections.sort(resultList,new HashMapComparator(group,true));
			String checkRepeat = "";
			int count = 0;
			long badCount = 0;
			long badAmount = 0;
			long badCost = 0;
			long totalBadCount = 0;
			long totalBdAmount = 0;
			long totalBadCost = 0;			
			Map<String,Object> newM;
			for(int x=0;x<resultList.size();x++){
				Map<String,Object> m = (Map<String,Object>)resultList.get(x);
				
				if(!checkRepeat.equals(m.get(group).toString())){
					if(x!=0){
						newM = new LinkedHashMap<String, Object>();
						newM.put("DATA0","");
						newM.put("DATA4","("+String.valueOf(count)+") total");
						newM.put("DATA6",badCount);
						newM.put("DATA7",badAmount);
						newM.put("DATA9",badCost);
						returnList.add(newM);
					}
					newM = new LinkedHashMap<String, Object>();
					newM.put(group,"-"+m.get(group).toString()+"-");
					newM.put("DATA4","");
					checkRepeat = m.get(group).toString();					
					returnList.add(newM);
					count = 0;
					badCount = Long.parseLong(m.get("DATA6").toString());
					badAmount = Long.parseLong(m.get("DATA7").toString());
					badCost = Long.parseLong(m.get("DATA9").toString());					
				}
				count += 1;
				badCount += Long.parseLong(m.get("DATA6").toString());
				badAmount += Long.parseLong(m.get("DATA7").toString());
				badCost += Long.parseLong(m.get("DATA9").toString());
				totalBadCount +=Long.parseLong(m.get("DATA6").toString());
				totalBdAmount += Long.parseLong(m.get("DATA7").toString());
				totalBadCost += Long.parseLong(m.get("DATA9").toString());
				returnList.add(m);				
			}
			newM = new LinkedHashMap<String, Object>();
			newM.put("DATA0","");
			newM.put("DATA4","("+String.valueOf(count)+") total");
			newM.put("DATA6",badCount);
			newM.put("DATA7",badAmount);
			newM.put("DATA9",badCost);
			returnList.add(newM);			
			Map<String,Object> mFooter = new LinkedHashMap<String, Object>();			
			mFooter.put("DATA0","");
			mFooter.put("DATA4","Total");
			mFooter.put("DATA6",totalBadCount);
			mFooter.put("DATA7",totalBdAmount);
			mFooter.put("DATA9",totalBadCost);
			returnFooter.add(mFooter);
			table.put("total",returnList.size());			
			table.put("rows",returnList);
			table.put("footer",returnFooter);
		}else{
			table.put("total",0);
		}
		return table;
	}
	
	@RequestMapping(value="/getIssueSummaryDetailPop",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getIssueSummaryDetailPop(
			@RequestParam(value="p1")String p1,
			@RequestParam(value="p2")String p2,
			@RequestParam(value="p3")String p3,
			@RequestParam(value="p4")String p4,
			@RequestParam(value="p5")String p5,
			@RequestParam(value="p6")String p6,
			@RequestParam(value="p7")String p7,
			@RequestParam(value="p8")String p8,
			@RequestParam(value="p9")String p9,
			@RequestParam(value="p10")String p10,			
			Authentication auth
			){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList =  service.getIssueSummaryDetailPOP(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,user.getLocale());
		if(resultList!=null){
			table.put("total",resultList.size());			
			table.put("rows",resultList);			
		}else{
			table.put("total",0);
		}
		return table;	
	}
}
