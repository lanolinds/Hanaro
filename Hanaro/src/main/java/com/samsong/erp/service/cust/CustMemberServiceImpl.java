package com.samsong.erp.service.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.cust.CustMemberDAO;

@Service
public class CustMemberServiceImpl implements CustMemberService{

	@Autowired
	CustMemberDAO dao;
	
	@Override
	public void prodMember(String procType, String custCode, String mName,
			String mEmail, String mPhone, String remark, Locale locale, String seq) {
		dao.prodMember(procType, custCode, mName, mEmail, mPhone, remark, locale, seq);
	}

	@Override
	public List<Map<String, Object>> getMemberList(String custCode,
			String memberName, Locale locale) {
		return dao.getMemberList(custCode, memberName, locale);
	}
	
}
