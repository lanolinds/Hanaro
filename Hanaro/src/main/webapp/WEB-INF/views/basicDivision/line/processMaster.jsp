<!-- 제작일 : 2011. 12. 5.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title><fmt:message key="menu.processMaster" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	
	function useYn(rowIdx,rowData){
		if(rowData.USE_YN=="N")
			return 'color:grey;font-style:italic;';
	}
	
	//공정코드추가용 화면을 연다
	function openProcAdd(){
		$('#addProccode').dialog({modal:true});
	}	
	
	//공정코드을 추가한다.
	function insertProc(){		
		if($("#formAddProcCode").form("validate")){
			$("#formAddProcCode").submit();
			
		}else{
			return false;
		}		
	}	
	
	//공정수정용 화면을 연다
	function openProcUpdate(){
		var datas = $("#processMasterTable").datagrid("getSelected");
		if(datas ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$("input[name='procCode']",$("#updateProccode")).val(datas.PROC_CD);
		$("input[name='procName']",$("#updateProccode")).val(datas.PROC_NM);
		$("input[name='procRemark']",$("#updateProccode")).val(datas.PROC_REMARK);
		$("select[name='useYn']",$("#updateProccode")).val(datas.USE_YN);
		$('#updateProccode').dialog({modal:true});
	}		
	
	//공정코드를 수정한다
	function updateProc(){		
		if($("#formUpdateProcCode").form("validate")){
			if($("select[name='useYn']",$("#updateProccode")).val()=="N"){
				$.messager.confirm("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.procUserNCascade' />",function(r){  
				    if (r){  
				    	$("#formUpdateProcCode").submit();  
				    }  
				});
			}else{
				$("#formUpdateProcCode").submit();
			}
		}else{
			return false;
		}		
	}
	
	$(document).ready(function(){
		$("#processMasterTable").datagrid({
			url:"getProcessMasterList"
			
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
	<table singleSelect = "true" toolbar="#procManage"  rowStyler="useYn"   iconCls="icon-gear-in" id="processMasterTable"  style="width:610px;height:600px" title ="<fmt:message key="menu.processMaster" />">
		<thead>
			<th field="PROC_CD" width="70"><fmt:message key="ui.label.procCode" /></th>
			<th field="PROC_NM" width="200"><fmt:message key="ui.label.procName" /></th>
			<th field="PROC_REMARK" width="250"><fmt:message key="ui.label.remark" /></th>
			<th field="USE_YN" width="60"><fmt:message key="ui.label.enabled" /></th>
		</thead>
	</table>
</div>
<div id="procManage" style="padding:5px;height:auto">
	<div align="right">				
         	<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:openProcAdd();"><fmt:message key="ui.button.Add"/></a>
         	<a href="#" class="easyui-linkbutton" iconCls="icon-pencil" plain="true" onclick="javascript:openProcUpdate();"><fmt:message key="ui.button.Edit"/></a>			
	</div>
</div>

<!-- 공정등록용 -->
<div title="<fmt:message key='ui.label.procCodeAdd' />" id="addProccode" style="width:400px;height:auto;" buttons="#addProcButton">
	<form id="formAddProcCode" style="padding:5px;" action="processMaster" method="post">
	<table>
		<tr>
			<td>				
				<input type="hidden" name="procType" value="INSERT">
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.procCode" /></span>				
				<input type="text" name="procCode" value="<fmt:message key='ui.label.AutoCreate' />"  size=40 readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">			
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.procName" /></span>
				<input name="procName"  class="easyui-validatebox" required="true" size=40>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.remark" /></span>
				<input  type="text" name="procRemark"  size=40>
			</td>
		</tr>
	</table>	
	</form>
</div>
<div id="addProcButton"><a href="#" class="easyui-linkbutton" onclick="javascript:insertProc();"><fmt:message key="info.confirm" /></a></div>

<!-- 공정수정용 -->
<div title="<fmt:message key='ui.label.procCodeAdd' />" id="updateProccode" style="width:400px;height:auto;" buttons="#updateProcButton">
	<form id="formUpdateProcCode" style="padding:5px;" action="processMaster" method="post">
	<table>
		<tr>
			<td>				
				<input type="hidden" name="procType" value="UPDATE">
				<span class="label-Leader-black" style="width:100px;"><fmt:message key="ui.label.procCode" /></span>				
				<input type="text" name="procCode"  size=40 readonly  style="border:1px solid #CFDBEC;background-color:#EFEFEF;">			
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.procName" /></span>
				<input name="procName"  class="easyui-validatebox" required="true" size=40>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label-Leader-blue" style="width:100px;"><fmt:message key="ui.label.remark" /></span>
				<input  type="text" name="procRemark"  size=40>
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
<div id="updateProcButton"><a href="#" class="easyui-linkbutton" onclick="javascript:updateProc();"><fmt:message key="info.confirm" /></a></div>
</body>

</html>
