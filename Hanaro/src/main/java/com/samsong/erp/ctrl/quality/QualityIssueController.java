package com.samsong.erp.ctrl.quality;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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

import com.samsong.erp.model.quality.QualityIssueRegSheet;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.quality.QualityIssueService;

@Controller
@RequestMapping(value="/qualityDivision/qualityIssue")
public class QualityIssueController {

	private String prefix ="/qualityDivision/qualityIssue"; 
	private static final Logger logger = Logger.getLogger(QualityIssueController.class);
	
	@Autowired
	private QualityIssueService service;
	
	@Autowired
	private CustManagementService serviceCust;
	
	 
	//품질문제등록 메뉴이동
	@RequestMapping(value="/qualityIssueReg", method=RequestMethod.GET)
	public String menuQualityIssueReg(Model model,Locale locale){				
		Map<String,Object> defects = service.getCodeDefectSource(locale, "");
		Map<String,Object> defectc = service.getCodeDefect(locale, 0, "");		
	    model.addAttribute("defectSource",defects);
		model.addAttribute("defectCode", defectc);
		model.addAttribute("qualityIssueRegSheet",new QualityIssueRegSheet());
		return prefix+"/qualityIssueReg";
	}	
	
	//품질문제등록
	@RequestMapping(value="/addQualityIssueReg", method=RequestMethod.POST )
	public String addQualityIssueReg(String procType,Locale locale, QualityIssueRegSheet sheet,Principal prin,Model model){	   
	String user =prin.getName();
	   try{
		    service.procQualityIssueReg(procType,locale,sheet,user);			
			return "redirect:"+prefix+"/qualityIssueReg";		
	   }catch(Exception e){
		   logger.info(e.getMessage());
			Map<String,Object> defects = service.getCodeDefectSource(locale, "");
			Map<String,Object> defectc = service.getCodeDefect(locale, 0, "");		
		    model.addAttribute("defectSource",defects);
			model.addAttribute("defectCode", defectc);
			model.addAttribute("qualityIssueRegSheet",sheet);
			return prefix+"/qualityIssueReg";		   
	   }
	   
	}	
	
	//품질출처선택 하위목록
	@RequestMapping(value="/codeDefectSourceCallback", method=RequestMethod.GET)
	public @ResponseBody Map<String,Object> codeDefectSourceCallback(Locale locale, @RequestParam("parentCode") String parentCode){		
		return service.getCodeDefectSource(locale, parentCode);
	}
	
	//품질발생품번등록용 (반환값 : 품번, 품명, 차종, 기종, 부품업체)
	@RequestMapping(value="/codePartListForIssueRegCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codePartListForIssueRegCallbak(Locale locale,
	@RequestParam(value="partType", required=false) String partType , @RequestParam(value="q", required=false) String q, Authentication auth){		
		String uid = auth.getName();
		String role = auth.getAuthorities().toString();
		List<Map<String ,Object>> resultList = new ArrayList<Map<String,Object>>();		
		if(role.equals("[ROLE_CUST]"))
			resultList =  service.getOccurPartListForReg(locale, uid, partType, q);
		else
			resultList =  service.getOccurPartListForReg(locale, "", partType, q);
		return resultList;
	}
	
	//품번에 대한 부품업체조회
	@RequestMapping(value="/supplierOptionByPartCodeCallbak", method=RequestMethod.GET)
	public @ResponseBody Map<Object,Object> supplierOptionByPartCodeCallbak(Locale locale,@RequestParam(value="partCode", required=false) String partCode){		
		return serviceCust.getSupplierOptionByPartCode(locale,partCode);
	}	
	
	//업체코드 조회
	@RequestMapping(value="/codeCustOptionCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Locale locale,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){		
		return serviceCust.getCustOption(locale, searchType,q);
	}
	
	//업체코드에 대한 라인코드  / 라인코드에 대한 공정코드 목록조회
	
	@RequestMapping(value="/codeLineProcOptionCallbak",method = RequestMethod.GET)
	public @ResponseBody Map<String,String> codeLineProcOptionCallbak(Locale locale,@RequestParam(value="custCode") String custCode, @RequestParam(value="lineCode", required=false) String lineCode){
		return serviceCust.getLineProcList(locale, custCode, lineCode);
	}
	
	//불량현상코드 조회
	@RequestMapping(value="/codeDefectCallbak", method=RequestMethod.GET)
	public @ResponseBody Map<String,Object> codeDefectCallbak(Locale locale, @RequestParam("searchLevel") int searchLevel, @RequestParam(value="code", required = false) String code){
		return service.getCodeDefect(locale, searchLevel, code);
	}
	

	 
}
