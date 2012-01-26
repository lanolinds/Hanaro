package com.samsong.erp.service.material;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.material.MaterialStockDAO;

@Service
public class MaterialStockServiceImpl implements MaterialStockService{
	
	@Autowired
	MaterialStockDAO dao;	
	private static Logger logger = Logger.getLogger(MaterialStockServiceImpl.class);
	
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

	@Override
	public List<Map<String, Object>> getComponentHead(Locale locale, String type) {
		return dao.getComponentHead(locale, type);
	}

	@Override
	public String getCheckPreCloseData(Locale locale, String year, String month) {
		return dao.getCheckPreCloseData(locale, year, month);
	}

	@Override
	public String getCheckThisCloseData(Locale locale, String year, String month) {
		return dao.getCheckThisCloseData(locale, year, month);
	}

	@Override
	public List<Map<String, Object>> prodApplyCloseData(Locale locale,
			String type, String year, String month, String user) {
		return dao.prodApplyCloseData(locale, type, year, month, user);
	}

	@Override
	public void prodApplyActualData(Locale locale, String[] stdDt,
			String[] partCode, String[] amount, String user) {
		dao.prodApplyActualData(locale, stdDt, partCode, amount, user);
		
	}

	@Override
	public String getCheckPreActDate(Locale locale, String stdDt) {
		return dao.getCheckPreActDate(locale, stdDt);
	}

	@Override
	public List<Map<String, Object>> getCurrentStock(Locale locale, String stdDt) {
		return dao.getCurrentStock(locale, stdDt);
	}
}
