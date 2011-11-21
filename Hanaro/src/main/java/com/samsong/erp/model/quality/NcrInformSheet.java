package com.samsong.erp.model.quality;

import java.util.Arrays;

public class NcrInformSheet {
	String measureProcType;
	String ncrNo;
	String title;
	String custManager;
	String custConfirmer;
	String custAppover;
	
	
	String measureFileName;
	
	String reasonIssue;
	String reasonOutflow;
	
	String imgReason1FileName;
	String imgReason2FileName;
	String imgTempMeasureFileName;
	String imgMeasure1FileName;
	String imgMeasure2FileName;
	
	
	String[] reasonFileSeq;
	String[] reasonFileState;
	
	String[] tempMeasure;
	String[] tempMeasureDate;
	String[] measure;
	String[] measureDate;	
	String[] lotNo;
	String[] confirm;
	String[] remark;	
	String[] inputChangeState;
	
	
	String[] inputBeforChange;
	String[] inputAfterChange;
	String[] inputChangeDate;
	int[] inputStandardSeq;	
	String[] stanContents;
	
	String[] standardState;
	String[] standardEtcSeq;
	
	String sampleDate;
	String supplierDate;
	String insideIncomeDate;
	String applyProcDate;
	String applyCustDate;
	
	String status;
	int rejectCount;
	
	
	
	
	


	@Override
	public String toString() {
		return "NcrInformSheet [measureProcType=" + measureProcType
				+ ", ncrNo=" + ncrNo + ", title=" + title + ", custManager="
				+ custManager + ", custConfirmer=" + custConfirmer
				+ ", custAppover=" + custAppover + ", measureFileName="
				+ measureFileName + ", reasonIssue=" + reasonIssue
				+ ", reasonOutflow=" + reasonOutflow + ", imgReason1FileName="
				+ imgReason1FileName + ", imgReason2FileName="
				+ imgReason2FileName + ", imgTempMeasureFileName="
				+ imgTempMeasureFileName + ", imgMeasure1FileName="
				+ imgMeasure1FileName + ", imgMeasure2FileName="
				+ imgMeasure2FileName + ", reasonFileSeq="
				+ Arrays.toString(reasonFileSeq) + ", reasonFileState="
				+ Arrays.toString(reasonFileState) + ", tempMeasure="
				+ Arrays.toString(tempMeasure) + ", tempMeasureDate="
				+ Arrays.toString(tempMeasureDate) + ", measure="
				+ Arrays.toString(measure) + ", measureDate="
				+ Arrays.toString(measureDate) + ", lotNo="
				+ Arrays.toString(lotNo) + ", confirm="
				+ Arrays.toString(confirm) + ", remark="
				+ Arrays.toString(remark) + ", inputChangeState="
				+ Arrays.toString(inputChangeState) + ", inputBeforChange="
				+ Arrays.toString(inputBeforChange) + ", inputAfterChange="
				+ Arrays.toString(inputAfterChange) + ", inputChangeDate="
				+ Arrays.toString(inputChangeDate) + ", inputStandardSeq="
				+ Arrays.toString(inputStandardSeq) + ", stanContents="
				+ Arrays.toString(stanContents) + ", standardState="
				+ Arrays.toString(standardState) + ", standardEtcSeq="
				+ Arrays.toString(standardEtcSeq) + ", sampleDate="
				+ sampleDate + ", supplierDate=" + supplierDate
				+ ", insideIncomeDate=" + insideIncomeDate + ", applyProcDate="
				+ applyProcDate + ", applyCustDate=" + applyCustDate
				+ ", status=" + status + ", rejectCount=" + rejectCount + "]";
	}





	public int getRejectCount() {
		return rejectCount;
	}





	public void setRejectCount(int rejectCount) {
		this.rejectCount = rejectCount;
	}





	public String[] getStandardState() {
		return standardState;
	}





	public void setStandardState(String[] standardState) {
		this.standardState = standardState;
	}





	public String[] getStandardEtcSeq() {
		return standardEtcSeq;
	}





	public void setStandardEtcSeq(String[] standardEtcSeq) {
		this.standardEtcSeq = standardEtcSeq;
	}





	public String[] getInputChangeState() {
		return inputChangeState;
	}





	public void setInputChangeState(String[] inputChangeState) {
		this.inputChangeState = inputChangeState;
	}





	public String[] getReasonFileState() {
		return reasonFileState;
	}





	public void setReasonFileState(String[] reasonFileState) {
		this.reasonFileState = reasonFileState;
	}





	public String[] getReasonFileSeq() {
		return reasonFileSeq;
	}





	public void setReasonFileSeq(String[] reasonFileSeq) {
		this.reasonFileSeq = reasonFileSeq;
	}





	public String getImgReason1FileName() {
		return imgReason1FileName;
	}





	public void setImgReason1FileName(String imgReason1FileName) {
		this.imgReason1FileName = imgReason1FileName;
	}





	public String getImgReason2FileName() {
		return imgReason2FileName;
	}





	public void setImgReason2FileName(String imgReason2FileName) {
		this.imgReason2FileName = imgReason2FileName;
	}





	public String getImgTempMeasureFileName() {
		return imgTempMeasureFileName;
	}





	public void setImgTempMeasureFileName(String imgTempMeasureFileName) {
		this.imgTempMeasureFileName = imgTempMeasureFileName;
	}





	public String getImgMeasure1FileName() {
		return imgMeasure1FileName;
	}





	public void setImgMeasure1FileName(String imgMeasure1FileName) {
		this.imgMeasure1FileName = imgMeasure1FileName;
	}





	public String getImgMeasure2FileName() {
		return imgMeasure2FileName;
	}





	public void setImgMeasure2FileName(String imgMeasure2FileName) {
		this.imgMeasure2FileName = imgMeasure2FileName;
	}





	public String getStatus() {
		return status;
	}





	public void setStatus(String status) {
		this.status = status;
	}





	public String getMeasureFileName() {
		return measureFileName;
	}





	public void setMeasureFileName(String measureFileName) {
		this.measureFileName = measureFileName;
	}





	public String getMeasureProcType() {
		return measureProcType;
	}





	public void setMeasureProcType(String measureProcType) {
		this.measureProcType = measureProcType;
	}





	public String[] getInputBeforChange() {
		return inputBeforChange;
	}


	public void setInputBeforChange(String[] inputBeforChange) {
		this.inputBeforChange = inputBeforChange;
	}


	public String getReasonIssue() {
		return reasonIssue;
	}


	public void setReasonIssue(String reasonIssue) {
		this.reasonIssue = reasonIssue;
	}


	public String getReasonOutflow() {
		return reasonOutflow;
	}


	public void setReasonOutflow(String reasonOutflow) {
		this.reasonOutflow = reasonOutflow;
	}




	public String[] getTempMeasure() {
		return tempMeasure;
	}


	public void setTempMeasure(String[] tempMeasure) {
		this.tempMeasure = tempMeasure;
	}


	public String[] getTempMeasureDate() {
		return tempMeasureDate;
	}


	public void setTempMeasureDate(String[] tempMeasureDate) {
		this.tempMeasureDate = tempMeasureDate;
	}


	public String[] getMeasure() {
		return measure;
	}


	public void setMeasure(String[] measure) {
		this.measure = measure;
	}


	public String[] getMeasureDate() {
		return measureDate;
	}


	public void setMeasureDate(String[] measureDate) {
		this.measureDate = measureDate;
	}


	public String[] getLotNo() {
		return lotNo;
	}


	public void setLotNo(String[] lotNo) {
		this.lotNo = lotNo;
	}


	public String[] getConfirm() {
		return confirm;
	}


	public void setConfirm(String[] confirm) {
		this.confirm = confirm;
	}


	public String[] getRemark() {
		return remark;
	}


	public void setRemark(String[] remark) {
		this.remark = remark;
	}


	public String getSampleDate() {
		return sampleDate;
	}


	public void setSampleDate(String sampleDate) {
		this.sampleDate = sampleDate;
	}


	public String getSupplierDate() {
		return supplierDate;
	}


	public void setSupplierDate(String supplierDate) {
		this.supplierDate = supplierDate;
	}


	public String getInsideIncomeDate() {
		return insideIncomeDate;
	}


	public void setInsideIncomeDate(String insideIncomeDate) {
		this.insideIncomeDate = insideIncomeDate;
	}


	public String getApplyProcDate() {
		return applyProcDate;
	}


	public void setApplyProcDate(String applyProcDate) {
		this.applyProcDate = applyProcDate;
	}


	public String getApplyCustDate() {
		return applyCustDate;
	}


	public void setApplyCustDate(String applyCustDate) {
		this.applyCustDate = applyCustDate;
	}

	
	
	public String getNcrNo() {
		return ncrNo;
	}
	public void setNcrNo(String ncrNo) {
		this.ncrNo = ncrNo;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCustManager() {
		return custManager;
	}
	public void setCustManager(String custManager) {
		this.custManager = custManager;
	}
	public String getCustConfirmer() {
		return custConfirmer;
	}
	public void setCustConfirmer(String custConfirmer) {
		this.custConfirmer = custConfirmer;
	}
	public String getCustAppover() {
		return custAppover;
	}
	public void setCustAppover(String custAppover) {
		this.custAppover = custAppover;
	}




	public int[] getInputStandardSeq() {
		return inputStandardSeq;
	}


	public void setInputStandardSeq(int[] inputStandardSeq) {
		this.inputStandardSeq = inputStandardSeq;
	}


	public String[] getInputAfterChange() {
		return inputAfterChange;
	}


	public void setInputAfterChange(String[] inputAfterChange) {
		this.inputAfterChange = inputAfterChange;
	}


	public String[] getInputChangeDate() {
		return inputChangeDate;
	}


	public void setInputChangeDate(String[] inputChangeDate) {
		this.inputChangeDate = inputChangeDate;
	}


	public String[] getStanContents() {
		return stanContents;
	}


	public void setStanContents(String[] stanContents) {
		this.stanContents = stanContents;
	}


}
