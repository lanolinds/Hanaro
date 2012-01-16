package com.samsong.erp.service.product;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.samsong.erp.model.product.StockInOutSheet;

public interface ProductStockService {
	public Map<String,Object> getComponentTypeOption(Locale locale,String type);
	public Map<String,Object> getLineCode(Locale locale);
	public List<Map<String,Object>> getPartList(Locale locale, String type,String term);
	public void prodIncomeOutgoList(Locale locale, String category, String pType, StockInOutSheet sheet,  String user);
	public List<Map<String,Object>> getIncomeOutgoList(Locale locale, String category, String stdDt, String endDt);	
}
