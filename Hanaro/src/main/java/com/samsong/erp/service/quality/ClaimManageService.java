package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;


public interface ClaimManageService {
	public List<Map<String,Object>> getClaimCode(String type,Locale locale);
	public void prodClaimManage(Locale locale,String prodType,String classType,String claimNo,String invoiceNo,String claimCost,String issueCust,String issueTeam,String cost,
			String partType,String rPartCode,String rPartName,String issueDate,String claimContent,String carType,
			String machineType,String workerCount,String issueTime,String failAmount,String inputBy,String p1,String p2,String p3,String p4,
			String p5,String p6,String p7,String p8,String lotNo,String file1Name,String file2Name,String file3Name,String file4Name,String file5Name,
			byte[] file1, byte[] file2,byte[] file3,byte[] file4,byte[] file5,String file1Type,String file2Type,String file3Type,String file4Type,String file5Type);
	public List<Map<String,Object>> getClaimRegList(Locale locale, String classType,String stdDt,String endDt,String partCode,String searchLocale);
	
	public List<Map<String,Object>> getClaimAgreeList(Locale locale,String selLocale,String regStdDt,String regEndDt,String regPartNo, String invoiceNo
			,String car, String model, String type, String inputBy, String deptCode, String state, String agreeStdDt, String agreeEndDt,String agreeBy);
	public List<Map<String,Object>> getClaimActionItem(Locale locale, String type, String q);
	public byte[] getClaimFile(String claimNo,String fileSeq);	

}