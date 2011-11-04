package com.samsong.erp.ctrl.quality;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.service.quality.QualityIssueService;
import com.samsong.erp.util.ClientFileNameEncoder;

@Controller
@RequestMapping("/qualityDivision/qualityIssue/acceptIssues")
public class IssueAcceptController {
	
	private Logger logger = Logger.getLogger(IssueAcceptController.class);
	@Autowired
	private QualityIssueService service;
	
	@RequestMapping("/issueDetailCallback")
	public @ResponseBody Map<String,Object> getIssueDetails(@RequestParam("no") String regNo,Locale locale){
		return service.getIssueDetails(regNo,locale);
	}
	@RequestMapping("/downloadFile")
	public void downloadFile(@RequestParam("seq") int seq,@RequestParam("no") String regNo,@RequestParam("name") String name,
			Locale locale,HttpServletRequest req, HttpServletResponse res){
		
		try{
			name = ClientFileNameEncoder.encodeFileName(name, req.getHeader("User-Agent"));
			byte[] binary =service.getQualityIssueFile(locale, regNo, Integer.toString(seq));
			res.setHeader("Content-Disposition", "inline;filename=" + name);
			res.setContentType("application/octet-stream");
			res.setContentLength(binary.length);
			OutputStream out = res.getOutputStream();
			out.write(binary);
			out.flush();
		}catch(IOException ex){
			logger.error("파일 다운로드 중 다음 에러 발생:"+ex.getMessage());
		}
		
	}
	@RequestMapping("/defectTreeCallback")
	public @ResponseBody List<Map<String,Object>> getDefectTreeData(Locale locale){
		return service.getDefectTreeData(locale);
	}

}
