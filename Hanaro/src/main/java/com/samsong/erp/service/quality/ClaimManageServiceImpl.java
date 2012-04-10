package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.quality.ClaimManageDAO;

@Service
public class ClaimManageServiceImpl implements ClaimManageService {

	@Autowired
	private ClaimManageDAO dao;
	
	private static final Logger logger  = Logger.getLogger(ClaimManageServiceImpl.class);
	
	@Override
	public List<Map<String, Object>> getClaimCode(String type, Locale locale) {
		return dao.getClaimCode(type, locale);
	}

	@Override
	public void prodClaimManage(Locale locale, String prodType,
			String classType, String claimNo, String invoiceNo,
			String claimCost, String issueCust, String issueTeam, String cost,
			String partType, String rPartCode, String rPartName,
			String issueDate, String claimContent, String carType,
			String machineType, String workerCount, String issueTime,
			String inputBy, String p1, String p2, String p3, String p4,
			String p5, String p6, String p7) {
		dao.prodClaimManage(locale, prodType, classType, claimNo, invoiceNo, claimCost, issueCust, issueTeam, cost, partType, rPartCode, rPartName, issueDate, claimContent, carType, machineType, workerCount, issueTime, inputBy, p1, p2, p3, p4, p5, p6, p7);
		
	}

	@Override
	public List<Map<String, Object>> getClaimRegList(Locale locale,
			String classType, String stdDt, String endDt, String partCode) {
		return dao.getClaimRegList(locale, classType, stdDt, endDt, partCode);
	}
	


}
