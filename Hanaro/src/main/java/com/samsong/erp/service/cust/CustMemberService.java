package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

public interface CustMemberService {
	public void prodMember(String procType,String custCode,String mName,String mEmail,String mPhone,String remark,Locale locale,String seq);
	public List<Map<String,Object>> getMemberList(String custCode,String memberName,Locale locale);
}
