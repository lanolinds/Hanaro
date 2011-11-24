package com.samsong.erp.service.basic;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.basic.ItemDAO;

@Service
public class ItemServiceImpl implements ItemService {

	@Autowired
	private ItemDAO dao;
	

	@Override
	public List<Map<String, Object>> getLocalizedItemList(Locale locale,
			String item, String cate, String localized) {
		return dao.getLocalizedItemList(locale,item,cate,localized);
	}


	@Override
	public void updateLocalItem(String item, String type, double p,
			String currency, String enabled, Locale locale) {
		dao.updateLocalItem(item,type,p,currency,enabled,locale);
		
	}


	@Override
	public Map<String, Object> getLocalItemInfo(String item, Locale locale) {
		return dao.getLocalItemInfo(item,locale);
	}


	@Override
	public List<Map<String, Object>> getLocalItemPricePerPartnerList(
			String item, Locale locale) {
		return dao.getLocalItemPricePerPartnerList(item,locale);
	}


	@Override
	public void updateLocalItemPrice(String action, String item,
			String partner, double price, String currency,
			String enabled, String username, Locale locale) {
		dao.updateLocalItemPrice(action,item,partner,price,currency,enabled,username,locale);
		
	}
	
}
