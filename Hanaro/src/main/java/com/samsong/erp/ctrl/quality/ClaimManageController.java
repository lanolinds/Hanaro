package com.samsong.erp.ctrl.quality;




import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;
import com.samsong.erp.service.cust.CustManagementService;
import com.samsong.erp.service.empInfo.EmployeeInfoService;
import com.samsong.erp.service.quality.ClaimManageService;
import com.samsong.erp.util.HashMapComparator;



@Controller
@RequestMapping("/qualityDivision/claimManage")
public class ClaimManageController {
	private String prefix = "/qualityDivision/claimManage";
	private static final Logger logger = Logger.getLogger(ClaimManageController.class);
	private JdbcTemplate sp;
	
	@Autowired
	private ClaimManageService service;
	
	@Autowired
	private EmployeeInfoService serviceEmp;
	
	
	@Autowired
	private CustManagementService serviceCust;
	
	@Autowired
	private ItemService serviceItem;
	
	@Autowired
	private MessageSource message;
	



	
	
	
	@RequestMapping(value="/claimManage",method=RequestMethod.GET)
	public String menuClaimManage(Model model,Locale locale,Authentication auth,LocalDate date){
		HanaroUser user =  (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> listClaimType = service.getClaimCode("CLAIMTYPE", user.getLocale());
		List<Map<String,Object>> listLSType = service.getClaimCode("LSTYPE", user.getLocale());
		List<Map<String,Object>> listIssueLine = service.getClaimCode("ISSUELINE", user.getLocale());
		List<Map<String,Object>> listModel = service.getClaimCode("MODEL", user.getLocale());
		List<Map<String,Object>> listSwtype = service.getClaimCode("SWTYPE", user.getLocale());
		model.addAttribute("claimType",listClaimType);
		model.addAttribute("lsType",listLSType);
		model.addAttribute("issueLine",listIssueLine);
		model.addAttribute("model",listModel);
		model.addAttribute("swtype",listSwtype);
		model.addAttribute("autoCreate",message.getMessage("ui.label.AutoCreate",null,locale));
		model.addAttribute("autoCarType",message.getMessage("alert.autoInputByPartNo",null,locale));
		
		List<Map<String,Object>> empInfo = serviceEmp.getUserInfo(user.getLocale(), user.getUsername());
		List<Map<String,Object>> claimDept = service.getClaimCode("REFTEAM",user.getLocale());
		model.addAttribute("claimDept", claimDept);
		model.addAttribute("writer",empInfo.get(0).get("DATA3"));
		model.addAttribute("today",date);
		
		List<Map<String,Object>> bomCar = serviceItem.getEbomItemList("CAR","",user.getLocale(),"","");
		List<Map<String,Object>> bomModel = serviceItem.getEbomItemList("MODEL","",user.getLocale(),"","");
		model.addAttribute("bomCar",bomCar);
		model.addAttribute("bomModel",bomModel);
		model.addAttribute("cLocale",user.getLocale().getCountry());
		List<Map<String,Object>> actCar = service.getClaimActionItem(user.getLocale(),"CAR","");
		model.addAttribute("actCar",actCar);		
		List<Map<String,Object>> actState = service.getClaimCode("AGREESTATE",user.getLocale());
		model.addAttribute("actState",actState);
		
		List<Map<String,Object>> listRStype = service.getClaimCode("RSTYPE", user.getLocale());
		model.addAttribute("rsType",listRStype);
		return prefix+"/claimManage";
	}
	
	 
	
	
	@RequestMapping(value="/claimAgree",method=RequestMethod.GET)
	public String menuClaimAgree(@RequestParam(value="claimNo") String claimNo,Model model,Authentication auth){
		HanaroUser user =  (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> listInfo = service.getClaimAgreeInfo(claimNo);
		model.addAttribute("cLocale",user.getLocale().getCountry());
		model.addAttribute("claimInfo",listInfo);
		return prefix+"/claimAgree";
	}
	
	@RequestMapping(value="/codeCustOptionLongCallbak", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> codeCustOptionCallbak(Authentication auth ,@RequestParam(value="searchType") String searchType,@RequestParam(value="q",required=false) String q){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return serviceCust.getCustOptionLong(user.getLocale(), searchType, q);
	}
	
	@RequestMapping(value="/getEbomItem",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getEbomItem(
			@RequestParam(value="type",required=false)String type,
			@RequestParam(value="partCode",required=false)String partCode,
			Authentication auth,
			@RequestParam(value="car",required=false)String car,
			@RequestParam(value="model",required=false)String model){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return serviceItem.getEbomItemList(type, partCode, user.getLocale(), car, model);
	}
	
	
	@RequestMapping(value="/getEbom",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getEbom(			
			@RequestParam(value="partCode",required=false)String partCode,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		return serviceItem.getEbom(partCode, user.getLocale());
	}
	
	
	@RequestMapping(value="/claimManage",method=RequestMethod.POST)
	public String  prodClaimManage(Locale locale,
			@RequestParam(value="prodType")String prodType,
			@RequestParam(value="classType")String classType,
			@RequestParam(value="claimNo")String claimNo,
			@RequestParam(value="invoiceNo")String invoiceNo,
			@RequestParam(value="claimCost")String claimCost,
			@RequestParam(value="issueCust")String issueCust,
			@RequestParam(value="issueTeam")String issueTeam,
			@RequestParam(value="cost")String cost,
			@RequestParam(value="partType1")String partType,
			@RequestParam(value="rPartCode")String rPartCode,
			@RequestParam(value="rPartName")String rPartName,
			@RequestParam(value="issueDate")String issueDate,
			@RequestParam(value="claimContent")String claimContent,
			@RequestParam(value="carType")String carType,
			@RequestParam(value="machineType")String machineType,
			@RequestParam(value="workerCount")String workerCount,
			@RequestParam(value="issueTime")String issueTime,
			@RequestParam(value="failAmount")String failAmount,
			Authentication auth,
			@RequestParam(value="p1", required=false)String p1,
			@RequestParam(value="p2", required=false)String p2,
			@RequestParam(value="p3", required=false)String p3,
			@RequestParam(value="p4", required=false)String p4,
			@RequestParam(value="p5", required=false)String p5,
			@RequestParam(value="p6", required=false)String p6,
			@RequestParam(value="p7", required=false)String p7,
			@RequestParam(value="p8", required=false)String p8,
			@RequestParam(value="lotNo")String lotNo,
			@RequestParam(value="file1")MultipartFile file1,
			@RequestParam(value="file2")MultipartFile file2,
			@RequestParam(value="file3")MultipartFile file3,
			@RequestParam(value="file4")MultipartFile file4,
			@RequestParam(value="file5")MultipartFile file5,
			@RequestParam(value="tripCost", required=false)String tripCost,
			@RequestParam(value="prodCost", required=false)String prodCost
			){
		HanaroUser user = (HanaroUser)auth.getPrincipal(); 
		String file1Name = file1.getOriginalFilename();
		String file2Name = file2.getOriginalFilename();
		String file3Name = file3.getOriginalFilename();
		String file4Name = file4.getOriginalFilename();
		String file5Name = file5.getOriginalFilename();
		try {
			service.prodClaimManage(user.getLocale(), prodType, classType, claimNo, invoiceNo, claimCost, issueCust, issueTeam, cost,
									partType, rPartCode, rPartName, issueDate, claimContent, carType, machineType, workerCount, issueTime,failAmount,
									user.getUsername(), p1, p2, p3, p4, p5, p6, p7,p8,lotNo,file1Name,file2Name,file3Name,file4Name,file5Name,
									file1.getBytes(),file2.getBytes(),file3.getBytes(),file4.getBytes(),file5.getBytes(),
									file1.getContentType(),file2.getContentType(),file3.getContentType(),file4.getContentType(),file5.getContentType(),
									tripCost,prodCost);
		} catch (IOException e) { 
			e.printStackTrace();
		}
		return "redirect:"+prefix+"/claimManage";		
	}
	
	
	
	@RequestMapping(value="/getClaimRegList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getClaimRegList(
			Authentication auth,
			@RequestParam("classType") String classType,			
			@RequestParam(value="stdDt",required=false) String stdDt,
			@RequestParam(value="endDt",required=false) String endDt,
			@RequestParam(value="partCode",required=false) String partCode,
			@RequestParam(value="searchLocale",required=false) String searchLocale,
			@RequestParam("page") int page,@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getClaimRegList(user.getLocale(), classType, stdDt, endDt, partCode,searchLocale);
				
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
	
	@RequestMapping(value="/getClaimAgreeList",method = RequestMethod.POST)
	public @ResponseBody Map<String,Object> getClaimAgreeList(
			Authentication auth,
			@RequestParam(value="selLocale",required=false) String selLocale,
			@RequestParam(value="regStdDt",required=false) String regStdDt,
			@RequestParam(value="regEndDt",required=false) String regEndDt,
			@RequestParam(value="regPartNo",required=false) String regPartNo,
			@RequestParam(value="invoiceNo",required=false) String invoiceNo,
			@RequestParam(value="car",required=false) String car,
			@RequestParam(value="model",required=false) String model,
			@RequestParam(value="type",required=false) String type,
			@RequestParam(value="inputBy",required=false) String inputBy,
			@RequestParam(value="deptCode",required=false) String deptCode,
			@RequestParam(value="state",required=false) String state,
			@RequestParam(value="agreeStdDt",required=false) String agreeStdDt,
			@RequestParam(value="agreeEndDt",required=false) String agreeEndDt,
			@RequestParam(value="agreeBy",required=false) String agreeBy,
			@RequestParam("page") int page,@RequestParam("rows") int rows,
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order	
			)
	{
		HanaroUser user = (HanaroUser)auth.getPrincipal();		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getClaimAgreeList(user.getLocale(),selLocale, regStdDt, regEndDt, regPartNo, invoiceNo, car, model, type, inputBy, deptCode, state, agreeStdDt, agreeEndDt, agreeBy);
				
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
	
	@RequestMapping(value="/getClaimActionItem",method=RequestMethod.POST)
	public @ResponseBody List<Map<String,Object>> getClaimActionItem(Authentication auth,
			@RequestParam("type") String type,
			@RequestParam(value="q",required=false) String term){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getClaimActionItem(user.getLocale(), type, term);
		
	}
	
	@RequestMapping(value="/getClaimFile", method=RequestMethod.GET)
	public  void  getQualityIssueFile(Authentication auth, @RequestParam("claimNo") String claimNo, @RequestParam("fileName") String fileName,@RequestParam("fileSeq") String fileSeq, HttpServletResponse response){
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getClaimFile(claimNo, fileSeq);	    
		

		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/getClaimImg", method=RequestMethod.GET)
	public  void  getNcrMeasureImg(Authentication auth, @RequestParam("claimNo") String claimNo,@RequestParam("fileType") String fileType,@RequestParam("fileSeq") String fileSeq, HttpServletResponse response){		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getClaimFile(claimNo, fileSeq);
		try {
			response.setContentType(fileType);
			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/prodRealClaimAgree", method=RequestMethod.POST)
	public void prodRealClaimAgree(@RequestParam("stateIng") String stateIng, 
			@RequestParam("analyCon") String analyCon, 
			@RequestParam("claimRate") String claimRate,
			@RequestParam("claim") String claim,
			@RequestParam("claimNo") String claimNo,
			@RequestParam("procType") String procType,
			Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		service.prodClaimAgree(procType,claimNo, stateIng, analyCon, claimRate, claim, user.getUsername(),user.getLocale());
	}
	
    
	
}
