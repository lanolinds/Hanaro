package com.samsong.erp.service.basic;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.basic.LineDAO;
@Service
public class LineServiceImpl implements LineService{
	
	@Autowired
	LineDAO dao;
	
	@Override
	public List<Map<String, Object>> getLineProcConfiguration(Locale locale,
			String custCode, String lineCode) {
		return dao.getLineProcConfiguration(locale, custCode, lineCode);
	}


	@Override
	public String getCheckUnique(Locale locale, String checkItem,
			String checkKey, String checkKey2) {
		return dao.getCheckUnique(locale, checkItem, checkKey, checkKey2);
	}


	@Override
	public void updateLineProcConfiguration(Locale locale, String procCate,
			String procType, String custCode, String lineCode, String procCode,
			String procSeq, String useYn, String user) {
		dao.updateLineProcConfiguration(locale, procCate, procType, custCode, lineCode, procCode, procSeq, useYn, user);
		
	}


	@Override
	public List<Map<String, Object>> getProcOption(Locale locale) {
		return dao.getProcOption(locale);
	}


	@Override
	public List<Map<String, Object>> getProcessMasterList(Locale locale) {
		return dao.getProcessMasterList(locale);
	}


	@Override
	public void updateProcessMaster(Locale locale, String procType,
			String procCode, String procName, String procRemark, String useYn,
			String user) {
		dao.updateProcessMaster(locale, procType, procCode, procName, procRemark, useYn, user);
	}
}
