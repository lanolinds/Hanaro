package com.samsong.erp.model.product;

public class StockInOutSheet {

	private int seq;
	private String stdDt;
	private String inoutType;
	private String fromTo;
	private String partCode;
	private String lotNo;
	private int amount = 0;
	private String comment;
	
	
	

	@Override
	public String toString() {
		return "StockInOutSheet [seq=" + seq + ", stdDt=" + stdDt
				+ ", inoutType=" + inoutType + ", fromTo=" + fromTo
				+ ", partCode=" + partCode + ", lotNo=" + lotNo + ", amount="
				+ amount + ", comment=" + comment + "]";
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getStdDt() {
		return stdDt;
	}
	public void setStdDt(String stdDt) {
		this.stdDt = stdDt;
	}
	public String getInoutType() {
		return inoutType;
	}
	public void setInoutType(String inoutType) {
		this.inoutType = inoutType;
	}

	public String getFromTo() {
		return fromTo;
	}
	public void setFromTo(String fromTo) {
		this.fromTo = fromTo;
	}
	public String getPartCode() {
		return partCode;
	}
	public void setPartCode(String partCode) {
		this.partCode = partCode;
	}
	public String getLotNo() {
		return lotNo;
	}
	public void setLotNo(String lotNo) {
		this.lotNo = lotNo;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}	
	
}
