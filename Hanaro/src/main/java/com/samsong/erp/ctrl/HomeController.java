package com.samsong.erp.ctrl;


import java.util.Locale;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.samsong.erp.dao.HomeDAO;
import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.HanaroUserDetailsService;
import com.samsong.erp.service.quality.QualityIssueService;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = Logger.getLogger(HomeController.class);
	
	@Autowired
	private QualityIssueService service;
	
	@Autowired
	private HomeDAO serviceHome;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String home(Authentication auth) {
		/*VIEW를 지역화 할때는 requestMapHandler에 넘어오는 Locale을 받아 사용하고
		 * 데이터를 지역활 할 때는 사용자의 설정 locale을 이용할것.
		 */
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		logger.info("사용자 설정 Locale:"+user.getLocale()); 
		
		
		return "home";
	}
	
	@RequestMapping(value="/accessDenied", method=RequestMethod.GET)
	public String accessDenied(){
		return "accessDenied";
	}
	
	@RequestMapping(value="/dataAccessFailure", method=RequestMethod.GET)
	public String dataAccessFailure(){
		return "dataAccessFailure";
	}
	
	@RequestMapping(value = "/help/manual", method = RequestMethod.GET)
	public String help(Locale locale, Model model) {
		return "help";
	}	
	@RequestMapping(value="/changePassword", method=RequestMethod.GET)
	public String changePasswordGET(Authentication auth,Model model){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		model.addAttribute("uid",user.getUsername());		
		return "changePassword";
	}	 
	@RequestMapping(value="/changePassword", method=RequestMethod.POST)
	public String changePasswordPOST(Authentication auth,Model model,@RequestParam("cntPwd") String cntPwd, @RequestParam("newPwd") String newPwd){
		Md5PasswordEncoder encoder = new Md5PasswordEncoder();
		cntPwd = encoder.encodePassword(cntPwd, null);
		newPwd = encoder.encodePassword(newPwd, null);
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		logger.info(user.getUsername());
		int result = 0;
		result = serviceHome.changePassword(user.getUsername(), cntPwd, newPwd);		
		model.addAttribute("uid",user.getUsername());		
		if(result>0)
			model.addAttribute("changed","changed");
		else
			model.addAttribute("fail","fail");
		return "changePassword";
	}
}
