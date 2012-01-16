package com.samsong.erp.service.product;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.product.ProductStockDAO;
import com.samsong.erp.model.product.StockInOutSheet;



@Service
public class ProductStockServiceImpl implements ProductStockService{
	
	@Autowired
	private ProductStockDAO dao;	
	private static Logger logger = Logger.getLogger(ProductStockServiceImpl.class);
	
	@Override
	public Map<String, Object> getComponentTypeOption(Locale locale, String type) {
		return dao.getComponentTypeOption(locale, type); 
	}

	@Override
	public Map<String, Object> getLineCode(Locale locale) {
		return dao.getLineCode(locale);
	}

	@Override
	public List<Map<String, Object>> getPartList(Locale locale, String type,String term) {
		return dao.getPartList(locale, type,term);
	}

	@Override
	public void prodIncomeOutgoList(Locale locale, String category,
			String pType, StockInOutSheet sheet, String user) {
		dao.prodIncomeOutgoList(locale, category, pType, sheet,  user);
		
	}

	@Override
	public List<Map<String, Object>> getIncomeOutgoList(Locale locale,
			String category, String stdDt, String endDt) {
		return dao.getIncomeOutgoList(locale, category, stdDt, endDt);
	}
	
	
}
