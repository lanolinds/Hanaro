<!-- 제작일 : 2011. 11. 1.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.qualityNcrManagement" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		.fileDown{cursor:pointer;color:blue;font-weight:bold;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	//NCR현황조회하기
	function searchList(){
		var params = {};
		params.division = $("#searchDivision").val();
		params.occurSite = $("#searchOccurSite").val(); 
		params.stdDt = $("#searchStdDt").datebox("getValue");
		params.endDt=$("#searchEndDt").datebox("getValue");
		params.reasonCust="";
		params.publishCust="";
		if(eval("${isEMP}")){
			params[$("input[name='selectType']:checked").val()] = "${deptCd}";	
		}else{
			params.reasonCust= "${deptCd}";			
		}
		$("#resultDataGrid").datagrid("load",params);
	}
	function fileDown(value,rowData){
		var ncrNo = rowData.DATA0;				
		var format = "";		
		if(value !="")
			format = "<a  href='getNcrMeasureFile?ncrNo="+ncrNo+"&fileName="+encodeURIComponent(value)+"'  class='icon-disk' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>";
		return format;
	}	
	function status(value,rowData){
		var text = "";
		switch(value){
			case "": text="<fmt:message key='ui.label.ncr.state.wait' />"; break;
			case "REG": text="<fmt:message key='ui.label.ncr.state.reg' />("+rowData.DATA13+")"; break;
			case "PLAN": text="<fmt:message key='ui.label.ncr.state.plan' />"; break;
			case "AGREE": text="<fmt:message key='ui.label.ncr.state.agree' />"; break;
			case "REJECT": text="<fmt:message key='ui.label.ncr.state.reject' />"; break;
			case "RETRY": text="<fmt:message key='ui.label.ncr.state.retry' ><fmt:param value='"+(rowData.DATA14+1)+"' /></fmt:message>"; break;
			case "GOOD": text="<fmt:message key='ui.label.ncr.state.finish' />"; break;
			case "BAD": text="<fmt:message key='ui.label.ncr.state.finish' />"; break;
			default : text=""; break;
		}	
		return"<span class='fileDown' onclick='javascript:popDetail("+rowData.DATA0+")'><b>"+text+"</b></span>";
	}

	function popDetail(value){
         var win = window.open("ncrManageDetail?ncrNo="+value,"NCRDetail", "width=1145,height=797,location=no,menubar=no,resizable=no,scrollbars=yes,status=no,toolbar=no");
         win.focus();
	}
	
	$(document).ready(function(){
		
		
		//조회용 처리구분 선택시 조회용출처옵션 변경
		$("#searchDivision").change(function(){
			$.get("codeDefectSourceCallback",{parentCode:$(this).val(),t: new Date().getTime()},function(map){
				var options="<option value=''>"+"<fmt:message key='ui.element.All'/>"+"</option>";				
				for(var key in map){
					options+='<option value='+key+'>'+map[key]+'</option>';
				}
				$("#searchOccurSite").empty().append(options);
			});
		});
		
		

	});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
			<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:900px;height:725px;" 
				title='<fmt:message key="menu.qualityNcrStatus"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"   singleSelect="true" striped="true"   url="getNCRList">
					<thead>
				       <tr>
				            <th field="DATA0" width="110" sortable="true" align="center"><fmt:message key="ui.label.ncrNo" /></th>  
				            <th field="DATA1" width="150" sortable="true" align="center" formatter="status"><fmt:message key="ui.label.progressStatus" /></th>  
				            <th field="DATA2" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurSite" /></th>
				            <th field="DATA3" width="70" sortable="true" align="center"><fmt:message key="ui.label.publishDate" /></th>
				            <th field="DATA4" width="70" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.measureLimitDate" /></th>
				            <th field="DATA5" width="100" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>
				            <th field="DATA6" width="100" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>  
				            <th field="DATA7" width="160" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonPartName" /></th>
				            <th field="DATA8" width="110" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.analysisName" /></th>
				            <th field="DATA9" width="100" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurPartNo" /></th>
				            <th field="DATA10" width="160" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurPartNm" /></th>
				            <th field="DATA11" width="100" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.DefectS" /></th>
				            <th field="DATA12" width="60" sortable="true" align="center" formatter="fileDown" ><fmt:message key="ui.label.File"  /></th>
				            <th field="DATA13" hidden="true"></th>
				            <th field="DATA14" hidden="true"></th>								
    				  </tr> 
					</thead>
					
				</table>
</div>
<div id="divSearch" style="padding:0px;height:auto">
       <div style="padding:5px;">        
         <fmt:message key="ui.label.QualityIssue.Division"/>
		<select  id='searchDivision' >
		<option value=""><fmt:message key="ui.element.All"/></option>									
				<c:forEach items="${defectSource }"  var="item" >
					<option value="${item.key }"> ${item.value }</option>
				</c:forEach>
		</select>
		 <fmt:message key="ui.label.QualityIssue.OccurSite"/>         
		<select  id='searchOccurSite' style="width:100px;">
				<option value=''><fmt:message key="ui.element.All"/></option>
		</select>
		 <fmt:message key="ui.label.SearchDate"/>
		<input id="searchStdDt" class="easyui-datebox" style="width:90px;"  value="${today}"  />~
		<input id="searchEndDt" class="easyui-datebox" style="width:90px;"  value="${today}"  />
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>		
		  
     </div>
     <c:if test="${isEMP}">
     <div style="background-color:#CFDBEC;"  style="padding:5px;">
        <fmt:message key="ui.label.applyTerm"/>
        <input type="radio"  name="selectType" value="all" checked /><fmt:message key="ui.element.All" />
     	<input type="radio"  name="selectType" value="reasonCust" /><fmt:message key="ui.label.quality.reasonTerm" />
     	<input type="radio" name="selectType" value="publishCust" /><fmt:message key="ui.label.quality.publishTerm" />
     	&nbsp;&nbsp;&nbsp;<span style="color:red;"><fmt:message key="info.label.applyTerm"/></span>
     </div>
     </c:if>
 
 </div>  
</body>

</html>
