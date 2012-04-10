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
	

}
