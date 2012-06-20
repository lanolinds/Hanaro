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
	public List<Map<String, Object>> getEbomItemList(String type,
			String partCode, Locale locale, String car, String model) {
		return dao.getEbomItemList(type, partCode, locale, car, model);
	}


	@Override
	public List<Map<String, Object>> getEbom(String partNo, Locale locale) {
		return dao.getEbom(partNo, locale);
	}

	@Override
	public List<Map<String, Object>> getLocalPartList(Locale locale,
			String carType, String machineType, String partCode,
			String partType, String custCode, String supplier) {
		return dao.getLocalPartList(locale, carType, machineType, partCode, partType, custCode, supplier);
	}

	@Override
	public List<Map<String, Object>> getBasicOption(Locale locale, String type) {
		return dao.getBasicOption(locale, type);
	}


	@Override
	public List<Map<String, Object>> getCodeCommonOption(Locale locale,
			String codeDiv) {
		return dao.getCodeCommonOption(locale, codeDiv);
	}


	@Override
	public void prodLocalPartInfo(Locale locale, String prodType,
			String partType, String partNo, String classCd, String partName,
			String carType, String unit, String machineType, String pColor,
			String alcCode, String custCode, String prodCost,
			String prodCostType, String supplier, String supplyCost,
			String supplyCostType, String assyCust, String lineCode,
			String assyCost, String assyCostType, String pQuality,
			String pWeight, String boxQty, String pkgQty, String vesselName,
			String saftyDay, String remark, String user) {
		dao.prodLocalPartInfo(locale, prodType, partType, partNo, classCd, partName, carType, 
				unit, machineType, pColor, alcCode, custCode, prodCost, prodCostType, supplier,
				supplyCost, supplyCostType, assyCust, lineCode, assyCost, assyCostType, pQuality,
				pWeight, boxQty, pkgQty, vesselName, saftyDay, remark, user);
	}


	@Override
	public List<Map<String, Object>> getPartMasterInfo(Locale locale,
			String partNo) {
		return dao.getPartMasterInfo(locale, partNo);
	}


	@Override
	public List<Map<String, Object>> getLineCode(Locale locale, String custCode) {
		return dao.getLineCode(locale, custCode);
	}



	
}
