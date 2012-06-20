package com.samsong.erp.service.basic;

import java.util.List;
import java.util.Locale;
import java.util.Map;

public interface ItemService {
	public List<Map<String,Object>> getLocalizedItemList(Locale locale, String item, String cate, String localized);

	public void updateLocalItem(String item, String type, double p,
			String currency, String enabled,Locale locale);

	public Map<String, Object> getLocalItemInfo(String item, Locale locale);

	public List<Map<String, Object>> getLocalItemPricePerPartnerList(
			String item, Locale locale);

	public void updateLocalItemPrice(String action, String item,
			String partner, double doubleValue, String currency,
			String enabled, String username, Locale locale);
	public List<Map<String,Object>> getEbomItemList(String type,String partCode,Locale locale,
			String car,String model);
	public List<Map<String,Object>> getEbom(String partNo,Locale locale);
	
	public List<Map<String,Object>> getLocalPartList(Locale locale, String carType,String machineType,String partCode, String partType, String custCode, String supplier);
	
	public List<Map<String,Object>> getBasicOption(Locale locale, String type);
	
	public List<Map<String,Object>> getCodeCommonOption(Locale locale, String codeDiv);
	public void prodLocalPartInfo(Locale locale, String prodType, String partType, String partNo,String classCd
			,String partName, String carType, String unit, String machineType, String pColor,String alcCode, String custCode
			,String prodCost,String prodCostType, String supplier,String supplyCost, String supplyCostType,String assyCust
			,String lineCode, String assyCost,String assyCostType, String pQuality,String pWeight,String boxQty,String pkgQty
			,String vesselName,String saftyDay,String remark,String user);
	public List<Map<String,Object>> getPartMasterInfo(Locale locale, String partNo);
	
	public List<Map<String,Object>> getLineCode(Locale locale,String custCode);	
}
