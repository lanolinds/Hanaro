package com.samsong.erp.ctrl.basic;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/basicDivision/items/itemLocalization")
public class ItemLocalizationController {
	
	private static Logger logger = Logger.getLogger(ItemLocalizationController.class);
	
	@Autowired
	private ItemService service;
	
	@RequestMapping(value="",method=RequestMethod.GET)
	public String totalItemList(){
		return "basicDivision/items/itemLocalization";
	}
	
	@RequestMapping(value="/updateLocalItem",method=RequestMethod.POST)
	public String updateLocalItem(@RequestParam("itemNo") String item,
			@RequestParam("type") String type,
			@RequestParam("price") String price,
			@RequestParam("currency") String currency,
			@RequestParam("enabled") String enabled,
			Authentication auth){
		
		double p = Double.parseDouble(price);
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		service.updateLocalItem(item,type,p,currency,enabled,user.getLocale());
		logger.info("사용자:"+user.getUsername()+"(이)가 지역화 품번을 다음과 같이 수정하였습니다.item:"+item+",price:"+price+",currency:"+currency+",enabled:"+enabled);
		return "redirect:/basicDivision/items/itemLocalization";
	}
	
	@RequestMapping(value="/gridCallback",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getLocalizedItemList(@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order,
			@RequestParam("item") String item,
			@RequestParam("cate") String cate,
			@RequestParam("localized") String localized,
			Authentication auth){
		Locale locale = ((HanaroUser)auth.getPrincipal()).getLocale();		
		Map<String,Object> json = new HashMap<String, Object>();
		List<Map<String,Object>> list =service.getLocalizedItemList(locale, item, cate, localized);
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
}
