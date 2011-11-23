package com.samsong.erp.ctrl.basic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;

@Controller
@RequestMapping("/basicDivision/items/localPrice")
public class ItemLocalPriceController {
	
	private static Logger logger = Logger.getLogger(ItemLocalPriceController.class);
	
	@Autowired
	private ItemService service;
	
	@RequestMapping("/{item}")
	public String getItemLocalPartnerInfo(@PathVariable String item,Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
	
		Map<String,Object> itemInfo = service.getLocalItemInfo(item,user.getLocale());
		List<Map<String,Object>> partnerList = service.getLocalItemPricePerPartnerList(item,user.getLocale());
//		List<Map<String,Object>> partnerList =new ArrayList<Map<String,Object>>();
//		Map<String,Object> m = new HashMap<String,Object>();
//		m.put("code", "1223");
//		m.put("name", "1223");
//		m.put("price", "1223");
//		m.put("currency", "1223");
//		partnerList.add(m);
		model.addAttribute("item",itemInfo);
		model.addAttribute("partners",partnerList);
		return "basicDivision/items/localPrice";
	}
//	@RequestMapping("/gridCallback")
//	public @ResponseBody Map<String,Object> getLocalItemPricePerPartnerList(@RequestParam("page") int page,
//			@RequestParam("rows") int rows,
//			@RequestParam(value="sort",required=false) String sortKey,
//			@RequestParam(value="order",required=false) String order,
//			@RequestParam("item") String item,
//			@RequestParam("cate") String cate,
//			@RequestParam("localized") String localized,
//			Authentication auth){
//		Locale locale = ((HanaroUser)auth.getPrincipal()).getLocale();		
//		logger.info("dev의 설정 로케일:"+locale.toString());
//		Map<String,Object> json = new HashMap<String, Object>();
//		List<Map<String,Object>> list =service.getLocalizedItemList(locale, item, cate, localized);
//		if(sortKey!=null){
//			Collections.sort(list,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
//		}
//		
//		if(list!=null){
//			json.put("total",list.size());
//			int from = (page-1)*rows;
//			int to = from + rows;
//			to = list.size()<to?list.size():to;
//			json.put("rows", list.subList(from,to));
//		}
//		else{
//			json.put("total", Integer.valueOf(0));
//			json.put("rows", Integer.valueOf(0));
//		}
//		return json;
//	}
}
