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
		List<Map<String,Object>> closeTableHead = service.getComponentHead(user.getLocale(),"P");
		
		model.addAttribute("today",date);
		model.addAttribute("thisYear",date.getYear());		
		model.addAttribute("incomeSheet",inOutSheet);
		model.addAttribute("outgoSheet",inOutSheet);
		model.addAttribute("incomeType",incomeType);
		model.addAttribute("outgoType",outgoType);		
		model.addAttribute("closeHead",closeTableHead);
		
		return prefix+"/inoutManagement";
	} 
	
	@RequestMapping(value="/getPartListCallBak",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getPartListCallBak(@RequestParam(value="type",required=false) String type, @RequestParam(value="q",required=false) String term,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();				
		return service.getPartList(user.getLocale(), type, term);
	}
	
	@RequestMapping(value="/inoutManagement",method=RequestMethod.POST)
	public String inoutManagement(Authentication auth,
			@RequestParam(value="DATA0",required=false) String[] DATA0,
			@RequestParam(value="DATA1",required=false) String[] DATA1,
			@RequestParam(value="DATA2",required=false) String[] DATA2,
			@RequestParam(value="DATA3",required=false) String[] DATA3,
			@RequestParam(value="DATA4",required=false) String[] DATA4,
			@RequestParam(value="DATA5",required=false) String[] DATA5,
			@RequestParam(value="DATA6",required=false) String[] DATA6,
			@RequestParam(value="DATA7",required=false) String[] DATA7,
			@RequestParam(value="DATA8",required=false) String[] DATA8,
			@RequestParam(value="DATA9",required=false) String[] DATA9,
			@RequestParam(value="DATA10",required=false) String[] DATA10,
			@RequestParam(value="DATA11",required=false) String[] DATA11,
			@RequestParam(value="DATA12",required=false) String[] DATA12,
			@RequestParam(value="category",required=false) String category,
			@RequestParam(value="actStdDt", required=false) String[] actStdDt,
			@RequestParam(value="actPartCode", required=false) String[] actPartCode,
			@RequestParam(value="actAmount", required=false) String[] actAmount			
			){		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		if(actStdDt==null){
			service.prodIncomeOutgoList(user.getLocale(), category, DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7, DATA8, DATA9, DATA10, DATA11, DATA12, user.getUsername());
		}else{
			service.prodApplyActualData(user.getLocale(), actStdDt, actPartCode, actAmount, user.getUsername());
		}
		logger.info("사용자("+user.getUsername()+")가 완성품입고를 처리합니다");

		return "redirect:"+prefix+"/inoutManagement"; 
	}
	 
	@RequestMapping(value="/getIncomeOutgoList",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getIncomeOutgoList(
			@RequestParam(value="category",required=false) String category,
			@RequestParam(value="stdDt",required=false) String stdDt,
			@RequestParam(value="endDt",required=false) String endDt, Authentication auth,
			@RequestParam(value="sort",required=false) String sortKey,@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getIncomeOutgoList(user.getLocale(), category, stdDt, endDt);
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}			
			table.put("total",resultList.size());			
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;
	}	
	
	@RequestMapping(value="/getInoutState",method=RequestMethod.GET)
	public @ResponseBody List<Map<String,Object>> getInoutState(@RequestParam("partCode") String partCode,@RequestParam("stdDt") String stdDt, @RequestParam("endDt") String endDt,@RequestParam("inoutYn") String inoutYn, @RequestParam("fromToYn") String fromToYn, Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getIncomeOutgoState(user.getLocale(), partCode, stdDt, endDt, inoutYn, fromToYn);		
	}
	
	@RequestMapping(value="/getSubOptionByInoutComponent",method=RequestMethod.GET)
	public @ResponseBody List<Map<String,Object>> getSubOptionByInoutComponent(@RequestParam("code") String code,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getSubOptionByInoutComponent(user.getLocale(), code);
	}
	
	@RequestMapping(value="/getCheckPreCloseData",method=RequestMethod.GET)
	public @ResponseBody String getCheckPreCloseData(Authentication auth, @RequestParam("year")String year, @RequestParam("month")String month){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return service.getCheckPreCloseData(user.getLocale(), year, month);
	}
	
	@RequestMapping(value="/getCheckThisCloseData",method=RequestMethod.GET)
	public @ResponseBody String getCheckThisCloseData(Authentication auth, @RequestParam("year")String year, @RequestParam("month")String month){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return service.getCheckThisCloseData(user.getLocale(), year, month);
	}
	
	@RequestMapping(value="/prodApplyCloseData",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> prodApplyCloseData(Authentication auth
			,@RequestParam(value="type",required=false) String type
			, @RequestParam(value="year",required=false) String year
			, @RequestParam(value="month",required=false) String month
			,@RequestParam(value="sort",required=false) String sortKey,@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.prodApplyCloseData(user.getLocale(), type, year, month, user.getUsername());
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}			
			table.put("total",resultList.size());			
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;		
	}
	@RequestMapping(value="/getCheckPreActDate",method=RequestMethod.GET)
	public @ResponseBody String getCheckPreActDate(Authentication auth, @RequestParam("stdDt") String stdDt){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return service.getCheckPreActDate(user.getLocale(), stdDt);
	}
	@RequestMapping(value="/getCurrentStock",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getCurrentStock(Authentication auth
			,@RequestParam(value="stdDt",required=false) String stdDt
			,@RequestParam(value="sort",required=false) String sortKey
			,@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getCurrentStock(user.getLocale(), stdDt);
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}			
			table.put("total",resultList.size());			
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;		
	}	
	
	
	
}
