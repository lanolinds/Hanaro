package com.samsong.erp.model.quality;

import java.util.Arrays;

public class NcrInformSheet {
	String ncrNo;
	String title;
	String custManager;
	String custConfirmer;
	String custAppover;	
	String reasonIssue;
	String reasonOutflow;
	String[] tempMeasure;
	String[] tempMeasureDate;
	String[] measure;
	String[] measureDate;	
	String[] lotNo;
	String[] confirm;
	String[] remark;	
	
	String[] inputBeforChange;
	int[] inputStandardSeq;
	String[] inputAfterChange;
	String[] inputChangeDate;
	
	String[] stanContents;
	
	
	
	String sampleDate;
	String supplierDate;
	String insideIncomeDate;
	String applyProcDate;
	String applyCustDate;		
	
	
	






	@Override
	public String toString() {
		return "NcrInformSheet [ncrNo=" + ncrNo + ", title=" + title
				+ ", custManager=" + custManager + ", custConfirmer="
				+ custConfirmer + ", custAppover=" + custAppover
				+ ", reasonIssue=" + reasonIssue + ", reasonOutflow="
				+ reasonOutflow + ", tempMeasure="
				+ Arrays.toString(tempMeasure) + ", tempMeasureDate="
				+ Arrays.toString(tempMeasureDate) + ", measure="
				+ Arrays.toString(measure) + ", measureDate="
				+ Arrays.toString(measureDate) + ", lotNo="
				+ Arrays.toString(lotNo) + ", confirm="
				+ Arrays.toString(confirm) + ", remark="
				+ Arrays.toString(remark) + ", inputBeforChange="
				+ Arrays.toString(inputBeforChange) + ", inputStandardSeq="
				+ Arrays.toString(inputStandardSeq) + ", inputAfterChange="
				+ Arrays.toString(inputAfterChange) + ", inputChangeDate="
				+ Arrays.toString(inputChangeDate) + ", stanContents="
				+ Arrays.toString(stanContents) + ", sampleDate=" + sampleDate
				+ ", supplierDate=" + supplierDate + ", insideIncomeDate="
				+ insideIncomeDate + ", applyProcDate=" + applyProcDate
				+ ", applyCustDate=" + applyCustDate + "]";
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
