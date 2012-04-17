package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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
	public void prodClaimManage(Locale locale,String prodType,String classType,String claimNo,String invoiceNo,String claimCost,String issueCust,String issueTeam,String cost,
			String partType,String rPartCode,String rPartName,String issueDate,String claimContent,String carType,
			String machineType,String workerCount,String issueTime,String failAmount,String inputBy,String p1,String p2,String p3,String p4,
			String p5,String p6,String p7,String p8,String lotNo,String file1Name,String file2Name,String file3Name,String file4Name,String file5Name,
			byte[] file1, byte[] file2,byte[] file3,byte[] file4,byte[] file5,String file1Type,String file2Type,String file3Type,String file4Type,String file5Type){
		dao.prodClaimManage(locale, prodType, classType, claimNo, invoiceNo, claimCost, issueCust, issueTeam, cost, partType, rPartCode, rPartName, issueDate, claimContent, carType, machineType, workerCount, issueTime,failAmount, inputBy, p1, p2, p3, p4, p5, p6, p7,p8,lotNo,file1Name,file2Name,file3Name,file4Name,file5Name,
				file1,file2,file3,file4,file5,file1Type,file2Type,file3Type,file4Type,file5Type);
		
	}

	@Override
	public List<Map<String, Object>> getClaimRegList(Locale locale,
			String classType, String stdDt, String endDt, String partCode,String searchLocale) {
		return dao.getClaimRegList(locale, classType, stdDt, endDt, partCode,searchLocale);
	}

	@Override
	public List<Map<String, Object>> getClaimAgreeList(Locale locale,String selLocale,
			String regStdDt, String regEndDt, String regPartNo,
			String invoiceNo, String car, String model, String type,
			String inputBy, String deptCode, String state, String agreeStdDt,
			String agreeEndDt, String agreeBy) {
		return dao.getClaimAgreeList(locale,selLocale, regStdDt, regEndDt, regPartNo, invoiceNo, car, model, type, inputBy, deptCode, state, agreeStdDt, agreeEndDt, agreeBy);
	}

	@Override
	public List<Map<String, Object>> getClaimActionItem(Locale locale,
			String type, String q) {
		return dao.getClaimActionItem(locale, type, q);
	}

	@Override
	public byte[] getClaimFile(String claimNo, String fileSeq) {
		return dao.getClaimFile(claimNo, fileSeq);
	}
	


}
