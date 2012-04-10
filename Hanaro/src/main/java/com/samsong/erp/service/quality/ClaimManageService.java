package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;


public interface ClaimManageService {
	public List<Map<String,Object>> getClaimCode(String type,Locale locale);
	public void prodClaimManage(Locale locale,String prodType,String classType,String claimNo,String invoiceNo,String claimCost,String issueCust,String issueTeam,String cost,
			String partType,String rPartCode,String rPartName,String issueDate,String claimContent,String carType,
			String machineType,String workerCount,String issueTime,String inputBy,String p1,String p2,String p3,String p4,
			String p5,String p6,String p7);
	public List<Map<String,Object>> getClaimRegList(Locale locale, String classType,String stdDt,String endDt,String partCode);	

}
