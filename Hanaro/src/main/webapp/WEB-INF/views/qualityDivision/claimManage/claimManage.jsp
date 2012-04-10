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
		#divRW{display:none;}
		#divSW{display:none;}
		#divEX{display:none;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script>
	<script type="text/javascript">
	var cDivision = "";

	
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
	        },
	        required:true
	     });
	}		
	
	function changeType(ob){
		cancel();
		$("#divLS").css("display","none");
		$("#divRW").css("display","none");
		$("#divSW").css("display","none");
		$("#divEX").css("display","none");
		$("#div"+ob).css("display","inline");
		
		var urlString = "getClaimRegList?classType="+ob;
		var cols = [];
		cols.push({field:'DATA0',hidden:true});
		cols.push({field:'DATA1',hidden:true});
		cols.push({field:'DATA2',title:'<fmt:message key="ui.label.RegNo" />',width:110,sortable:true,align:'center'});
		cols.push({field:'DATA3',title:'INVOICE NO',width:110,sortable:true,align:'center'});
		cols.push({field:'DATA13',title:'<fmt:message key="ui.label.OccurDate" />',width:70,sortable:true,align:'center'});
		cols.push({field:'DATA10',hidden:true});
		cols.push({field:'DATA11',title:'<fmt:message key="ui.label.qualityIssue.reasonPartNo" />',width:120,sortable:true,align:'left'});
		cols.push({field:'DATA12',title:'<fmt:message key="ui.label.qualityIssue.reasonPartName" />',width:150,sortable:true,align:'left'});
		cols.push({field:'DATA5',hidden:true});
		cols.push({field:'DATA6',title:'<fmt:message key="ui.label.qualityIssue.reasonOrgan" />',width:90,sortable:true,align:'center'});
		cols.push({field:'DATA4',title:'CLAIM',width:70,sortable:true,align:'right',formatter:numeric});
		cols.push({field:'DATA7',hidden:true});
		cols.push({field:'DATA8',title:'<fmt:message key="ui.label.refTeam" />',width:90,sortable:true,align:'center'});
		cols.push({field:'DATA9',hidden:true});
		cols.push({field:'DATA15',title:'<fmt:message key="ui.label.Car" />',width:60,sortable:true,align:'center'});
		cols.push({field:'DATA16',hidden:true});
		cols.push({field:'DATA23',title:'<fmt:message key="ui.label.Model" />',width:70,sortable:true,align:'center'});
		cols.push({field:'DATA17',title:'<fmt:message key="ui.member.count" />',width:60,sortable:true,align:'center'});
		cols.push({field:'DATA18',title:'<fmt:message key="ui.label.needWorkTime" />',width:80,sortable:true,align:'center'});
		cols.push({field:'DATA19',hidden:true});
		cols.push({field:'DATA20',hidden:true});
		cols.push({field:'DATA21',hidden:true});
		cols.push({field:'DATA14',title:'<fmt:message key="ui.label.claimContent" />',width:200,sortable:true,align:'left'});		
		if(ob=="LS" || ob=="RW"){
			cols.push({field:'DATA25',hidden:true});
			if(ob=="LS")
				cols.push({field:'DATA26',title:'<fmt:message key="ui.label.type" />',width:80,sortable:true,align:'center'});
			else
				cols.push({field:'DATA26',title:'<fmt:message key="ui.label.QualityIssue.OccurLine" />',width:130,sortable:true,align:'center'});
			cols.push({field:'DATA27',title:'<fmt:message key="ui.label.workPartNo" />',width:120,sortable:true,align:'left'});
			cols.push({field:'DATA28',title:'<fmt:message key="ui.label.workPartNm" />',width:150,sortable:true,align:'left'});
			cols.push({field:'DATA29',hidden:true});
			cols.push({field:'DATA30',hidden:true});
			cols.push({field:'DATA31',hidden:true});
			cols.push({field:'DATA32',hidden:true});		
		}else if(ob=="SW"){
			cols.push({field:'DATA25',title:'<fmt:message key="ui.label.workCost" />',width:70,sortable:true,align:'right',formatter:numeric});
			cols.push({field:'DATA26',title:'<fmt:message key="ui.label.workContent" />',width:170,sortable:true,align:'left'});
			cols.push({field:'DATA27',title:'<fmt:message key="ui.label.selectCount" />',width:70,sortable:true,align:'right',formatter:numeric});
			cols.push({field:'DATA28',title:'<fmt:message key="chartYName.issueAmount" />',width:70,sortable:true,align:'right',formatter:numeric});			
			cols.push({field:'DATA29',hidden:true});
			cols.push({field:'DATA30',title:'<fmt:message key="ui.label.cagegory" />',width:110,sortable:true,align:'center'});
		}else{
			cols.push({field:'DATA25',hidden:true});			
			cols.push({field:'DATA26',title:'<fmt:message key="ui.label.QualityIssue.OccurLine" />',width:130,sortable:true,align:'center'});
			cols.push({field:'DATA27',hidden:true});
			cols.push({field:'DATA28',hidden:true});
			cols.push({field:'DATA29',hidden:true});
			cols.push({field:'DATA30',hidden:true});			
		}
		$('#listReg').datagrid({  
		    url:urlString,  
		    columns:[cols]
		});  
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

	
	function searchBomItem(){
		var params = {};		
		params.partCode = $("#txtBomPartCode").val();
		params.car = $("#selBomCar").val();
		params.model = $("#selBomModel").val();
		$("#ebomPart").datagrid("load",params);
	}
	function ebomPartClick(rowIndex, rowData){
		$("#infoBomPartCode").val(rowData.part_no);
		$("#infoBomCar").val(rowData.car_type);
		$("#infoBomMachine").val(rowData.machine_type);
		$("#infoBomPartName").val(rowData.part_name);
		var params = {};		
		params.partCode = rowData.part_no;		
		$("#ebomPartDetail").datagrid("load",params);
	}
	function ebomPartDetailClick(rowIndex, rowData){	
		$("select[name='partType1']",$("#div"+cDivision)).val("1002");
		$("#rPartCode"+cDivision).combogrid("setValue",rowData.child_part);
		$("input[name='rPartName']",$("#div"+cDivision)).val(rowData.part_name);
		$("input[name='carType']",$("#div"+cDivision)).val(rowData.car_type);
		$("input[name='cost']",$("#div"+cDivision)).val(rowData.price).trigger("change");
		$("#issueCustName"+cDivision).combogrid("setValue",rowData.cust_code);	
		if(cDivision =="LS" ||cDivision =="RW"){
			$("#p2"+cDivision).combogrid("setValue",$("#infoBomPartCode").val());
			$("input[name='p3']",$("#div"+cDivision)).val($("#infoBomPartName").val());
		}
		$("#dialogBom").dialog("close");
		
	}
	function popBom(divName){
		cDivision = divName;
		$("#dialogBom").dialog({modal:true});		
	}
	
	function popCalWork(){
		$("#dialogCalWork").dialog({modal:true});
	}
	function workCal(type){
		if(type="ADD"){
			
		}else if(type="DEL"){
			
		}else{
			
		}
	}
	
	function save(prodType){
		fnSelectedLS();
		fnSelectedRW();
		fnSelectedEX();		
		var cDiv = $("input[name='claimType']:checked").val();		
		if($("form[name='form"+cDiv+"']").form("validate")){			
			$("input[name='prodType']",$("#div"+cDiv)).val(prodType);
			$("body").css("cursor","wait");
			$("form[name='form"+cDiv+"']").submit();
		}else{
			return false;
		}
	}	
	
	
	function cancel(){
		for(var i=0;i<4;i++)
		$("form")[i].reset();
		$("#btReg").css("display","inline");
		$("#btEdit").css("display","none");
		$("#btDel").css("display","none");		
	}
	function searchRegList(){		
		var params = {};
		params.stdDt = $("#searchStdDt").datebox("getValue");
		params.endDt = $("#searchEndDt").datebox("getValue");
		params.partCode = $("#searchPartCode").val();
		$("#listReg").datagrid("load",params);
	}
	function listRegClick(rowIndex, rowData){
		var cDiv = $("input[name='claimType']:checked").val();
		var $div = $("#div"+cDiv);
		$("input[name='claimNo']",$div).val(rowData.DATA2);
		$("input[name='invoiceNo']",$div).val(rowData.DATA3);
		$("input[name='inputDt']",$div).val(rowData.DATA21);
		$("input[name='inputBy']",$div).val(rowData.DATA20);
		$("input[name='carType']",$div).val(rowData.DATA15);
		$("select[name='partType1']",$div).val(rowData.DATA10);
		$("#rPartCode"+cDiv).combogrid("setValue",rowData.DATA11);
		$("select[name='machineType']",$div).val(rowData.DATA16);
		$("input[name='rPartName']",$div).val(rowData.DATA12);
		$("#issueDate"+cDiv).datebox("setValue",rowData.DATA13);
		$("input[name='issueTime']",$div).val(rowData.DATA18);
		if(cDiv=="SW")
			$("input[name='workerCount']",$div).val(rowData.DATA17);
		else
			$("#workerCount"+cDiv).numberspinner("setValue",rowData.DATA17);
		$("input[name='claimCost']",$div).val(rowData.DATA4);
		$("input[name='cost']",$div).val(rowData.DATA9);
		$("select[name='issueTeam']",$div).val(rowData.DATA7);
		$("#issueCustName"+cDiv).combogrid("setValue",rowData.DATA6);
		$("input[name='issueCust']",$div).val(rowData.DATA5);
		$("input[name='claimContent']",$div).val(rowData.DATA14);
		if(cDiv=="LS" || cDiv=="RW"){
			$("select[name='p1']",$div).val(rowData.DATA25);
			$("#p2"+cDiv).combogrid("setValue",rowData.DATA27);
			$("input[name='p3']",$div).val(rowData.DATA28);
			$("#p4"+cDiv).timespinner("setValue",rowData.DATA29);
			$("#p5"+cDiv).timespinner("setValue",rowData.DATA30);
			$("#p6"+cDiv).timespinner("setValue",rowData.DATA31);
			$("#p7"+cDiv).timespinner("setValue",rowData.DATA32);
		}else if(cDiv=="SW"){
			$("input[name='p1']",$div).val(rowData.DATA25);
			$("input[name='p2']",$div).val(rowData.DATA26);
			$("select[name='p3']",$div).val(rowData.DATA29);
			$("#p4"+cDiv).numberspinner("setValue",rowData.DATA27);
			$("#p5"+cDiv).numberspinner("setValue",rowData.DATA28);
		}else{
			$("select[name='p1']",$div).val(rowData.DATA25);
			$("#p2"+cDiv).timespinner("setValue",rowData.DATA27);
			$("#p3"+cDiv).timespinner("setValue",rowData.DATA28);
			$("#p4"+cDiv).timespinner("setValue",rowData.DATA29);
			$("#p5"+cDiv).timespinner("setValue",rowData.DATA30);			
		}
		$("#btReg").css("display","none");
		$("#btEdit").css("display","inline");
		$("#btDel").css("display","inline");
		

	}
	
	
	function addClaim(){
		
	}
	function editClaim(){
		
	}
	function deleteClaim(){
		
	}	

	
	
		$(document).ready(function(){
			
			//입력하지 않는 항목을 음영처리한다.
			$("input",$(".label-Leader-black").parent().next()).css("background-color","#F1F0F0");		
			
			$("input[name='p4']",$("#divLS")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p5']",$("#divLS")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p6']",$("#divLS")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			$("input[name='p7']",$("#divLS")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedLS,onSpinDown:fnSelectedLS});
			
			workPartListCallbak("rPartCodeLS","rPartName","carType","1002","LS");
			workPartListCallbak("p2LS","p3","","1001","LS");
			workCustListCallbak("issueCustName","issueCust","LS");
			
			$("input[name='p4']",$("#divRW")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p5']",$("#divRW")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p6']",$("#divRW")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			$("input[name='p7']",$("#divRW")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedRW,onSpinDown:fnSelectedRW});
			
			workPartListCallbak("rPartCodeRW","rPartName","carType","1002","RW");
			workPartListCallbak("p2RW","p3","","1001","RW");
			workCustListCallbak("issueCustName","issueCust","RW");
			
			workPartListCallbak("rPartCodeSW","rPartName","carType","1002","SW");
			workCustListCallbak("issueCustName","issueCust","SW");
			
			workPartListCallbak("rPartCodeEX","rPartName","carType","1002","EX");
			workCustListCallbak("issueCustName","issueCust","EX");
			
			$("input[name='p2']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p3']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p4']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p5']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});			
			
		

			$("#ebomPart").datagrid({onClickRow:ebomPartClick});
			$("#ebomPartDetail").datagrid({onDblClickRow:ebomPartDetailClick});			
			$("#listReg").datagrid({onClickRow:listRegClick});
			
			
		});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
<div id="tabs" class="easyui-tabs" style="width:1120px;height:730px;">  
    <div title="<fmt:message key='ui.qualityClaimReg'/>"  iconCls="icon-coins-add"  style="padding:5px;">  
		<table>
			<tr>				
				<td>
					<div  style="width:1100px;height:330px;padding:10px;">
						<table width="100%" style="background-color: #F5F3F3;">
							<tr>
								<td colspan="2" style="border:0px;text-align:left;" >
									<input type="radio" name="claimType" value="${claimType[1].code}" checked onclick="javascript:changeType('${claimType[1].code}');"><font color="red">${claimType[1].name}</font>
									<input type="radio" name="claimType" value="${claimType[2].code}" onclick="javascript:changeType('${claimType[2].code}');"><font color="blue">${claimType[2].name}</font>
									<input type="radio" name="claimType" value="${claimType[3].code}" onclick="javascript:changeType('${claimType[3].code}');"><font color="#089B00">${claimType[3].name}</font>
									<input type="radio" name="claimType" value="${claimType[0].code}" onclick="javascript:changeType('${claimType[0].code}');"><font color="#DEA300">${claimType[0].name}</font>								
								</td>
								<td colspan="2" style="border:0px;text-align:right;" >
									<c:if test="${cLocale!='KR'}">
									<a id="btReg"  href="#" class="easyui-linkbutton" iconCls="icon-disk" onclick="javascript:save('INSERT');"><fmt:message key="ui.button.Reg"/></a>
									<a id="btEdit" style="display:none;"  href="#" class="easyui-linkbutton" iconCls="icon-pencil" onclick="javascript:save('UPDATE');"><fmt:message key="ui.button.Edit"/></a>
									<a id="btDel" style="display:none;"  href="#" class="easyui-linkbutton" iconCls="icon-delete" onclick="javascript:save('DELETE');"><fmt:message key="ui.button.Delete"/></a>
									<a  href="#" class="easyui-linkbutton" iconCls="icon-arrow-redo" onclick="javascript:cancel();"><fmt:message key="ui.button.Cancel"/></a>
									</c:if>											
								</td>								
							</tr>
						</table>						
  						<hr>	
						<div id="divLS">
							<form name="formLS" action="claimManage" method="post" >
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td>
											<input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly />
											<input name="classType" value="LS" type="hidden"/>
											<input name="prodType" value="INSERT"  type="hidden"/>
										</td>
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
											<input id="p2LS" name="p2" style="width:130px;" required="true" />
										</td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:60px;" onchange="javascript:changePType(this.value,'LS','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeLS" name="rPartCode" style="width:130px;" required="true" />
											<a  href="#" class="easyui-linkbutton" iconCls="icon-node-tree" onclick="javascript:popBom('LS');" plain="true"></a>
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
										<td class="LS"><input name="p4" id="p4LS" onchange="javascript:fnSelectedLSD(this.value);"  /></td>																				
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.OccurDate'/></span></th>
										<td><input id="issueDateLS" name="issueDate" class="easyui-datebox"  required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.stopTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="LS"><input name="p5" id="p5LS" onchange="javascript:fnSelectedLSD(this.value);" /></td>																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input id="workerCountLS" name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeStart'/></span></th>
										<td class="LS"><input name="p6" id="p6LS" onchange="javascript:fnSelectedLSD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam" class="easyui-validatebox"  required="true">
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
										<td class="LS"><input name="p7"  id="p7LS" onchange="javascript:fnSelectedLSD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text"  style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>					
						</div>	
						<div id="divRW">
							<form name="formRW"  action="claimManage" method="post">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td>
											<input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly />
											<input name="classType" value="RW"  type="hidden"/>
											<input name="prodType" value="INSERT"  type="hidden"/>
										</td>
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
											<input id="p2RW" name="p2" style="width:130px;" required="true" />
										</td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:60px;" onchange="javascript:changePType(this.value,'RW','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeRW" name="rPartCode" style="width:130px;" required="true" />
											<a  href="#" class="easyui-linkbutton" iconCls="icon-node-tree" onclick="javascript:popBom('RW');" plain="true"></a>
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
										<td class="RW"><input id="p4RW"  name="p4"  onchange="javascript:fnSelectedRWD(this.value);"  /></td>																				
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.reworkDt'/></span></th>
										<td><input id="issueDateRW" name="issueDate" class="easyui-datebox"  required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.reworkTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="RW"><input id="p5RW"  name="p5" onchange="javascript:fnSelectedRWD(this.value);" /></td>																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input id="workerCountRW" name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeStart'/></span></th>
										<td class="RW"><input id="p6RW"  name="p6" onchange="javascript:fnSelectedRWD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam" class="easyui-validatebox"  required="true">
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
										<td class="RW"><input id="p7RW"  name="p7" onchange="javascript:fnSelectedRWD(this.value);" /></td>																													
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="5"><input name="claimContent" type="text" style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>
						
									
						<div id="divSW">
							<form name="formSW"  action="claimManage" method="post">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td>
											<input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly />
											<input name="classType" value="SW"  type="hidden"/>
											<input name="prodType" value="INSERT"  type="hidden"/>
										</td>
										<th><span  class="label-Leader-blue" >INVOICE NO</span></th>
										<td><input name="invoiceNo" type="text" class="easyui-validatebox" value="" required="true" /></td>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workCost'/></span></th>
										<td class="SW">
											<input name="p1" class="easyui-validatebox" required="true"  style="width:150px;"/>
											<a  href="#" class="easyui-linkbutton" iconCls="icon-account-balances" onclick="javascript:popCalWork();" plain="true"></a>
										</td>
																																			
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
											<select name="partType1" style="width:60px;" onchange="javascript:changePType(this.value,'SW','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeSW" name="rPartCode" style="width:130px;" required="true" />
											<a  href="#" class="easyui-linkbutton" iconCls="icon-node-tree" onclick="javascript:popBom('SW');" plain="true"></a>
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
										<td class="SW"><input id="p4SW" name="p4" class="easyui-numberspinner"  min="1" max="999999" required="true"   value="1"  /></td>																			
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectDt'/></span></th>
										<td><input id="issueDateSW" name="issueDate" class="easyui-datebox"  required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.selectTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td class="SW"><input id="p5SW" name="p5" class="easyui-numberspinner"  min="1" max="999999" required="true"   value="1"  /></td>																			
									</tr>
									<tr>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td class="SW" ><input id="workerCountSW" name="workerCount" class="easyui-validatebox"   value="1" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>																											
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam" class="easyui-validatebox"  required="true">
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
										<td colspan="5"><input name="claimContent" type="text"  style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>
						
						<div id="divEX">
							<form name="formEX"  action="claimManage" method="post">
								<table>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
										<td>
											<input name="claimNo" type="text" class="auto" value="${autoCreate}" readonly />
											<input name="classType" value="EX"  type="hidden"/>
											<input name="prodType" value="INSERT"  type="hidden"/>
										</td>
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
										<td class="EX"><input id="p2EX" name="p2" onchange="javascript:fnSelectedEXD(this.value);"   /></td>										
																									
									</tr>
									<tr>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
										<td><input name="carType" type="text" class="auto"  value="${autoCarType}" readonly /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
										<td>
											<select name="partType1" style="width:60px;" onchange="javascript:changePType(this.value,'EX','','');">
												<option value="1002"><fmt:message key="ui.material"/></option>
												<option value="1001"><fmt:message key="ui.label.product"/></option>
											</select>
											<input id="rPartCodeEX" name="rPartCode" style="width:130px;" required="true" />
											<a  href="#" class="easyui-linkbutton" iconCls="icon-node-tree" onclick="javascript:popBom('EX');" plain="true"></a>
										</td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="EX"><input  id="p3EX" name="p3" onchange="javascript:fnSelectedEXD(this.value);"  /></td>														
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
										<td class="EX"><input  id="p4EX" name="p4" onchange="javascript:fnSelectedEXD(this.value);"  /></td>																					
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.changeDt'/></span></th>
										<td><input id="issueDateEX" name="issueDate" class="easyui-datebox" required="true" editable="false" /></td>									
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.changeTime'/></span></th>
										<td><input name="issueTime" type="text" readonly value="0"></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
										<td class="EX"><input  id="p5EX" name="p5" onchange="javascript:fnSelectedEXD(this.value);"  /></td>																				
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input id="workerCountEX" name="workerCount" class="easyui-numberspinner"  min="1" max="100" required="true"   value="1"  /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0" />
										</td>																											
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.refTeam'/></span></th>
										<td>
											<select name="issueTeam" class="easyui-validatebox"  required="true">
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
										<td colspan="5"><input name="claimContent" type="text"   style="width:940px;" /></td>									
									</tr>								
								</table>
							</form>
						</div>						
					</div>  				
				</td>
			</tr>
			<tr>
				<td>
					<table style="width:1100px;height:340px;" title='<fmt:message key="ui.label.RegList"/>' toolbar="#divSearch" pagination="true"  id="listReg" 
							pageSize="10"   singleSelect="true" striped="true"  url="getClaimRegList?classType=LS" >
						<thead>
					        <tr>  
					            <th field="DATA0" hidden="true"></th>  
					            <th field="DATA1" hidden="true"></th>  
					            <th field="DATA2" width="110" sortable="true" align="center"><fmt:message key="ui.label.RegNo" /></th>  				      
					            <th field="DATA3" width="110" sortable="true" align="center">INVOICE NO</th>
					            <th field="DATA13" width="70" sortable="true" align="center"><fmt:message key="ui.label.OccurDate"/></th>
					            <th field="DATA10" hidden="true"></th>  
					            <th field="DATA11" width="120" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>
					            <th field="DATA12" width="150" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartName" /></th>  
					            <th field="DATA5" hidden="true"></th>  
					            <th field="DATA6" width="90" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>  
					            <th field="DATA4" width="70" sortable="true" align="right" formatter="numeric">CLAIM</th>
					            <th field="DATA7" hidden="true"></th>
					            <th field="DATA8" width="90" sortable="true" align="center"><fmt:message key="ui.label.refTeam" /></th>
					            <th field="DATA9" hidden="true"></th>
					            <th field="DATA15" width="60" sortable="true" align="center"><fmt:message key="ui.label.Car"/></th>
					            <th field="DATA16" hidden="true"></th>
					            <th field="DATA23" width="70" sortable="true" align="center"><fmt:message key="ui.label.Model"/></th>
					            <th field="DATA17" width="60" sortable="true" align="center"><fmt:message key="ui.member.count"/></th>
					            <th field="DATA18" width="80" sortable="true" align="center"><fmt:message key="ui.label.needWorkTime"/></th>
					            <th field="DATA19" hidden="true"></th>
					            <th field="DATA20" hidden="true"></th>
					            <th field="DATA21" hidden="true"></th>
					            <th field="DATA25" hidden="true"></th>
					            <th field="DATA14" width="200" sortable="false" align="left"><fmt:message key="ui.label.claimContent"/></th>
					            <th field="DATA26" width="80" sortable="true" align="center"><fmt:message key="ui.label.type"/></th>
					            <th field="DATA27" width="120" sortable="true" align="left"><fmt:message key="ui.label.workPartNo"/></th>
					            <th field="DATA28" width="150" sortable="true" align="left"><fmt:message key="ui.label.workPartNm"/></th>
					            <th field="DATA29" hidden="true"></th>
					            <th field="DATA30" hidden="true"></th>
					            <th field="DATA31" hidden="true"></th>
					            <th field="DATA32" hidden="true"></th>
	    					</tr> 
						</thead>
					</table>					
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
<div id="dialogBom" title="EBOM"  iconCls="icon-node-tree"  >  
    <table style="margin:8px;">
    	<tr>
    		<td>
    			<span class="label-Leader-blue"><fmt:message key="ui.label.Car"/></span>    			
    			<select id="selBomCar">
					<option value=""><fmt:message key='ui.element.Select'/></option>
					<c:forEach items="${bomCar}" var="citem">
						<option value="${citem.car_type}">${citem.car_type}</option>
					</c:forEach>
    			</select>
    			<span class="label-Leader-blue"><fmt:message key="ui.label.Model"/></span>
    			<select id="selBomModel">
					<option value=""><fmt:message key='ui.element.Select'/></option>
					<c:forEach items="${bomModel}" var="citem">
						<option value="${citem.machine_type}">${citem.machine_type}</option>
					</c:forEach>
    			</select>    			
    			<span class="label-Leader-blue"><fmt:message key="ui.label.product"/></span>
    			<input  id="txtBomPartCode" type="text" size="30"/>
				<a  href="#" class="easyui-linkbutton" iconCls="icon-table-tab-search" onclick="javascript:searchBomItem();"><fmt:message key="ui.button.Search"/></a>
    		</td>
    	</tr>
    	<tr>
    		<td>
    		<hr>
    			<table>
    				<tr>
    					<td  style="width:150px;height:330px;" rowspan="2">
				            <table  id="ebomPart" fit="true"  idField="part_no" singleSelect="true" url="getEbomItem?type=PRODUCT">			
								<thead>
									<tr>										
										<th field="part_no" width="130" sortable="false"><fmt:message key="ui.label.product"/></th>
										<th field="part_name" hidden="true"></th> 
										<th field="car_type" hidden="true"></th>
										<th field="machine_type" hidden="true"></th>																		
									</tr>	
								</thead>
							</table>
    					</td>
    					<td >
    						<table style="background-color:#D8D8D7;padding:10px;width:400px;">
    							<tr>
    								<td><fmt:message key="ui.label.PartNo"/></td>
    								<td><input type="text" id="infoBomPartCode" readonly size="20"></td>
    								<td><fmt:message key="ui.label.Car"/></td>
    								<td><input type="text" id="infoBomCar" readonly size="5"></td>
    								<td><fmt:message key="ui.label.Model"/></td>
    								<td><input type="text" id="infoBomMachine" readonly size="5"></td>    								
    								
    							</tr>
    							<tr>
    								<td><fmt:message key="ui.label.PartName"/></td>
    								<td colspan="5"><input type="text" id="infoBomPartName" size="35"/ readonly></td>
    							</tr>
    						</table>
    					</td>
    				</tr>
    				<tr>
    					<td>
				            <table id="ebomPartDetail"
										fit="true"  idField="child_part" singleSelect="true" url="getEbom">			
								<thead>
									<tr>										
										<th field="child_part" width="120" sortable="false"><fmt:message key="ui.material"/></th>
										<th field="amount" width="60" sortable="false"><fmt:message key="ui.label.needAmount"/></th>
										<th field="cust_name" width="130" sortable="false"><fmt:message key="ui.label.cust.custNm"/></th>
										<th field="price" width="60" sortable="false"><fmt:message key="ui.label.unitPrice"/></th>										
										<th field="cust_code" hidden="true" ></th>
										<th field="part_name" hidden="true" ></th>
										<th field="car_type" hidden="true" ></th>										
									</tr>	
								</thead>
							</table>
    					</td>    				
    				</tr>
    			</table>
    		</td>
    	</tr>    	
    </table> 
</div>  
<div id="dialogCalWork"  iconCls="icon-account-balances" title="<fmt:message key='ui.label.workerCountCost'/>" >
	<table style="margin:8px;">
		<tr>
			<td><fmt:message key="ui.label.employee.position"/></td>
			<td>
				<select id="selCalWorkRank">
					<option value="10000"><fmt:message key="ui.member.sw"/></option>
					<option value="15000"><fmt:message key="ui.member.dr"/></option>
					<option value="20000"><fmt:message key="ui.member.gj"/></option>
				</select>
			</td>
			<td><fmt:message key="ui.member.count"/></td>
			<td><input class="easyui-numberspinner" style="width:60px;" id="txtCalWorkCount" min="1" max="100" value="1"/></td>
			<td><fmt:message key="ui.member.time"/></td>
			<td><input class="easyui-numberspinner" style="width:60px;" id="txtCalWorkTime" min="1" max="1440" value="60"/></td>
			<td>
				<a  href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="javascript:workCal('ADD');"><fmt:message key="ui.button.Add"/></a>
				<a  href="#" class="easyui-linkbutton" iconCls="icon-delete" onclick="javascript:workCal('DEL');"><fmt:message key="ui.button.Delete"/></a>			
			</td>
		</tr>
		<tr>
			<td colspan="7" >
				<hr>
	            <table style="height:200px;" class="easyui-datagrid" id="workCalDetail" iconCls="icon-account-balances"  fit="true"  idField="rank" singleSelect="true">			
					<thead>
						<tr>										
							<th field="rank" width="70" sortable="false"><fmt:message key="ui.label.employee.position"/></th>
							<th field="count" width="70" sortable="false"><fmt:message key="ui.member.count"/></th>
							<th field="time" width="80" sortable="false"><fmt:message key="ui.member.time"/></th>
							<th field="priceA" width="105" sortable="false"><fmt:message key="ui.label.usecost"/>A</th>
							<th field="priceB" width="105" sortable="false"><fmt:message key="ui.label.usecost"/>B</th>
						</tr>	
					</thead>
				</table>								
			</td>
		</tr>
		<tr>
			<td colspan="7" align="center">
				<a  href="#" class="easyui-linkbutton" iconCls="icon-disk" onclick="javascript:workCal('SAVE');"><fmt:message key="ui.button.Save"/></a>			
			</td>
		</tr>
	</table>
</div>
<div id="divSearch" style="padding:5px;height:auto;" align="right">
       <div>		 
		 <fmt:message key="ui.label.OccurDate"/>
		 <input id="searchStdDt" class="easyui-datebox" style="width:90px;"  value="${today}"  /><span style="margin: 0em .3em;">~</span>
		 <input id="searchEndDt" class="easyui-datebox" style="width:90px;"  value="${today}"  />
		 <fmt:message key="ui.label.PartNo"/>
		 <input id="searchPartCode" size="20"/>
		 <a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchRegList();"><fmt:message key="ui.button.Search"/></a>
     </div>      
 </div>  

</body>

</html>
