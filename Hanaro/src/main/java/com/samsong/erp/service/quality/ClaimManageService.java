package com.samsong.erp.service.quality;

import java.util.List;
import java.util.Locale;
import java.util.Map;


public interface ClaimManageService {
	public List<Map<String,Object>> getClaimCode(String type,Locale locale);

}
