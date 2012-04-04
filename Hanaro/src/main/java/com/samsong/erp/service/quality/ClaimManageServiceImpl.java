package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.samsong.erp.dao.quality.ClaimManageDAO;

@Service
public class ClaimManageServiceImpl implements ClaimManageService {

	@Autowired
	private ClaimManageDAO dao;
	
	private static final Logger logger  = Logger.getLogger(ClaimManageServiceImpl.class);
	
	@Override
	public List<Map<String, Object>> getClaimCode(String type, Locale locale) {
		return dao.getClaimCode(type, locale);
	}


}
