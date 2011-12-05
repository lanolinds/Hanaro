package com.samsong.erp.service.basic;

import java.util.List;
import java.util.Locale;
import java.util.Map;


public interface LineService {
	//라인구성정보를 가져온다.
	public List<Map<String,Object>> getLineProcConfiguration(Locale locale,String custCode,String lineCode);
	
	//라인, 공정의 기존의 등록된 데이터를 확인한다.
	public String getCheckUnique(Locale locale, String checkItem, String checkKey, String checkKey2);
	
	//라인구성정보를 저장 수정한다.
	public void updateLineProcConfiguration(Locale locale,String procCate,String procType,String custCode,
			String lineCode,String procCode, String procSeq, String useYn, String user);
	
	//지역코드에 의한 사용가능한 공정코드를 가져온다.
	public List<Map<String,Object>> getProcOption(Locale locale);
	
	//등록된 공정코드정보를 가져온다.
	public List<Map<String,Object>> getProcessMasterList(Locale locale);
	
	//공정코드를 등록,수정한다.
	public void updateProcessMaster(Locale locale,String procType, String procCode,String procName,String procRemark,String useYn,String user);
}
