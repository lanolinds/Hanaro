package com.samsong.erp.model.quality;

import java.util.List;
import java.util.Map;

public class IssueApproval {
	
	private String approvalNo;
	private String causePartner;
	private String defect1;
	private String defect2;
	private String defect3;
	private String remark;
	private String adHocs;
	private String method;
	private int workCost;
	private int testCost;
	private String shipType;
	private double claim;
	
	public double getClaim() {
		return claim;
	}
	public void setClaim(double claim) {
		this.claim = claim;
	}

	public String getApprovalNo() {
		return approvalNo;
	}
	public void setApprovalNo(String approvalNo) {
		this.approvalNo = approvalNo;
	}
	public String getDefect1() {
		return defect1;
	}
	public void setDefect1(String defect1) {
		this.defect1 = defect1;
	}
	public String getDefect2() {
		return defect2;
	}
	public void setDefect2(String defect2) {
		this.defect2 = defect2;
	}
	public String getDefect3() {
		return defect3;
	}
	public void setDefect3(String defect3) {
		this.defect3 = defect3;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getAdHocs() {
		return adHocs;
	}
	public void setAdHocs(String adHocs) {
		this.adHocs = adHocs;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public int getWorkCost() {
		return workCost;
	}
	public void setWorkCost(int workCost) {
		this.workCost = workCost;
	}
	public int getTestCost() {
		return testCost;
	}
	public void setTestCost(int testCost) {
		this.testCost = testCost;
	}
	public String getShipType() {
		return shipType;
	}
	public void setShipType(String shipType) {
		this.shipType = shipType;
	}

	public String getCausePartner() {
		return causePartner;
	}
	public void setCausePartner(String causePartner) {
		this.causePartner = causePartner;
	}
	@Override
	public String toString() {
		return "IssueApproval [approvalNo=" + approvalNo + ", causePartner="
				+ causePartner + ", defect1=" + defect1 + ", defect2="
				+ defect2 + ", defect3=" + defect3 + ", remark=" + remark
				+ ", adHocs=" + adHocs + ", method=" + method + ", workCost="
				+ workCost + ", testCost=" + testCost + ", shipType="
				+ shipType + ", claim=" + claim + "]";
	}
	
}
