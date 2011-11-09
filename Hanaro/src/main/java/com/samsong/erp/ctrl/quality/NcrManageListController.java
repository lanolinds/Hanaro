package com.samsong.erp.ctrl.quality;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.samsong.erp.model.quality.NcrInformSheet;
import com.samsong.erp.service.quality.QualityIssueService;



@Controller
@RequestMapping("/qualityDivision/qualityIssue")
public class NcrManageListController {
	private String prefix = "/qualityDivision/qualityIssue";	
	private static final Logger logger = Logger.getLogger(NcrManageListController.class);
	
	@Autowired
	QualityIssueService service;
	
	@RequestMapping(value="/ncrManageList", method=RequestMethod.GET)
	public String menuNcrManageList(){		
		return prefix+"/ncrManageList"; 
	}
	@RequestMapping(value="/ncrManageDetail", method=RequestMethod.GET)
	public String menuNcrManageDetail(Model model, @RequestParam(value="ncrNo", required=false) String ncrNo, Locale locale){
	    String[] standardNames = {"ui.label.quality.fmea","ui.label.quality.managePlan","ui.label.quality.workStandard","ui.label.quality.csheet"};
        model.addAttribute("stanNames",standardNames); 		
		NcrInformSheet sheet = new NcrInformSheet();	
//		이공간은 sheet를 구성하는부분, 처리모듈이 완료되면 수정요망, 현재는 테스트용 임시구성
		sheet.setNcrNo(ncrNo);		
		List<Map<String,Object>> standard = new ArrayList<Map<String,Object>>();		
		standard = service.getNcrMeasureDataGrid(locale, ncrNo, "standard");		
		model.addAttribute("standard",standard);
		model.addAttribute("ncrInForm",sheet);
		//조회하는 내용중 sheet에서 제외되는것들을 넣는다.
		Map<String,Object> head = new HashMap<String,Object>();
		model.addAttribute("viewData",head);

		return prefix+"/ncrManageDetail";
	}
	//대책서머리를 등록한다.
	@RequestMapping(value="/procNcrMeasure",method=RequestMethod.POST)
	public String addNcrMeasureForm(NcrInformSheet sheet,Locale locale,Principal prin,@RequestParam("treatFile") MultipartFile treatFile,
			@RequestParam("imgReasonFile1") MultipartFile imgReasonFile1, @RequestParam("imgReasonFile2") MultipartFile imgReasonFile2,
			@RequestParam("imgTempNameFile") MultipartFile imgTempNameFile,@RequestParam("imgMeasureName1File") MultipartFile imgMeasureName1File,
			@RequestParam("imgMeasureName2File") MultipartFile imgMeasureName2File,@RequestParam(value="inputAddFile", required=false) MultipartFile[] inputAddFiles,
			@RequestParam(value="inputChangeFile",required=false) MultipartFile[] inputChangeFile, @RequestParam(value="stanFile",required=false) MultipartFile[] stanFile,
			@RequestParam("measureProcType") String measureProcType){
		String user = prin.getName(); 
		
		if(measureProcType.equals("DELETE")){
			try{
				service.deleteNcrMeasure(locale, sheet);
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}		
		else if(measureProcType.equals("INSERT")){
			try{			
				sheet.setMeasureFileName(treatFile.getOriginalFilename());
				sheet.setImgReason1FileName(imgReasonFile1.getOriginalFilename());
				sheet.setImgReason2FileName(imgReasonFile2.getOriginalFilename());
				sheet.setImgTempMeasureFileName(imgTempNameFile.getOriginalFilename());
				sheet.setImgMeasure1FileName(imgMeasureName1File.getOriginalFilename());
				sheet.setImgMeasure2FileName(imgMeasureName2File.getOriginalFilename());
				service.addNcrMeasure(locale, user, sheet, treatFile.getBytes(),imgReasonFile1.getBytes(),imgReasonFile2.getBytes(),
						imgTempNameFile.getBytes(),imgMeasureName1File.getBytes(),imgMeasureName2File.getBytes(),
						inputAddFiles,inputChangeFile,stanFile);
			}catch(Exception ex){
				ex.printStackTrace();
			} 
		}else if(measureProcType.equals("UPDATE")){
			try{							
				sheet.setMeasureFileName(treatFile.getOriginalFilename());
				sheet.setImgReason1FileName(imgReasonFile1.getOriginalFilename());
				sheet.setImgReason2FileName(imgReasonFile2.getOriginalFilename());
				sheet.setImgTempMeasureFileName(imgTempNameFile.getOriginalFilename());
				sheet.setImgMeasure1FileName(imgMeasureName1File.getOriginalFilename());
				sheet.setImgMeasure2FileName(imgMeasureName2File.getOriginalFilename());
				service.updateNcrMeasure(locale, user, sheet, treatFile.getBytes(),imgReasonFile1.getBytes(),imgReasonFile2.getBytes(),
						imgTempNameFile.getBytes(),imgMeasureName1File.getBytes(),imgMeasureName2File.getBytes(),
						inputAddFiles,inputChangeFile,stanFile);
			}catch(Exception ex){
				ex.printStackTrace();
			} 			
		}
		
		return "redirect:"+prefix+"/ncrManageDetail";
	}
	
	@RequestMapping(value="/getNcrMeasureDataGrid", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getNcrMeasureDataGrid(Locale locale, @RequestParam("ncrNo") String ncrNo,@RequestParam("gridType") String gridType){
		
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getNcrMeasureDataGrid(locale, ncrNo, gridType);
		if(resultList!=null){
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;
	}	

}
