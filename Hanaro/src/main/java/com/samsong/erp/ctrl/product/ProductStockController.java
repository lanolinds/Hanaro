package com.samsong.erp.ctrl.product;

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
import com.samsong.erp.model.product.StockIncomeSheet;
import com.samsong.erp.model.product.StockOutgoSheet;
import com.samsong.erp.service.product.ProductStockService;

@Controller
@RequestMapping("/productDivision/stock")
public class ProductStockController {
	private String prefix = "/productDivision/stock";
	private static final Logger logger = Logger.getLogger(NcrStatusController.class);
	
	@Autowired
	private ProductStockService service;
	
	 
	@RequestMapping(value="/inoutManagement",method=RequestMethod.GET)
	public String menuInoutManagement(Authentication auth,LocalDate date, Model model,StockIncomeSheet incomeSheet,StockOutgoSheet outgoSheet){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> incomeType = service.getComponentTypeOption(user.getLocale(),"PR");
		Map<String,Object> outgoType = service.getComponentTypeOption(user.getLocale(),"PI");
		Map<String,Object> lineCode = service.getLineCode(user.getLocale());		
		model.addAttribute("today",date);
		model.addAttribute("incomeSheet",incomeSheet);
		model.addAttribute("outgoSheet",outgoSheet);
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
	
	@RequestMapping(value="/prodIncomeList",method=RequestMethod.POST)
	public @ResponseBody String prodIncomeList(@RequestParam("pType") String pType, @RequestParam("p1") String p1, @RequestParam("p2") String p2, @RequestParam("p3") String p3, @RequestParam("p4") String p4, @RequestParam("p5") String p5, @RequestParam("p6") String p6, @RequestParam("p7") String p7, @RequestParam(value="seq",required=false) int seq){
			return "323";
	}
	
	
}
