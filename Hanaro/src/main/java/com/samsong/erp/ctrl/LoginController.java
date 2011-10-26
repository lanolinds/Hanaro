package com.samsong.erp.ctrl;

import java.util.Locale;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginController {
	private static Logger logger = Logger.getLogger(LoginController.class);
	@RequestMapping("/login")
	public String login(Locale locale){
		return "login";
	}

}
