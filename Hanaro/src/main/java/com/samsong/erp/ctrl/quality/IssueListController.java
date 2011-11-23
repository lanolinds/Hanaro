package com.samsong.erp.ctrl.quality;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class IssueListController {
	
	private static Logger logger = Logger.getLogger(IssueListController.class);
	
	@Autowired
	private QualityIssueService service;
	

	@RequestMapping(value="/list",method=RequestMethod.GET)
	public String list(Model model){
		Calendar cal = Calendar.getInstance();
		model.addAttribute("toDate",cal.getTime());
		cal.add(Calendar.DATE, -7);
		model.addAttribute("fromDate",cal.getTime());
		return "qualityDivision/qualityIssue/list";
	}
	
	@RequestMapping(value="/list/gridCallback", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getUndoneIssueList(@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order,
			@RequestParam(value="fromDate",required=false) String fromDateStr,
			@RequestParam(value="toDate",required=false) String toDateStr,
			@RequestParam(value="item",required=false) String item,Authentication auth
			){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		Date fromDate=null;
		Date toDate = null;
		try {
			fromDate = fmt.parse(fromDateStr);
			toDate = fmt.parse(toDateStr);
		} catch (Exception ex) {
			logger.info("검색기간을 java.util.Date 타입으로 파싱하던 중 에러가 났습니다:"+ex.getMessage());
		}
		
		Map<String,Object> json = new HashMap<String, Object>();
		List<Map<String,Object>> list =service.getUndoneIssueList(fromDate,toDate,item,user.getLocale());	
		if(sortKey!=null){
			Collections.sort(list,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
		}
		
		if(list!=null){
			json.put("total",list.size());
			int from = (page-1)*rows;
			int to = from + rows;
			to = list.size()<to?list.size():to;
			json.put("rows", list.subList(from,to));
		}
		else{
			json.put("total", Integer.valueOf(0));
			json.put("rows", Integer.valueOf(0));
		}
		return json;
	}
	
	@RequestMapping(value="/list/gridCallback2", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getUndoneIssueList2(@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order,
			@RequestParam(value="fromDate",required=false) String fromDateStr,
			@RequestParam(value="toDate",required=false) String toDateStr,
			@RequestParam(value="item",required=false) String item,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		Date fromDate=null;
		Date toDate = null;
		try {
			fromDate = fmt.parse(fromDateStr);
			toDate = fmt.parse(toDateStr);
		} catch (Exception ex) {
			logger.info("검색기간을 java.util.Date 타입으로 파싱하던 중 에러가 났습니다:"+ex.getMessage());
		}
		
		Map<String,Object> json = new HashMap<String, Object>();
		List<Map<String,Object>> list =service.getDoneIssueList(fromDate,toDate,item,user.getLocale());	
		if(sortKey!=null){
			Collections.sort(list,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
		}
		
		if(list!=null){
			json.put("total",list.size());
			int from = (page-1)*rows;
			int to = from + rows;
			to = list.size()<to?list.size():to;
			json.put("rows", list.subList(from,to));
		}
		else{
			json.put("total", Integer.valueOf(0));
			json.put("rows", Integer.valueOf(0));
		}
		return json;
	}
	
	@RequestMapping(value="/list/itemAssistCallback", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getAssistItemList(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> list = service.getAssistItemList(user.getLocale(),"ready");	
		Map<String,Object> json = new HashMap<String, Object>();
		if(list!=null){
			json.put("total",list.size());
			json.put("rows", list);
		}
		else{
			json.put("total", Integer.valueOf(0));
			json.put("rows", Integer.valueOf(0));
		}
		return json;
	}
	
	@RequestMapping(value="/list/itemAssistCallback2", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getAssistItemList2(Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> list = service.getAssistItemList(user.getLocale(),"done");	
		Map<String,Object> json = new HashMap<String, Object>();
		if(list!=null){
			json.put("total",list.size());
			json.put("rows", list);
		}
		else{
			json.put("total", Integer.valueOf(0));
			json.put("rows", Integer.valueOf(0));
		}
		return json;
	}
}
