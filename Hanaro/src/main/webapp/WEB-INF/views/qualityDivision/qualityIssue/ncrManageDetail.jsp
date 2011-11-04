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
		#form1 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form1 td {border:1px dotted #CBC7C4	r;width:170px;}
		#form1 input{border:0px;width:100%;}		
		
		#form2 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form2 .group{background-color: #E1E8F3;}
		
		#form3 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form3 .group{background-color: #E1E8F3;}
		
		#form4 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form4table td {border:1px dotted #CBC7C4	r;width:170px;}
		#form4table input{border:0px;width:100%;}
		
		#form5 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form5 td {border:1px dotted #CBC7C4	r;width:170px;}
		#form5 input{border:0px;width:100%;}
		#form5 .group{background-color: #E1E8F3;}								
		
		
	</style>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	<script type="text/javascript">
	

	//임시파일 등록처리
	function insertReasonFile(){		
		var row={};
		row.reasonFile="<input type='file' name='inputAddFile' size='11' />";
		$("#datagridReasonFile").datagrid("insertRow",{row:row});
	}

	
	//임시대책 처리	
	function insertTempData(){
		var row={};
		row.tempMeasureContents="<textarea name='tempMeasure' cols='29' rows='3'></textarea>";
		row.tempMeasureDate="<input type='text' size='9' name='tempMeasureDate'  />";
		$("#datagridTempMeasure").datagrid("insertRow",{row:row});
	}
	
	//근본대책 처리
	
	function insertMeasureData(){
		var row={};
		row.measureContents="<textarea name='measure' cols='29' rows='3'></textarea>";
		row.measureDate="<input type='text' size='9' name='measureDate'  />";
		$("#datagridMeasure").datagrid("insertRow",{row:row});
	}
	
	//부적합 전/후 LOT확인
	function insertLotConfirm(){
		var row={};
		row.lotNo="<input type='text' size='9' name='lotNo'  />";
		row.contents="<input type='text' size='30' name='confirm'  />";
		row.remark="<input type='text' size='27' name='remark'  />";
		$("#datagridLotConfirm").datagrid("insertRow",{row:row});		
	}
	
	//표준반영사항 처리
	function insertStandard(){
		var row={};
		row.stanContents="<textarea name='stanContents' cols='34' rows='3'></textarea>";
		row.stanFile="<input type='file' name='stanFile' size='1'  />";
		row.stanFileDown="";
		$("#datagridStandard").datagrid("insertRow",{row:row});		
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
	
	
	
	</script>

</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="center" style="padding:10px;">
	<table>
		<tr>
			<td>
				<div iconCls="icon-table-chart" class="easyui-panel" style="width:600px;height:725px;" title='<fmt:message key="ui.label.ncrInformReport"/>'>
					<form:form id="form1" modelAttribute="ncrInForm" >
						<table style="padding:10px;" class="groupTable" width="100%">
							<tr>
								<th colspan='4' ><label class="label-Leader-blue"><fmt:message key="ui.label.Occur" /></label><hr/></th>								
							</tr>						
							<tr>
								<th><label><fmt:message key="ui.label.title" /></label></th>
								<td><form:input path="title" /></td>
								<th><label><fmt:message key="ui.label.ncrNo" /></label></th>
								<td><form:input path="ncrNo" readonly="true" /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.PartNo" /></label></th>
								<td><input type="text"   readonly="true" /></td>
								<th><label><fmt:message key="ui.label.PartName" /></label></th>
								<td><input type="text"   readonly="true" /></td>
							</tr>

						    <tr>
								<th><label><fmt:message key="ui.label.QualityIssue.OccurSite" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.CarModel" /></label></th>
								<td><input type="text"   readonly="true"  /></td>			
							</tr>								
							<tr>
								<th><label><fmt:message key="ui.label.QualityIssue.OccurPlace" /></label></th>
								<td><input type="text"  readonly="true"  /></td>							
								<th><label><fmt:message key="ui.label.OccurDate" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>		
			
							<tr>
								<th><label><fmt:message key="ui.label.RegPlace" /></label></th>
								<td><input type="text"  readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.QualityIssue.DefectL" /></label></th>
								<td><input type="text"   readonly="true"  /></td>																								
							</tr>
							<tr>

								<th><label><fmt:message key="ui.label.QualityIssue.DefectM" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.QualityIssue.DefectS" /></label></th>
								<td><input type="text"   readonly="true"  /></td>																
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
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr>																
								<th><label><fmt:message key="ui.label.qualityIssue.reasonPartName" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>				
							<tr>								
								<th><label><fmt:message key="ui.label.QualityIssue.DefectAmount" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.LotNo" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>		
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.4m1" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.4m2" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>											
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.analysisName" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>		
							<tr>
								<th colspan="2" rowspan="7">
									<img src=<c:url value="/resources/images/no_image.jpg" /> width="300px" height="180px" />
								</th>
								<th><label><fmt:message key="ui.label.qualityIssue.reasonExplanation" /></label></th>
								<td><input type="text"   readonly="true"  /></td>														

							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.requestContents" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>				
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.sampleReceiveDate" /></label></th>
								<td><form:input path="sampleDate" class="easyui-datebox"   /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.supplierApplyDate" /></label></th>
								<td><form:input  path="supplierDate" class="easyui-datebox"   /></td>
							</tr>		
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.insideIncomeDate" /></label></th>
								<td><form:input  path="insideIncomeDate" class="easyui-datebox"  /></td>
							</tr>
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.procApplyDate" /></label></th>
								<td><form:input  path="applyProcDate" class="easyui-datebox"   /></td>
							</tr>											
							<tr>								
								<th><label><fmt:message key="ui.label.qualityIssue.custApplyDate" /></label></th>
								<td><form:input   path="applyCustDate" class="easyui-datebox"  /></td>
							</tr>																													
							<tr>
								<th><label><fmt:message key="ui.label.refDoc" /></label></th>
								<th></th>
								<th><label><fmt:message key="ui.label.qualityIssue.measureLimitDate" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr><th colspan='4'></th></tr>																																																				
							<tr>
								<th colspan='4'  ><label class="label-Leader-blue"><fmt:message key="ui.label.ncrPublish" /></label><hr /></th>								
							</tr>											
							<tr>
								<th><label><fmt:message key="ui.label.publishOrgan" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.manager" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.manager" /></label></th>
								<td><form:input path="custManager" class="easyui-validatebox" required="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.confirmer" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.confirmer" /></label></th>
								<td><form:input path="custConfirmer" class="easyui-validatebox" required="true"  /></td>
							</tr>			
							<tr>
								<th><label><fmt:message key="ui.label.approver" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.approver" /></label></th>
								<td><form:input path="custAppover" class="easyui-validatebox" required="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.publishDate" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
								<th><label><fmt:message key="ui.label.qualityIssue.measureReplyDate" /></label></th>
								<td><input type="text"   readonly="true"  /></td>
							</tr>
							<tr>
								<th><label><fmt:message key="ui.label.ncrTreatReport"><fmt:param value=""/></fmt:message></label></th>
								<td><input type="file" /></td>
								<th colspan="2"><span></span></th>
							</tr>																																																													
																																								
							</table>
						</form:form>
				</div>
			</td>
			<td>
				<div class="easyui-tabs"  style="width:500px;height:725px;">
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='1' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.reasonAnlysis'/> " >
					  <form:form id="form2" modelAttribute="measure1" >
					  	<table style="padding:10px;" class="groupTable" width="100%">
							<tr>
								<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.reasonIssue" /></label></th>								
							</tr>	
							<tr>								
								<th colspan="2">
								<form:textarea path="reasonIssue" rows="4" cols="66" />
								</th>
							</tr>
							<tr>								
								<th><img id="imgReason1" src=<c:url value="/resources/images/no_image.jpg" /> width="240px" height="180px" /></th>
								<th><img id="imgReason2" src=<c:url value="/resources/images/no_image.jpg" />  width="240px" height="180px" /></th>
							</tr>
							<tr>								
								<th>
									<input type="file" />
								</th>
								<th>
									<input type="file" />
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
								<table id="datagridReasonFile"  class="easyui-datagrid"  style="width:490px;height:200px;"  toolbar="#pageNavForReasonfile" pageSize="100" fitColumns="true" singleSelect="true" striped="true" >
									<thead >
										<tr >
											<th field="reasonFile" width="200px" resizable="false"><fmt:message key="ui.label.File" /></th>
											<th field="reasonFileName" width="290px" resizable="false"></th>
										</tr>
									</thead>									
								</table>
								</th>
							</tr>																								
					  	</table>
					  </form:form>
					  </div>  
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='2' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.measure'/> " >  
						<form:form id="form3" modelAttribute="measure2">
							<table style="padding:10px;" class="groupTable" width="100%">
								<tr>
									<th colspan="2" class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.tempMeasure" /></label></th>								
								</tr>	
								<tr>								
									<th rowspan="2">
										<table  id="datagridTempMeasure"   class="easyui-datagrid" style="width:340px;height:200px;"   nowrap="false" toolbar="#pageNavForTempMeasure" pageSize="100" fitColumns="true" singleSelect="true" striped="true" > 
											<thead>
												<tr>
													<th field="tempMeasureContents"  resizable="false" width="240" ><fmt:message key="ui.label.contents" /></th>
													<th field="tempMeasureDate" resizable="false"  width="90"><fmt:message key="ui.label.date" /></th>
												</tr>
											</thead>
										</table>
									</th>
									<th>
										<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
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
										<table  id="datagridMeasure"   class="easyui-datagrid" style="width:340px;height:410px;"   nowrap="false" toolbar="#pageNavForMeasure" pageSize="100" fitColumns="true" singleSelect="true" striped="true" > 
											<thead>
												<tr>
													<th field="measureContents" resizable="false"  width="240" ><fmt:message key="ui.label.contents" /></th>
													<th field="measureDate"  resizable="false"  width="90"><fmt:message key="ui.label.date" /></th>
												</tr>
											</thead>
										</table>
									</th>
									<th>
										<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
									</th>
								</tr>							
								<tr>
									<th>
										<input type="file" name="imgMeasureName1File"  size="1" />
									</th>
								</tr>
								<tr>
									<th>
										<img src=<c:url value="/resources/images/no_image.jpg" /> width="125px" height="175px"/>
									</th>
								</tr>
								<tr>
									<th>
										<input type="file" name="imgMeasureName1File"  size="1" />
									</th>
								</tr>
						        <tr><th colspan='2'></th></tr>								
								<tr>
									<th colspan='2' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.qualityIssue.lotConfirm" /></label></th>								
								</tr>								
								<tr>								
									<th colspan="2">
									<table id="datagridLotConfirm"  class="easyui-datagrid"  style="width:473px;height:200px;"  toolbar="#pageNavForLotConfirm" pageSize="100" fitColumns="true" singleSelect="true" striped="true" >
										<thead >
											<tr >
												<th field="lotNo" width="90px" resizable="false"><fmt:message key="ui.label.LotNo" /></th>
												<th field="contents" width="200px" resizable="false"><fmt:message key="ui.label.qualityIssue.confirmPhenomenon" /></th>
												<th field="remark" width="185px" resizable="false"><fmt:message key="ui.label.remark" /></th>
											</tr>
										</thead>									
									</table>
									</th>
								</tr>																																								
							</table>
						</form:form>					
					  </div>
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='3' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.applyStandard'/> " >
						<form id="form4" >
							<table style="padding:10px;" class="groupTable" width="100%" id="form4Table">
							<c:forEach items="${stanNames}"  var="item" varStatus="state" >
								<tr>
									<th colspan='2'><label class="label-Leader-black"><fmt:message key="${item}" /></label></th>								
								</tr>
								<tr>
									<th><fmt:message key="ui.label.beforeChange" /></th>
									<td>			
										<input type="text" name="inputBeforChange" />
										<input type="hidden" name="inputStandardSeq" value="${state.count}" />
									</td>
								</tr>		
								<tr>
									<th><fmt:message key="ui.label.afterChange" /></th>
									<td><input type="text" name="inputAfterChange" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.changeDate" /></th>
									<td><input class="easyui-datebox" name="inputChangeDate" /></td>
								</tr>
								<tr>
									<th><fmt:message key="ui.label.File" /></th>
									<td><input type="file" name="inputChangeFile" /></td>
								</tr>																																																																										
							</c:forEach>
								<tr>
									<th colspan='2'><label class="label-Leader-black"><fmt:message key="ui.label.etc" /></label></th>								
								</tr>	
							</table>
							<table style="padding:10px;" class="groupTable" width="100%">
								<tr>	
									<th colspan="2">
									<table id="datagridStandard"  class="easyui-datagrid"  style="width:473px;height:200px;"  toolbar="#pageNavForStandard" pageSize="100" fitColumns="true" singleSelect="true" striped="true" >
										<thead >
											<tr >
												<th field="stanContents" width="283px" resizable="false"><fmt:message key="ui.label.contents" /></th>
												<th field="stanFile" width="140px" resizable="false"><fmt:message key="ui.label.File" /></th>
												<th field="stanFileDown" width="50px" resizable="false"></th>
											</tr>
										</thead>									
									</table>
									</th>
								</tr>													
							</table>
						</form>							
					  </div>  					    
					  <div title='<fmt:message key="ui.label.evaluation"/>' >  
						<form id="form5" >
							<table style="padding:10px;" class="groupTable" width="100%">
								<tr>
									<th colspan='3' class="group"><label class="label-Leader-blue"><fmt:message key="ui.label.ncrEvaluation" /></label></th>								
								</tr>				
								<tr>
									<th><fmt:message key="ui.label.evaluation"/><fmt:message key="ui.label.contents" /></th>
									<td><textarea name="inputEvaluation" cols=35 rows=5 ></textarea>
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
				</div>			
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#" iconCls="icon-disk" class="easyui-linkbutton"><fmt:message key="ui.button.Reg" /></a>
				<a href="#" iconCls="icon-pencil" class="easyui-linkbutton"><fmt:message key="ui.button.Edit" /></a>
				<a href="#" iconCls="icon-delete" class="easyui-linkbutton"><fmt:message key="ui.button.Delete" /></a>
				<a href="#" iconCls="icon-information" class="easyui-linkbutton"><fmt:message key="ui.button.inform" /></a>
				<a href="#" iconCls="icon-comment-delete" class="easyui-linkbutton"><fmt:message key="ui.button.reject" /></a>
				<a href="#" iconCls="icon-accept" class="easyui-linkbutton"><fmt:message key="ui.button.agree" /></a>
				<a href="#" iconCls="icon-table-edit" class="easyui-linkbutton"><fmt:message key="ui.button.evaluation" /></a>
				<a href="#" iconCls="icon-arrow-redo" class="easyui-linkbutton"><fmt:message key="ui.button.Cancel" /></a>
				
				
			</td>
		</tr>
	</table>
</div>


<div id="pageNavForReasonfile">
	<table width="100%">
		<tr>
			<td align="right">						
			<a  class="easyui-linkbutton" href="#" iconCls="icon-add" onclick="javascript:insertReasonFile();"><fmt:message key="ui.button.Add" /></a>
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteDataGrid('datagridReasonFile');"><fmt:message key="ui.button.Delete" /></a>
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
			<a  class="easyui-linkbutton" href="#" iconCls="icon-delete" onclick="javascript:deleteDataGrid('datagridStandard');"><fmt:message key="ui.button.Delete" /></a>
			</td>
		</tr>
	</table>
</div>


</body>

</html>
