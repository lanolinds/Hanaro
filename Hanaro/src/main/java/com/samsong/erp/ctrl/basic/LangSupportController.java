package com.samsong.erp.ctrl.basic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.util.HashMapComparator;
import com.samsong.erp.util.message.JdbcMessageSource;
import com.samsong.erp.util.message.Messages;

@Controller
public class LangSupportController {

	
	private static Logger logger = Logger.getLogger(LangSupportController.class);
	
	@Autowired
	MessageSource message;
	
	@RequestMapping(value="/basicDivision/global/langSupport", method=RequestMethod.GET)
	public String languageSupport(Locale locale,Model model){
		model.addAttribute("lang",locale.toString());
		return "basicDivision/global/langSupport";
	}
	
	
	@RequestMapping(value="/basicDivision/global/editLang",method=RequestMethod.POST)
	public String editLanguage(@RequestParam("key") String key, @RequestParam("val") String value,
			Authentication auth,Locale locale){
		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		if(message instanceof JdbcMessageSource){
			((JdbcMessageSource) message).persistMessage("hanaro", locale, key, value);
			logger.info("사용자:"+user.getUsername()+" 이(가) message_"+locale.getLanguage()+".properties 파일의 내용을 다음과 같이 수정하였습니다. key:"+key+",value="+value);
		}
		return "redirect:/basicDivision/global/langSupport";
	}
	@RequestMapping(value="/basicDivision/global/langSupport/gridCallback",method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getLanguageSupports(@RequestParam("page") int page,
			@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order,
			@RequestParam("status") String status,
			Locale locale){
		
		Locale stdLocale =null;
		
		
		List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
		
		if(message instanceof JdbcMessageSource){
			Messages messages= ((JdbcMessageSource) message).getMessages("hanaro");
			Map<String,String> kr = messages.getMessages(stdLocale);
			Map<String,String>local = messages.getMessages(locale);
			if(kr !=null)
			{
				Iterator<Entry<String,String>> i = kr.entrySet().iterator();
				while(i.hasNext()){
					Entry<String,String> e = i.next();
					Map<String,Object> m =new HashMap<String,Object>();
					m.put("key",e.getKey());
					m.put("std", e.getValue());
					String msg = null;
					try{
						msg = local.get(e.getKey());
					}catch(Exception ex){
						msg=null;
					}
					m.put("local",msg);
					if(status.equals("ready")){
						if(msg==null)
							list.add(m);
					}
					else{
						if(msg!=null)
							list.add(m);
					}
					
				}
				
			}
			
		}
		
		if(sortKey!=null){
			Collections.sort(list,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
		}
		else{
			Collections.sort(list,new HashMapComparator("key",true));
		}
		
		Map<String,Object> json = new HashMap<String, Object>();
		
		
		if(list!=null){
			json.put("total",list.size());
			int from = (page-1)*rows;
			int to = from + rows;
			to = list.size()<to?list.size():to;
			json.put("rows", list.subList(from,to));
		}
		
		return json;
	}
}
