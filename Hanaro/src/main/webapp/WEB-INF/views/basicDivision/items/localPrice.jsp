<!-- 제작일 : 2011. 11. 22.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title><fmt:message key="ui.label.pricePerPartner"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
	.simple-table  th {background-color: #FAFAFA;height:24px; font-weight:normal; text-align: left; white-space:nowrap;width: 100px; }
	.simple-table  td {border:1px dotted silver;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
<%-- 	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script> --%>
<script type="text/javascript">

$(document).ready(function(){
	
	//다이얼로그 랜더링.
	$("#priceEditDlg").dialog({buttons:[{text:'<fmt:message key="ui.button.Save"/>',iconCls:"icon-disk",handler:function(){
		validateEditForm();
	}},{text:'<fmt:message key="ui.button.Cancel"/>',iconCls:"icon-cancel",handler:function(){
		$("#priceEditDlg").dialog("close");
	}}]});
	
});

function addPrice(){
	bindPriceToDlg();
}
function editPrice(){
	var selected =$("#partnerList").datagrid("getSelected");
	if(!selected || selected.length===0){
		$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
		return false;
	}
	bindPriceToDlg(selected);
	
}

function bindPriceToDlg(data){
	
	if(data){
		var $form = $("form[name='priceForm']")[0];
		$form.reset();
		$("form[name='priceForm'] input[name='action']").val("edit");	
		$("#partners").combobox("setValue",data.code).combobox("disable");
		$("input[name='price']",$form).val(data.price);
		$("select[name='currency']",$form).val(data.currency);
		$(":radio[value='"+data.enabled+"']",$form).attr("checked",true);
		$("#priceEditDlg").dialog("open");
	}
	else{
		var $form = $("form[name='priceForm']")[0];
		$form.reset();
		$("form[name='priceForm'] input[name='action']").val("add");	
		$("#partners").combobox("setValue",'').combobox("enable");
		$("input[name='price']",$form).val(0.00);
		$("#priceEditDlg").dialog("open");
	}
}

function validateEditForm(){
	var action = $("form[name='priceForm'] input[name='action']").val();
	if(action=="add"){
		var partner = $("#partners").combobox("getValue");
		if(!partner || partner==""){
			$.messager.alert("Warnning",'<fmt:message key="warn.enterPartner"/>',"warning");
			return false;
		}
	}
	if(!$("#dlgPrice").numberbox("isValid")){
		$("#dlgPrice").numberbox("validate");
		return false;
	}
	
	if(action=="edit")
	{
		$("#partners").combobox("enable");
	}
	$("#priceEditDlg").dialog("close");
	$("form[name='priceForm']").submit();
}

</script>



</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

<div id="itemDetails" class="easyui-panel" title='<fmt:message key="ui.label.regInfo"/>' iconCls="icon-document-info" style="width:1000px;height:auto;padding:4px;">
<table class="simple-table" style="width:100%; ">
<tr>
<th><fmt:message key="ui.label.PartNo"/></th>
<td>${item.no }</td>
<th><fmt:message key="ui.label.PartName"/></th>
<td>${item.name }</td>
</tr>
<tr>
<th><fmt:message key="ui.label.CarModel"/></th>
<td>${item.car}/${item.model}</td>
<th><fmt:message key="ui.label.category"/></th>
<td>

<c:choose>
<c:when test="${item.type eq '1001'}"><fmt:message key="ui.label.product"/></c:when>
<c:otherwise><fmt:message key="ui.label.material"/></c:otherwise>
</c:choose>

</td>
</tr>
<tr>
<th><fmt:message key="ui.label.local"/></th>
<td>${item.locale}</td>
<th><fmt:message key="ui.label.defaultPrice"/></th>
<td><fmt:formatNumber  minFractionDigits="2" value="${item.price }"/>&nbsp;(${item.currency })</td>
</tr>
</table>	
</div>
<br/>
<table id="partnerList" class="easyui-datagrid" idField="code"
 toolbar="#toolbar"  singleSelect="true" style="width:1000px; height:400px;" fitColumns="true" 
 title='<fmt:message key="ui.label.localItemPriceStatus"/>' iconCls="icon-table-money">			
	<thead>
		<tr> 
			<th field="code" width="150" ><fmt:message key="ui.label.cust.custCd"/></th>
			<th field="name" width="250" sortable="true"><fmt:message key="ui.label.cust.custNm"/></th>
			<th field="price" width="100" align="right" sortable="true"><fmt:message key="ui.label.unitPrice"/></th>
			<th field="currency" width="50" align="center" sortable="true"><fmt:message key="ui.label.currency"/></th>
			<th field="enabled" width="50" align="center" sortable="true"><fmt:message key="ui.label.enabled"/></th>
		</tr>	
	</thead>
	<tbody>
	<c:forEach var="partner" items="${partners }">
	<tr>
		<td>${partner.code }</td>
		<td>${partner.name }</td>
		<td><fmt:formatNumber  minFractionDigits="2" value="${partner.price }"/></td>
		<td>${partner.currency }</td>
		<td>${partner.enabled }</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
<div style="width:1000px;text-align:right; padding:6px 0px;">
<a href='<c:url value="/basicDivision/items/itemLocalization"/>' class="easyui-linkbutton"  iconCls="icon-application-view-detail"><fmt:message key="ui.label.toList"/></a>
</div>
<!-- 툴바 -->
<div  id="toolbar" style="padding:5px;height:auto;">
 <div style="text-align:right;margin-top:.5em;">
 	<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="addPrice()" plain="true"><fmt:message key="ui.button.Add"/></a>
 	<a href="#" class="easyui-linkbutton" iconCls="icon-pencil" onclick="editPrice()" plain="true"><fmt:message key="ui.button.Edit"/></a>
<%--  	<a href="#" class="easyui-linkbutton" iconCls="icon-delete" onclick="deletePrice()" plain="true"><fmt:message key="ui.button.Delete"/></a> --%>
 </div>
</div>
</div>
<!-- 업체별 단가 관리 다이얼 로그 -->
<div id="priceEditDlg" closed="true" title='<fmt:message key="ui.button.Edit"/>' iconCls="icon-page-edit" style="width:350px;height:180px;" modal="true">
<form name="priceForm" action="updatePrice" method="post">
<input type="hidden" name="item" value="${item.no }"/>
<input type="hidden" name="action" value="add"/>
<table class="simple-table" style="margin-top:6px; width:100%;border: 1px solid silver;">
<tr>
<th><fmt:message key="ui.label.partner"/></th>
<td>
<select name="partners" id="partners" class="easyui-combobox" style="width:200px;">
<option value='' selected="selected"><fmt:message key="ui.element.Select"/></option>
<c:forEach var="partner" items="${options}">
<option value="${partner.custCode}">${partner.custName }</option>
</c:forEach>
</select>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.unitPrice"/></th>
<td>
<input type="text" name="price" id="dlgPrice"  class="easyui-numberbox" style="text-align: right;" required="true" min="0" precision="2" value="0.00" />
<select name="currency" id="currency">
<option value="BRL">BRL</option>
<option value="CNY">CNY</option>
<option value="CZK">CZK</option>
<option value="EUR">EUR</option>
<option value="INR">INR</option>
<option value="KRW">KRW</option>
<option value="USD">USD</option>
</select>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.enabled"/></th>
<td>
 <input type="radio"  name="enabled" value="Y" checked="checked"/><fmt:message key="ui.label.yes"/>
<input type="radio"  name="enabled" value="N"  style="margin-left:.5em;"/><fmt:message key="ui.label.no"/>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>
