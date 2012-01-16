package com.samsong.erp.ctrl.product;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List; 
import java.util.Map;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.ctrl.quality.NcrStatusController;
import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.model.product.StockInOutSheet;
import com.samsong.erp.service.product.ProductStockService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/productDivision/stock")
public class ProductStockController {
	private String prefix = "/productDivision/stock";
	private static final Logger logger = Logger.getLogger(NcrStatusController.class);
	
	@Autowired
	private ProductStockService service;
	
	 
	@RequestMapping(value="/inoutManagement",method=RequestMethod.GET)
	public String menuInoutManagement(Authentication auth,LocalDate date, Model model,StockInOutSheet inOutSheet){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> incomeType = service.getComponentTypeOption(user.getLocale(),"PR");
		Map<String,Object> outgoType = service.getComponentTypeOption(user.getLocale(),"PI");
		Map<String,Object> lineCode = service.getLineCode(user.getLocale());		
		model.addAttribute("today",date);
		model.addAttribute("incomeSheet",inOutSheet);
		model.addAttribute("outgoSheet",inOutSheet);
		model.addAttribute("incomeType",incomeType);
		model.addAttribute("outgoType",outgoType);
		model.addAttribute("lineCode",lineCode);
		return prefix+"/inoutManagement";
	} 
	
	@RequestMapping(value="/getPartListCallBak",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getPartListCallBak(@RequestParam(value="type",required=false) String type, @RequestParam(value="q",required=false) String term,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();				
		return service.getPartList(user.getLocale(), type, term);
	}
	
	@RequestMapping(value="/inoutManagement",method=RequestMethod.POST)
	public String inoutManagement(Authentication auth,
			@RequestParam("category") String category,
			@RequestParam("pType") String pType,
			StockInOutSheet sheet){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		service.prodIncomeOutgoList(user.getLocale(), category, pType, sheet,  user.getUsername());
		return "redirect:"+prefix+"/inoutManagement";
	}
	
	@RequestMapping(value="/getIncomeOutgoList",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getIncomeOutgoList(
			@RequestParam(value="category",required=false) String category,
			@RequestParam(value="stdDt",required=false) String stdDt,
			@RequestParam(value="endDt",required=false) String endDt, Authentication auth,@RequestParam("page") int page,@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getIncomeOutgoList(user.getLocale(), category, stdDt, endDt);
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
