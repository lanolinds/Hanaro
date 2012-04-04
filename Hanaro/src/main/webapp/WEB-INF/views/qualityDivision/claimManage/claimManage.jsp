<!-- 제작일 : 2012. 3. 29.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.qualityClaimManage"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		form th {background-color: #FAFAFA;height:23px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		form td {border:1px dotted silver;}
		form input{border:0px;width:230px;}
		form select{width:230px;}
		.auto{color:blue;}
		.LS{background-color: #FCEDED;}
		.RW{background-color: #DCE1FD;}
		.SW{background-color: #DCFADB;}
		.EX{background-color: #FDF7D3;}
		/*
		#divRW{display:none;}
		#divSW{display:none;}
		#divEX{display:none;}
		*/
		
		
				
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script>
	<script type="text/javascript">

	
	//발생품번선택 자동완성(All: 모든품번, 1001 : 완성품, 1002 : 부품)
	function workPartListCallbak(codeString,nameString,carString,partType,divName){
	    $("#"+codeString).combogrid({
	    	panelWidth:583,
	        url : '../qualityIssue/codePartListForIssueRegCallbak?partType='+partType,
	        columns:[[  
	                  {field:'partNo',title:'<fmt:message key="ui.label.PartNo"/>',width:100},  
	                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:200},  
	                  {field:'car',title:'<fmt:message key="ui.label.Car"/>',width:60},  
	                  {field:'model',title:'<fmt:message key="ui.label.Model"/>',width:60},
	                  {field:'price',title:'<fmt:message key="ui.label.unitPrice"/>',width:60},
	                  {field:'custCode',title:'<fmt:message key="ui.label.cust.custCd"/>',width:60}
	              ]],
	        idField:'partNo',  
	        textField:'partNo',
	        mode:'remote',
	        onSelect:function(rowIndex, rowData){
	        	$("input[name='"+nameString+"']",$("#div"+divName)).val(rowData.partName);	        	
	        	if(carString!=""){
	        		$("input[name='"+carString+"']",$("#div"+divName)).val(rowData.car);
	        		$("input[name='cost']",$("#div"+divName)).val(rowData.price);
	        		$("#issueCustName"+divName).combogrid("setValue",rowData.custCode);
	        	}
	        }
	     });
	}	
	
	//거래처선택 자동완성
	function workCustListCallbak(codeString,nameString,divName){		
	    $("input[name='"+codeString+"']",$("#div"+divName)).combogrid({
	    	panelWidth:683,
	        url : 'codeCustOptionLongCallbak?searchType=CLAIMCUST',
	        columns:[[  
	                  {field:'DATA0',title:'<fmt:message key="ui.label.cust.custType"/>',width:100},  
	                  {field:'DATA1',title:'<fmt:message key="ui.label.cust.custCd"/>',width:70},  
	                  {field:'DATA2',title:'<fmt:message key="ui.label.cust.custNm"/>',width:150},  
	                  {field:'DATA3',title:'<fmt:message key="ui.label.cust.officePhone"/>',width:90},
	                  {field:'DATA4',title:'<fmt:message key="ui.label.cust.officeFax"/>',width:90},
	                  {field:'DATA5',title:'<fmt:message key="ui.label.cust.email"/>',width:150}
	                  
	              ]],
	        idField:'DATA1',  
	        textField:'DATA2',
	        mode:'remote',
	        onSelect:function(rowIndex, rowData){
	        	$("input[name='"+nameString+"']",$("#div"+divName)).val(rowData.DATA1);	        	
	        }
	     });
	}		
	
	function changeType(ob){
		$("#divLS").css("display","none");
		$("#divRW").css("display","none");
		$("#divSW").css("display","none");
		$("#divEX").css("display","none");
		$("#div"+ob).css("display","inline");
	}	
	function fnSelected(p4,p5,p6,p7,divName){
		
		var endWork = $("input[name='"+p5+"']",$("#div"+divName)).timespinner("getHours")*60+$("input[name='"+p5+"']",$("#div"+divName)).timespinner("getMinutes");		
		var endRest = $("input[name='"+p7+"']",$("#div"+divName)).timespinner("getHours")*60+$("input[name='"+p7+"']",$("#div"+divName)).timespinner("getMinutes");		
		var startWorkTime = $("input[name='"+p4+"']",$("#div"+divName)).timespinner("getHours")*60+$("input[name='"+p4+"']",$("#div"+divName)).timespinner("getMinutes");		
		var startRestTime = $("input[name='"+p6+"']",$("#div"+divName)).timespinner("getHours")*60+$("input[name='"+p6+"']",$("#div"+divName)).timespinner("getMinutes");		
		var resTime = ((endRest>endWork)?endWork:endRest)-((startRestTime<startWorkTime)?startWorkTime:startRestTime);
		var realTime = (endWork-startWorkTime)-((resTime<0)?0:resTime);
		return (realTime<0)?0:realTime;		
	}
	function fnSelectedLS(date){
		$("input[name='issueTime']",$("#divLS")).val(fnSelected("p4","p5","p6","p7","LS")).trigger("change");
	}
	function fnSelectedRW(date){
		$("input[name='issueTime']",$("#divRW")).val(fnSelected("p4","p5","p6","p7","RW")).trigger("change");
	}
	function fnSelectedEX(date){
		$("input[name='issueTime']",$("#divEX")).val(fnSelected("p2","p3","p4","p5","EX")).trigger("change");
	}
	function fnSelectedD(value){
		if(value.split(':').length!=2){return false;}
		else if(value.split(':')[0]>24 || value.split(':')[1]>59){return false;}
		else{return true;}
	}
	function fnSelectedLSD(value){		
		if(fnSelectedD(value))		
		$("input[name='issueTime']",$("#divLS")).val(fnSelected("p4","p5","p6","p7","LS")).trigger("change");
	}
	function fnSelectedRWD(value){		
		if(fnSelectedD(value))		
		$("input[name='issueTime']",$("#divRW")).val(fnSelected("p4","p5","p6","p7","RW")).trigger("change");
	}
	function fnSelectedEXD(value){		
		if(fnSelectedD(value))		
		$("input[name='issueTime']",$("#divEX")).val(fnSelected("p2","p3","p4","p5","EX")).trigger("change");
	}	
	
	function changePType(type,divName,codeString,nameString){
		if(codeString=="")			 
			workPartListCallbak("rPartCode"+divName,"rPartName","carType",type,divName);
		else			
			workPartListCallbak(codeString+divName,nameString,"",type,divName);
	}
	
	
	function save(ob){
		
	}
	function cancel(ob){
		
	}
	
	function addClaim(){
		
	}
	function editClaim(){
		
	}
	function deleteClaim(){
		
	}	

	
	
		$(document).ready(function(){
			
			//입력하지 않는 항목을 음영처리한다.
			$("input",$(".label-Leader-black").parent().next()).css("background-color","#E5E5E5");		
			
			$("input[name='p4']",$("#divLS")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p5']",$("#divLS")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p6']",$("#divLS")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p7']",$("#divLS")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			
			workPartListCallbak("rPartCodeLS","rPartName","carType","1002","LS");
			workPartListCallbak("p2LS","p3","","1001","LS");
			workCustListCallbak("issueCustName","issueCust","LS");
			
			$("input[name='p4']",$("#divRW")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p5']",$("#divRW")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p6']",$("#divRW")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p7']",$("#divRW")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			
			workPartListCallbak("rPartCodeRW","rPartName","carType","1002","RW");
			workPartListCallbak("p2RW","p3","","1001","RW");
			workCustListCallbak("issueCustName","issueCust","RW");
			
			workPartListCallbak("rPartCodeSW","rPartName","carType","1002","SW");
			workCustListCallbak("issueCustName","issueCust","SW");
			
			workPartListCallbak("rPartCodeEX","rPartName","carType","1002","EX");
			workCustListCallbak("issueCustName","issueCust","EX");
			
			$("input[name='p2']",$("#divEX")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p3']",$("#divEX")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p4']",$("#divEX")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p5']",$("#divEX")).timespinner({value:"00:00",required:false,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});			
			
		

			

			
			
			
			
		});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
<div id="tabs" class="easyui-tabs" style="width:1180px;height:730px;">  
    <div title="<fmt:message key='ui.qualityClaimReg'/>"  iconCls="icon-coins-add"  style="padding:5px;">  
		<table>
			<tr>				
				<td>
					<div  style="width:1100px;height:330px;padding:10px;background-color:#F6F6F6;">
						<table width="100%">
							<tr>
								<td colspan="2" style="border:0px;text-align:left;" >
									<input type="radio" name="claimType" value="${claimType[1].code}" checked onclick="javascript:changeType('${claimType[1].code}');"><font color="red">${claimType[1].name}</font>
									<input type="radio" name="claimType" value="${claimType[2].code}" onclick="javascript:changeType('${claimType[2].code}');"><font color="blue">${claimType[2].name}</font>
									<input type="radio" name="claimType" value="${claimType[3].code}" onclick="javascript:changeType('${claimType[3].code}');"><font color="#089B00">${claimType[3].name}</font>
									<input type="radio" name="claimType" value="${claimType[0].code}" onclick="javascript:changeType('${claimType[0].code}');"><font color="#DEA300">${claimType[0].name}</font>								
								</td>
								<td colspan="2" style="border:0px;text-align:right;" >
									<a  href="#" class="easyui-linkbutton" iconCls="icon-disk" onclick="javascript:save(this);"><fmt:message key="ui.button.Save"/></a>
									<a  href="#" class="easyui-linkbutton" iconCls="icon-arrow-redo" onclick="javascript:cancel(this);"><fmt:message key="ui.button.Cancel"/></a>											
								</td>								
							</tr>
						</table>						
  						<hr>	
						<div id="divLS">
							<form name="formLS">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td><input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly /></td>
										<th><span  class="label-Leader-blue" >INVOICE NO</span></th>
										<td><input name="invoiceNo" type="text" class="easyui-validatebox" value="" required="true" /></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.type'/></span></th>
										<td class="LS">
											<select name="p1" class="easyui-validatebox" required="true" >
												<c:forEach items="${lsType}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.writeDt'/></span></th>
										<td><input name="inputDt" type="text" value="${today}" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.writer'/></span></th>
										<td><input name="inputBy" type="text" value="${writer}" readonly/></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workPartNo'/></span></th>
										<td class="LS">
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'LS','p2','p3');">												
												<option value="1001"><fmt:message key="ui.label.product"/></option>
												<option value="1002"><fmt:message key="ui.material"/></option>												
											</select>										
											<input id="p2LS" name="p2" style="width:130px;" required="true" />
										</td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'LS','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeLS" name="rPartCode" style="width:130px;" required="true" />
										</td>
										<th class="LS"><span  class="label-Leader-black" ><fmt:message key='ui.label.workPartNm'/></span></th>
										<td class="LS"><input name="p3" type="text" readonly/></td>																		
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true" >
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.startTime'/></span></th>
										<td class="LS"><input name="p4" onchange="javascript:fnSelectedLSD(this.value);"  /></td>																				
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.OccurDate'/></span></th>
										<td><input name="issueDate" class="easyui-datebox" value="${today}" required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.stopTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="LS"><input name="p5" onchange="javascript:fnSelectedLSD(this.value);" /></td>																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeStart'/></span></th>
										<td class="LS"><input name="p6" onchange="javascript:fnSelectedLSD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam">
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${claimDept}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonOrgan'/></span></th>
										<td>
											<input name="issueCustName" id="issueCustNameLS" style="width:220px;" />
											<input name="issueCust" type="hidden"/>
										</td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
										<td class="LS"><input name="p7" onchange="javascript:fnSelectedLSD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text" class="easyui-validatebox" required="false" style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>	
						
						
						
						<div id="divRW">
							<form name="formRW">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td><input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly /></td>
										<th><span  class="label-Leader-blue" >INVOICE NO</span></th>
										<td><input name="invoiceNo" type="text" class="easyui-validatebox" value="" required="true" /></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.QualityIssue.OccurLine'/></span></th>
										<td class="RW">
											<select name="p1" class="easyui-validatebox" required="true" >
												<c:forEach items="${issueLine}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.writeDt'/></span></th>
										<td><input name="inputDt" type="text" value="${today}" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.writer'/></span></th>
										<td><input name="inputBy" type="text" value="${writer}" readonly/></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workPartNo'/></span></th>
										<td class="RW">
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'RW','p2','p3');">												
												<option value="1001"><fmt:message key="ui.label.product"/></option>
												<option value="1002"><fmt:message key="ui.material"/></option>												
											</select>										
											<input id="p2RW" name="p2" style="width:130px;" required="true" />
										</td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'RW','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeRW" name="rPartCode" style="width:130px;" required="true" />
										</td>
										<th class="RW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workPartNm'/></span></th>
										<td class="RW"><input name="p3" type="text" readonly/></td>																		
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true" >
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.startTime'/></span></th>
										<td class="RW"><input name="p4"  onchange="javascript:fnSelectedRWD(this.value);"  /></td>																				
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.reworkDt'/></span></th>
										<td><input name="issueDate" class="easyui-datebox" value="${today}" required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.reworkTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="RW"><input name="p5" onchange="javascript:fnSelectedRWD(this.value);" /></td>																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeStart'/></span></th>
										<td class="RW"><input name="p6" onchange="javascript:fnSelectedRWD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam">
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${claimDept}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonOrgan'/></span></th>
										<td>
											<input name="issueCustName" id="issueCustNameRW" style="width:220px;" />
											<input name="issueCust" type="hidden"/>
										</td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
										<td class="RW"><input name="p7" onchange="javascript:fnSelectedRWD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text" class="easyui-validatebox" required="false" style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>
						
									
						<div id="divSW">
							<form name="formSW">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td><input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly /></td>
										<th><span  class="label-Leader-blue" >INVOICE NO</span></th>
										<td><input name="invoiceNo" type="text" class="easyui-validatebox" value="" required="true" /></td>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workCost'/></span></th>
										<td class="SW"><input name="p1" class="easyui-validatebox" required="true"  style="width:150px;"/></td>																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.writeDt'/></span></th>
										<td><input name="inputDt" type="text" value="${today}" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.writer'/></span></th>
										<td><input name="inputBy" type="text" value="${writer}" readonly/></td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workContent'/></span></th>
										<td class="SW"><input name="p2" class="easyui-validatebox" required="true" /></td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'SW','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeSW" name="rPartCode" style="width:130px;" required="true" />
										</td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.cagegory'/></span></th>
										<td class="SW">
											<select name="p3" class="easyui-validatebox" required="true" >
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${swtype}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>										
										</td>																		
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true" >
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectCount'/></span></th>
										<td class="SW"><input name="p4" class="easyui-numberspinner"  min="1" max="999999" required="true"   value="1"  /></td>																			
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectDt'/></span></th>
										<td><input name="issueDate" class="easyui-datebox" value="${today}" required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.selectTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td class="SW"><input name="p5" class="easyui-numberspinner"  min="1" max="999999" required="true"   value="1"  /></td>																			
									</tr>
									<tr>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td class="SW" ><input name="workerCount" class="easyui-validatebox" required="false"  value="" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>																											
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam">
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${claimDept}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonOrgan'/></span></th>
										<td>
											<input name="issueCustName" id="issueCustNameSW" style="width:220px;" />
											<input name="issueCust" type="hidden"/>
										</td>																																							
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text" class="easyui-validatebox" required="false" style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>
						
						<div id="divEX">
							<form name="formEX">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td><input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly /></td>
										<th><span  class="label-Leader-blue" >INVOICE NO</span></th>
										<td><input name="invoiceNo" type="text" class="easyui-validatebox" value="" required="true" /></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.QualityIssue.OccurLine'/></span></th>
										<td class="EX">
											<select name="p1" class="easyui-validatebox" required="true" >
												<c:forEach items="${issueLine}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.writeDt'/></span></th>
										<td><input name="inputDt" type="text" value="${today}" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.writer'/></span></th>
										<td><input name="inputBy" type="text" value="${writer}" readonly/></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.startTime'/></span></th>
										<td class="EX"><input name="p2" onchange="javascript:fnSelectedEXD(this.value);"   /></td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:80px;" onchange="javascript:changePType(this.value,'EX','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeEX" name="rPartCode" style="width:130px;" required="true" />
										</td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="EX"><input name="p3" onchange="javascript:fnSelectedEXD(this.value);"  /></td>														
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true" >
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeStart'/></span></th>
										<td class="EX"><input name="p4" onchange="javascript:fnSelectedEXD(this.value);"  /></td>																					
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.changeDt'/></span></th>
										<td><input name="issueDate" class="easyui-datebox" value="${today}" required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.changeTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
										<td class="EX"><input name="p5" onchange="javascript:fnSelectedEXD(this.value);"  /></td>																				
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>																											
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam">
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${claimDept}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonOrgan'/></span></th>
										<td>
											<input name="issueCustName" id="issueCustNameEX" style="width:220px;" />
											<input name="issueCust" type="hidden"/>
										</td>																																							
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text" class="easyui-validatebox" required="false" style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>	
									
						
																								
					</div>  				
				</td>
			</tr>
		</table>        
    </div>  
    <div title="<fmt:message key='ui.label.qualityIssue.ready'/>" iconCls="icon-coins"  style="padding:20px;">  
        tab2  
    </div>  
    <div title="<fmt:message key='ui.label.qualityIssue.done'/>" iconCls="icon-table-money" style="padding:20px;">     
        tab3  
    </div>  
</div>  
</div>
</body>

</html>
