package com.samsong.erp.ctrl;

import java.util.Locale;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = Logger.getLogger(HomeController.class);
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String home() {
		return "home";
	}
	
	@RequestMapping(value="/timeout", method=RequestMethod.GET)
	public String timeout(){
		return "timeout";
	}
	@RequestMapping(value="/accessDenied", method=RequestMethod.GET)
	public String accessDenied(){
		return "accessDenied";
	}
	
	@RequestMapping(value = "/help/manual", method = RequestMethod.GET)
	public String help(Locale locale, Model model) {
		return "help";
	}
}
