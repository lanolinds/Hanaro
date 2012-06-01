package com.samsong.erp.dao.cust;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

@Repository
public class CustMemberDAO {
	private JdbcTemplate jdbc;
	private SimpleJdbcCall  sp;
	
	@Autowired
	public void init(DataSource ds){
		jdbc = new JdbcTemplate(ds);
	}

	
	public void prodMember(String procType,String custCode,String mName,String mEmail,String mPhone,String remark,Locale locale,String seq){
		String query = "EXEC [CustMemberDAO_prodMember] ?,?,?,?,?,?,?,?";
		jdbc.update(query,new Object[]{procType,custCode,mName,mEmail,mPhone,remark,locale.getCountry(),seq});
	}
	
	public List<Map<String,Object>> getMemberList(String custCode,String memberName,Locale locale){
		String query = "EXEC [CustMemberDAO_getMemberList] ?,?,?";
		return jdbc.queryForList(query,new Object[]{custCode,memberName,locale.getCountry()});
	}
}
