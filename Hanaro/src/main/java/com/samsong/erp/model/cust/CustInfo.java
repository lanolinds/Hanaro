package com.samsong.erp.model.cust;

import java.util.List;
import java.util.Map;

public class CustInfo {
	
	private String custType;//업체구분
	private String custCd;
	private String custNm;
	private String custNo;//사업자번호
	private String chief;//대표자
	private String mobileChief;
	private String phoneOffice;
	private String phoneFax;
	private String address;
	private String homepage;//직위code
	private String email;
	private String stdDt;
	private String endDt;
	public String getCustType() {
		return custType;
	}
	public void setCustType(String custType) {
		this.custType = custType;
	}
	public String getCustCd() {
		return custCd;
	}
	public void setCustCd(String custCd) {
		this.custCd = custCd;
	}
	public String getCustNm() {
		return custNm;
	}
	public void setCustNm(String custNm) {
		this.custNm = custNm;
	}
	public String getCustNo() {
		return custNo;
	}
	public void setCustNo(String custNo) {
		this.custNo = custNo;
	}
	public String getChief() {
		return chief;
	}
	public void setChief(String chief) {
		this.chief = chief;
	}
	public String getMobileChief() {
		return mobileChief;
	}
	public void setMobileChief(String mobileChief) {
		this.mobileChief = mobileChief;
	}
	public String getPhoneOffice() {
		return phoneOffice;
	}
	public void setPhoneOffice(String phoneOffice) {
		this.phoneOffice = phoneOffice;
	}
	public String getPhoneFax() {
		return phoneFax;
	}
	public void setPhoneFax(String phoneFax) {
		this.phoneFax = phoneFax;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getHomepage() {
		return homepage;
	}
	public void setHomepage(String homepage) {
		this.homepage = homepage;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getStdDt() {
		return stdDt;
	}
	public void setStdDt(String stdDt) {
		this.stdDt = stdDt;
	}
	public String getEndDt() {
		return endDt;
	}
	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}
	
}
