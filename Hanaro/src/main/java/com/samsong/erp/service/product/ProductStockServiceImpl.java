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
	ProductStockDAO dao;	
	private static Logger logger = Logger.getLogger(ProductStockServiceImpl.class);
	
	@Override
	public Map<String, Object> getComponentTypeOption(Locale locale, String type) {
		return dao.getComponentTypeOption(locale, type); 
	}

	@Override
	public List<Map<String, Object>> getPartList(Locale locale, String type,String term) {
		return dao.getPartList(locale, type,term);
	}

	@Override
	public void prodIncomeOutgoList(Locale locale, String category,
			String[] DATA0, String[] DATA1, String[] DATA2, String[] DATA3,
			String[] DATA4, String[] DATA5, String[] DATA6, String[] DATA7,
			String[] DATA8, String[] DATA9, String[] DATA10, String[] DATA11,
			String[] DATA12, String user) {
		dao.prodIncomeOutgoList(locale, category, DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7, DATA8, DATA9, DATA10, DATA11, DATA12, user);
		
	}

	@Override
	public List<Map<String, Object>> getIncomeOutgoList(Locale locale,
			String category, String stdDt, String endDt) {
		return dao.getIncomeOutgoList(locale, category, stdDt, endDt);
	}

	@Override
	public List<Map<String, Object>> getIncomeOutgoState(Locale locale,
			String partCode, String stdDt, String endDt, String inoutYn,
			String fromToYn) {
		return dao.getIncomeOutgoState(locale, partCode, stdDt, endDt, inoutYn, fromToYn);
	}



	@Override
	public List<Map<String, Object>> getSubOptionByInoutComponent(
			Locale locale, String code) {
		return dao.getSubOptionByInoutComponent(locale, code);
	}


	
	
}
