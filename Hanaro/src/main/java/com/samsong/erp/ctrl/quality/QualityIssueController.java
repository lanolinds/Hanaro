package com.samsong.erp.ctrl.quality;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.model.quality.QualityIssueRegSheet;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class QualityIssueController {

	private String prefix ="/qualityDivision/qualityIssue"; 
	private static final Logger logger = Logger.getLogger(QualityIssueController.class);
	
	
	@Autowired
	private QualityIssueService service;
	
	@Autowired
	private CustManagementService serviceCust;
	
	
	@Autowired
	private MessageSource message;
	 
	//품질문제등록 메뉴이동
	@RequestMapping(value="/qualityIssueReg", method=RequestMethod.GET)
	public String menuQualityIssueReg(Model model,Authentication auth,Locale locale){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> defects = service.getCodeDefectSource(user.getLocale(), "");
		Map<String,Object> defectc = service.getCodeDefect(user.getLocale(), 0, "");		
	    model.addAttribute("defectSource",defects);
		model.addAttribute("defectCode", defectc);
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		model.addAttribute("endDt", sf.format(cal.getTime()));
		cal.add(Calendar.DATE, -7);
		model.addAttribute("stdDt", sf.format(cal.getTime()));
		QualityIssueRegSheet sheet = new QualityIssueRegSheet();
		sheet.setRegNo(message.getMessage("ui.label.AutoCreate",null,locale));
		model.addAttribute("qualityIssueRegSheet",sheet);
		return prefix+"/qualityIssueReg";
	}
	
	//품질문제등록
	@RequestMapping(value="/addQualityIssueReg", method=RequestMethod.POST )
	public String addQualityIssueReg(String procType,Authentication auth, QualityIssueRegSheet sheet,Model model, @RequestParam("files1") MultipartFile files1, @RequestParam("files2") MultipartFile files2){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
	  try {
	   //선택된 파일이름은 모델에 담는다.		  
	   sheet.setFile1(files1.getOriginalFilename());
	   sheet.setFile2(files2.getOriginalFilename());
	   //선택된 파일객체는 직접 입력한다.	   
		service.procQualityIssueReg(procType,user.getLocale(),sheet,user.getUsername(), files1.getBytes(), files2.getBytes());
		logger.info(sheet.toString()+","+procType);
	  } catch (IOException e) {
		e.printStackTrace();
	  }
	   return "redirect:"+prefix+"/qualityIssueReg";
	}	
	
	//품질출처선택 하위목록
	@RequestMapping(value="/codeDefectSourceCallback", method=RequestMethod.GET)
	public @ResponseBody Map<String,Object> codeDefectSourceCallback(Authentication auth, @RequestParam("parentCode") String parentCode){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getCodeDefectSource(user.getLocale(), parentCode);
	}
	
	//품질발생품번등록용 (반환값 : 품번, 품명, 차종, 기종, 부품업체)
	@RequestMapping(value="/codePartListForIssueRegCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codePartListForIssueRegCallbak(@RequestParam(value="partType", required=false) String partType , @RequestParam(value="q", required=false) String q, Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		List<Map<String ,Object>> resultList = new ArrayList<Map<String,Object>>();		
		if(auth.getAuthorities().contains(new GrantedAuthorityImpl("ROLE_CUST")))
			resultList =  service.getOccurPartListForReg(user.getLocale(), user.getUsername(), partType, q);
		else
			resultList =  service.getOccurPartListForReg(user.getLocale(), "", partType, q);
		return resultList;
	}
	
	//품번에 대한 부품업체조회
	@RequestMapping(value="/supplierOptionByPartCodeCallbak", method=RequestMethod.GET)
	public @ResponseBody Map<Object,Object> supplierOptionByPartCodeCallbak(Authentication auth,@RequestParam(value="partCode", required=false) String partCode){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getSupplierOptionByPartCode(user.getLocale(),partCode);
	}	
	
	//업체코드 조회
	@RequestMapping(value="/codeCustOptionCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Authentication auth ,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getCustOption(user.getLocale(), searchType,q);
	}
	
	//업체코드에 대한 라인코드  / 라인코드에 대한 공정코드 목록조회
	
	@RequestMapping(value="/codeLineProcOptionCallbak",method = RequestMethod.GET)
	public @ResponseBody Map<String,String> codeLineProcOptionCallbak(Authentication auth,@RequestParam(value="custCode") String custCode, @RequestParam(value="lineCode", required=false) String lineCode){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getLineProcList(user.getLocale(), custCode, lineCode);
	}
	
	//불량현상코드 조회
	@RequestMapping(value="/codeDefectCallbak", method=RequestMethod.GET)
	public @ResponseBody Map<String,Object> codeDefectCallbak(Authentication auth, @RequestParam("searchLevel") int searchLevel, @RequestParam(value="code", required = false) String code){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getCodeDefect(user.getLocale(), searchLevel, code);
	}
	
	
	//품질불량등록 메뉴의 등록된 목록조회
	@RequestMapping(value="/getQualityIssueRegList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getQualityIssueRegList(Authentication auth, @RequestParam(value="division",required=false) String division, @RequestParam(value="occurSite",required=false) String occurSite,
			@RequestParam(value="stdDt",required=false) String stdDt, @RequestParam(value="endDt",required=false) String endDt,@RequestParam("page") int page,@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getQualityIssueRegList(user.getLocale(), division, occurSite, stdDt, endDt);
				
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
	
	//품질 파일 다운
	@RequestMapping(value="/getQualityIssueFile", method=RequestMethod.GET)
	public  void  getQualityIssueFile(Authentication auth, @RequestParam("regNo") String regNo, @RequestParam("fileName") String fileName,@RequestParam("fileSeq") String fileSeq, HttpServletResponse response){		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getQualityIssueFile(user.getLocale(), regNo, fileSeq);	    
		

		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	 
}
