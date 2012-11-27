<!-- 제작일 : 2012. 1. 12.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title><fmt:message key="menu.productInoutMgmt"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		#incomeForm th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#incomeForm td {border:1px dotted silver;width:200px;}
		#incomeForm input{border:0px;width:200px;}
		#incomeForm select{width:200px;}
		#outgoForm th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#outgoForm td {border:1px dotted silver;width:200px;}
		#outgoForm input{border:0px;width:200px;}
		#outgoForm select{width:200px;}
		#inoutStateTable th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left;white-space:nowrap;}
		#inoutStateTable td {border:1px dotted silver;}
		#inoutStateTable input{border:0px;}
		#inoutStateTable select{width:200px;}
		#resultStateTable th {border:1px solid #E5E5E5;background-color: #FAFAFA;height:22px; font-weight:normal; text-align: center; white-space:nowrap;}
		#resultStateTable td {border:1px dotted silver;}
		.incomeCls{background-color: #DFF6FE;}
		.outgoCls{background-color: #FEEEEE;}
		.actual{background-color: #E5E9EA;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	
	<script type="text/javascript">
	function useYn(rowIdx,rowData){
		if(rowData.DATA9=="DELETE")
			return 'color:grey;font-style:italic;';
	}
	
	function pointCell1(){
		return 'color:#3775CC;';
	}
	
	function pointCell2(){
		return 'color:#6B1D1D;';
	}	
	
	
	function resetIncomeForm(){		
		$('form')[0].reset();		
		$("input[name='pType']",$("#incomeForm")).val("insert");
		$("input[name='rowIdx']",$("#incomeForm")).val("");
		$("input[name='seq']",$("#incomeForm")).val("");
	}	
	function resetIncomeParts(){
		$("#inPartCode").combogrid("setValue","");
		$("#inPartName").val("");
		$("#inLotNo").val("");
		$("#inAmount").numberspinner("setValue","0");
		$("#inComment").val("");
	}	
	
	function insertIncomeForm(){
		var record = $("#incomeList").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}		
		$("#inStdDt").datebox('setValue',record.DATA1);
		$("#inInoutType").val(record.DATA12).trigger("change",record.DATA11);		
		$("#inPartCode").combogrid("setValue",record.DATA4);
		$("#inPartName").val(record.DATA5);
		$("#inLotNo").val(record.DATA6);
		$("#inAmount").numberspinner('setValue',record.DATA7);
		$("#inComment").val(record.DATA8);
		
		$("input[name='pType']",$("#incomeForm")).val("update");
		$("input[name='seq']",$("#incomeForm")).val(record.DATA0);
		
		var rowIdx = $("#incomeList").datagrid("getRowIndex",record);		
		$("input[name='rowIdx']",$("#incomeForm")).val(rowIdx);
		
				
	}
	function deleteIncomeList(){		
		var record = $("#incomeList").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}		
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='warn.wannaDelete' />",function(r){  
		    if (r){
				var newRow  ={};
				newRow.DATA0 = record.DATA0;
				newRow.DATA1 = record.DATA1;
				newRow.DATA2 = record.DATA2;
				newRow.DATA3 = record.DATA3;
				newRow.DATA4 = record.DATA4;
				newRow.DATA5 = record.DATA5;
				newRow.DATA6 = record.DATA6;
				newRow.DATA7 = record.DATA7;
				newRow.DATA8 = record.DATA8;
				newRow.DATA9 = "DELETE";
				newRow.DATA10 = record.DATA10;
				newRow.DATA11 = record.DATA11;
				newRow.DATA12 = record.DATA12;
				var rowIdx = $("#incomeList").datagrid("getRowIndex",record);				
		    	$("#incomeList").datagrid("updateRow",{index:rowIdx,row:newRow});
		    }  
		});		
	}
	
	function searchIncomeList(){		
		var params = {};
		params.category= "income";		 
		params.stdDt = $("#fromDate").datebox("getValue");
		params.endDt=$("#toDate").datebox("getValue");		
		var data2 = new Date(params.stdDt.split('-')[0],Number(params.stdDt.split('-')[1])-1,params.stdDt.split('-')[2]);
		var data1 = new Date(params.endDt.split('-')[0],Number(params.endDt.split('-')[1])-1,params.endDt.split('-')[2]);
		var day = 1000 * 3600 * 24
		if(parseInt((data1 - data2) / day, 10)>7){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='info.betweenDateWarn7' />");
			return;
		}
		$("#incomeList").datagrid("load",params);
		
	}	
	
	function saveIncome(){	
		if($("#incomeForm").form("validate")){
			var newRow  ={};
			newRow.DATA0 = $("input[name='seq']",$("#incomeForm")).val();
			newRow.DATA1 = $("#inStdDt").datebox("getValue");
			newRow.DATA2 = $("#inInoutType option:selected").text();
			newRow.DATA3 = $("#inFromLine option:selected").text();
			newRow.DATA4 = $("#inPartCode").combogrid("getValue");
			newRow.DATA5 = $("#inPartName").val();
			newRow.DATA6 = $("#inLotNo").val();
			newRow.DATA7 = $("#inAmount").numberspinner("getValue");
			newRow.DATA8 = $("#inComment").val();			
			newRow.DATA9 = "SAVE";
			newRow.DATA10 = "${today}";
			newRow.DATA11 = $("#inFromLine").val();
			newRow.DATA12 = $("#inInoutType").val();			
			
			var type = $("input[name='pType']",$("#incomeForm")).val();
			if(type=="update"){
				var rowI = $("input[name='rowIdx']",$("#incomeForm")).val();
				$("#incomeList").datagrid("updateRow",{index:rowI,row:newRow});
				resetIncomeForm();
			}else{
				$("#incomeList").datagrid("appendRow",newRow);
				resetIncomeParts();
			}
			
		}else{
			return false;
		}
	}
	
	function saveIncomeAll(){
		var frm = document.incomeFormName;
		var data = $("#incomeList").datagrid("getData");
		
		if(data.rows.length==0){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.noUpdateItem' />");
			return;
		}
		
		var data0 =[];
		var data1 =[];
		var data2 =[];
		var data3 =[];
		var data4 =[];
		var data5= [];
		var data6 =[];
		var data7 =[];
		var data8 =[];
		var data9 =[];
		var data10 =[];
		var data11 =[];
		var data12 =[];
				
		var checkSameDate = "";
		var checkValue = true;
		
		for(var x=0;x<data.rows.length;x++){
			if(data.rows[x].DATA9=="SAVE" || data.rows[x].DATA9=="DELETE"){
				if(checkSameDate!="" && checkSameDate!=data.rows[x].DATA1){
					checkValue = false
					break;
				}				
				if(checkSameDate=="")
					checkSameDate = data.rows[x].DATA1;
			data0.push(data.rows[x].DATA0);
			data1.push(data.rows[x].DATA1);
			data2.push(data.rows[x].DATA2);
			data3.push(data.rows[x].DATA3);
			data4.push(data.rows[x].DATA4);
			data5.push(data.rows[x].DATA5);
			data6.push(data.rows[x].DATA6);
			data7.push(data.rows[x].DATA7);
			data8.push(data.rows[x].DATA8);
			data9.push(data.rows[x].DATA9);
			data10.push(data.rows[x].DATA10);
			data11.push(data.rows[x].DATA11);
			data12.push(data.rows[x].DATA12);
			}
		}
		if(checkValue){
			frm.DATA0.value = data0;
			frm.DATA1.value = data1;
			frm.DATA2.value = data2;
			frm.DATA3.value = data3;
			frm.DATA4.value = data4;
			frm.DATA5.value = data5;
			frm.DATA6.value = data6;
			frm.DATA7.value = data7;
			frm.DATA8.value = data8;
			frm.DATA9.value = data9;
			frm.DATA10.value = data10;
			frm.DATA11.value = data11;
			frm.DATA12.value = data12;
			frm.submit();
		}else{
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.enableSameDate' />");	
		}
		
	}
	
	
	
	
	
	
	function resetOutgoForm(){
		$('form')[1].reset();		
		$("input[name='pType']",$("#outgoForm")).val("insert");
		$("input[name='rowIdx']",$("#outgoForm")).val("");
		$("input[name='seq']",$("#outgoForm")).val("");		
	}
	
	function resetOutgoParts(){
		$("#outPartCode").combogrid("setValue","");
		$("#outPartName").val("");
		$("#outLotNo").val("");
		$("#outAmount").numberspinner("setValue","0");
		$("#outComment").val("");
	}	
	
	function insertOutgoForm(){
		var record = $("#outgoList").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$("#outStdDt").datebox('setValue',record.DATA1);
		$("#outInoutType").val(record.DATA12).trigger("change",record.DATA11);;		
		$("#outPartCode").combogrid("setValue",record.DATA4);
		$("#outPartName").val(record.DATA5);
		$("#outLotNo").val(record.DATA6);
		$("#outAmount").numberspinner('setValue',record.DATA7);
		$("#outComment").val(record.DATA8);		
		$("input[name='pType']",$("#outgoForm")).val("update");
		$("input[name='seq']",$("#outgoForm")).val(record.DATA0);		
		var rowIdx = $("#outgoList").datagrid("getRowIndex",record);		
		$("input[name='rowIdx']",$("#outgoForm")).val(rowIdx);		
				
	}
	function deleteOutgoList(){
		var record = $("#outgoList").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}			
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='warn.wannaDelete' />",function(r){  
		    if (r){
				var newRow  ={};
				newRow.DATA0 = record.DATA0;
				newRow.DATA1 = record.DATA1;
				newRow.DATA2 = record.DATA2;
				newRow.DATA3 = record.DATA3;
				newRow.DATA4 = record.DATA4;
				newRow.DATA5 = record.DATA5;
				newRow.DATA6 = record.DATA6;
				newRow.DATA7 = record.DATA7;
				newRow.DATA8 = record.DATA8;
				newRow.DATA9 = "DELETE";
				newRow.DATA10 = record.DATA10;
				newRow.DATA11 = record.DATA11;
				newRow.DATA12 = record.DATA12;
				var rowIdx = $("#outgoList").datagrid("getRowIndex",record);				
		    	$("#outgoList").datagrid("updateRow",{index:rowIdx,row:newRow});
		    }  
		});				
		
	}
	
	function searchOutgoList(){
		var params = {};
		params.category= "outgo";		 
		params.stdDt = $("#fromDateOutgo").datebox("getValue");
		params.endDt=$("#toDateOutgo").datebox("getValue");
		var data2 = new Date(params.stdDt.split('-')[0],Number(params.stdDt.split('-')[1])-1,params.stdDt.split('-')[2]);
		var data1 = new Date(params.endDt.split('-')[0],Number(params.endDt.split('-')[1])-1,params.endDt.split('-')[2]);
		var day = 1000 * 3600 * 24
		if(parseInt((data1 - data2) / day, 10)>7){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='info.betweenDateWarn7' />");
			return;
		}		
		$("#outgoList").datagrid("load",params);
		
	}		
	
	function saveOutgo(){	
		if($("#outgoForm").form("validate")){			
			var newRow  ={};
			newRow.DATA0 = $("input[name='seq']",$("#outgoForm")).val();
			newRow.DATA1 = $("#outStdDt").datebox("getValue");
			newRow.DATA2 = $("#outInoutType option:selected").text();
			newRow.DATA3 = $("#outToCust option:selected").text();
			newRow.DATA4 = $("#outPartCode").combogrid("getValue");
			newRow.DATA5 = $("#outPartName").val();
			newRow.DATA6 = $("#outLotNo").val();
			newRow.DATA7 = $("#outAmount").numberspinner("getValue");
			newRow.DATA8 = $("#outComment").val();
			newRow.DATA9 = "SAVE";
			newRow.DATA10 = "${today}";
			newRow.DATA11 = $("#outToCust").val();
			newRow.DATA12 = $("#outInoutType").val();			
			var type = $("input[name='pType']",$("#outgoForm")).val();			
			if(type=="update"){
				var rowI = $("input[name='rowIdx']",$("#outgoForm")).val();				
				$("#outgoList").datagrid("updateRow",{index:rowI,row:newRow});
				resetOutgoForm();
			}else{
				$("#outgoList").datagrid("appendRow",newRow);
				resetOutgoParts();
			}
			
		}else{
			return false;
		}		
		
	}

	function saveOutgoAll(){
		var frm = document.outgoFormName;
		var data = $("#outgoList").datagrid("getData");
		if(data.rows.length==0){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.noUpdateItem' />");
			return;
		}		
		
		var data0 =[];
		var data1 =[];
		var data2 =[];
		var data3 =[];
		var data4 =[];
		var data5= [];
		var data6 =[];
		var data7 =[];
		var data8 =[];
		var data9 =[];
		var data10 =[];
		var data11 =[];
		var data12 =[];
		
		var checkSameDate = "";
		var checkValue = true;
		
		for(var x=0;x<data.rows.length;x++){
			if(data.rows[x].DATA9=="SAVE" || data.rows[x].DATA9=="DELETE"){				
				if(checkSameDate!="" && checkSameDate!=data.rows[x].DATA1){
					checkValue = false
					break;
				}				
				if(checkSameDate=="")
					checkSameDate = data.rows[x].DATA1;				
				data0.push(data.rows[x].DATA0);
				data1.push(data.rows[x].DATA1);
				data2.push(data.rows[x].DATA2);
				data3.push(data.rows[x].DATA3);
				data4.push(data.rows[x].DATA4);
				data5.push(data.rows[x].DATA5);
				data6.push(data.rows[x].DATA6);
				data7.push(data.rows[x].DATA7);
				data8.push(data.rows[x].DATA8);
				data9.push(data.rows[x].DATA9);
				data10.push(data.rows[x].DATA10);
				data11.push(data.rows[x].DATA11);
				data12.push(data.rows[x].DATA12);
			}
		}
		if(checkValue){
		frm.DATA0.value = data0;
		frm.DATA1.value = data1;
		frm.DATA2.value = data2;
		frm.DATA3.value = data3;
		frm.DATA4.value = data4;
		frm.DATA5.value = data5;
		frm.DATA6.value = data6;
		frm.DATA7.value = data7;
		frm.DATA8.value = data8;
		frm.DATA9.value = data9;
		frm.DATA10.value = data10;
		frm.DATA11.value = data11;
		frm.DATA12.value = data12;		
		
		frm.submit();
		}else{
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.enableSameDate' />");	
		}
	}	
	
	function searchInoutState(){
		if($("#searchPartCode").combogrid("getValue") ==""){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warning.selectPartCode' />");
			return;
		}		
		
		var p1 = $("#searchPartCode").combogrid("getValue");
		var p2 = $("#searchFrom").datebox("getValue");
		var p3 = $("#searchTo").datebox("getValue");
		var p4,p5;
		($("#searchTerm1").attr("checked"))?p4="Y":p4="N";
		($("#searchTerm2").attr("checked"))?p5="Y":p5="N";
			
		var txtHead = "<tr>";		
		txtHead+= "<th style='width:80px;'><fmt:message key='ui.label.datetime'/></th>";
		txtHead+= "<th style='width:70px;'><fmt:message key='ui.label.income'/><fmt:message key='ui.label.count'/></th>";
		txtHead+= "<th style='width:70px;'><fmt:message key='ui.label.outgo'/><fmt:message key='ui.label.count'/></th>";
		txtHead+= "<th style='width:80px;'><fmt:message key='ui.label.LotNo'/></th>";
		if(p4=="Y")
		txtHead+= "<th  style='width:120px;'><fmt:message key='ui.label.detailInoutType'/></th>";
		if(p5=="Y")
		txtHead+= "<th  style='width:200px;'><fmt:message key='ui.label.fromTo'/></th>";
		txtHead+= "<th  style='width:80px;'><fmt:message key='menu.currentStock'/></th>";
		txtHead+= "</tr>";		
		
		
		var txtBody = "";
		
		$.getJSON("getInoutState",{partCode:p1,stdDt:p2,endDt:p3,inoutYn:p4,fromToYn:p5,t:new Date().getTime()},function(list){
			var countAmount = 0;
			$.each(list,function(i,cell){		
				if((i==0 && cell.DATA1=="actual") || cell.DATA1=="pre"){
					countAmount = Number(countAmount)+Number(cell.DATA8);
				}else{
					$("#preStock").empty().append(numeric(countAmount));
					txtBody+="<tr>";
					txtBody+="<td align='center' class='"+cell.DATA1+"'>"+((cell.DATA1=="actual")?"<fmt:message key='ui.button.applyActualStock'/>":cell.DATA2)+"</td>";
					if(cell.DATA1=="income"){
						txtBody+="<td align='right' class='incomeCls'>"+numeric(cell.DATA3)+"</td><td>&nbsp;</td>";	
					}
					else if(cell.DATA1=="outgo"){
						txtBody+="<td>&nbsp;</td><td  align='right'  class='outgoCls'>"+numeric(cell.DATA3)+"</td>";
					}
					else if(cell.DATA1=="actual"){
						txtBody+="<td class='"+cell.DATA1+"'>&nbsp;</td><td class='"+cell.DATA1+"'>&nbsp;</td>";
					} 
						
					txtBody+="<td align='center' class='"+cell.DATA1+"'>"+cell.DATA6+"&nbsp;</td>";					
					if(p4=="Y")
						txtBody+= "<td class='"+cell.DATA1+"'>"+((cell.DATA1=="actual")?"&nbsp;":cell.DATA4)+"</td>";
					if(p5=="Y")
						txtBody+= "<td class='"+cell.DATA1+"'>"+((cell.DATA1=="actual")?"&nbsp;":cell.DATA5)+"</td>";
					txtBody+="<td align='right' class='"+cell.DATA1+"'>"+numeric(cell.DATA8)+"</td>";

					txtBody+="</tr>";
				}

			});
			$("#resultStateTable thead").empty().append(txtHead);
			$("#resultStateTable tbody").empty().append(txtBody);
		});
	}
	
	function getSubOptions(idName,code,edata){
		var txt ="<option value=''><fmt:message key='ui.element.Select' /></option>";
		$.getJSON("getSubOptionByInoutComponent",{code:code,t:new Date().getTime()},function(list){
			$.each(list,function(i,cell){
				if(edata==cell.code)
					txt+="<option value='"+cell.code+"' selected>"+cell.name+"</option>";
				else
					txt+="<option value='"+cell.code+"'>"+cell.name+"</option>";
			});
			$("#"+idName).empty().append(txt);
		});
	}
	
	function getCheckPreActDate(){
		var stdDt = $("#currentSearchDate").datebox("getValue");		
		$.get("getCheckPreActDate",{stdDt:stdDt,t:new Date().getTime()},function(result){
			if($.trim(result)=="YES")				
				searchCurrentStock();
			else
				$.messager.alert("<fmt:message key='info.confirm' />","<fmt:message key='info.cannotSearchWithoutPreActual' />");
		});		
	}
	
	function searchCurrentStock(){
		var params = {};
		params.stdDt= $("#currentSearchDate").datebox("getValue");
		$("#currentList").datagrid("load",params);		
	}
	
	function getCheckPreCloseData(){
		var year = $("#closeYear").val();
		var month = $("#closeMonth").val();
		$.get("getCheckPreCloseData",{year:year,month:month,t:new Date().getTime()},function(result){
			if($.trim(result)=="YES")
				getCheckThisCloseData();
			else
				$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.cannotActionCloseData' />");
		});
	}
	function getCheckThisCloseData(){		
		var year = $("#closeYear").val();
		var month = $("#closeMonth").val();
		$.get("getCheckThisCloseData",{year:year,month:month,t:new Date().getTime()},function(result){
			if($.trim(result)=="YES"){
				$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='ask.existsCloseData' />",function(r){  
				    if (r){
				    	getCloseActionList("action");
				    }else{
				    	getCloseActionList("search");	
				    }
				});
			}	
			else
				getCloseActionList("action");
		});		
	}
	
	function getCloseActionList(typeAction){				
		var params = {};
		params.type= typeAction;		 
		params.year = $("#closeYear").val();
		params.month = $("#closeMonth").val();
		$("#closeActualList").datagrid("load",params);
	}	
	
	function addCloseData(){
		$("#closeProdType").val("insert");
		$("#closePartCode").combogrid("enable");
	    $('#dialogClose').dialog({modal:true});
	    $("#closeAmount").numberspinner("setValue",0);
	}
	
	function editCloseData(){
		var record = $("#closeActualList").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		
		var rowIdx = $("#closeActualList").datagrid("getRowIndex",record);
		$("#closePartCode").combogrid("setValue",record.DATA0);
		$("#closePartCode").combogrid("disable");
		$("#closeAmount").numberspinner("setValue",record.DATA13);
		$("#closeRowId").val(rowIdx);
		$("#closeProdType").val("update");
		$('#dialogClose').dialog({modal:true});
	}
	

	function changeActualCount(){
		if($("#formCloseEdit").form("validate")){
			var newRow  ={};
			if($("#closeProdType").val()=="insert"){
				
				var sameRowIdx = -1;				
				var data = $("#closeActualList").datagrid("getData");
				for(var x =0;x<data.rows.length;x++){					
					if(data.rows[x].DATA0==$("#closePartCode").combogrid("getValue")){
						sameRowIdx = $("#closeActualList").datagrid("getRowIndex",data.rows[x]);						
					}
				}
				if(sameRowIdx<0){					
					newRow.DATA0 = $("#closePartCode").combogrid("getValue");
					for(var x=1;x<13;x++)
						newRow["DATA"+x] = "0";	
					newRow.DATA13 = $("#closeAmount").numberspinner("getValue");
					$("#closeActualList").datagrid("appendRow",newRow);
				}else{				
					$.messager.alert("<fmt:message key='info.confirm' />","<fmt:message key='info.cannotInsertExists' />");
					return;
				}				
			}else{
				newRow.DATA13 = $("#closeAmount").numberspinner("getValue");
				var rowI = $("#closeRowId").val();
				$("#closeActualList").datagrid("updateRow",{index:rowI,row:newRow});				
			}
			$('form')[2].reset();
			$('#dialogClose').dialog("close");
			
				
		}else{
			return false;	
		}
	}
	
	
	
	function saveActualData(){
		
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='ask.applyActualData' />",function(r){  
		    if (r){
		
				var frm = document.actualDataForm;
				var data = $("#closeActualList").datagrid("getData");
				if(data.rows.length==0){
					$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.noUpdateItem' />");
					return;
				}		
				var data0 =[];
				var data1 =[];
				var data2 =[];			
				
				for(var x=0;x<data.rows.length;x++){		
					data0.push(data.rows[x].DATA14);
					data1.push(data.rows[x].DATA0);
					data2.push(data.rows[x].DATA13);			
				}
				
				frm.actStdDt.value = data0;
				frm.actPartCode.value = data1;
				frm.actAmount.value = data2;
				frm.submit();
		    }
		});
	}
	
		$(document).ready(function(){			

			

		    $('#inPartCode').combogrid({
		    	panelWidth:400,
		        url : 'getPartListCallBak?type=1001',
		        columns:[[  
		                  {field:'partCode',title:'<fmt:message key="ui.label.PartNo"/>',width:120},  
		                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:255}
		              ]],
		        idField:'partCode',  
		        textField:'partCode',
		        mode:'remote',
		        onSelect:function(rowIndex, rowData){
		        	$("#inPartName").val(rowData.partName);		        	
		        }
		     });		
		    $('#outPartCode').combogrid({
		    	panelWidth:400,
		        url : 'getPartListCallBak?type=1001',
		        columns:[[  
		                  {field:'partCode',title:'<fmt:message key="ui.label.PartNo"/>',width:120},  
		                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:255}
		              ]],
		        idField:'partCode',  
		        textField:'partCode',
		        mode:'remote',
		        onSelect:function(rowIndex, rowData){
		        	$("#outPartName").val(rowData.partName);		        	
		        }
		     });
		    $('#searchPartCode').combogrid({
		    	panelWidth:400,
		        url : 'getPartListCallBak?type=1001',
		        columns:[[  
		                  {field:'partCode',title:'<fmt:message key="ui.label.PartNo"/>',width:120},  
		                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:255}
		              ]],
		        idField:'partCode',  
		        textField:'partCode',
		        mode:'remote'
		     });
		    $('#closePartCode').combogrid({
		    	panelWidth:400,
		        url : 'getPartListCallBak?type=1001',
		        columns:[[  
		                  {field:'partCode',title:'<fmt:message key="ui.label.PartNo"/>',width:120},  
		                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:255}
		              ]],
		        idField:'partCode',  
		        textField:'partCode',
		        mode:'remote'
		     });		   
		    
		    
		    $("#inInoutType").change(function(event,data){		    	
		    	getSubOptions('inFromLine',this.value,data);
		    });
		    $("#outInoutType").change(function(event,data){
		    	getSubOptions('outToCust',this.value,data);
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
    <div class="easyui-tabs" style="width:1180px;height:720px;" >
        <div title="<fmt:message key='menu.incomeMgmt' />" iconCls="icon-brick-add"  >
        <table>
        	<tr>
        		<td style="width:830px;height:660px;">
		            <table class="easyui-datagrid" id="incomeList" pagination="false" pageList="[50,100,200,300]"  border="false"
								fit="true"  idField="DATA0"  toolbar="#toolbar"  singleSelect="true" url="getIncomeOutgoList" rowStyler="useYn">			
						<thead>
							<tr>
								<th field="DATA0" hidden="true"></th>
								<th field="DATA1" width="80" sortable="true"><fmt:message key="ui.label.incomeDate"/></th>
								<th field="DATA2" width="150" sortable="true"><fmt:message key="ui.label.incomeType"/></th> 
								<th field="DATA3" width="100" sortable="true"><fmt:message key="ui.label.supplyPlace"/></th>
								<th field="DATA4" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
								<th field="DATA5" width="250" sortable="true"><fmt:message key="ui.label.PartName"/></th>
								<th field="DATA6" width="100" sortable="true"><fmt:message key="ui.label.LotNo"/></th>
								<th field="DATA7" width="100" sortable="true"  align="right"  formatter="numeric"><fmt:message key="ui.label.count"/></th>
								<th field="DATA8" width="200" sortable="false"><fmt:message key="ui.label.remark"/></th>
								<th field="DATA9" width="120" sortable="false"><fmt:message key="ui.label.inputBy"/></th>
								<th field="DATA10" width="80" sortable="false"><fmt:message key="ui.label.inputDt"/></th>
								<th field="DATA11" hidden="true"></th>
								<th field="DATA12" hidden="true"></th>								
							</tr>	
						</thead>
					</table>        		
        		</td>
        		<td>
					<div iconCls="icon-brick-edit" class="easyui-panel"  title="<fmt:message key='menu.incomeMgmt' />" style="width:330px;height:660px;">  
					    <form:form action="inoutManagement" modelAttribute="incomeSheet"  id="incomeForm"   method="POST" name="incomeFormName" >
					    	<table style="margin:5px;">
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.incomeDate"/></span></th>
					    			<td>
					    				<form:input path="stdDt" class="easyui-datebox"  editable="false" required='true' id="inStdDt" />
					    				<input type="hidden" name="category"  value="income"/>
					    				<input type="hidden" name="pType" value="insert" />
					    				<form:input  type="hidden" path="seq" name="seq" value="" />
					    				<input type="hidden" name="rowIdx" />
					    				<c:forEach begin="0" end="12" step="1" varStatus="count">
					    					<input type="hidden" name="DATA${count.index}">
					    				</c:forEach>
					    									    									    				
					    			</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.incomeType"/></span></th>
					    			<td>
									<form:select path="inoutType" class="easyui-validatebox" required='true' id="inInoutType" >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${incomeType }"  />
									</form:select>
									</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.supplyPlace"/></span></th>
					    			<td>
									<select class="easyui-validatebox" required='true' id="inFromLine" >
										<option value=''><fmt:message key='ui.element.Select' /></option>									   										
									</select>
									</td>
					    		</tr>    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartNo"/></span></th>
									<td><form:input path="partCode" required='true' id='inPartCode' /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartName"/></span></th>
									<td><input id="inPartName" readonly class="easyui-validatebox" required='true' value=""  /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.LotNo"/></span></th>
					    			<td><form:input path="lotNo" id="inLotNo" value="" /></td>				
					    		</tr>    	    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.count"/></span></th>
									<td><form:input path="amount" class="easyui-numberspinner"  id="inAmount"  min="0"  /></td>
					    		</tr>    	
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.remark"/></span></th>
					    			<td><form:input path="comment" id="inComment" value="" /></td>				
					    		</tr>     		
					    		<tr>
					    			<th colspan="2"  style="text-align:center;" >
					    			<a href="#" onclick="javascript:saveIncome();"  class="easyui-linkbutton" iconCls="icon-accept" id="btChange"><fmt:message key="info.confirm"/></a>
					    			<a href="#" onclick="javascript:resetIncomeForm()" class="easyui-linkbutton"  iconCls="icon-arrow-redo" id="btCancel"><fmt:message key="ui.button.Cancel"/></a>
					    			</th>
					    		</tr>	    		    		    		    		    		
					    	</table>
					    </form:form>
					</div>        		
        		</td>
        	</tr>
        </table>
        </div>
        <div title="<fmt:message key='menu.outgoMgmt' />" iconCls="icon-brick-delete" >  
		<table>
        	<tr>
        		<td style="width:830px;height:660px;">
		            <table class="easyui-datagrid" id="outgoList" pagination="false" pageList="[50,100,200,300]"  border="false"
								fit="true"  idField="DATA0"  toolbar="#toolbarOutgo"  singleSelect="true" url="getIncomeOutgoList"  rowStyler="useYn">			
						<thead>
							<tr>
								<th field="DATA0" hidden="true"></th>
								<th field="DATA1" width="80" sortable="true"><fmt:message key="ui.label.outgoDate"/></th>
								<th field="DATA2" width="150" sortable="true"><fmt:message key="ui.label.outgoType"/></th> 
								<th field="DATA3" width="100" sortable="true"><fmt:message key="ui.label.customer"/></th>
								<th field="DATA4" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
								<th field="DATA5" width="250" sortable="true"><fmt:message key="ui.label.PartName"/></th>
								<th field="DATA6" width="100" sortable="true"><fmt:message key="ui.label.LotNo"/></th>
								<th field="DATA7" width="100" sortable="true"  align="right"  formatter="numeric"><fmt:message key="ui.label.count"/></th>
								<th field="DATA8" width="200" sortable="false"><fmt:message key="ui.label.remark"/></th>
								<th field="DATA9" width="120" sortable="false"><fmt:message key="ui.label.inputBy"/></th>
								<th field="DATA10" width="80" sortable="false"><fmt:message key="ui.label.inputDt"/></th>
								<th field="DATA11" hidden="true"></th>
								<th field="DATA12" hidden="true"></th>
							</tr>	
						</thead>
					</table>        		
        		</td>
        		<td>
					<div iconCls="icon-brick-edit" class="easyui-panel"  title="<fmt:message key='menu.outgoMgmt' />" style="width:330px;height:660px;">  
					    <form:form action="inoutManagement" modelAttribute="outgoSheet"  id="outgoForm"   method="POST" name="outgoFormName" >
					    	<table style="margin:5px;">
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.outgoDate"/></span></th>
					    			<td>
					    				<form:input path="stdDt" class="easyui-datebox"  editable="false" required='true' id="outStdDt" />
					    				<input type="hidden" name="category"  value="outgo"/>
					    				<input type="hidden" name="pType" value="insert" />
					    				<form:input path="seq" type="hidden"  name="seq" value="" />			
					    				<input type="hidden" name="rowIdx" />
					    				<c:forEach begin="0" end="12" step="1" varStatus="count">
					    					<input type="hidden" name="DATA${count.index}">
					    				</c:forEach>					    						    				
					    			</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.outgoType"/></span></th>
					    			<td>
									<form:select path="inoutType" class="easyui-validatebox" required='true' id="outInoutType"  >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${outgoType}"  />
									</form:select>
									</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.customer"/></span></th>
					    			<td>
									<select class="easyui-validatebox" required='true' id="outToCust" >
										<option value=''><fmt:message key='ui.element.Select' /></option>
									</select>
									</td>
					    		</tr>    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartNo"/></span></th>
									<td><form:input path="partCode" required='true' id='outPartCode' /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartName"/></span></th>
									<td><input id="outPartName" readonly  class="easyui-validatebox" required='true'  value="" /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.LotNo"/></span></th>
					    			<td><form:input path="lotNo" id="outLotNo"  value=""/></td>				
					    		</tr>    	    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.count"/></span></th>
									<td><form:input path="amount" class="easyui-numberspinner"  id="outAmount"  min="0"/></td>
					    		</tr>    	
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.remark"/></span></th>
					    			<td><form:input path="comment" id="outComment" value="" /></td>				
					    		</tr>     		
					    		<tr>
					    			<th colspan="2"  style="text-align:center;" >
					    			<a href="#" onclick="javascript:saveOutgo();"  class="easyui-linkbutton" iconCls="icon-accept" id="btChange"><fmt:message key="info.confirm"/></a>
					    			<a href="#" onclick="javascript:resetOutgoForm()" class="easyui-linkbutton"  iconCls="icon-arrow-redo" id="btCancel"><fmt:message key="ui.button.Cancel"/></a>
					    			</th>
					    		</tr>	    		    		    		    		    		
					    	</table>
					    </form:form>
					</div>        		
        		</td>
        	</tr>
        </table>
        </div>      
        <div title="<fmt:message key='menu.inoutSearch' />" iconCls="icon-table-refresh" style="padding:15px;">  
			<div class="easyui-panel"  title="<fmt:message key='menu.inoutSearch' />" style="width:550px;height:110px;">			
		    	<table id="inoutStateTable">	
		    		<tr>
		    			<th style="width:120px;"><span  class="label-Leader-black"><fmt:message key="ui.label.PartNo"/></span></th>
						<th colspan="2"><input id="searchPartCode"/></th>						
		    		</tr>
		    		<tr>
		    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.SearchDate"/></span></th>
						<th colspan="2">
						 	<input id="searchFrom" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
						 	<span style="margin: 0em .3em;">~</span>
						 	<input id="searchTo" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>						
						</th>	

		    		</tr>	    
		    		<tr>
		    			<th><span  class="label-Leader-blue"><fmt:message key="ui.label.includeTerm"/></span></th>
						<th>
							<span style="width:170px;">
						 	<input type="checkbox" id="searchTerm1" checked /><fmt:message key="ui.label.detailInoutType"/>
						 	</span>
						 	<span style="width:170px;">
						 	<input type="checkbox" id="searchTerm2" checked /><fmt:message key="ui.label.fromTo"/>
						 	</span>						 							
						</th>		
						<th>
					    	<a href="#" onclick="javascript:searchInoutState();"  class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a>						
						</th>		
						
		    		</tr>	   		    		  		    		    		    			    			      		    		    		    		    		
		    	</table>			
			</div> 
			<br>
			<br>
			<div>
				<span class="label-Leader-red" ><fmt:message key="ui.label.preSearchStock"/></span>
				<span style="width:20px;">:</span><span id="preStock" style="color:red;">0</span>
			</div>
			<br>			
			<div>
				<table id="resultStateTable">
					<thead></thead>
					<tbody></tbody>
				</table>
			</div>  
        </div>
        <div title="<fmt:message key='menu.currentStock' />" iconCls="icon-text-align-justity">
            <table class="easyui-datagrid" id="currentList" pagination="false"   border="false"
						fit="true"  idField="DATA0"  toolbar="#toolCurrent"  singleSelect="true"  url="getCurrentStock">			
				<thead>
					<tr>						
						<th field="DATA0" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="DATA1" width="100" sortable="true"  align="right"  formatter="numeric"><fmt:message key="ui.label.preMonthStock"/></th>
						<th field="DATA12" width="100" sortable="true"  align="right"  formatter="numeric" styler="pointCell1"><fmt:message key="menu.currentStock"/></th>						
						<c:forEach begin="2" end="11" step="1" varStatus="item" >							
							<th field="DATA${item.index}" width="120" sortable="true"  align="right"  formatter="numeric">${closeHead[item.index-2].name}</th>
						</c:forEach>
												
					</tr>	
				</thead>
			</table>              
        </div>
        <div title="<fmt:message key='menu.closeActualMgmt' />" iconCls="icon-book-keeping" style="padding:2px;">          
            <table class="easyui-datagrid" id="closeActualList" pagination="false"   border="false"
						fit="true"  idField="DATA0"  toolbar="#toolCloseActual"  singleSelect="true"  url="prodApplyCloseData">			
				<thead>
					<tr>						
						<th field="DATA0" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="DATA1" width="100" sortable="true"  align="right"  formatter="numeric"><fmt:message key="ui.label.preMonthStock"/></th>
						<c:forEach begin="2" end="11" step="1" varStatus="item" >							
							<th field="DATA${item.index}" width="120" sortable="true"  align="right"  formatter="numeric">${closeHead[item.index-2].name}</th>
						</c:forEach>
						<th field="DATA12" width="100" sortable="true"  align="right"  styler="pointCell1" formatter="numeric"><fmt:message key="ui.label.closeAmount"/></th>
						<th field="DATA13" width="100" sortable="true"  align="right"  styler="pointCell2" formatter="numeric"><fmt:message key="ui.label.actualStockAmount"/></th>
						<th field="DATA14" hidden="true"></th>
					</tr>	
				</thead>
			</table>             
        </div>                              
    </div> 
</div>
 
<!-- 툴바 -->
<div  id="toolbar" style="padding:5px;height:auto;">
	<div style="margin-top:.5em;">
		<span style="margin-right:.5em"><fmt:message key="ui.label.incomeDate"/></span>
	 	<input id="fromDate" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin: 0em .3em;">~</span>
	 	<input id="toDate" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin-left:2em;"><a href="javascript:searchIncomeList()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
	 	<span style="margin-left:0em;"><a href="javascript:saveIncomeAll()" class="easyui-linkbutton" iconCls="icon-disk" id="saveButtonIncome"><fmt:message key="ui.button.Save"/></a></span>
	</div>
	<div style="text-align:right;">
	         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:resetIncomeForm();"><fmt:message key="ui.button.Add"/></a>  
	         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="javascript:insertIncomeForm();"><fmt:message key="ui.button.Edit"/></a>           
	         <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="javascript:deleteIncomeList();"><fmt:message key="ui.button.Delete"/></a>
	</div>
</div>

<!-- 툴바 -->
<div  id="toolbarOutgo" style="padding:5px;height:auto;">
	<div style="margin-top:.5em;">
		<span style="margin-right:.5em"><fmt:message key="ui.label.outgoDate"/></span>
	 	<input id="fromDateOutgo" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin: 0em .3em;">~</span>
	 	<input id="toDateOutgo" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin-left:2em;"><a href="javascript:searchOutgoList()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
	 	<span style="margin-left:0em;"><a href="javascript:saveOutgoAll()" class="easyui-linkbutton" iconCls="icon-disk" id="saveButtonOutgo"><fmt:message key="ui.button.Save"/></a></span>	 	
	</div>
	<div style="text-align:right;">
	         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:resetOutgoForm();"><fmt:message key="ui.button.Reg"/></a>  
	         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="javascript:insertOutgoForm();"><fmt:message key="ui.button.Edit"/></a>           
	         <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="javascript:deleteOutgoList();"><fmt:message key="ui.button.Delete"/></a>
	</div>
</div>

<!-- 툴바 -->
<div  id="toolCloseActual" style="padding:5px;height:auto;">
	<div style="margin-top:.5em;">
		<span style="margin-right:.5em"><fmt:message key="ui.label.closeDate"/></span>
	 	<select id="closeYear">
	 		<c:forEach begin="0" end="9" step="1" varStatus="pnt">
	 			<option value="${thisYear-pnt.index}">${thisYear-pnt.index}</option>
	 		</c:forEach>
	 	</select>년
	 	<select id="closeMonth">
	 		<c:forEach begin="1" end="12" step="1" varStatus="pnt">
	 			<option value="${pnt.index}">${pnt.index}</option>
	 		</c:forEach>
	 	</select>월
	 	<span style="margin-left:2em;"><a href="javascript:getCheckPreCloseData()" class="easyui-linkbutton" iconCls="icon-book-edit"><fmt:message key="ui.button.actionClose"/></a></span>
	 	<span style="margin-left:0em;"><a href="javascript:saveActualData()" class="easyui-linkbutton" iconCls="icon-book-go"><fmt:message key="ui.button.applyActualStock"/></a></span>	 		 	
	</div>
	<div style="text-align:right;">
	         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:addCloseData();"><fmt:message key="ui.button.Add"/></a>  
	         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true"  onclick="javascript:editCloseData();"><fmt:message key="ui.button.Edit"/></a>
	</div>
</div>

<!-- 툴바 -->
<div  id="toolCurrent" style="padding:5px;height:auto;">
	<div style="margin-top:.5em;">
		<span style="margin-right:.5em"><fmt:message key="ui.label.SearchDate"/></span>
		<input id="currentSearchDate" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin-left:2em;"><a href="javascript:getCheckPreActDate()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>	 		 		 	
	</div>	
</div>

<div id="dialogClose" buttons="#dialButton" title ="<fmt:message key='ui.button.applyActualStock'/>">
	<form id="formCloseEdit">
		<table style="margin:10px;">
			<tr>
				<th><fmt:message key="ui.label.PartNo"/></th>
				<td>
					<input type="text" id="closePartCode" required="false" />
					<input type="hidden" id="closeProdType"/>
					<input type="hidden" id="closeRowId"/>
				</td>				
			</tr>
			<tr>
				<th><fmt:message key="ui.label.count"/></th>
				<td><input type="text" id="closeAmount"  class="easyui-numberspinner"   value="0"/></td>				
			</tr>		
		</table>
	</form>
</div>
<div id="dialButton" align="center">				
	<a href="#" onclick="javascript:changeActualCount();"  class="easyui-linkbutton" iconCls="icon-accept" id="btCloseButton"><fmt:message key="ui.button.apply"/></a>
</div>
<div>
<form action="inoutManagement"method="POST" name="actualDataForm" >
	<input type="hidden" name="actStdDt">
	<input type="hidden" name="actPartCode">
	<input type="hidden" name="actAmount">	
</form>
</div>




</body>

</html>
