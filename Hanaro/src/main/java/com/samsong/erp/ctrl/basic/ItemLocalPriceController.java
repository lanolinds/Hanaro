package com.samsong.erp.ctrl.basic;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;
import com.samsong.erp.service.cust.CustManagementService;

@Controller
@RequestMapping("/basicDivision/items/localPrice")
public class ItemLocalPriceController {
	
	private static Logger logger = Logger.getLogger(ItemLocalPriceController.class);
	
	@Autowired
	private ItemService service;
	@Autowired
	private CustManagementService partnerService;
	
	@RequestMapping("/{item}")
	public String getItemLocalPartnerInfo(@PathVariable("item") String item,Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		logger.debug("아이템:"+item);
		Map<String,Object> itemInfo = service.getLocalItemInfo(item,user.getLocale());
		List<Map<String,Object>> partnerList = service.getLocalItemPricePerPartnerList(item,user.getLocale());
		List<Map<String,Object>> options = partnerService.getCustOption(user.getLocale(), "qisall", "");
		model.addAttribute("item",itemInfo);
		model.addAttribute("partners",partnerList);
		model.addAttribute("options",options);
		return "basicDivision/items/localPrice";
	}
	
	@RequestMapping("/updatePrice")
	public String updatePrice(@RequestParam("item") String item,
			@RequestParam("action") String action,
			@RequestParam("partners") String partner,
			@RequestParam("price") Double price,
			@RequestParam("currency") String currency,
			@RequestParam("enabled") String enabled,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		
		logger.debug("action:"+action);
		logger.debug("parter:"+partner);
		logger.debug("item:"+item);
		
		service.updateLocalItemPrice(action,item,partner,price.doubleValue(),currency,enabled,user.getUsername(),user.getLocale());
		
		
		return "redirect:/basicDivision/items/localPrice/"+item;
	}
}
