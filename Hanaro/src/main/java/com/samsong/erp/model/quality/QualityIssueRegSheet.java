package com.samsong.erp.model.quality;

public class QualityIssueRegSheet {
	
	private String regNo;
	private 	String division;
	private String occurSite;
	private String occurDate;
	private String occurAmPm;
	private int occurHour;
	private String occurPartNo;
	private String car;
	private String model;
	private String partSupplier;
	private String occurPlace;
	private String occurLine;
	private String occurProc;
	private String lotNo;
	private String defectL;
	private String defectM;
	private String defectS;
	private int defectAmount = 1;
	private String explanation;

	private String state;
	private String file1;
	private String file2;
	
	
	
	
	@Override
	public String toString() {
		return "QualityIssueRegSheet [regNo=" + regNo + ", division="
				+ division + ", occurSite=" + occurSite + ", occurDate="
				+ occurDate + ", occurAmPm=" + occurAmPm + ", occurHour="
				+ occurHour + ", occurPartNo=" + occurPartNo + ", car=" + car
				+ ", model=" + model + ", partSupplier=" + partSupplier
				+ ", occurPlace=" + occurPlace + ", occurLine=" + occurLine
				+ ", occurProc=" + occurProc + ", lotNo=" + lotNo
				+ ", defectL=" + defectL + ", defectM=" + defectM
				+ ", defectS=" + defectS + ", defectAmount=" + defectAmount
				+ ", explanation=" + explanation + ", state=" + state
				+ ", file1=" + file1 + ", file2=" + file2 + ", getRegNo()="
				+ getRegNo() + ", getDivision()=" + getDivision()
				+ ", getOccurSite()=" + getOccurSite() + ", getOccurDate()="
				+ getOccurDate() + ", getOccurAmPm()=" + getOccurAmPm()
				+ ", getOccurHour()=" + getOccurHour() + ", getOccurPartNo()="
				+ getOccurPartNo() + ", getCar()=" + getCar() + ", getModel()="
				+ getModel() + ", getPartSupplier()=" + getPartSupplier()
				+ ", getOccurPlace()=" + getOccurPlace() + ", getOccurLine()="
				+ getOccurLine() + ", getOccurProc()=" + getOccurProc()
				+ ", getLotNo()=" + getLotNo() + ", getDefectL()="
				+ getDefectL() + ", getDefectM()=" + getDefectM()
				+ ", getDefectS()=" + getDefectS() + ", getDefectAmount()="
				+ getDefectAmount() + ", getExplanation()=" + getExplanation()
				+ ", getState()=" + getState() + ", getFile1()=" + getFile1()
				+ ", getFile2()=" + getFile2() + ", getClass()=" + getClass()
				+ ", hashCode()=" + hashCode() + ", toString()="
				+ super.toString() + "]";
	}
	public String getRegNo() {
		return regNo;
	}
	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}
	public String getDivision() {
		return division;
	}
	public void setDivision(String division) {
		this.division = division;
	}
	public String getOccurSite() {
		return occurSite;
	}
	public void setOccurSite(String occurSite) {
		this.occurSite = occurSite;
	}
	public String getOccurDate() {
		return occurDate;
	}
	public void setOccurDate(String occurDate) {
		this.occurDate = occurDate;
	}
	public String getOccurAmPm() {
		return occurAmPm;
	}
	public void setOccurAmPm(String occurAmPm) {
		this.occurAmPm = occurAmPm;
	}
	public int getOccurHour() {
		return occurHour;
	}
	public void setOccurHour(int occurHour) {
		this.occurHour = occurHour;
	}
	public String getOccurPartNo() {
		return occurPartNo;
	}
	public void setOccurPartNo(String occurPartNo) {
		this.occurPartNo = occurPartNo;
	}
	public String getCar() {
		return car;
	}
	public void setCar(String car) {
		this.car = car;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getPartSupplier() {
		return partSupplier;
	}
	public void setPartSupplier(String partSupplier) {
		this.partSupplier = partSupplier;
	}
	public String getOccurPlace() {
		return occurPlace;
	}
	public void setOccurPlace(String occurPlace) {
		this.occurPlace = occurPlace;
	}
	public String getOccurLine() {
		return occurLine;
	}
	public void setOccurLine(String occurLine) {
		this.occurLine = occurLine;
	}
	public String getOccurProc() {
		return occurProc;
	}
	public void setOccurProc(String occurProc) {
		this.occurProc = occurProc;
	}
	public String getLotNo() {
		return lotNo;
	}
	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}
	public String getDefectL() {
		return defectL;
	}
	public void setDefectL(String defectL) {
		this.defectL = defectL;
	}
	public String getDefectM() {
		return defectM;
	}
	public void setDefectM(String defectM) {
		this.defectM = defectM;
	}
	public String getDefectS() {
		return defectS;
	}
	public void setDefectS(String defectS) {
		this.defectS = defectS;
	}
	public int getDefectAmount() {
		return defectAmount;
	}
	public void setDefectAmount(int defectAmount) {
		this.defectAmount = defectAmount;
	}
	public String getExplanation() {
		return explanation;
	}
	public void setExplanation(String explanation) {
		this.explanation = explanation;
	}

	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getFile1() {
		return file1;
	}
	public void setFile1(String file1) {
		this.file1 = file1;
	}
	public String getFile2() {
		return file2;
	}
	public void setFile2(String file2) {
		this.file2 = file2;
	}

}
