package com.samsong.erp.model.quality;

public class NcrInformSheet {
	String ncrNo;
	String title;
	String custManager;
	String custConfirmer;
	String custAppover;
	String measureReportName;
	String measureReplyDate;
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
				+ ", measureReportName=" + measureReportName
				+ ", measureReplyDate=" + measureReplyDate + ", sampleDate="
				+ sampleDate + ", supplierDate=" + supplierDate
				+ ", insideIncomeDate=" + insideIncomeDate + ", applyProcDate="
				+ applyProcDate + ", applyCustDate=" + applyCustDate + "]";
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
	public String getMeasureReportName() {
		return measureReportName;
	}
	public void setMeasureReportName(String measureReportName) {
		this.measureReportName = measureReportName;
	}
	public String getMeasureReplyDate() {
		return measureReplyDate;
	}
	public void setMeasureReplyDate(String measureReplyDate) {
		this.measureReplyDate = measureReplyDate;
	}
	
	
	
}
