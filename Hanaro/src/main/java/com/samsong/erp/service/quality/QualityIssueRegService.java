package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.samsong.erp.model.quality.QualityIssueRegSheet;

public interface QualityIssueRegService {
	public Map<String,Object> getCodeDefectSource(Locale locale,String parentCode);
	
	public List<Map<String,Object>> getOccurPartListForReg(Locale locale,String uid,String partType,String q);
	
	public Map<String,Object> getCodeDefect(Locale locale, int searchLevel,String code);
	
	public void procQualityIssueReg (String procType, Locale locale, QualityIssueRegSheet sheet, String user);
	
}
