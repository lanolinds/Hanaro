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


	@Override
	public List<Map<String, Object>> getLineProcConfiguration(Locale locale,
			String custCode, String lineCode) {
		return dao.getLineProcConfiguration(locale, custCode, lineCode);
	}


	@Override
	public String getCheckUnique(Locale locale, String checkItem,
			String checkKey, String checkKey2) {
		return dao.getCheckUnique(locale, checkItem, checkKey, checkKey2);
	}


	@Override
	public void updateLineProcConfiguration(Locale locale, String procCate,
			String procType, String custCode, String lineCode, String procCode,
			String procSeq, String useYn, String user) {
		dao.updateLineProcConfiguration(locale, procCate, procType, custCode, lineCode, procCode, procSeq, useYn, user);
		
	}


	@Override
	public List<Map<String, Object>> getProcOption(Locale locale) {
		return dao.getProcOption(locale);
	}
	
}
