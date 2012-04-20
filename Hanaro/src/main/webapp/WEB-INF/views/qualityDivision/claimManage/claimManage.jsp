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
		.valt{color:blue;}
		.valtRED{color:red;}
		
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
	        		$("input[name='cost']",$("#div"+divName)).val(rowData.price).trigger("change");
	        		$("#issueCustName"+divName).combogrid("setValue",rowData.custCode);
	        		if(partType=="1001"){	        			
	        			$("input[name='prodCost']",$("#div"+divName)).val(rowData.price).trigger("change");
	        			if(divName=="LS" || divName=="RW"){
	        				$("#p2"+divName).combogrid("setValue",rowData.partNo);
	        				$("input[name='p3']",$("#div"+divName)).val(rowData.partName);
	        			}else if(divName=="SW"){
	        				$("#p5"+divName).combogrid("setValue",rowData.partNo);
	        				$("input[name='p6']",$("#div"+divName)).val(rowData.partName);	        				
	        			}	
	        		}
	        	}else{
	        		$("input[name='prodCost']",$("#div"+divName)).val(rowData.price).trigger("change");
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
		cols.push({field:'DATA2',title:'<fmt:message key="ui.claimNo" />',width:110,sortable:true,align:'center'});
		cols.push({field:'DATA3',title:'INVOICE NO',width:110,sortable:true,align:'center'});
		cols.push({field:'DATA13',title:'<fmt:message key="ui.label.OccurDate" />',width:70,sortable:true,align:'center'});
		cols.push({field:'DATA10',hidden:true});
		cols.push({field:'DATA11',title:'<fmt:message key="ui.label.qualityIssue.reasonPartNo" />',width:120,sortable:true,align:'left'});
		cols.push({field:'DATA12',title:'<fmt:message key="ui.label.qualityIssue.reasonPartName" />',width:150,sortable:true,align:'left'});
		cols.push({field:'DATA5',hidden:true});
		cols.push({field:'DATA6',title:'<fmt:message key="ui.label.qualityIssue.reasonOrgan" />',width:90,sortable:true,align:'center'});
		cols.push({field:'DATA4',title:'CLAIM',width:70,sortable:true,align:'right',formatter:numeric});
		cols.push({field:'DATA7',hidden:true});
		cols.push({field:'DATA8',title:'<fmt:message key="ui.label.refTeam" />',width:70,sortable:true,align:'center'});
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
		if(ob=="LS"){
			cols.push({field:'DATA32',hidden:true});
			cols.push({field:'DATA33',title:'<fmt:message key="ui.label.type" />',width:80,sortable:true,align:'center'});
			cols.push({field:'DATA34',title:'<fmt:message key="ui.label.productPartNo" />',width:120,sortable:true,align:'left'});
			cols.push({field:'DATA35',title:'<fmt:message key="ui.label.productPartNm" />',width:150,sortable:true,align:'left'});
			cols.push({field:'DATA36',hidden:true});
			cols.push({field:'DATA37',hidden:true});
			cols.push({field:'DATA38',hidden:true});
			cols.push({field:'DATA39',hidden:true});			
		}else if(ob=="RW"){
			cols.push({field:'DATA32',hidden:true});
			cols.push({field:'DATA33',title:'<fmt:message key="ui.label.QualityIssue.OccurLine" />',width:130,sortable:true,align:'center'});
			cols.push({field:'DATA34',title:'<fmt:message key="ui.label.productPartNo" />',width:120,sortable:true,align:'left'});
			cols.push({field:'DATA35',title:'<fmt:message key="ui.label.productPartNm" />',width:150,sortable:true,align:'left'});
			cols.push({field:'DATA36',title:'<fmt:message key="ui.label.workCost" />',width:70,sortable:true,align:'right',formatter:numeric});
			cols.push({field:'DATA37',title:'<fmt:message key="ui.label.workContent" />',width:170,sortable:true,align:'left'});
			cols.push({field:'DATA38',hidden:true});
			cols.push({field:'DATA39',hidden:true});
			cols.push({field:'DATA40',hidden:true});
		}else if(ob=="SW"){
			cols.push({field:'DATA32',title:'<fmt:message key="ui.label.workCost" />',width:70,sortable:true,align:'right',formatter:numeric});
			cols.push({field:'DATA33',title:'<fmt:message key="ui.label.workContent" />',width:170,sortable:true,align:'left'});
			cols.push({field:'DATA34',title:'<fmt:message key="ui.label.selectCount" />',width:70,sortable:true,align:'right',formatter:numeric});						
			cols.push({field:'DATA35',hidden:true});
			cols.push({field:'DATA36',title:'<fmt:message key="ui.label.cagegory" />',width:110,sortable:true,align:'center'});
			cols.push({field:'DATA37',title:'<fmt:message key="ui.label.productPartNo" />',width:120,sortable:true,align:'left'});
			cols.push({field:'DATA38',title:'<fmt:message key="ui.label.productPartNm" />',width:150,sortable:true,align:'left'});
			cols.push({field:'DATA39',hidden:true});
			cols.push({field:'DATA40',hidden:true});
			cols.push({field:'DATA41',hidden:true});
			
		}else{
			cols.push({field:'DATA32',hidden:true});			
			cols.push({field:'DATA33',title:'<fmt:message key="ui.label.QualityIssue.OccurLine" />',width:130,sortable:true,align:'center'});
			cols.push({field:'DATA34',hidden:true});
			cols.push({field:'DATA35',hidden:true});
			cols.push({field:'DATA36',hidden:true});
			cols.push({field:'DATA37',hidden:true});			
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
	function fnSelectedEXD(value){		
		if(fnSelectedD(value))		
		$("input[name='issueTime']",$("#divEX")).val(fnSelected("p2","p3","p4","p5","EX")).trigger("change");
	}	
	
	function changePType(type,divName,codeString,nameString){
		$("input[name='tripCost']",$("#divSW")).val("0");
		
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
		$("#infoBomProdCost").val(rowData.prodCost);
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
		$("input[name='prodCost']",$("#div"+cDivision)).val($("#infoBomProdCost").val()).trigger("change");
		if(cDivision =="LS" ||cDivision =="RW"){
			$("#p2"+cDivision).combogrid("setValue",$("#infoBomPartCode").val());
			$("input[name='p3']",$("#div"+cDivision)).val($("#infoBomPartName").val());
		}else if (cDivision=="SW"){
			$("#p5"+cDivision).combogrid("setValue",$("#infoBomPartCode").val());
			$("input[name='p6']",$("#div"+cDivision)).val($("#infoBomPartName").val());
		}
		$("#dialogBom").dialog("close");
		
	}
	function popBom(divName){
		cDivision = divName;
		$("#dialogBom").dialog({modal:true});		
	}
	
	function popCalWork(){
		var cDiv = $("input[name='claimType']:checked").val();
		if(cDiv=="RW"){
			$("#trCost").numberspinner("setValue","0").numberspinner("disable");
		}else{
			var rPartType = $("select[name='partType1']",$("#div"+cDiv)).val();			
			if(rPartType=="1001")
				$("#trCost").numberspinner("setValue","0").numberspinner("enable");
			else
				$("#trCost").numberspinner("setValue","0").numberspinner("disable");
		}		
		$("#dialogCalWork").dialog({modal:true});
	}
	function workCal(){
		var cDiv = $("input[name='claimType']:checked").val();		
		var x1 = Number($("#sw1").numberspinner("getValue"));
		var x2 = Number($("#sw2").numberspinner("getValue"));
		var x3 = Number($("#dr1").numberspinner("getValue"));
		var x4 = Number($("#dr2").numberspinner("getValue"));
		var x5 = Number($("#gj1").numberspinner("getValue"));
		var x6 = Number($("#gj2").numberspinner("getValue"));
		var trip = Number($("#trCost").numberspinner("getValue"));
		var total = (((x2/60)*10000)*x1)
		 +(((x4/60)*15000)*x3)
		 +(((x6/60)*20000)*x5);
		if(cDiv=="SW"){
			$("input[name='p1']",$("#divSW")).val(Number(total).toFixed(2)).trigger("change");
			$("#workerCountSW").val(x1+x3+x5);
			$("input[name='tripCost']",$("#divSW")).val(Number(trip).toFixed(2));
		}else{
			$("input[name='p4']",$("#divRW")).val(Number(total).toFixed(2)).trigger("change");
			$("#workerCountRW").val(x1+x3+x5);			
		}
		$("#dialogCalWork").dialog("close");
		
	}
	
	function save(prodType){
		fnSelectedLS();
		
		fnSelectedEX();		
		var cDiv = $("input[name='claimType']:checked").val();		
		if($("form[name='form"+cDiv+"']").form("validate")){			
			$("input[name='prodType']",$("#div"+cDiv)).val(prodType);
			
			checkPop(cDiv);
			//$("body").css("cursor","wait");
			//$("form[name='form"+cDiv+"']").submit();
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
		
		$("#p4LS").timespinner("setValue","00:00");
		$("#p5LS").timespinner("setValue","00:00");
		$("#p6LS").timespinner("setValue","00:00");
		$("#p7LS").timespinner("setValue","00:00");
		$("#p2EX").timespinner("setValue","00:00");
		$("#p3EX").timespinner("setValue","00:00");
		$("#p4EX").timespinner("setValue","00:00");
		$("#p5EX").timespinner("setValue","00:00");		
		
		
	}
	function searchRegList(){		
		var params = {};
		params.stdDt = $("#searchStdDt").datebox("getValue");
		params.endDt = $("#searchEndDt").datebox("getValue");
		params.partCode = $("#searchPartCode").val();
		params.searchLocale = $("#searchLocale").val();
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
		$("input[name='issueTime']",$div).val(rowData.DATA18);
		$("input[name='lotNo']",$div).val(rowData.DATA24);
		
		$(".files").remove();		
		if(rowData.DATA25 !="" && rowData.DATA25 !=null)
			$("input[name='file1']",$div).after("<a href='getClaimFile?claimNo="+rowData.DATA2+"&fileName="+encodeURIComponent(rowData.DATA25)+"&fileSeq=1'  class='files "+fileExtensionIcon(rowData.DATA25)+"' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>");
		if(rowData.DATA26 !="" && rowData.DATA26 !=null)
			$("input[name='file2']",$div).after("<a href='getClaimFile?claimNo="+rowData.DATA2+"&fileName="+encodeURIComponent(rowData.DATA26)+"&fileSeq=2'  class='files "+fileExtensionIcon(rowData.DATA26)+"' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>");
		if(rowData.DATA27 !="" && rowData.DATA27 !=null)
			$("input[name='file3']",$div).after("<a href='getClaimFile?claimNo="+rowData.DATA2+"&fileName="+encodeURIComponent(rowData.DATA27)+"&fileSeq=3'  class='files "+fileExtensionIcon(rowData.DATA27)+"' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>");
		if(rowData.DATA28 !="" && rowData.DATA28 !=null)
			$("input[name='file4']",$div).after("<a href='getClaimFile?claimNo="+rowData.DATA2+"&fileName="+encodeURIComponent(rowData.DATA28)+"&fileSeq=4'  class='files "+fileExtensionIcon(rowData.DATA28)+"' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>");
		if(rowData.DATA29 !="" && rowData.DATA29 !=null)
			$("input[name='file5']",$div).after("<a href='getClaimFile?claimNo="+rowData.DATA2+"&fileName="+encodeURIComponent(rowData.DATA29)+"&fileSeq=5'  class='files "+fileExtensionIcon(rowData.DATA29)+"' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>");	
		
		$("#failAmount"+cDiv).numberspinner("setValue",rowData.DATA30);
		if(cDiv=="SW" || cDiv=="RW")
			$("input[name='workerCount']",$div).val(rowData.DATA17);
		else
			$("#workerCount"+cDiv).numberspinner("setValue",rowData.DATA17);
		$("input[name='claimCost']",$div).val(rowData.DATA4);
		$("input[name='cost']",$div).val(rowData.DATA9);
		$("select[name='issueTeam']",$div).val(rowData.DATA7);
		$("#issueCustName"+cDiv).combogrid("setValue",rowData.DATA6);
		$("input[name='issueCust']",$div).val(rowData.DATA5);
		$("input[name='claimContent']",$div).val(rowData.DATA14);
		if(cDiv=="LS"){
			$("select[name='p1']",$div).val(rowData.DATA32);
			$("#p2"+cDiv).combogrid("setValue",rowData.DATA34);
			$("input[name='p3']",$div).val(rowData.DATA35);
			$("#p4"+cDiv).timespinner("setValue",rowData.DATA36);
			$("#p5"+cDiv).timespinner("setValue",rowData.DATA37);
			$("#p6"+cDiv).timespinner("setValue",rowData.DATA38);
			$("#p7"+cDiv).timespinner("setValue",rowData.DATA39);
		}else if(cDiv=="RW"){
			$("select[name='p1']",$div).val(rowData.DATA32);
			$("#p2"+cDiv).combogrid("setValue",rowData.DATA34);
			$("input[name='p3']",$div).val(rowData.DATA35);
			$("input[name='p4']",$div).val(rowData.DATA36);
			$("input[name='p5']",$div).val(rowData.DATA37);
			$("select[name='p6']",$div).val(rowData.DATA38);
			$("#p7"+cDiv).numberspinner("setValue",rowData.DATA39);
			$("input[name='prodCost']",$div).val(rowData.DATA40);
		}else if(cDiv=="SW"){
			$("input[name='p1']",$div).val(rowData.DATA32);
			$("input[name='p2']",$div).val(rowData.DATA33);
			$("select[name='p3']",$div).val(rowData.DATA35);
			$("#p4"+cDiv).numberspinner("setValue",rowData.DATA34);
			$("#p5"+cDiv).combogrid("setValue",rowData.DATA37);
			$("input[name='p6']",$div).val(rowData.DATA38);			
			$("select[name='p7']",$div).val(rowData.DATA39);
			$("input[name='tripCost']",$div).val(rowData.DATA40);
			$("input[name='prodCost']",$div).val(rowData.DATA41);
		}else{
			$("select[name='p1']",$div).val(rowData.DATA32);
			$("#p2"+cDiv).timespinner("setValue",rowData.DATA34);
			$("#p3"+cDiv).timespinner("setValue",rowData.DATA35);
			$("#p4"+cDiv).timespinner("setValue",rowData.DATA36);
			$("#p5"+cDiv).timespinner("setValue",rowData.DATA37);			
		}
		
		
		
		$("#btReg").css("display","none");
		$("#btEdit").css("display","inline");
		$("#btDel").css("display","inline");
		
		
	}
	
	function changeActState(val){
		if(val=="AGREE"){			
			$("#actDivColor").css("display","inline");
		}else{
			$("#actAgreeStdDt").datebox("setValue","");
			$("#actAgreeEndDt").datebox("setValue","");
			$("#actAgreeBy").combobox("setValue","");
			$("#actDivColor").css("display","none");
		}
	}
	
	function searchAgreeList(){
		var params = {};
		params.selLocale = $("#actSearchLocale").val();
		params.regStdDt = $("#actRegStdDt").datebox("getValue");
		params.regEndDt = $("#actRegEndDt").datebox("getValue");
		params.regPartNo = $("#actRPartNo").combobox("getValue");
		params.invoiceNo = $("#actInvoiceNo").val();
		params.car = $("#actSearchCar").val();
		params.model = $("#actSearchModel").val();
		params.type = $("#actSearchType").val();
		params.inputBy = $("#actInputBy").combobox("getValue");
		params.deptCode = $("#actRefTeam").val();
		params.state = $("#actState").val();
		params.agreeStdDt = $("#actAgreeStdDt").datebox("getValue");
		params.agreeEndDt = $("#actAgreeEndDt").datebox("getValue");
		params.agreeBy = $("#actAgreeBy").combobox("getValue");
		
		$("#agreeList").datagrid("load",params);
	}
	function rowStyAgree(rowIndex,rowData){
		if(rowData.DATA20=="AGREE")
			return "background-color:#E7FAFD;";
		else if(rowData.DATA20=="WAIT")
			return "background-color:#FCE5FC;";
	}
	function claimCate(value,rowData,rowIndex){
		if(rowData.DATA3=="LS")
			return "color:red;";
		else if(rowData.DATA3=="RW")
			return "color:blue;";
		else if(rowData.DATA3=="SW")
			return "color:#089B00;";
		else
			return "color:#DEA300;";
	}
	function spinClaimEX(){
		calClaim('EX');
	}
	function spinClaimLS(){
		calClaim('LS');
	}
	function spinClaimRW(){
		calClaim('RW');
	}
	function spinClaimSW(){
		calClaim('SW');
	}	
	
	
	function calClaim(dtype){		
		var totalClaim = 0;
		var model = $("select[name='machineType']",$("#div"+dtype)).val();
		
		if(Number($("input[name='cost']",$("#div"+dtype)).val())==0){			
			return;
		}
		//기종별 생산금액현황
		var modelCost = 0;
		switch(model){
			case 'BK': modelCost = 4286; break;
			case 'HA': modelCost = 2500; break;
			case 'RR': modelCost = 6428; break;
			case 'PT': modelCost = 10000; break;
			default : modelCost = 0; break;
		}
		var cbm = 0;
		var totalCbm = 0;
		switch("${cLocale}"){
			case 'IN': cbm = 0.135; break;
			case 'CN' : cbm = 0.115; break;
			default : cbm = 0; break;
		}
		if(cbm==0){			
			return;
		}else{
			//물류비완성
			totalCbm = Number($("input[name='cost']",$("#div"+dtype)).val())*Number($("#failAmount"+dtype).numberspinner("getValue"))*Number(cbm);
		}
		var prodActionType = "";
		var prodFailCost = 0;
		var prodCount = 0;
		var prodCost =0;
		if(dtype=="RW" || dtype=="SW"){
			if(dtype=="RW"){
				prodActionType = $("select[name='p6']",$("#div"+dtype)).val();
				prodCount = $("#p7RW").numberspinner("getValue");
				prodCost = $("input[name='prodCost']",$("#div"+dtype)).val();
			}
			else{
				prodActionType = $("select[name='p7']",$("#div"+dtype)).val();
				prodCount = Number($("#failAmount"+dtype).numberspinner("getValue"));
				prodCost = $("input[name='cost']",$("#div"+dtype)).val();
			}
			
			
			switch(prodActionType){	
				case 'ALL' : prodFailCost = Number(prodCost)*Number(prodCount)*0.5;break;
				case 'PART' : prodFailCost = Number(prodCost)*Number(prodCount)*0.4;break;
				case 'IMMI' : prodFailCost = Number(prodCost)*Number(prodCount)*0.3;break;
				case 'TRASH' : prodFailCost = Number(prodCost)*Number(prodCount);break;
			}
		}
			
		if(dtype=="LS" || dtype=="EX"){
			totalClaim = Number(modelCost)*Number($("#workerCount"+dtype).numberspinner("getValue"))*(Number($("input[name='issueTime']",$("#div"+dtype)).val())/60);
			totalClaim = Number(totalClaim) + Number(totalCbm);
			totalClaim = Number(totalClaim) / Number($("input[name='cost']",$("#div"+dtype)).val());
			$("input[name='claimCost']",$("#div"+dtype)).val(Number(totalClaim).toFixed(0));
		}else if(dtype=="RW"){			
			totalClaim = Number(prodFailCost)*0.9;
			if(prodActionType!="TRASH"){
				totalClaim = Number(totalClaim) + Number($("input[name='p4']",$("#div"+dtype)).val());
				totalClaim = Number(totalClaim) + Number(totalCbm);
				totalClaim = Number(totalClaim) / Number($("input[name='cost']",$("#div"+dtype)).val());
			}
			$("input[name='claimCost']",$("#div"+dtype)).val(Number(totalClaim).toFixed(0));
		}else if(dtype="SW"){
			if($("select[name='partType1']",$("#div"+dtype)).val()=="1002"){
				totalClaim = Number($("input[name='cost']",$("#div"+dtype)).val())*Number($("#failAmount"+dtype).numberspinner("getValue"))*1.5;
				totalClaim = Number(totalClaim) + Number($("input[name='p1']",$("#div"+dtype)).val());
				totalClaim = Number(totalClaim) + Number(totalCbm);
				totalClaim = Number(totalClaim) / Number($("input[name='cost']",$("#div"+dtype)).val());
				$("input[name='claimCost']",$("#div"+dtype)).val(Number(totalClaim).toFixed(0));				
			}else{				
				totalClaim = Number(prodFailCost)+Number($("input[name='tripCost']",$("#div"+dtype)).val())+100000;				
				totalClaim = Number(totalClaim) + Number(totalCbm);				
				totalClaim = Number(totalClaim) + (Number($("input[name='prodCost']",$("#div"+dtype)).val())*0.2);				
				totalClaim = Number(totalClaim) * 0.9;
				$("input[name='claimCost']",$("#div"+dtype)).val(Number(totalClaim).toFixed(0));
			}	
		}
	}
	
	
	function checkPop(cDiv){
		var cbm = 0;
		switch("${cLocale}"){
			case 'IN': cbm = 0.135; break;
			case 'CN' : cbm = 0.115; break;
			default : cbm = 0; break;
		}		
		if(cDiv=="LS" || cDiv=="EX"){
			var model = $("select[name='machineType']",$("#div"+cDiv)).val();			
			var modelCost = 0;
			switch(model){
				case 'BK': modelCost = 4286; break;
				case 'HA': modelCost = 2500; break;
				case 'RR': modelCost = 6428; break;
				case 'PT': modelCost = 10000; break;
				default : modelCost = 0; break;
			}
			$("#cLSEX1").empty().append(modelCost+" x ");
			$("#cLSEX2").empty().append($("input[name='workerCount']",$("#div"+cDiv)).val()+" x ");
			$("#cLSEX3").empty().append($("input[name='issueTime']",$("#div"+cDiv)).val()+" + ");
			$("#cLSEX4").empty().append("("+$("input[name='cost']",$("#div"+cDiv)).val()+"x"+$("#failAmount"+cDiv).numberspinner("getValue")+"x"+cbm+")");
			$("#cLSEX5").empty().append($("input[name='cost']",$("#div"+cDiv)).val());
			$("#cLSEX6").empty().append($("input[name='claimCost']",$("#div"+cDiv)).val());
			$("#checkLSEX").dialog({modal:true});
		}else if (cDiv=="RW" && $("select[name='p6']",$("#div"+cDiv)).val()!="TRASH"){			
			$("#cRW1").empty().append($("input[name='prodCost']",$("#div"+cDiv)).val()+" x ");
			$("#cRW2").empty().append($("#p7RW").numberspinner("getValue")+" x ");			
			var rate = "";
			switch($("select[name='p6']",$("#div"+cDiv)).val()){
				case 'ALL' : rate = "0.5";break;
				case 'PART' : rate = "0.4";break;
				case 'IMMI' : rate = "0.3";break;
				case 'TRASH' : rate = "1.0";break;			
			}
			$("#cRW3").empty().append(rate);
			$("#cRW4").empty().append($("input[name='p4']",$("#div"+cDiv)).val()+" + ");
			$("#cRW5").empty().append("("+$("input[name='cost']",$("#div"+cDiv)).val()+"x"+$("#failAmount"+cDiv).numberspinner("getValue")+"x"+cbm+")");
			$("#cRW6").empty().append($("input[name='cost']",$("#div"+cDiv)).val());
			$("#cRW7").empty().append($("input[name='claimCost']",$("#div"+cDiv)).val());
			$("#checkRW").dialog({modal:true});
		}else if (cDiv=="RW" && $("select[name='p6']",$("#div"+cDiv)).val()=="TRASH"){			
			$("#cRWT1").empty().append($("input[name='prodCost']",$("#div"+cDiv)).val()+" x ");
			$("#cRWT2").empty().append($("#p7RW").numberspinner("getValue"));
			$("#cRWT3").empty().append($("input[name='claimCost']",$("#div"+cDiv)).val());
			$("#checkRWT").dialog({modal:true});
		}else if(dtype="SW"){
			if($("select[name='partType1']",$("#div"+dtype)).val()=="1002"){
				$("#cSWM1").empty().append($("input[name='cost']",$("#div"+cDiv)).val()+" x ");
				$("#cSWM2").empty().append($("#failAmount"+cDiv).numberspinner("getValue"));
				$("#cSWM3").empty().append($("input[name='p1']",$("#div"+cDiv)).val()+" + ");
				$("#cSWM4").empty().append("("+$("input[name='cost']",$("#div"+cDiv)).val()+"x"+$("#failAmount"+cDiv).numberspinner("getValue")+"x"+cbm+")");
				$("#cSWM5").empty().append($("input[name='cost']",$("#div"+cDiv)).val());
				$("#cSWM6").empty().append($("input[name='claimCost']",$("#div"+cDiv)).val());
				$("#checkSWM").dialog({modal:true});
			}else{				
				$("#cSWP1").empty().append($("input[name='cost']",$("#div"+cDiv)).val()+" x ");
				$("#cSWP2").empty().append($("#failAmount"+cDiv).numberspinner("getValue")+" x ");
				var rate = "";
				switch($("select[name='p7']",$("#div"+cDiv)).val()){
					case 'ALL' : rate = "0.5";break;
					case 'PART' : rate = "0.4";break;
					case 'IMMI' : rate = "0.3";break;
					case 'TRASH' : rate = "1.0";break;			
				}				
				$("#cSWP3").empty().append(rate+" + ");
				$("#cSWP4").empty().append($("input[name='tripCost']",$("#div"+cDiv)).val()+" + ");
				$("#cSWP5").empty().append("("+$("input[name='cost']",$("#div"+cDiv)).val()+"x"+$("#failAmount"+cDiv).numberspinner("getValue")+"x"+cbm+") + ");
				$("#cSWP6").empty().append(Number($("input[name='cost']",$("#div"+cDiv)).val())*0.2);
				$("#cSWP7").empty().append($("input[name='claimCost']",$("#div"+cDiv)).val());
				$("#checkSWP").dialog({modal:true});
			}	
		}
	}
	function subForm(){
		var cDiv = $("input[name='claimType']:checked").val();
		$("body").css("cursor","wait");
		$("form[name='form"+cDiv+"']").submit();		
	}
	
	function agreeClick(rowIndex, rowData){
		var claimNo = rowData.DATA1;
        var win = window.open("claimAgree?claimNo="+claimNo,"AgreeDetail","width=930,height=680,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no");
        win.focus();
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
			
			workPartListCallbak("rPartCodeRW","rPartName","carType","1002","RW");
			workPartListCallbak("p2RW","p3","","1001","RW");
			workCustListCallbak("issueCustName","issueCust","RW");
			
			workPartListCallbak("rPartCodeSW","rPartName","carType","1002","SW");
			workPartListCallbak("p5SW","p6","","1001","SW");
			workCustListCallbak("issueCustName","issueCust","SW");
			
			workPartListCallbak("rPartCodeEX","rPartName","carType","1002","EX");
			workCustListCallbak("issueCustName","issueCust","EX");
			
			$("input[name='p2']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p3']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p4']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			$("input[name='p5']",$("#divEX")).timespinner({value:"00:00",required:true,showSeconds:false,onSpinUp:fnSelectedEX,onSpinDown:fnSelectedEX});
			
			$("#workerCountLS").numberspinner({onSpinUp:spinClaimLS,onSpinDown:spinClaimLS});
			$("#workerCountEX").numberspinner({onSpinUp:spinClaimEX,onSpinDown:spinClaimEX});
			$("#failAmountLS").numberspinner({onSpinUp:spinClaimLS,onSpinDown:spinClaimLS});
			$("#failAmountEX").numberspinner({onSpinUp:spinClaimEX,onSpinDown:spinClaimEX});
			$("#failAmountRW").numberspinner({onSpinUp:spinClaimRW,onSpinDown:spinClaimRW});
			$("#failAmountSW").numberspinner({onSpinUp:spinClaimSW,onSpinDown:spinClaimSW});
			
			$("#p7RW").numberspinner({onSpinUp:spinClaimRW,onSpinDown:spinClaimRW});

			$("#ebomPart").datagrid({onClickRow:ebomPartClick});
			$("#ebomPartDetail").datagrid({onDblClickRow:ebomPartDetailClick});			
			$("#listReg").datagrid({onClickRow:listRegClick});
			$("#agreeList").datagrid({onDblClickRow:agreeClick});
			
			
			
			
			
			
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
							<form name="formLS" action="claimManage" method="post" enctype="multipart/form-data" >
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
										<th><span  class="label-Leader-blue" >LOT NO</span></th>
										<td><input name="lotNo" type="text"  class="easyui-validatebox" required="true" /></td>										
										<th><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td><input id="failAmountLS" name="failAmount" min="0" max="999999" required="true"   value="0" onchange="javascript:calClaim('LS');"  /></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.productPartNo'/></span></th>
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
										<th class="LS"><span  class="label-Leader-black" ><fmt:message key='ui.label.productPartNm'/></span></th>
										<td class="LS"><input name="p3" type="text" readonly/></td>																		
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true"  onchange="javascript:calClaim('LS');">
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
										<td><input name="issueTime" type="text" readonly value="0"  onchange="javascript:calClaim('LS');"></td>
										<th class="LS"><span  class="label-Leader-blue" ><fmt:message key='ui.label.endTime'/></span></th>
										<td class="LS"><input name="p5" id="p5LS" onchange="javascript:fnSelectedLSD(this.value);" /></td>																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input id="workerCountLS" name="workerCount"  min="0" max="100" required="true"   value="0"  onchange="javascript:calClaim('LS');" /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0"  onchange="javascript:calClaim('LS');" />
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
										<td colspan="3"><input name="claimContent" type="text"  style="width:570px;" /></td>									
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.File'/></span></th>
										<td colspan="5">
											<input name="file1" type="file" style="width:160px;"/>
											<input name="file2" type="file" style="width:160px;"/>
											<input name="file3" type="file" style="width:160px;"/>
											<input name="file4" type="file" style="width:160px;"/>
											<input name="file5" type="file" style="width:160px;"/>
										</td>
									</tr>															
								</table>
							</form>					
						</div>	
						<div id="divRW">
							<form name="formRW"  action="claimManage" method="post" enctype="multipart/form-data">
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
										<th><span  class="label-Leader-blue" >LOT NO</span></th>
										<td><input name="lotNo" type="text"  class="easyui-validatebox" required="true" /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td><input id="failAmountRW" name="failAmount" min="0" max="999999" required="true"   value="0"  onchange="javascript:calClaim('RW');"  /></td>
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.productPartNo'/></span></th>
										<td class="RW">																					
											<input id="p2RW" name="p2" style="width:130px;" required="true" />
											<input name="prodCost" type = "hidden" value="0"  onchange="javascript:calClaim('RW');"/>
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
										<th class="RW"><span  class="label-Leader-black" ><fmt:message key='ui.label.productPartNm'/></span></th>
										<td class="RW"><input name="p3" type="text" readonly/></td>																		
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true"   onchange="javascript:calClaim('RW');">
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th  class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.productCount'/></span></th>
										<td  class="RW"><input id="p7RW" name="p7" min="0" max="999999" required="true"   value="0"  onchange="javascript:calClaim('RW');"  /></td>										
																																								
									</tr>			 			
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.reworkDt'/></span></th>
										<td><input id="issueDateRW" name="issueDate" class="easyui-datebox"  required="true" editable="false" /></td>									
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.reworkTime'/></span></th>
										<td><input name="issueTime" class="easyui-numberspinner"  id="txtCalWorkTime" min="0" max="1440" value="0"/></td>
										<th class="RW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workCost'/></span></th>
										<td class="RW">
											<input name="p4" class="easyui-validatebox" required="true"  style="width:150px;" value="0"/>
											<a  href="#" class="easyui-linkbutton" iconCls="icon-account-balances" onclick="javascript:popCalWork();" plain="true"></a>
										</td>										
																													
									</tr>
									<tr>
										<th class="RW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td class="RW" ><input id="workerCountRW" name="workerCount" class="easyui-validatebox"   value="0" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0"  onchange="javascript:calClaim('RW');" />
										</td>		
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workContent'/></span></th>
										<td class="RW"><input name="p5" class="easyui-validatebox" required="true" /></td>																																	
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
										<th class="RW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workType'/></span></th>
										<td class="RW">
											<select name="p6" class="easyui-validatebox"  required="true"  onchange="javascript:calClaim('RW');" >
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${rsType}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>																																									
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="3"><input name="claimContent" type="text"  style="width:570px;" /></td>									
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.File'/></span></th>
										<td colspan="5">
											<input name="file1" type="file" style="width:160px;"/>
											<input name="file2" type="file" style="width:160px;"/>
											<input name="file3" type="file" style="width:160px;"/>
											<input name="file4" type="file" style="width:160px;"/>
											<input name="file5" type="file" style="width:160px;"/>
										</td>
									</tr>
								</table>
							</form>
						</div>
						
									
						<div id="divSW">
							<form name="formSW"  action="claimManage" method="post" enctype="multipart/form-data">
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
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectCount'/></span></th>
										<td class="SW"><input id="p4SW" name="p4" class="easyui-numberspinner"  min="0" max="9999999" required="true"   value="0"  /></td>																																			
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" >LOT NO</span></th>
										<td><input name="lotNo" type="text"  class="easyui-validatebox" required="true" /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td><input id="failAmountSW" name="failAmount" class="easyui-numberspinner"  min="0" max="999999" required="true"   value="0" onchange="javascript:calClaim('SW');"   /></td>
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.productPartNo'/></span></th>										
										<td class="SW">																					
											<input id="p5SW" name="p5" style="width:130px;" required="true" />
											<input name="prodCost" type = "hidden" value="0"  onchange="javascript:calClaim('SW');" />
											<input name="tripCost" type = "hidden" value="0"  onchange="javascript:calClaim('SW');" />
										</td>															
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
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.productPartNm'/></span></th>
										<td class="SW"><input name="p6" type="text" readonly/></td>
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.Model'/></span></th>
										<td>
											<select name="machineType" class="easyui-validatebox" required="true"    onchange="javascript:calClaim('SW');">
												<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${model}" var="citem">
													<option value="${citem.code}">${citem.name}</option>
												</c:forEach>
											</select>
										</td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
										<td><input name="rPartName" type="text" readonly/></td>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workCost'/></span></th>
										<td class="SW">
											<input name="p1" class="easyui-validatebox" required="true"  style="width:150px;"  value="0"/>
											<a  href="#" class="easyui-linkbutton" iconCls="icon-account-balances" onclick="javascript:popCalWork();" plain="true"></a>
										</td>										
									</tr>						
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectDt'/></span></th>
										<td><input id="issueDateSW" name="issueDate" class="easyui-datebox"  required="true" editable="false" /></td>									
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectTime'/></span></th>
										<td><input name="issueTime"  class="easyui-numberspinner" id="txtCalWorkTime" min="0" max="1440" value="0" /></td>																																							
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workContent'/></span></th>
										<td class="SW"><input name="p2" class="easyui-validatebox" required="true" /></td>						
									</tr>
									<tr>
										<th class="SW"><span  class="label-Leader-black" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td class="SW" ><input id="workerCountSW" name="workerCount" class="easyui-validatebox"   value="0" readonly/></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0"  onchange="javascript:calClaim('SW');" />
										</td>					
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.selectType'/></span></th>
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
										<th class="SW"><span  class="label-Leader-blue" ><fmt:message key='ui.label.workType'/></span></th>
										<td class="SW">
											<select name="p7" class="easyui-validatebox"  required="true"  onchange="javascript:calClaim('SW');" >
											<option value=""><fmt:message key='ui.element.Select'/></option>
												<c:forEach items="${rsType}" var="cDept">
													<option value="${cDept.code}">${cDept.name}</option>
												</c:forEach>
											</select>
										</td>																																	
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.claimContent'/></span></th>
										<td colspan="3"><input name="claimContent" type="text"  style="width:570px;" /></td>
																	
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.File'/></span></th>
										<td colspan="5">
											<input name="file1" type="file" style="width:160px;"/>
											<input name="file2" type="file" style="width:160px;"/>
											<input name="file3" type="file" style="width:160px;"/>
											<input name="file4" type="file" style="width:160px;"/>
											<input name="file5" type="file" style="width:160px;"/>
										</td>
									</tr>								
								</table>
							</form>
						</div>
						
						<div id="divEX">
							<form name="formEX"  action="claimManage" method="post" enctype="multipart/form-data">
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
										<th><span  class="label-Leader-blue" >LOT NO</span></th>
										<td><input name="lotNo" type="text" class="easyui-validatebox" required="true" /></td>
										<th><span  class="label-Leader-blue" ><fmt:message key='chartYName.issueAmount'/></span></th>
										<td><input id="failAmountEX" name="failAmount"   min="0" max="999999" required="true"   value="0" onchange="javascript:calClaim('EX');"   /></td>
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
											<select name="machineType" class="easyui-validatebox" required="true"    onchange="javascript:calClaim('EX');">
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
										<td><input name="issueTime" type="text" readonly value="0" onchange="javascript:calClaim('EX');" ></td>
										<th class="EX"><span  class="label-Leader-blue" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
										<td class="EX"><input  id="p5EX" name="p5" onchange="javascript:fnSelectedEXD(this.value);"  /></td>																				
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workerCount'/></span></th>
										<td><input id="workerCountEX" name="workerCount"  min="0" max="100" required="true"   value="0" onchange="javascript:calClaim('EX');"   /></td>
										<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
										<td>
											<input name="claimCost" type="text" readonly value="0" />
											<input name="cost" type="hidden" value="0"   onchange="javascript:calClaim('EX');"/>
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
										<td colspan="3"><input name="claimContent" type="text"  style="width:570px;" /></td>									
									</tr>
									<tr>
										<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.File'/></span></th>
										<td colspan="5">
											<input name="file1" type="file" style="width:160px;"/>
											<input name="file2" type="file" style="width:160px;"/>
											<input name="file3" type="file" style="width:160px;"/>
											<input name="file4" type="file" style="width:160px;"/>
											<input name="file5" type="file" style="width:160px;"/>
										</td>
									</tr>								
								</table>
							</form>
						</div>						
					</div>  				
				</td>
			</tr>
			<tr>
				<td>
					<table style="width:1100px;height:300px;" title='<fmt:message key="ui.label.RegList"/>' toolbar="#divSearch" pagination="true"  id="listReg" 
							pageSize="10"   singleSelect="true" striped="true"  url="getClaimRegList?classType=LS" >
						<thead>
					        <tr>  
					            <th field="DATA0" hidden="true"></th>  
					            <th field="DATA1" hidden="true"></th>  
					            <th field="DATA2" width="110" sortable="true" align="center"><fmt:message key="ui.claimNo" /></th>  				      
					            <th field="DATA3" width="110" sortable="true" align="center">INVOICE NO</th>
					            <th field="DATA13" width="70" sortable="true" align="center"><fmt:message key="ui.label.OccurDate"/></th>
					            <th field="DATA10" hidden="true"></th>  
					            <th field="DATA11" width="120" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>
					            <th field="DATA12" width="150" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartName" /></th>  
					            <th field="DATA5" hidden="true"></th>  
					            <th field="DATA6" width="90" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>  
					            <th field="DATA4" width="70" sortable="true" align="right" formatter="numeric">CLAIM</th>
					            <th field="DATA7" hidden="true"></th>
					            <th field="DATA8" width="70" sortable="true" align="center"><fmt:message key="ui.label.refTeam" /></th>
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
					            <th field="DATA32" hidden="true"></th>
					            <th field="DATA33" width="80" sortable="true" align="center"><fmt:message key="ui.label.type"/></th>
					            <th field="DATA34" width="120" sortable="true" align="left"><fmt:message key="ui.label.productPartNo"/></th>
					            <th field="DATA35" width="150" sortable="true" align="left"><fmt:message key="ui.label.productPartNm"/></th>
					            <th field="DATA36" hidden="true"></th>
					            <th field="DATA37" hidden="true"></th>
					            <th field="DATA38" hidden="true"></th>
					            <th field="DATA39" hidden="true"></th>
	    					</tr> 
						</thead>
					</table>					
				</td>
			</tr>
		</table>        
    </div>
    <div title="<fmt:message key='ui.label.claimAction'/>" iconCls="icon-table-money" style="padding:20px;">     
	     <table title="<fmt:message key='ui.label.actionList'/>" toolbar="#divActionListTool" id="agreeList" fit="true"  idField="DATA1" singleSelect="true" url="getClaimAgreeList" pagination="true"  pageSize="50"
	     	rowStyler = "rowStyAgree"   >			
			<thead>
				<tr>
					<th field="DATA0" hidden="true"></th>										
					<th field="DATA1" width="120" sortable="true"  align="left"><fmt:message key="ui.claimNo"/></th>
		            <th field="DATA2" width="110" sortable="true" align="center">INVOICE NO</th>
		            <th field="DATA3" hidden="true"></th>
		            <th field="DATA4" width="90" sortable="true" align="center" styler="claimCate"><fmt:message key="ui.label.cagegory"/></th>		            
		            <th field="DATA5" width="70" sortable="true" align="center"><fmt:message key="ui.label.OccurDate"/></th>
		            <th field="DATA6" width="120" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>
		            <th field="DATA7" hidden="true"></th>
		            <th field="DATA8" width="90" sortable="true" align="center"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>
		            <th field="DATA9" width="70" sortable="true" align="right" formatter="numeric">CLAIM</th>
		            <th field="DATA10" width="60" sortable="true" align="center"><fmt:message key="ui.label.Car"/></th>
		            <th field="DATA11" hidden="true"></th>
		            <th field="DATA12" width="70" sortable="true" align="center"><fmt:message key="ui.label.Model"/></th>
		            <th field="DATA13" hidden="true"></th>
		            <th field="DATA14" width="70" sortable="true" align="center"><fmt:message key="ui.label.refTeam" /></th>
		            <th field="DATA15" hidden="true"></th>  		            
		            <th field="DATA16" width="100" sortable="true" align="center"><fmt:message key="ui.writer" /></th>
		            <th field="DATA17" width="70" sortable="true" align="center"><fmt:message key="ui.label.actionDt"/></th>
		            <th field="DATA18" hidden="true"></th>
		            <th field="DATA19" width="100" sortable="true" align="center"><fmt:message key="ui.label.actor" /></th>
		            <th field="DATA20" hidden="true"></th>
		            <th field="DATA21" hidden="true"></th>											
				</tr>	
			</thead>
		</table>
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
										<th field="prodCost" hidden="true"></th>																			
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
    								<td colspan="3"><input type="text" id="infoBomPartName" size="35"/ readonly></td>
    								<td><fmt:message key="ui.label.unitPrice"/></td>
    								<td><input type="text" id="infoBomProdCost" readonly size="5"></td>    								
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
			<th>
				<fmt:message key="ui.member.sw"/> : 
				<input type="hidden" value="10000"/>
			</th>						
			<td><fmt:message key="ui.member.count"/></td>
			<td><input id="sw1" class="easyui-numberspinner" style="width:60px;" min="0" max="100" value="0"/></td>
			<td><fmt:message key="ui.member.time"/></td>
			<td><input id="sw2" class="easyui-numberspinner" style="width:60px;" min="0" max="1440" value="0"/></td>
		</tr>
		<tr>			
			<th>
				<fmt:message key="ui.member.dr"/> : 
				<input type="hidden" value="15000"/>
			</th>
			<td><fmt:message key="ui.member.count"/></td>
			<td><input id="dr1" class="easyui-numberspinner" style="width:60px;" min="0" max="100" value="0"/></td>
			<td><fmt:message key="ui.member.time"/></td>
			<td><input id="dr2" class="easyui-numberspinner" style="width:60px;" min="0" max="1440" value="0"/></td>
		</tr>	
		<tr>			
			<th>
				<fmt:message key="ui.member.gj"/> : 
				<input type="hidden" value="20000"/>
			</th>
			<td><fmt:message key="ui.member.count"/></td>
			<td><input id="gj1" class="easyui-numberspinner" style="width:60px;" min="0" max="100" value="0"/></td>
			<td><fmt:message key="ui.member.time"/></td>
			<td><input id="gj2" class="easyui-numberspinner" style="width:60px;"  min="0" max="1440" value="0"/></td>		
		</tr>
		<tr>
			<th colspan="2"><fmt:message key="ui.label.tripCost"/> :</th>		
			<td colspan="3">
				<input id="trCost" class="easyui-numberspinner" style="width:120px;" min="0" max="999999999" value="0"/>
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center">
				<hr>
				<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:workCal();"><fmt:message key="ui.button.apply"/></a>			
			</td>
		</tr>
	</table>
</div>
<div id="divSearch" style="padding:5px;height:auto;" align="right">
       <div>		 
       	 <c:if test="${cLocale=='KR'}"> 
			 <fmt:message key="ui.label.local"/>
			 <select id="searchLocale">
			 	<option value="KR"><fmt:message key="ui.element.All"/></option>
			 	<option value="CN"><fmt:message key="country.china"/></option>
			 	<option value="IN"><fmt:message key="country.india"/></option>
			 	<option value="CZ"><fmt:message key="country.czech"/></option>
			 </select><span style="width:20px;">&nbsp;&nbsp;</span>
		 </c:if>       
		 <fmt:message key="ui.label.OccurDate"/>
		 <input id="searchStdDt" class="easyui-datebox" style="width:90px;"  value="${today}"  /><span style="margin: 0em .3em;">~</span>
		 <input id="searchEndDt" class="easyui-datebox" style="width:90px;"  value="${today}"  /><span style="width:20px;">&nbsp;&nbsp;</span>
		 <fmt:message key="ui.label.PartNo"/>
		 <input id="searchPartCode" size="20"/>
		 <a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchRegList();"><fmt:message key="ui.button.Search"/></a>
     </div>      
 </div>
 <div id="divActionListTool" style="padding:5px;height:auto;">
       <div style="padding:3px;">
       	 <c:if test="${cLocale=='KR'}"> 
			 <span class="label-Leader-blue"><fmt:message key="ui.label.local"/></span>
			 <select id="actSearchLocale">
			 	<option value="KR"><fmt:message key="ui.element.All"/></option>
			 	<option value="CN"><fmt:message key="country.china"/></option>
			 	<option value="IN"><fmt:message key="country.india"/></option>
			 	<option value="CZ"><fmt:message key="country.czech"/></option>
			 </select>
		 </c:if>
		 <span class="label-Leader-blue"><fmt:message key="ui.label.cagegory"/></span>
		 <select id="actSearchType">
		 	<option value=""><fmt:message key="ui.element.All"/></option>
			<c:forEach items="${claimType}" var="cDept">
				<option value="${cDept.code}">${cDept.name}</option>
			</c:forEach>	
		 </select>	
		 <span class="label-Leader-blue"><fmt:message key="ui.label.Car"/></span>
		 <select id="actSearchCar">
		 	<option value=""><fmt:message key="ui.element.All"/></option>
			<c:forEach items="${actCar}" var="cDept">
				<option value="${cDept.code}">${cDept.name}</option>
			</c:forEach>	
		 </select>		 
		 <span class="label-Leader-blue"><fmt:message key="ui.label.Model"/></span>
		 <select id="actSearchModel">
		 	<option value=""><fmt:message key="ui.element.All"/></option>
			<c:forEach items="${model}" var="cDept">
				<option value="${cDept.code}">${cDept.name}</option>
			</c:forEach>	
		 </select>
		 <span class="label-Leader-blue"><fmt:message key="ui.label.refTeam"/></span>
		 <select id="actRefTeam">
		 	<option value=""><fmt:message key="ui.element.All"/></option>
			<c:forEach items="${claimDept}" var="cDept">
				<option value="${cDept.code}">${cDept.name}</option>
			</c:forEach>	
		 </select>		
		 <span class="label-Leader-blue"><fmt:message key="ui.label.progressStatus"/></span>
		 <select id="actState" onchange="javascript:changeActState(this.value);">
		 	<option value=""><fmt:message key="ui.element.All"/></option>
			<c:forEach items="${actState}" var="cDept">
				<option value="${cDept.code}">${cDept.name}</option>
			</c:forEach>	
		 </select>			  
     </div>      
     <div style="padding:3px;">
		 <span class="label-Leader-blue"><fmt:message key="ui.label.OccurDate"/></span>
		 <input id="actRegStdDt" class="easyui-datebox" style="width:90px;"/>
		 <span style="margin: 0em .3em;">~</span>
		 <input id="actRegEndDt" class="easyui-datebox" style="width:90px;"/>
		 <span class="label-Leader-blue"><fmt:message key="ui.label.reason"/></span>
		 <input id="actRPartNo" class="easyui-combobox" url="getClaimActionItem?type=RPARTNO"  valueField="code" textField = "name" mode="remote" />
		 <span class="label-Leader-blue">INVOICE NO</span>
		 <input id="actInvoiceNo" type="text" />
		 <span class="label-Leader-blue"><fmt:message key="ui.writer"/></span>
		 <input id="actInputBy" class="easyui-combobox" url="getClaimActionItem?type=INPUTBY"  valueField="code" textField = "name" mode="remote" />		 		 
     </div>
     <div style="padding:3px;display:none;" id="actDivColor">
		 <span class="label-Leader-green"><fmt:message key="ui.label.actionDt"/></span>
		 <input id="actAgreeStdDt" class="easyui-datebox" style="width:90px;background-color: #d9d9d9;" />
		 <span style="margin: 0em .3em;">~</span>
		 <input id="actAgreeEndDt" class="easyui-datebox" style="width:90px;" />		 
		 <span class="label-Leader-green"><fmt:message key="ui.label.actor"/></span>
		 <input id="actAgreeBy" class="easyui-combobox" url="getClaimActionItem?type=AGREEBY"  valueField="code" textField = "name" mode="remote" />		 		 
     </div>     
     <div style="padding:3px;" align="right">
     	<span style="background-color:#E7FAFD;padding:3px 7px;border:1px solid #B5B5B5;">${actState[0].name}</span>
     	<span style="background-color:#FCE5FC;padding:3px 7px;border:1px solid #B5B5B5;">${actState[2].name}</span>
     	<span style="background-color:#FFFFFF;padding:3px 7px;border:1px solid #B5B5B5;">${actState[1].name}</span>          	
     	<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchAgreeList();"><fmt:message key="ui.button.Search"/></a>
     </div>
 </div>
 
 
 <div title="<fmt:message key='ui.label.checkClaim'/>" id="checkLSEX" style="padding:20px;">
 	<p style="background-color:#E2F0FE;">
 		<b>[<fmt:message key="ui.label.calBasic"/>]</b><br>
		(<fmt:message key="ui.label.modelCost"/> x 
		<fmt:message key="ui.label.workerCount"/> x 
		<fmt:message key="ui.label.needWorkTime"/> + 
		<fmt:message key="ui.label.delCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x CBM(<c:if test ="${cLocale=='IN'}">13.5%</c:if><c:if test ="${cLocale=='CN'}">11.5%</c:if>)
		)) / <fmt:message key="ui.label.unitPrice"/> 	
 	</p>
 	<p>
	 	<table>
	 		<tr>
	 			<th colspan="7" align="left">[<fmt:message key="ui.label.claimCost"/>]</th>
	 		</tr>
	 		<tr>
	 			<td> ( </td>
	 			<td class="valt"> ( </td>
	 			<td id="cLSEX1" class="valt"></td>
	 			<td id="cLSEX2" class="valt"></td>
	 			<td id="cLSEX3" class="valt"></td>
	 			<td id="cLSEX4" class="valt"></td>
	 			<td class="valt"> ) / <td>
	 			<td id="cLSEX5" class="valt"></td>
	 			<td class="valt"> = <td>
	 			<th id="cLSEX6" class="valtRED"></th>
	 		</tr>			 		 		 		
	 	</table>
 	</p>
 	<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:subForm();"><fmt:message key="ui.button.apply"/></a>
 </div>
 
 <div title="<fmt:message key='ui.label.checkClaim'/>" id="checkRW" style="padding:20px;">
 	<p style="background-color:#E2F0FE;">
 		<b>[<fmt:message key="ui.label.calBasic"/>]</b><br>
		(<fmt:message key="ui.label.prodFailCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x α) x 90% +  
		<fmt:message key="ui.label.workCost"/> + 
		<fmt:message key="ui.label.delCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x CBM(<c:if test ="${cLocale=='IN'}">13.5%</c:if><c:if test ="${cLocale=='CN'}">11.5%</c:if>)
		)) / <fmt:message key="ui.label.unitPrice"/> 	
 	</p>
 	<p>
	 	<table>
	 		<tr>
	 			<th colspan="11" align="left">[<fmt:message key="ui.label.claimCost"/>]</th>
	 		</tr>
	 		<tr>	 			
	 			<td class="valt"> ( </td>
	 			<td id="cRW1" class="valt"></td>
	 			<td id="cRW2" class="valt"></td>
	 			<td id="cRW3" class="valt"></td>
	 			<td class="valt"> x 0.9 + <td>
	 			<td id="cRW4" class="valt"></td>
	 			<td id="cRW5" class="valt"></td>
	 			<td class="valt"> ) / <td>
	 			<td id="cRW6" class="valt"></td>
	 			<td class="valt"> = <td>
	 			<th id="cRW7" class="valtRED"></th>
	 		</tr>			 		 		 		
	 	</table>
 	</p>
 	<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:subForm();"><fmt:message key="ui.button.apply"/></a>
 </div> 
 
  <div title="<fmt:message key='ui.label.checkClaim'/>" id="checkRWT" style="padding:20px;">
 	<p style="background-color:#E2F0FE;">
 		<b>[<fmt:message key="ui.label.calBasic"/>]</b><br>
		<fmt:message key="ui.label.prodFailCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/>) x 90%  	
 	</p>
 	<p>
	 	<table>
	 		<tr>
	 			<th colspan="6" align="left">[<fmt:message key="ui.label.claimCost"/>]</th>
	 		</tr>
	 		<tr>	 			
	 			<td class="valt">  </td>
	 			<td id="cRWT1" class="valt"></td>
	 			<td id="cRWT2" class="valt"></td>	 			
	 			<td class="valt"> x 0.9<td>
	 			<td class="valt"> = <td>
	 			<th id="cRWT3" class="valtRED"></th>
	 		</tr>			 		 		 		
	 	</table>
 	</p>
 	<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:subForm();"><fmt:message key="ui.button.apply"/></a>
 </div>
 
  <div title="<fmt:message key='ui.label.checkClaim'/>" id="checkSWM" style="padding:20px;">
 	<p style="background-color:#E2F0FE;">
 		<b>[<fmt:message key="ui.label.calBasic"/>]</b><br>
		(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/>) x 150% + 
		<fmt:message key="ui.label.workCost"/> +
		<fmt:message key="ui.label.delCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x CBM(<c:if test ="${cLocale=='IN'}">13.5%</c:if><c:if test ="${cLocale=='CN'}">11.5%</c:if>)) 
		) / <fmt:message key="ui.label.unitPrice"/>		
 	</p>
 	<p>
	 	<table>
	 		<tr>
	 			<th colspan="10" align="left">[<fmt:message key="ui.label.claimCost"/>]</th>
	 		</tr>
	 		<tr>	 			
	 			<td class="valt">(</td>
	 			<td id="cSWM1" class="valt"></td>
	 			<td id="cSWM2" class="valt"></td>	 			
	 			<td class="valt"> x 1.5 + <td>
	 			<td id="cSWM3" class="valt"></td>
	 			<td id="cSWM4" class="valt"></td>
	 			<td class="valt"> ) / <td>
	 			<td id="cSWM5" class="valt"></td>	 			
	 			<td class="valt"> = <td>
	 			<th id="cSWM6" class="valtRED"></th>
	 		</tr>			 		 		 		
	 	</table>
 	</p>
 	<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:subForm();"><fmt:message key="ui.button.apply"/></a>
 </div>   
 
 <div title="<fmt:message key='ui.label.checkClaim'/>" id="checkSWP" style="padding:20px;">
 	<p style="background-color:#E2F0FE;">
 		<b>[<fmt:message key="ui.label.calBasic"/>]</b><br>
 		(<fmt:message key="ui.label.prodFailCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x α) +
 		<fmt:message key="ui.label.tripCost"/> +
 		<fmt:message key="ui.label.addCost"/> +		
		<fmt:message key="ui.label.delCost"/>(<fmt:message key="ui.label.unitPrice"/> x <fmt:message key="ui.label.count"/> x CBM(<c:if test ="${cLocale=='IN'}">13.5%</c:if><c:if test ="${cLocale=='CN'}">11.5%</c:if>)) +
		<fmt:message key="ui.label.qisManageCost"/>  
		) x 90%		
 	</p>
 	<p>
	 	<table>
	 		<tr>
	 			<th colspan="11" align="left">[<fmt:message key="ui.label.claimCost"/>]</th>
	 		</tr>
	 		<tr>	 			
	 			<td class="valt">(</td>
	 			<td id="cSWP1" class="valt"></td>
	 			<td id="cSWP2" class="valt"></td>
	 			<td id="cSWP3" class="valt"></td> 			
	 			<td id="cSWP4" class="valt"></td>
	 			<td class="valt">100000 + <td>
	 			<td id="cSWP5" class="valt"></td>
	 			<td id="cSWP6" class="valt"></td>
	 			<td class="valt">) x 0.9</td>	 			
	 			<td class="valt"> = <td>
	 			<th id="cSWP7" class="valtRED"></th>
	 		</tr>			 		 		 		
	 	</table>
 	</p>
 	<a  href="#" class="easyui-linkbutton" iconCls="icon-accept" onclick="javascript:subForm();" ><fmt:message key="ui.button.apply"/></a>
 </div>   
 
 
 

</body>

</html>
