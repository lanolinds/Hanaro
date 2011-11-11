<!-- 제작일 : 2011. 11. 2.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
	<title><fmt:message key="menu.qualityNcrManagement" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>		
	<style type="text/css">
		#headTable th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#headTable td {border:1px dotted #CBC7C4	r;width:170px;}
		#headTable input{border:0px;width:100%;}		
		
		#measureTable1 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#measureTable1 .group{background-color: #E1E8F3;}
		
		#measureTable2 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#measureTable2 .group{background-color: #E1E8F3;}
		
		#measureTable3 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#measureTable3 td {border:1px dotted #CBC7C4	r;width:170px;}
		#measureTable3 input{border:0px;width:100%;}
		
		#measureTable4 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		
		#form2 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form2 td {border:1px dotted #CBC7C4	r;width:170px;}
		#form2 input{border:0px;width:100%;}
		#form2 .group{background-color: #E1E8F3;}
		.fileDown{cursor:pointer;color:blue;font-weight:bold;}
		.fileDelete{cursor:pointer;}								
		
		
	</style>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	<script type="text/javascript">
	

	//임시파일 등록처리
	function insertReasonFile(){		
		var row={};
		row.DATAFIlE="";
		row.DATA0="";
		row.DATA1="";
		row.DATASTATE="a";
		$("#datagridReasonFile").datagrid("insertRow",{row:row});
	}
	//임시파일 삭제처리
	function deleteReasonFile(){
		var idx;		
		idx = $("#datagridReasonFile").datagrid("getSelected");
		if(!idx)
		{
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}	
		idx = $("#datagridReasonFile").datagrid("getRowIndex",idx);
		var row={};		
		row.DATA0="delete";
		row.DATASTATE="d";
		$("#datagridReasonFile").datagrid("updateRow",{index:idx,row:row});		
	}
	//임시파일 업데이트처리
	function updateReason(){
		var row;		
		row = $("#datagridReasonFile").datagrid("getSelected");
		idx = $("#datagridReasonFile").datagrid("getRowIndex",row);
		if(row.DATASTATE=="a"  || row.DATASTATE=="d")
			return;
		var row={};		
		row.DATA0="update";
		row.DATASTATE="u";
		$("#datagridReasonFile").datagrid("updateRow",{index:idx,row:row});			
	}	
	
	function rFile(value){
		return "<input type='file' name='inputAddFile' onchange='javascript:updateReason()' size='11' />";
	}
	function rFileName(value){		
		if(value=="delete")
			return "<fmt:message key='ui.label.reserveDelete' />";
		else if(value=="update")
			return "<fmt:message key='ui.label.reserveUpdate' />";
		else if(value!=""){
			var fileName = value.split('?')[0];
			var fileSeq = value.split('?')[1];
			return "<a  class='fileDown' href='getNcrMeasureReasonFile?ncrNo=${ncrInForm.ncrNo}&fileName="+encodeURIComponent(fileName)+"&fileSeq="+fileSeq+"' ><span class='icon-attach' style='width:16px;'' >&nbsp;</span>"+fileName+"</a>";
		}else
			return "";		
	}
	function rFileSeq(value){		
		return "<input type='hidden' name='reasonFileSeq' value='"+value+"' />";
	}
	function rFileState(value){
		return "<input type='hidden' name='reasonFileState' value='"+value+"' />";
	}
	
	

	
	//임시대책 처리	
	function insertTempData(){
		var row={};
		row.DATA0="";
		row.DATA1="";
		$("#datagridTempMeasure").datagrid("insertRow",{row:row});
	}
	
	function tMeasure(value){		
		return "<textarea name='tempMeasure' cols='29' rows='3'>"+value+"</textarea>";
	}
	function tMeasureDate(value){		
		return "<input type='text' size='9' name='tempMeasureDate' value='"+value+"' />";
	}	
	
	//근본대책 처리	
	function insertMeasureData(){
		var row={};
		row.DATA0="";
		row.DATA1="";
		$("#datagridMeasure").datagrid("insertRow",{row:row});
	}
	
	function measure(value){
		return "<textarea name='measure' cols='29' rows='3'>"+value+"</textarea>";
	}
	function measureDate(value){
		return "<input type='text' size='9' name='measureDate' value='"+value+"'  />";
	}
	
	
	//부적합 전/후 LOT확인
	function insertLotConfirm(){
		var row={};
		row.DATA0="";
		row.DATA1="";
		row.DATA2="";
		$("#datagridLotConfirm").datagrid("insertRow",{row:row});		
	}
	
	function lot(value){
		return "<input type='text' size='9' name='lotNo' value='"+value+"'  />";
	}
	function confirm(value){
		return "<input type='text' size='30' name='confirm' value='"+value+"' />";
	}
	function remark(value){
		return "<input type='text' size='27' name='remark' value='"+value+"' />";	
	}

	//표준반영사항 기준4개 파일 상태 변경
	function modifyFile(state,thisP){
		
		$("input[name='inputChangeState']",thisP.parent().parent()).val(state);
		if(state=="d")		
			thisP.parent().empty().append("<fmt:message key='ui.label.reserveDelete' />");
		
	}
	
	
	
	//표준반영사항 등록처리
	function insertStandard(){
		var row={};
		row.DATA0="";
		row.stanFile="";
		row.DATA1="";
		row.DATASTATE="a";
		$("#datagridStandard").datagrid("insertRow",{row:row});		
	}
	function deleteStandard(){
		var idx;		
		idx = $("#datagridStandard").datagrid("getSelected");
		if(!idx)
		{
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}	
		idx = $("#datagridStandard").datagrid("getRowIndex",idx);
		var row={};		
		row.DATA1="delete";
		row.DATASTATE="d";
		$("#datagridStandard").datagrid("updateRow",{index:idx,row:row});			
	}
	function updateStandard(){
		var row;		
		row = $("#datagridStandard").datagrid("getSelected");
		idx = $("#datagridStandard").datagrid("getRowIndex",row);
		if(row.DATASTATE=="a" || row.DATASTATE=="d")
			return;
		var row={};		
		row.DATA1="update";
		row.DATASTATE="u";
		$("#datagridStandard").datagrid("updateRow",{index:idx,row:row});	
	}
	
	function stanContent(value){
		return "<textarea name='stanContents' cols='34' rows='3'>"+value+"</textarea>";
	}
	function stanFile(value){
		return "<input type='file' name='stanFile' size='1' onchange='javascript:updateStandard()'  />"; 
	}
	function stanFileName(value){
		if(value=="delete")
			return "<fmt:message key='ui.button.Delete' />";
		else if(value=="update")
			return "<fmt:message key='ui.label.change' />";
		else if(value!=""){
			var fileName = value.split('?')[0];
			var fileSeq = value.split('?')[1];
			return "<a  class='fileDown' href='getNcrMeasureStandardFile?ncrNo=${ncrInForm.ncrNo}&fileName="+encodeURIComponent(fileName)+"&fileSeq="+fileSeq+"' ><span class='icon-attach' style='width:16px;'' >&nbsp;</span><fmt:message key='ui.label.down' /></a>";
		}else
			return "";
	}
	function stanState(value){
		return "<input type='hidden' name='standardState' value='"+value+"' />";
	}	
	function stanEtcSeq(value){
		return "<input type='hidden' name='standardEtcSeq' value='"+value+"' />";
	}
	
	
	
	
	 
	

	//dataGrid ID를 인자로 받아 해당 Grid에 선택된 아이템을 삭제한다.
	function deleteDataGrid(dataGridName){
		
		var idx;		
		idx = $("#"+dataGridName).datagrid("getSelected");
		if(!idx)
		{
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		idx = $("#"+dataGridName).datagrid("getRowIndex",idx);
		$("#"+dataGridName).datagrid("deleteRow",idx);
	}	
	
	//대책서를 등록한다.
	function insertData(){
		if($("#form1").form("validate")){			
			$("#form1").submit();			
		}else{
			return false;
		}
	}
	//대책서를 수정한다.
	function updateData(){
		if($("#form1").form("validate")){
			document.form1.measureProcType.value = "UPDATE";
			$("#form1").submit();			
		}else{
			return false;
		}		
	}
	
	//대책서를 삭제한다.
	function deleteData(){
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='warn.wannaDelete' />",function(r){  
		    if (r){  
				document.form1.measureProcType.value = "DELETE";
				$("#form1").submit();	  
		    }  
		});			

	}
	
	$(document).ready(function(){
		$("#datagridReasonFile").datagrid({queryParams:{ncrNo:$("#ncrNo").val(),gridType:"reasonFile"}});
		$("#datagridTempMeasure").datagrid({queryParams:{ncrNo:$("#ncrNo").val(),gridType:"tempMeasure"}});
		$("#datagridMeasure").datagrid({queryParams:{ncrNo:$("#ncrNo").val(),gridType:"measure"}});
		$("#datagridLotConfirm").datagrid({queryParams:{ncrNo:$("#ncrNo").val(),gridType:"lotConfirm"}});
		$("#datagridStandard").datagrid({queryParams:{ncrNo:$("#ncrNo").val(),gridType:"standardEtc"}});
		
		$(".fileDelete").live("click",function(){
			modifyFile('d',$(this));
		});
		
	});
	
	
	
	</script>

</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="center" style="padding:10px;">
	<form:form id="form1" name="form1" modelAttribute="ncrInForm" enctype="multipart/form-data" action="procNcrMeasure">
	<table>
		<tr>
			<td>
			
				<div iconCls="icon-table-chart" class="easyui-panel" style="width:600px;height:725px;" title='<fmt:message key="ui.label.ncrInformReport"/>'>
					
						<table style="padding:10px;" class="groupTable" width="100%" id="headTable">
							<tr>
								<th colspan='4' ><label class="label-Leader-blue"><fmt:message key="ui.label.Occur" /></label><hr/></th>								
							</tr>						
							<tr>
								<th><label><fmt:message key="ui.label.title" /></label></th>
								<td><form:input path="title" class="easyui-validatebox" required="true" style="color:blue;" /></td>
								<th><label><fmt:message key="ui.label.ncrNo" /></label></th>
								<td>
									<form:input path="ncrNo" readonly="true" id="ncrNo" />
									<input type="hidden" name="measureProcType" value="INSERT" >
								</td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.PartNo" /></label></th>
								<td><input type="text"   readonly="true" value="${sheetMap.occurPartNo}" /></td>
								<th><label><fmt:message key="ui.label.PartName" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.occurPartName}"  /></td>
							</tr>

						    <tr>
								<th><label><fmt:message key="ui.label.QualityIssue.OccurSite" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.occurSite}"  /></td>
								<th><label><fmt:message key="ui.label.CarModel" /></label></th>
								<td><input type="text"   readonly="true"    value="${sheetMap.carmodel}"  /></td>			
							</tr>								
							<tr>
								<th><label><fmt:message key="ui.label.QualityIssue.OccurPlace" /></label></th>
								<td><input type="text"  readonly="true"   value="${sheetMap.occurPlace}"  /></td>							
								<th><label><fmt:message key="ui.label.OccurDate" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.occurDate}"  /></td>
							</tr>		
			
							<tr>
								<th><label><fmt:message key="ui.label.RegPlace" /></label></th>
								<td><input type="text"  readonly="true"  value="${sheetMap.regCust}" /></td>
								<th><label><fmt:message key="ui.label.QualityIssue.DefectL" /></label></th>
								<td><input type="text"   readonly="true" value="${sheetMap.defectL}"  /></td>																								
							</tr>
							<tr>

								<th><label><fmt:message key="ui.label.QualityIssue.DefectM" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.defectM}"   /></td>
								<th><label><fmt:message key="ui.label.QualityIssue.DefectS" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.defectS}"   /></td>																
							</tr>
							<tr><th colspan='4'></th></tr>																			
							<tr>
								<th colspan='4'  ><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.phenomenonContents" /></label><hr /></th>								
							</tr>
							<tr>
								<th colspan="2" rowspan="7">
									<img src=<c:url value="/resources/images/no_image.jpg" /> width="300px" height="170px"/>								
								</th>								
								<th><label><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.rPartNo}"  /></td>
							</tr>
							<tr>																
								<th><label><fmt:message key="ui.label.qualityIssue.reasonPartName" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.rPartNm}" /></td>
							</tr>				
							<tr>								
								<th><label><fmt:message key="ui.label.QualityIssue.DefectAmount" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.defectAmount}" /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.LotNo" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.lot}" /></td>
							</tr>		
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.4m1" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.reason1}"  /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.4m2" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.reason2}" /></td>
							</tr>											
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.analysisName" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.reason3}"  /></td>
							</tr>		
							<tr>
								<th colspan="2" rowspan="7">
									<img src=<c:url value="/resources/images/no_image.jpg" /> width="300px" height="180px" />
								</th>
								<th><label><fmt:message key="ui.label.qualityIssue.reasonExplanation" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.remark}" /></td>														

							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.requestContents" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.requestContent}"  /></td>
							</tr>				
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.sampleReceiveDate" /></label></th>
								<td><form:input path="sampleDate" class="easyui-datebox" editable="false"  style="color:blue;" /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.supplierApplyDate" /></label></th>
								<td><form:input  path="supplierDate" class="easyui-datebox"  editable="false" style="color:blue;"  /></td>
							</tr>		
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.insideIncomeDate" /></label></th>
								<td><form:input  path="insideIncomeDate" class="easyui-datebox"   editable="false" style="color:blue;" /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.procApplyDate" /></label></th>
								<td><form:input  path="applyProcDate" class="easyui-datebox"  editable="false" style="color:blue;"  /></td>
							</tr>											
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.custApplyDate" /></label></th>
								<td><form:input   path="applyCustDate" class="easyui-datebox"   editable="false" style="color:blue;" /></td>
							</tr>																													
							<tr>
								<th><label><fmt:message key="ui.label.refDoc" /></label></th>
								<th></th>
								<th><label><fmt:message key="ui.label.qualityIssue.measureLimitDate" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.measureRequestDt}" /></td>
							</tr>
							<tr><th colspan='4'></th></tr>																																																				
							<tr>
								<th colspan='4'  ><label class="label-Leader-blue"><fmt:message key="ui.label.ncrPublish" /></label><hr /></th>								
							</tr>											
							<tr>
								<th><label><fmt:message key="ui.label.publishOrgan" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.actionDept}" /></td>
								<th><label><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.reasonCust}" /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.manager" /></label></th>
								<td><input type="text"   readonly="true"  value="${sheetMap.actionBy}"  /></td>
								<th><label><fmt:message key="ui.label.manager" /></label></th>
								<td><form:input path="custManager" style="color:blue;" class="easyui-validatebox" required="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.confirmer" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.actionBy}" /></td>
								<th><label><fmt:message key="ui.label.confirmer" /></label></th>
								<td><form:input path="custConfirmer" style="color:blue;"  class="easyui-validatebox" required="true"  /></td>
							</tr>			
							<tr>
								<th><label><fmt:message key="ui.label.approver" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.actionByCap}" /></td>
								<th><label><fmt:message key="ui.label.approver" /></label></th>
								<td><form:input path="custAppover" style="color:blue;" class="easyui-validatebox" required="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.publishDate" /></label></th>
								<td><input type="text"   readonly="true"   value="${sheetMap.actionDt}" /></td>
								<th><label><fmt:message key="ui.label.qualityIssue.measureReplyDate" /></label></th>
								<td><input type="text"   readonly="true"  style="color:blue;"  value="${sheetMap.measureDate}" /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.ncrTreatReport"><fmt:param value=""/></fmt:message></label></th>
								<td><input type="file" name="treatFile" /></td>
								<th colspan="2">								
								<c:if test="${!sheetMap.measureFileName.equals('')}">
									<a href="getNcrMeasureFile?ncrNo=${ncrInForm.ncrNo}&fileName=${sheetMap.measureFileName}">
										<span class="icon-attach" style="width:16px;" >&nbsp;</span>
										<fmt:message key="ui.label.File" />
									</a>
								</c:if>
								</th>
							</tr>																																																													
																																								
							</table>
						
				</div>
			</td>
			<td>
				<div class="easyui-tabs"  style="width:500px;height:725px;">
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='1' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.reasonAnlysis'/> " >
					  
					  	<table style="padding:10px;" class="groupTable" width="100%" id="measureTable1">
							<tr>
								<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.reasonIssue" /></label></th>								
							</tr>	
							<tr>								
								<th colspan="2">
								<form:textarea path="reasonIssue" rows="4" cols="66" />
								</th>
							</tr>
							<tr>
								<th>
									<c:choose>
										<c:when test="${!ncrInForm.imgReason1FileName.equals('')}">
											<img id="imgReason1" src=<c:url value="getNcrMeasureImg?ncrNo=${ncrInForm.ncrNo}&fileSeq=1" /> width="240px" height="180px" />
										</c:when>
										<c:otherwise>
										<img id="imgReason1" src=<c:url value="/resources/images/no_image.jpg" /> width="240px" height="180px" />
										</c:otherwise>
									</c:choose>
								</th>							
								<th>
									<c:choose>
										<c:when test="${!ncrInForm.imgReason2FileName.equals('')}">
											<img id="imgReason2" src=<c:url value="getNcrMeasureImg?ncrNo=${ncrInForm.ncrNo}&fileSeq=2" /> width="240px" height="180px" />
										</c:when>
										<c:otherwise>
											<img id="imgReason2" src=<c:url value="/resources/images/no_image.jpg" />  width="240px" height="180px" />
										</c:otherwise>
									</c:choose>	
								</th>
							</tr>
							<tr>								
								<th>
									<input type="file" name="imgReasonFile1" />
								</th>
								<th>
									<input type="file" name="imgReasonFile2" />
								</th>
							</tr>
							<tr><th colspan='2'></th></tr>														
							<tr>
								<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.reasonOutflow" /></label></th>								
							</tr>								
							<tr>								
								<th colspan="2">
								<form:textarea path="reasonOutflow"  rows="4" cols="66"/>
								</th>
							</tr>	
						    <tr><th colspan='2'></th></tr>														
							<tr>
								<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.reasonCheckDetailList" /></label></th>								
							</tr>								
							<tr>								
								<th colspan="2">
								<table id="datagridReasonFile"  style="width:490px;height:200px;"  toolbar="#pageNavForReasonfile" pageSize="100" fitColumns="true" singleSelect="true" striped="true"
								url="getNcrMeasureDataGrid" >
									<thead >
										<tr >
											<th field="DATAFILE" width="200px" resizable="false" formatter="rFile"><fmt:message key="ui.label.File" /></th>
											<th field="DATA0" width="290px" resizable="false" formatter="rFileName"></th>
											<th field="DATA1" hidden="true" formatter="rFileSeq"></th>
											<th field="DATASTATE" hidden="true" formatter="rFileState"></th>
										</tr>
									</thead>									
								</table>
								</th>
							</tr>																								
					  	</table>
					  
					  </div>  
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='2' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.measure'/> " >  
						
							<table style="padding:10px;" class="groupTable" width="100%" id="measureTable2">
								<tr>
									<th colspan="2" class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.tempMeasure" /></label></th>								
								</tr>	
								<tr>								
									<th rowspan="2">
										<table  id="datagridTempMeasure"  style="width:340px;height:200px;"   nowrap="false" toolbar="#pageNavForTempMeasure" pageSize="100" fitColumns="true" singleSelect="true" striped="true" url="getNcrMeasureDataGrid"  > 
											<thead>
												<tr>
													<th field="DATA0"  resizable="false" width="240" formatter="tMeasure" ><fmt:message key="ui.label.contents" /></th>
													<th field="DATA1" resizable="false"  width="90" formatter="tMeasureDate" ><fmt:message key="ui.label.date" /></th>
												</tr>
											</thead>
										</table>
									</th>
									<th>
										<c:choose>
											<c:when test="${!ncrInForm.imgTempMeasureFileName.equals('')}">
												<img src=<c:url value="getNcrMeasureImg?ncrNo=${ncrInForm.ncrNo}&fileSeq=3" /> width="125px" height="175px" />
											</c:when>
											<c:otherwise>
												<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
											</c:otherwise>
										</c:choose>
									</th>
								</tr>
								<tr>
									<th>
										<input type="file" name="imgTempNameFile"  size="1" />
									</th>
								</tr>
						        <tr><th colspan='2'></th></tr>								
								<tr>	
									<th colspan="2" class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.fundMeasure" /></label></th>								
								</tr>									
								<tr>								
									<th rowspan="4">
										<table  id="datagridMeasure"   style="width:340px;height:410px;"   nowrap="false" toolbar="#pageNavForMeasure" pageSize="100" fitColumns="true" singleSelect="true" striped="true" url="getNcrMeasureDataGrid" > 
											<thead>
												<tr>
													<th field="DATA0" resizable="false"  width="240"  formatter="measure"><fmt:message key="ui.label.contents" /></th>
													<th field="DATA1"  resizable="false"  width="90" formatter="measureDate" ><fmt:message key="ui.label.date" /></th>
												</tr>
											</thead>
										</table>
									</th>
									<th>
										<c:choose>
											<c:when test="${!ncrInForm.imgMeasure1FileName.equals('')}">
												<img src=<c:url value="getNcrMeasureImg?ncrNo=${ncrInForm.ncrNo}&fileSeq=4" /> width="125px" height="175px" />
											</c:when>
											<c:otherwise>
												<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
											</c:otherwise>
										</c:choose>
									</th>
								</tr>							
								<tr>
									<th>
										<input type="file" name="imgMeasureName1File"  size="1" />
									</th>
								</tr>
								<tr>
									<th>
										<c:choose>
											<c:when test="${!ncrInForm.imgMeasure2FileName.equals('')}">
												<img src=<c:url value="getNcrMeasureImg?ncrNo=${ncrInForm.ncrNo}&fileSeq=5" /> width="125px" height="175px" />
											</c:when>
											<c:otherwise>
												<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
											</c:otherwise>
										</c:choose>
									</th>
								</tr>
								<tr>
									<th>
										<input type="file" name="imgMeasureName2File"  size="1" />
									</th>
								</tr>
						        <tr><th colspan='2'></th></tr>								
								<tr>
									<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.lotConfirm" /></label></th>								
								</tr>								
								<tr>								
									<th colspan="2">
									<table id="datagridLotConfirm" url="getNcrMeasureDataGrid"  style="width:473px;height:200px;"  toolbar="#pageNavForLotConfirm" pageSize="100" fitColumns="true" singleSelect="true" striped="true" >
										<thead >
											<tr >
												<th field="DATA0" width="90px" resizable="false" formatter="lot"><fmt:message key="ui.label.LotNo" /></th>
												<th field="DATA1" width="200px" resizable="false" formatter="confirm"><fmt:message key="ui.label.qualityIssue.confirmPhenomenon" /></th>
												<th field="DATA2" width="185px" resizable="false" formatter="remark"><fmt:message key="ui.label.remark" /></th>
											</tr>
										</thead>									
									</table>
									</th>
								</tr>																																								
							</table>
																	
					  </div>
					  
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='3' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.applyStandard'/> " >
						
							<table style="padding:10px;" class="groupTable" width="100%" id="measureTable3">
							<c:forEach items="${stanNames}"  var="item" varStatus="state" >
								<tr>
									<th colspan='3'><label class="label-Leader-black"><fmt:message key="${item}" /></label></th>								
								</tr>
								<tr>
									<th><fmt:message key="ui.label.beforeChange" /></th>
									<td colspan='2'>			
										<input type="text" name="inputBeforChange" value="${standard[state.index].DATA0}" />
										<input type="hidden" name="inputStandardSeq" value="${state.count}" />
									</td>
								</tr>		
								<tr>
									<th><fmt:message key="ui.label.afterChange" /></th>
									<td colspan='2'><input type="text" name="inputAfterChange" value="${standard[state.index].DATA1}" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.changeDate" /></th>
									<td colspan='2'><input class="easyui-datebox"  editable="false"  name="inputChangeDate" value="${standard[state.index].DATA2}"  /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.File" /></th>
									<td>
										<input type="file" name="inputChangeFile" size="1"  />
										<input type="hidden" name="inputChangeState" />
									</td>
									<td style="width:150px;">
									
									<c:if test="${standard[state.index].DATA3!='' && standard[state.index].DATA3!=null}">
									<a  href="getNcrMeasureStandardFile?ncrNo=${ncrInForm.ncrNo}&fileName=${standard[state.index].DATA3}&fileSeq=${state.count}" title="${standard[state.index].DATA3}" class="fileDown">[<fmt:message key="ui.label.File" />]</a>
									<span class="icon-delete fileDelete" style="width:16px;">&nbsp;</span>
									</c:if>	
									</td>
								</tr>																																																																										
								</c:forEach>
								<tr>
									<th colspan='3'><label class="label-Leader-black"><fmt:message key="ui.label.etc" /></label></th>								
								</tr>	
							</table>
							<table style="padding:10px;" class="groupTable" width="100%" id="measureTable4">
								<tr>	
									<th colspan="3">
									<table id="datagridStandard" url="getNcrMeasureDataGrid"  style="width:473px;height:200px;"  toolbar="#pageNavForStandard" pageSize="100" fitColumns="true" singleSelect="true" striped="true" >
										<thead >
											<tr >
												<th field="DATA0" width="283px" resizable="false" formatter="stanContent"><fmt:message key="ui.label.contents" /></th>
												<th field="stanFile" width="140px" resizable="false" formatter="stanFile"><fmt:message key="ui.label.File" /></th>
												<th field="DATA1" width="50px" resizable="false" formatter="stanFileName"></th>
												<th field="DATASTATE" hidden="true" formatter="stanState" ></th>
												<th field="DATA2" hidden="true" formatter="stanEtcSeq" ></th>
												
											</tr>
										</thead>									
									</table>
									</th>
								</tr>													
							</table>												
					  </div>  			
					  <c:if test="${ncrInForm.status=='AGREE'}">
					  <div title='<fmt:message key="ui.label.evaluation"/>'  id="displayValuation">  
						<form id="form2" enctype="multipart/form-data" action="addNcrMeasureEvaluation">
							<table style="padding:10px;" class="groupTable" width="100%">
								<tr>
									<th colspan='3' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.ncrEvaluation" /></label></th>								
								</tr>				
								<tr>
									<th><fmt:message key="ui.label.evaluation"/><fmt:message key="ui.label.contents" /></th>
									<td>
										<textarea name="inputEvaluation" cols=35 rows=5 ></textarea>
										<input type="hidden" name="validateProcType" value="INSERT" >
										<input type="hidden" name="validateNcrNo">
									</td>
									<th><img src='<c:url value="/resources/images/samsong_logo.gif" />'  width="100px" height="80px" /></th>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.evaluation"/><fmt:message key="ui.label.Result" /></th>
									<td colspan="2">
										<select name="selectEvaluationResult"   class="easyui-validatebox"  required="true">
											<option value=""><fmt:message key="ui.element.Select" /></option>
											<option value="GOOD">GOOD</option>
											<option value="BAD">BAD</option>
										</select>
									</td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.File" /></th>
									<td colspan="2"><input type="file" name="inputEvaluationFile" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.manager" /></th>
									<td colspan="2"><input class="easyui-validatebox" name="evalManager" required="true" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.confirmer" /></th>
									<td colspan="2"><input class="easyui-validatebox" name="evalConfirmer" required="true" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.approver" /></th>
									<td colspan="2"><input class="easyui-validatebox" name="evalApprover" required="true" /></td>
								</tr>																											
							</table>		
							</form>		
					  </div>
					  </c:if>
					    				
				</div>
											
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#" iconCls="icon-disk" class="easyui-linkbutton" onclick="javascript:insertData();"><fmt:message key="ui.button.Reg" /></a>
				<a href="#" iconCls="icon-pencil" class="easyui-linkbutton" onclick="javascript:updateData();" ><fmt:message key="ui.button.Edit" /></a>
				<a href="#" iconCls="icon-delete" class="easyui-linkbutton" onclick="javascript:deleteData();" ><fmt:message key="ui.button.Delete" /></a>
				<a href="#" iconCls="icon-information" class="easyui-linkbutton"><fmt:message key="ui.button.inform" /></a>
				<a href="#" iconCls="icon-comment-delete" class="easyui-linkbutton"><fmt:message key="ui.button.reject" /></a>
				<a href="#" iconCls="icon-accept" class="easyui-linkbutton"><fmt:message key="ui.button.agree" /></a>
				<a href="#" iconCls="icon-table-edit" class="easyui-linkbutton"><fmt:message key="ui.button.evaluation" /></a>
				<a href="#" iconCls="icon-arrow-redo" class="easyui-linkbutton"><fmt:message key="ui.button.Cancel" /></a>
			</td>
		</tr>
	</table>
	</form:form>
</div>


<div id="pageNavForReasonfile">
	<table width="100%">
		<tr>
			<td align="right">						
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertReasonFile();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteReasonFile();"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>

<div id="pageNavForTempMeasure">
	<table width="100%">
		<tr>
			<td align="right">			
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertTempData();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteDataGrid('datagridTempMeasure');"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>

<div id="pageNavForMeasure">
	<table width="100%">
		<tr>
			<td align="right">			
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertMeasureData();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteDataGrid('datagridMeasure');"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>

<div id="pageNavForLotConfirm">
	<table width="100%">
		<tr>
			<td align="right">						
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertLotConfirm();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteDataGrid('datagridLotConfirm');"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>

<div id="pageNavForStandard">
	<table width="100%">
		<tr>
			<td align="right">						
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertStandard();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteStandard();"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>


</body>

</html>
