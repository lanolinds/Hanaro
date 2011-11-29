<!-- 제작일 : 2011. 11. 28.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.lineProcConfigure" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	
	function useYnLine(rowIdx,rowData){
		if(rowData.use_yn=="N")
			return 'color:grey;font-style:italic;';
	}
	
	function useYnProc(rowIdx,rowData){
		if(rowData.linkUse=="N" || rowData.procUse=="N" )
			return 'color:grey;font-style:italic;';
	}	
	
	function codeUseYn(value){
		if(value=="Y")
			return "<fmt:message key='ui.label.enable' />";
		else
			return "<fmt:message key='ui.label.disable' />";
	}
	
	//라인을 추가한다.
	function insertLine(){
		if($("#formAddLineCode").form("validate")){
			$.get("getCheckUnique",{checkItem:"line",checkKey:$("input[name='lineCode']",$("#addLinecode")).val()},function(result){
				if(result=='Y'){
					$.messager.alert('<fmt:message key="warn.infoWarn" />','<fmt:message key="error.alreadyInserted" />');  
					return;		
				}
				$("#formAddLineCode").submit();
			});
		}else{
			return false;
		}
	}
	
	//라인상태변경용 화면을 연다
	function openLineState(){
		var datas = $("#lineTable").datagrid("getSelected");
		if(datas ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$("select[name='useYn']",$("#updateLinecode")).val(datas.use_yn);
		$("input[name='lineCode']",$("#updateLinecode")).val(datas.line_code);
		$('#updateLinecode').dialog({modal:true});
	}
	
	//공정추가용 화면을 연다
	function openProcAdd(){
		var lineCode = $("#txtSelectedLine").text();
		if(lineCode ==''){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedLine' />");
			return;
		}
		$("input[name='lineCode']",$("#addProccode")).val(lineCode);
		$('#addProccode').dialog({modal:true});
	}
	
	//공정을 추가한다.
	function insertProc(){
		var lineCode =  $("#txtSelectedLine").text();
		if($("#formAddProcCode").form("validate")){
			$.get("getCheckUnique",{checkItem:"proc",checkKey:$("#procCall").combogrid("getValue"),checkKey2:lineCode},function(result){
				if(result=='Y'){
					$.messager.alert('<fmt:message key="warn.infoWarn" />','<fmt:message key="error.alreadyInserted" />');  
					return;		
				}
				$("#formAddProcCode").submit();
			});
		}else{
			return false;
		}		
	}
	//공정수정용 화면을 연다
	function openProcUpdate(){
		var datas = $("#procTable").datagrid("getSelected");
		if(datas ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$("input[name='lineCode']",$("#updateProccode")).val(datas.line_code);
		$("input[name='procCode']",$("#updateProccode")).val(datas.proc_cd);
		$("input[name='procName']",$("#updateProccode")).val(datas.proc_nm);
		$("input[name='procSeq']",$("#updateProccode")).val(datas.proc_seq);
		if(datas.procUse=="N"){
			$("select[name='useYn']",$("#updateProccode")).attr("disabled","disabled");
			$("#donotEdit").text("<fmt:message key='info.doNotEditProcUse' />");
		}else{
			$("select[name='useYn']",$("#updateProccode")).removeAttr("disabled");
			$("#donotEdit").empty();
		}
		$("select[name='useYn']",$("#updateProccode")).val(datas.linkUse);
		$('#updateProccode').dialog({modal:true});
	}	
	
	//공정을 수정한다
	function updateProc(){		
		if($("#formUpdateProcCode").form("validate")){
			$("#formUpdateProcCode").submit();
		}else{
			return false;
		}		
	}
	
	$(document).ready(function(){
		$("#lineTable").datagrid({
			queryParams:{custCode:$("#selCust").val(),lineCode:""},
		    onClickRow:function(rowIndex, rowData){
		    	if(rowData.use_yn=="Y")
		    		$("#txtSelectedLine").text(rowData.line_code).css("color","blue");
		    	else
		    		$("#txtSelectedLine").text(rowData.line_code).css("color","gray");
		    	$("#procTable").datagrid("load",{custCode:"",lineCode:rowData.line_code});
		    	
		    }
		});
		
		$("#selCust").change(function(){
			$("#lineTable").datagrid("load",{custCode:$(this).val(),lineCode:""});
		});
		
		
			
	    $("#procCall").combogrid({
	    	panelWidth:580,
	        url : 'getProcOption',
	        columns:[[  
	                  {field:'procCode',title:'<fmt:message key="ui.label.procCode"/>',width:100},  
	                  {field:'procName',title:'<fmt:message key="ui.label.procName"/>',width:200},  
	                  {field:'procRemark',title:'<fmt:message key="ui.label.remark"/>',width:250}
	              ]],
	        idField:'procCode',  
	        mode:'local',
	        textField:'procName'
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
<table>
<tr>
	<td>
		<table title ="<fmt:message key='menu.line' />" iconCls="icon-table-link" id="lineTable" url="getLineProcConfiguration" pageSize ="100" rowStyler="useYnLine"  singleSelect = "true"
		style="width:360px;height:500px;" toolbar="#lineManage" >
			<thead>
				<tr>
					<th field="cust_nm" width="145"><fmt:message key="ui.label.cust.custNm" /></th>
					<th field="line_code" width="110"><fmt:message key="ui.label.lineCode" /></th>
					<th field="use_yn" width="80"><fmt:message key="ui.label.enabled" /></th>
				</tr>
			</thead>
		</table>
	</td>
	<td>
		<table id="procTable" class="easyui-datagrid" title ="<fmt:message key='ui.label.procManage' />" iconCls="icon-lorry-link" url="getLineProcConfiguration" pageSize ="100" rowStyler="useYnProc"  singleSelect = "true"
		style="width:700px;height:500px;" toolbar="#procManage" >
			<thead>
				<tr>
					<th field="line_code" width="110"><fmt:message key="ui.label.lineCode" /></th>
					<th field="proc_cd" width="110"><fmt:message key="ui.label.procCode" /></th>
					<th field="proc_nm" width="110"><fmt:message key="ui.label.procName" /></th>
					<th field="proc_seq" width="50"><fmt:message key="ui.label.seq" /></th>
					<th field="proc_remark" width="130"><fmt:message key="ui.label.remark" /></th>
					<th field="linkUse" width="80"><fmt:message key="ui.label.enabled" /></th>
					<th field="procUse" width="80" formatter="codeUseYn"><fmt:message key="ui.labal.codeState" /></th>
				</tr>
			</thead>
		</table>	
	</td>
</tr>
</table>
</div>
<div id="lineManage" style="padding:5px;height:auto">
	<div>	
			<select id="selCust" style="width:160px;">
				<option value=""><fmt:message key="ui.element.All"/></option>
				<c:forEach items="${custOption}" var="item">
					<option value="${item.custCode}">${item.custName}</option>
				</c:forEach>
			</select>	
         	<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:$('#addLinecode').dialog({modal:true});"><fmt:message key="ui.button.Add"/></a>
         	<a href="#" class="easyui-linkbutton" iconCls="icon-cog-edit" plain="true" onclick="javascript:openLineState();"><fmt:message key="ui.button.changeStatus"/></a>			
	</div>
</div>
<div id="procManage" style="padding:5px;height:auto">
	<div>	
			<span  id="txtSelectedLine" style="color:blue;width:500px;font-size:large;font-weight: bolder;"></span>			
         	<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:openProcAdd();"><fmt:message key="ui.button.Add"/></a>
         	<a href="#" class="easyui-linkbutton" iconCls="icon-cog-edit" plain="true" onclick="javascript:openProcUpdate();"><fmt:message key="ui.button.changeStatus"/></a>			
	</div>
</div>

<!-- 라인등록용 -->
<div title="<fmt:message key='ui.label.lineAdd' />" id="addLinecode" style="width:350px;height:auto;" buttons="#addLineButton">
	<form id="formAddLineCode" style="padding:5px;" action="lineProcConfigure" method="post">
		<table>
			<tr> 
				<td>
					<input type="hidden" name="procCate" value="LINE">
					<input type="hidden" name="procType" value="INSERT">
					<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.cust.custNm" /></span>
					<select name="custCode" style="width:160px;">
						<c:forEach items="${custOption}" var="item">
							<option value="${item.custCode}">${item.custName}</option>
						</c:forEach>
					</select>						
				</td>
			</tr>
			<tr>
				<td>
					<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.lineCode" /></span>
					<input type="text" name="lineCode" size="25" class="easyui-validatebox" required="true">
				</td>
			</tr>
			<tr>
			<td style="color:red;">
				<br>
				<span style="width:5px;"></span>※ <fmt:message key="ui.label.lineCode" /><fmt:message key="info.unique" />
			</td>
			</tr>		
		</table>
	</form>
</div>
<div id="addLineButton"><a href="#" class="easyui-linkbutton" onclick="javascript:insertLine();"><fmt:message key="info.confirm" /></a></div>

<!-- 라인사용유무변경용 -->
<div title="<fmt:message key='menu.line' />" id="updateLinecode" style="width:300px;height:auto;" buttons="#updateLineButton">
	<form id="formUpdateLineCode" style="padding:5px;" action="lineProcConfigure" method="post">
		<table>
			<tr>
				<td>
					<input type="hidden" name="procCate" value="LINE">
					<input type="hidden" name="procType" value="UPDATE">
					<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.lineCode" /></span>								
					<input type="text" name="lineCode" size="18" readonly style="border:1px solid #CFDBEC;background-color:#EFEFEF;">				
				</td>
			</tr>
			<tr>
				<td>
					<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.enabled" /></span>				
					<select name="useYn">
						<option value="Y"><fmt:message key="ui.label.enable" /></option>
						<option value="N"><fmt:message key="ui.label.disable" /></option>
					</select>				
				</td>
			</tr>
		</table>
	</form>
</div>	
<div id="updateLineButton"><a href="#" class="easyui-linkbutton" onclick="javascript:$('#formUpdateLineCode').submit();"><fmt:message key="info.confirm" /></a></div>


<!-- 공정등록용 -->
<div title="<fmt:message key='ui.label.procAdd' />" id="addProccode" style="width:360px;height:auto;" buttons="#addProcButton">
	<form id="formAddProcCode" style="padding:5px;" action="lineProcConfigure" method="post">
	<table>
		<tr>
			<td>
				<input type="hidden" name="procCate" value="PROC">
				<input type="hidden" name="procType" value="INSERT">
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.lineCode" /></span>				
				<input type="text" name="lineCode" size="18" readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">			
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.procName" /></span>
				<input name="procCode"  style="width:160px;" id="procCall" required="true">
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.seq" /></span>
				<input class="easyui-validatebox" required="true" type="text" name="procSeq" size="7">
			</td>
		</tr>
	</table>	
	</form>
</div>
<div id="addProcButton"><a href="#" class="easyui-linkbutton" onclick="javascript:insertProc();"><fmt:message key="info.confirm" /></a></div>

<!-- 공정관리용 -->

<div title="<fmt:message key='ui.label.procManage' />" id="updateProccode" style="width:360px;height:auto;" buttons="#updateProcButton">
	<form id="formUpdateProcCode" style="padding:5px;" action="lineProcConfigure" method="post">
	<table>
		<tr>
			<td>
				<input type="hidden" name="procCate" value="PROC">
				<input type="hidden" name="procType" value="UPDATE">
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.lineCode" /></span>				
				<input type="text" name="lineCode" size="18" readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">			
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.procCode" /></span>
				<input type="text" name="procCode" size="18" readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.procName" /></span>
				<input type="text" name="procName" size="18" readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">
			</td>
		</tr>		
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.seq" /></span>
				<input class="easyui-validatebox" required="true" type="text" name="procSeq" size="7">
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.enabled" /></span>				
				<select name="useYn">
					<option value="Y"><fmt:message key="ui.label.enable" /></option>
					<option value="N"><fmt:message key="ui.label.disable" /></option>
				</select>				
			</td>
		</tr>	
		<tr>
			<td style="color:red;">
				<br>
				<span style="width:5px;"></span><span id="donotEdit"></span>				
			</td>
		</tr>	
	</table>	
	</form>
</div>
<div id="updateProcButton"><a href="#" class="easyui-linkbutton" onclick="javascript:updateProc();"><fmt:message key="info.confirm" /></a></div>

</body>

</html>
