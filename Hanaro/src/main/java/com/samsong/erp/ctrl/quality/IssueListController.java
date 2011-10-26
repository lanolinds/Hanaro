package com.samsong.erp.ctrl.quality;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class IssueListController {
	
	private static Logger logger = Logger.getLogger(IssueListController.class);
	
	@Autowired
	private QualityIssueService service;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public String list(){
		return "/qualityDivision/qualityIssue/list";
	}
	
	@RequestMapping(value="/list/gridCallback", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getUndoneIssueList(@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order,
			Locale locale){
		List<Map<String,Object>> list = service.getUndoneIssueList(locale);	
		if(sortKey!=null){
			Collections.sort(list,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
		}
		Map<String,Object> json = new HashMap<String, Object>();
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

}
