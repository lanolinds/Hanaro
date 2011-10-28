package com.samsong.erp.service.quality;


import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.samsong.erp.dao.quality.QualityIssueDAO;
import com.samsong.erp.model.quality.QualityIssueRegSheet;

@Service
public class QualityIssueServiceImpl implements QualityIssueService {

	@Autowired
	private QualityIssueDAO dao;
	
	public Map<String,Object>  getCodeDefectSource(Locale locale, String parentCode) {		
		return dao.getCodeDefectSource(locale, parentCode);
	}

	public List<Map<String, Object>> getOccurPartListForReg(Locale locale,
			String uid, String partType, String q) {		 
		return dao.getOccurPartListForReg(locale, uid, partType, q);
	}

	@Override
	public Map<String, Object> getCodeDefect(Locale locale, int searchLevel,
			String code) {
		return dao.getCodeDefect(locale, searchLevel, code);
	}

	@Override
	public void procQualityIssueReg(String procType, Locale locale, QualityIssueRegSheet sheet, String user) { 
		dao.procQualityIssueReg(procType, locale, sheet, user);
	}

	@Override
	public List<Map<String, Object>> getAssistItemList(Locale locale,String status) {
		return dao.getAssistItemList(locale,status);
	}

	@Override
	public List<Map<String, Object>> getUndoneIssueList(Date fromDate,
			Date toDate, String item, Locale locale) {
		return dao.getUndoneIssueList(fromDate,toDate,item,locale);
	}

	@Override
	public List<Map<String, Object>> getQualityIssueRegList(Locale locale, String division, String occurSite, String stdDt, String endDt) {
			return dao.getQualityIssueRegList(locale, division, occurSite, stdDt, endDt);
	}


}
