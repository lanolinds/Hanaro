package com.samsong.erp.util;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

public class HanaroAuthenticationFilter extends UsernamePasswordAuthenticationFilter {
	private static final Logger logger = Logger.getLogger(HanaroAuthenticationFilter.class);
	
	@Override
	protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, Authentication authResult) throws IOException, ServletException{
		String userIp = request.getRemoteAddr();
		String userName = authResult.getName();
		String authorities=authResult.getAuthorities().toString();
		logger.info("사용자가"+userName+" 이(가) 로그인 하였습니다. IP:"+userIp+",소유권한:"+authorities);
		super.successfulAuthentication(request, response, authResult);
				
	}

}
