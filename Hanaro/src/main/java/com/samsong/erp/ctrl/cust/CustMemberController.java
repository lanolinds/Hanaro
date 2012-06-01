package com.samsong.erp.ctrl.cust;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.cust.CustMemberService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping(value="/custDivision/manager")
public class CustMemberController {

	private String prefix = "/custDivision/manager";	
	private static final Logger logger = Logger.getLogger(CustMemberController.class);
	
	@Autowired
	private CustManagementService serviceCust;
	
	@Autowired
	private CustMemberService service;
	
	
	@RequestMapping(value="/view",method=RequestMethod.GET)
	public String menuManager(Authentication auth,Model model){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> custList = serviceCust.getCustOptionLong(user.getLocale(),"LOCALCUST","");
		model.addAttribute("custList",custList);
		return prefix+"/view";
	}
	@RequestMapping(value="/codeCustOptionLongCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Authentication auth ,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getCustOptionLong(user.getLocale(), searchType, q);
	}	
	
	@RequestMapping(value="/view",method=RequestMethod.POST)
	public String	updateMemberData(
			@RequestParam(value="procType",required=false)String procType,
			@RequestParam(value="custCode",required=false)String custCode,
			@RequestParam(value="memberName",required=false)String memberName,
			@RequestParam(value="memberEmail",required=false)String memberEmail,
			@RequestParam(value="memberPhone",required=false)String memberPhone,
			@RequestParam(value="remark",required=false)String remark,
			@RequestParam(value="seq",required=false)String seq,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();

		service.prodMember(procType, custCode, memberName, memberEmail, memberPhone, remark, user.getLocale(), seq);
		return "redirect:"+prefix+"/view";	
	}
	

	@RequestMapping(value="/getMemberList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getCustRegList(Authentication auth, 
			@RequestParam(value="custCode",required=false) String custCode,
			@RequestParam(value="memberName",required=false) String memberName,			
			@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getMemberList(custCode, memberName, user.getLocale());
	
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}
			
			table.put("total",resultList.size());
			int start =  (page-1)*rows;
			int end  = start +rows;
			if(end>resultList.size())end = resultList.size();
			table.put("rows",resultList.subList(start,end));
		}else{
			table.put("total",0);
		}
		return table;
	}
	
	
	
	
}
