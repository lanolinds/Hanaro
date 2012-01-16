package com.samsong.erp.service.product;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.product.ProductStockDAO;



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
	
	
}
