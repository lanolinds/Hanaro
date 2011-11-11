package com.samsong.erp.service.quality;


import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.dao.quality.QualityIssueDAO;
import com.samsong.erp.model.quality.NcrInformSheet;
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
	public void procQualityIssueReg(String procType, Locale locale, QualityIssueRegSheet sheet, String user, byte[] files1, byte[] files2) { 
		dao.procQualityIssueReg(procType, locale, sheet, user, files1, files2);
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

	@Override
	public byte[] getQualityIssueFile(Locale locale, String regNo,
			String fileSeq) {
		return dao.getQualityIssueFile(locale, regNo, fileSeq);
	}

	@Override
	public Map<String, Object> getIssueDetails(String regNo, Locale locale) {
		return dao.getIssueDetails(regNo,locale);
	}

	@Override
	public List<Map<String, Object>> getDefectTreeData(Locale locale) {
		return dao.getDefectTreeData(locale);
	}

	@Override
	public void addNcrMeasure(Locale locale, String user, NcrInformSheet sheet,
			byte[] measureFile,  byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1, byte[] imgMeasure2,
			MultipartFile[] inputAddFile, MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType) {
		dao.addNcrMeasure(locale, sheet, user, measureFile, imgReason1, imgReason2, imgTempMeasure,
				imgMeasure1, imgMeasure2,inputAddFile, inputChangeFile, stanFile
				,imgReasonFile1ContentType,  imgReasonFile2ContentType, imgTempNameFileContentType,
				imgMeasureName1FileContentType, imgMeasureName2FileContentType);
		
	}

	@Override
	public void deleteNcrMeasure(Locale locale, NcrInformSheet sheet) {
		dao.deleteNcrMeasure(locale, sheet);
	}

	@Override
	public void updateNcrMeasure(Locale locale, String user,
			NcrInformSheet sheet, byte[] measureFile, byte[] imgReason1,
			byte[] imgReason2, byte[] imgTempMeasure, byte[] imgMeasure1,
			byte[] imgMeasure2, MultipartFile[] inputAddFile,
			MultipartFile[] inputChangeFile, MultipartFile[] stanFile
			,String imgReasonFile1ContentType,  String imgReasonFile2ContentType, String imgTempNameFileContentType,
			String imgMeasureName1FileContentType, String imgMeasureName2FileContentType) {
			dao.updateNcrMeasure(locale, sheet, user, measureFile, imgReason1, imgReason2,
					imgTempMeasure, imgMeasure1, imgMeasure2, inputAddFile, inputChangeFile, stanFile
					,imgReasonFile1ContentType,  imgReasonFile2ContentType, imgTempNameFileContentType,
					imgMeasureName1FileContentType, imgMeasureName2FileContentType);
		
	}

	@Override
	public List<Map<String, Object>> getNcrMeasureDataGrid(Locale locale,
			String ncrNo, String gridType) {
			return dao.getNcrMeasureDataGrid(locale, ncrNo, gridType);
	}

	@Override
	public List<Map<String, Object>> getNcrDetail(Locale locale, String ncrNo) {
			return dao.getNcrDetail(locale, ncrNo);
	}

	@Override
	public byte[] getNcrMeasureFile(Locale locale, String ncrNo) {
			return dao.getNcrMeasureFile(locale, ncrNo);
	}

	@Override
	public byte[] getNcrMeasureReasonFile(Locale locale, String ncrNo,
			String fileSeq) {
			return dao.getNcrMeasureReasonFile(locale, ncrNo, fileSeq);
	}

	@Override
	public byte[] getNcrMeasureStandardFile(Locale locale, String ncrNo,
			String fileSeq) {
			return dao.getNcrMeasureStandardFile(locale, ncrNo, fileSeq);
	}

	@Override
	public List<Map<String,Object>> getNcrMeasureImg(Locale locale, String ncrNo, String fileSeq) {
			return dao.getNcrMeasureImg(locale, ncrNo, fileSeq);
	}

}
