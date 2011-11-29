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
	
	//라인구성정보를 가져온다.
	public List<Map<String,Object>> getLineProcConfiguration(Locale locale,String custCode,String lineCode);
	
	//라인, 공정의 기존의 등록된 데이터를 확인한다.
	public String getCheckUnique(Locale locale, String checkItem, String checkKey, String checkKey2);
	
	//라인구성정보를 저장 수정한다.
	public void updateLineProcConfiguration(Locale locale,String procCate,String procType,String custCode,
			String lineCode,String procCode, String procSeq, String useYn, String user);
	
	//지역코드에 의한 사용가능한 공정코드를 가져온다.
	public List<Map<String,Object>> getProcOption(Locale locale);
}
