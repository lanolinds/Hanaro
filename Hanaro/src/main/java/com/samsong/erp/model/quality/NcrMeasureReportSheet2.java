package com.samsong.erp.model.quality;

import java.util.Arrays;

public class NcrMeasureReportSheet2 {
	String ncrNo;
	String imgTempName;
	String imgMeasureName1;
	String imgMeasureName2;
	String[] tempMeasure;
	String[] tempMeasureDate;
	String[] measure;
	String[] measureDate;
	String[] lotNo;
	String[] confirm;
	String[] remark;
	
	
	
	@Override
	public String toString() {
		return "NcrMeasureReportSheet2 [ncrNo=" + ncrNo + ", imgTempName="
				+ imgTempName + ", imgMeasureName1=" + imgMeasureName1
				+ ", imgMeasureName2=" + imgMeasureName2 + ", tempMeasure="
				+ Arrays.toString(tempMeasure) + ", tempMeasureDate="
				+ Arrays.toString(tempMeasureDate) + ", measure="
				+ Arrays.toString(measure) + ", measureDate="
				+ Arrays.toString(measureDate) + ", lotNo="
				+ Arrays.toString(lotNo) + ", confirm="
				+ Arrays.toString(confirm) + ", remark="
				+ Arrays.toString(remark) + "]";
	}
	public String getNcrNo() {
		return ncrNo;
	}
	public void setNcrNo(String ncrNo) {
		this.ncrNo = ncrNo;
	}
	public String getImgTempName() {
		return imgTempName;
	}
	public void setImgTempName(String imgTempName) {
		this.imgTempName = imgTempName;
	}
	public String getImgMeasureName1() {
		return imgMeasureName1;
	}
	public void setImgMeasureName1(String imgMeasureName1) {
		this.imgMeasureName1 = imgMeasureName1;
	}
	public String getImgMeasureName2() {
		return imgMeasureName2;
	}
	public void setImgMeasureName2(String imgMeasureName2) {
		this.imgMeasureName2 = imgMeasureName2;
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
	
	
	
}
