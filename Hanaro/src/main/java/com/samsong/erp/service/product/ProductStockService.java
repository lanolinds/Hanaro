package com.samsong.erp.service.product;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.samsong.erp.model.product.StockInOutSheet;

public interface ProductStockService {
	public Map<String,Object> getComponentTypeOption(Locale locale,String type);	
	public List<Map<String,Object>> getPartList(Locale locale, String type,String term);	
	public void prodIncomeOutgoList(Locale locale, String category
			,String[] DATA0,String[] DATA1,String[] DATA2,String[] DATA3,String[] DATA4
			,String[] DATA5,String[] DATA6,String[] DATA7,String[] DATA8,String[] DATA9
			,String[] DATA10,String[] DATA11,String[] DATA12,String user);
	
	public List<Map<String,Object>> getIncomeOutgoList(Locale locale, String category, String stdDt, String endDt);
	public List<Map<String,Object>> getIncomeOutgoState(Locale locale,String partCode,String stdDt,String endDt,String inoutYn,String fromToYn);	
	public List<Map<String,Object>> getSubOptionByInoutComponent(Locale locale, String code);	
	public List<Map<String,Object>> getComponentHead(Locale locale,String type);
	public String getCheckPreCloseData(Locale locale,String year,String month);
	public String getCheckThisCloseData(Locale locale,String year,String month);
	
	public List<Map<String,Object>> prodApplyCloseData(Locale locale,String type, String year, String month, String user);
	
	public void prodApplyActualData(final Locale locale,final String[] stdDt,final String[] partCode,final String[] amount, final String user);	
}
