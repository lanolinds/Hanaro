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
		#form1 td {border:1px dotted silve	r;width:170px;}
		#form1 input{border:0px;width:100%;}		
		
		#form2 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form2 .group{background-color: #E1E8F3;}
		
		#form3 th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }		#form3 .group{background-color: #E1E8F3;}
		
		
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

	
	//임시조치 처리	
	function insertTempData(){
		var row={};
		row.tempMeasureContents="<textarea name='tempMeasure' cols='30' rows='3'></textarea>";
		row.tempMeasureDate="<input type='text' size='11' name='tempMeasureDate'  />";
		$("#datagridTempMeasure").datagrid("insertRow",{row:row});
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
									<img src=<c:url value="/resources/images/no_image.jpg" /> width="300px" height="160px"/>								
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
									<img src=<c:url value="/resources/images/no_image.jpg" /> width="300px" height="160px" />
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
											<th field="reasonFile" width="200px"><fmt:message key="ui.label.File" /></th>
											<th field="reasonFileName" width="290px"></th>
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
										<table  id="datagridTempMeasure"   class="easyui-datagrid" style="width:370px;height:200px;"   nowrap="false" toolbar="#pageNavForTempMeasure" pageSize="100" fitColumns="true" singleSelect="true" striped="true" > 
											<thead>
												<tr>
													<th field="tempMeasureContents" width="260" ><fmt:message key="ui.label.contents" /></th>
													<th field="tempMeasureDate"  width="100"><fmt:message key="ui.label.date" /></th>
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
							</table>
						</form:form>					
					  </div>
					  <div title="<fmt:message key='ui.label.ncrTreatReport'><fmt:param value='3' /></fmt:message>-<fmt:message key='ui.label.qualityIssue.applyStandard'/> " >
					
					  </div>  					    
					  <div title='<fmt:message key="ui.label.ncrEvaluation"/>' >  
					
					  </div>  				
				</div>			
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


</body>

</html>
