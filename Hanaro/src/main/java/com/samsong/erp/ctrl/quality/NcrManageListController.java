package com.samsong.erp.ctrl.quality;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

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
		Map<String,Object> sheetMap = new HashMap<String,Object>(); 
		List<Map<String,Object>> sheetList = service.getNcrDetail(locale, ncrNo);
		if(sheetList !=null){
			sheet.setStatus(String.valueOf(((HashMap)sheetList.get(0)).get("DATA0"))); //상태
			sheet.setTitle(String.valueOf(((HashMap)sheetList.get(0)).get("DATA1")));//제목
			sheetMap.put("occurPartNo",String.valueOf(((HashMap)sheetList.get(0)).get("DATA3"))); //발생품번
			sheetMap.put("occurPartName",String.valueOf(((HashMap)sheetList.get(0)).get("DATA4")));//발생품명
			sheetMap.put("occurSite",String.valueOf(((HashMap)sheetList.get(0)).get("DATA5"))); //출처
			sheetMap.put("carmodel",String.valueOf(((HashMap)sheetList.get(0)).get("DATA6"))); //차종기종
			sheetMap.put("occurPlace",String.valueOf(((HashMap)sheetList.get(0)).get("DATA7"))); //발생처
			sheetMap.put("occurDate",String.valueOf(((HashMap)sheetList.get(0)).get("DATA8"))); //발생일시
			sheetMap.put("regCust",String.valueOf(((HashMap)sheetList.get(0)).get("DATA9"))); //등록처
			sheetMap.put("defectL",String.valueOf(((HashMap)sheetList.get(0)).get("DATA10")));//불량현상(대)
			sheetMap.put("defectM",String.valueOf(((HashMap)sheetList.get(0)).get("DATA11")));//불량현상(중)
			sheetMap.put("defectS", String.valueOf(((HashMap)sheetList.get(0)).get("DATA12")));//불량현상(소)
			sheetMap.put("rPartNo",String.valueOf(((HashMap)sheetList.get(0)).get("DATA13")));//원인품번
			sheetMap.put("rPartNm",String.valueOf(((HashMap)sheetList.get(0)).get("DATA14"))); //원인품명
			sheetMap.put("defectAmount",String.valueOf(((HashMap)sheetList.get(0)).get("DATA15")));//부적합수량
			sheetMap.put("lot",String.valueOf(((HashMap)sheetList.get(0)).get("DATA16")));//LOT
			sheetMap.put("reason1",String.valueOf(((HashMap)sheetList.get(0)).get("DATA17"))); //4m1
			sheetMap.put("reason2",String.valueOf(((HashMap)sheetList.get(0)).get("DATA18"))); //4m2
			sheetMap.put("reason3",String.valueOf(((HashMap)sheetList.get(0)).get("DATA19"))); //analy
			sheetMap.put("remark",String.valueOf(((HashMap)sheetList.get(0)).get("DATA20"))); //원인설명
			sheetMap.put("requestContent",String.valueOf(((HashMap)sheetList.get(0)).get("DATA21"))); //요청사항
			sheet.setSampleDate(String.valueOf(((HashMap)sheetList.get(0)).get("DATA22")));//샘플적용일
			sheet.setSupplierDate(String.valueOf(((HashMap)sheetList.get(0)).get("DATA23"))); //협력사적용일
			sheet.setInsideIncomeDate(String.valueOf(((HashMap)sheetList.get(0)).get("DATA24"))); //사내입고일
			sheet.setApplyProcDate(String.valueOf(((HashMap)sheetList.get(0)).get("DATA25"))); //공정투입일
			sheet.setApplyCustDate(String.valueOf(((HashMap)sheetList.get(0)).get("DATA26"))); //고객적용일
			sheetMap.put("measureRequestDt",String.valueOf(((HashMap)sheetList.get(0)).get("DATA27")));  //대책요구일
			sheetMap.put("actionDept",String.valueOf(((HashMap)sheetList.get(0)).get("DATA28"))); //처리처
			sheetMap.put("actionBy",String.valueOf(((HashMap)sheetList.get(0)).get("DATA29"))); //처리자
			sheetMap.put("actionByCap",String.valueOf(((HashMap)sheetList.get(0)).get("DATA30"))); //처리자 팀장
			sheetMap.put("actionDt",String.valueOf(((HashMap)sheetList.get(0)).get("DATA31")));//처리일
			sheetMap.put("reasonCust",String.valueOf(((HashMap)sheetList.get(0)).get("DATA32")));//귀책처			
			sheet.setCustManager(String.valueOf(((HashMap)sheetList.get(0)).get("DATA33")));//귀책담당
			sheet.setCustConfirmer(String.valueOf(((HashMap)sheetList.get(0)).get("DATA34"))); //귀책검토
			sheet.setCustAppover(String.valueOf(((HashMap)sheetList.get(0)).get("DATA35"))); //귀책승인
			sheetMap.put("measureDate",String.valueOf(((HashMap)sheetList.get(0)).get("DATA36"))); //대책서등록일
			sheetMap.put("measureFileName",String.valueOf(((HashMap)sheetList.get(0)).get("DATA37"))); //대책서 파일명
			sheet.setReasonIssue(String.valueOf(((HashMap)sheetList.get(0)).get("DATA38"))); //임시대책
			sheet.setReasonOutflow(String.valueOf(((HashMap)sheetList.get(0)).get("DATA39"))); //근본대책
			sheet.setImgReason1FileName(String.valueOf(((HashMap)sheetList.get(0)).get("DATA40")));
			sheet.setImgReason2FileName(String.valueOf(((HashMap)sheetList.get(0)).get("DATA41")));
			sheet.setImgTempMeasureFileName(String.valueOf(((HashMap)sheetList.get(0)).get("DATA42")));
			sheet.setImgMeasure1FileName(String.valueOf(((HashMap)sheetList.get(0)).get("DATA43")));
			sheet.setImgMeasure2FileName(String.valueOf(((HashMap)sheetList.get(0)).get("DATA44")));
			sheetMap.put("reasonOrgan",String.valueOf(((HashMap)sheetList.get(0)).get("DATA45")));
		}
		sheet.setNcrNo(ncrNo);	
		
		model.addAttribute("sheetMap",sheetMap);
		List<Map<String,Object>> standard = new ArrayList<Map<String,Object>>();		
		standard = service.getNcrMeasureDataGrid(locale, ncrNo, "standard");		
		model.addAttribute("standard",standard);
		model.addAttribute("ncrInForm",sheet);

		return prefix+"/ncrManageDetail";
	}
	//대책서머리를 등록한다.
	@RequestMapping(value="/procNcrMeasure",method=RequestMethod.POST)
	public String addNcrMeasureForm(NcrInformSheet sheet,Locale locale,Principal prin,@RequestParam("treatFile") MultipartFile treatFile,
			@RequestParam("imgReasonFile1") MultipartFile imgReasonFile1, @RequestParam("imgReasonFile2") MultipartFile imgReasonFile2,
			@RequestParam("imgTempNameFile") MultipartFile imgTempNameFile,@RequestParam("imgMeasureName1File") MultipartFile imgMeasureName1File,
			@RequestParam("imgMeasureName2File") MultipartFile imgMeasureName2File,@RequestParam(value="inputAddFile", required=false) MultipartFile[] inputAddFiles,
			@RequestParam(value="inputChangeFile",required=false) MultipartFile[] inputChangeFile, @RequestParam(value="stanFile",required=false) MultipartFile[] stanFile,
			@RequestParam("measureProcType") String measureProcType,Model model){
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
						inputAddFiles,inputChangeFile,stanFile
						,imgReasonFile1.getContentType(),imgReasonFile2.getContentType(),imgTempNameFile.getContentType(),
						imgMeasureName1File.getContentType(),imgMeasureName2File.getContentType());
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
						inputAddFiles,inputChangeFile,stanFile
						,imgReasonFile1.getContentType(),imgReasonFile2.getContentType(),imgTempNameFile.getContentType(),
						imgMeasureName1File.getContentType(),imgMeasureName2File.getContentType());
			}catch(Exception ex){
				ex.printStackTrace();
			} 			
		}
		model.addAttribute("ncrNo",sheet.getNcrNo());
		
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
	
	//NCR대책서 파일다운
	@RequestMapping(value="/getNcrMeasureFile", method=RequestMethod.GET)
	public  void  getNcrMeasureFile(Locale locale, @RequestParam("ncrNo") String ncrNo, @RequestParam("fileName") String fileName, HttpServletResponse response){		
	
		
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getNcrMeasureFile(locale, ncrNo);
		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//NCR임시대책 파일 다운
	@RequestMapping(value="/getNcrMeasureReasonFile", method=RequestMethod.GET)
	public  void  getNcrMeasureReasonFile(Locale locale, @RequestParam("ncrNo") String ncrNo, @RequestParam("fileName") String fileName, @RequestParam("fileSeq") String fileSeq, HttpServletResponse response){		
		
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getNcrMeasureReasonFile(locale, ncrNo, fileSeq);
		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//NCR표준반영사항파일다운
	@RequestMapping(value="/getNcrMeasureStandardFile", method=RequestMethod.GET)
	public  void  getNcrMeasureStandardFile(Locale locale, @RequestParam("ncrNo") String ncrNo, @RequestParam("fileName") String fileName, @RequestParam("fileSeq") String fileSeq, HttpServletResponse response){		
		
		byte[] file = null;
		BufferedOutputStream out = null;
		file = service.getNcrMeasureStandardFile(locale, ncrNo, fileSeq);
		try {
		    response.setHeader("Content-Disposition","attachment;filename=\""+URLEncoder.encode(fileName, "UTF-8")+"\"");	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}	
	
	//NCR대책서 이미지 처리
	@RequestMapping(value="/getNcrMeasureImg", method=RequestMethod.GET)
	public  void  getNcrMeasureImg(Locale locale, @RequestParam("ncrNo") String ncrNo,@RequestParam("fileSeq") String fileSeq, HttpServletResponse response){		
		
		byte[] file = null;
		String type = "";
		BufferedOutputStream out = null;
		List<Map<String,Object>> list = service.getNcrMeasureImg(locale, ncrNo, fileSeq);
		file = (byte[]) ((HashMap)list.get(0)).get("file");
		type = (String) ((HashMap)list.get(0)).get("type");
		try {
			response.setContentType(type);
		    	    

			out = new BufferedOutputStream(response.getOutputStream());
			out.write(file);
			out.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}		
	
	
	
	

}
