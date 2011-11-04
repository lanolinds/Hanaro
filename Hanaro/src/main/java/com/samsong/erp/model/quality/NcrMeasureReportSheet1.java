package com.samsong.erp.model.quality;

public class NcrMeasureReportSheet1 {
	String ncrNo;
	String reasonIssue;
	String reasonOutflow;
	String img1Name;
	String img2Name;
	
	
	
	
	
	
	@Override
	public String toString() {
		return "NcrMeasureReportSheet1 [ncrNo=" + ncrNo + ", reasonIssue="
				+ reasonIssue + ", reasonOutflow=" + reasonOutflow
				+ ", img1Name=" + img1Name + ", img2Name=" + img2Name + "]";
	}
	public String getNcrNo() {
		return ncrNo;
	}
	public void setNcrNo(String ncrNo) {
		this.ncrNo = ncrNo;
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
	public String getImg1Name() {
		return img1Name;
	}
	public void setImg1Name(String img1Name) {
		this.img1Name = img1Name;
	}
	public String getImg2Name() {
		return img2Name;
	}
	public void setImg2Name(String img2Name) {
		this.img2Name = img2Name;
	}
	
	
}
