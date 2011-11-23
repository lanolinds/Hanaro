<!-- 제작일 : 2011. 11. 22.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.itemLocalization"/></title>
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
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script>
	
	<script type="text/javascript">
	$(document).ready(function(){
		
		//그리드 랜더링.
		$("#itemList").datagrid({
			onLoadError:function(error){
				handleAjaxError(error);
			},
			queryParams:{item:'',cate:'1001',localized:'N'},
			rowStyler:function(i,row){
				if(row.localized==="N"){
					return 'color:grey;font-style:italic;';  
				}
			},
			onSelect:function(index,data){
				if(data.localized=="Y"){
					$("#btnLocalize").linkbutton("disable");
					$("#btnEdit").linkbutton("enable");
					$("#btnPartner").linkbutton("enable");
				}
				else{
					$("#btnLocalize").linkbutton("enable");
					$("#btnEdit").linkbutton("disable");
					$("#btnPartner").linkbutton("disable");
				}
			}
		});
		
		//다이얼로그 랜더링.
		$("#itemEditDlg").dialog({buttons:[{text:'<fmt:message key="ui.button.Save"/>',iconCls:"icon-disk",handler:function(){
			validateItemEditForm();
		}},{text:'<fmt:message key="ui.button.Cancel"/>',iconCls:"icon-cancel",handler:function(){
			$("#itemEditDlg").dialog("close");
		}}]});
	});
	
	function reloadGrid(){
		var params={};
		params.item = $.trim($("#searchItem").val());
		params.cate = $(":checked[name='cate']").val();
		params.localized=$(":checked[name='localized']").val();
		
		$("#itemList").datagrid("clearSelections");
		$("#itemList").datagrid("load",params);
		
	}
	function bindItemToDlg(){
		
		var selected =$("#itemList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		var $form = $("form[name='itemForm']")[0];
		$form.reset();
		$("input[name='type']",$form).val(selected.type);
		$("input[name='itemNo']",$form).val(selected.no);
		$("input[name='itemName']",$form).val(selected.name);
		$("input[name='price']",$form).val(selected.price);
		$("select[name='currency']",$form).val(selected.currency);
		$(":radio[value='"+selected.enabled+"']",$form).attr("checked",true);
		$("#itemEditDlg").dialog("open");
	}
	
	function validateItemEditForm(){
		if(!$("#dlgPrice").numberbox("isValid"))
		{
			return false;	
		}
		$("#itemEditDlg").dialog("close");
		$("form[name='itemForm']").submit();
		
	}
	
	function goTo(){
		var selected =$("#itemList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		var url = '<c:url value="/basicDivision/items/localPrice"/>'+'/'+selected.no;
		$("#btnPartner").attr("href",url);
		
	}
	</script>

</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

<table id="itemList" pagination="true" pageList="[50,100,200,300]" idField="no" url="itemLocalization/gridCallback" 
 toolbar="#toolbar"  singleSelect="true" style="width:1000px; height:600px;" fitColumns="true" 
 title='<fmt:message key="ui.label.itemList"/>' iconCls="icon-application-view-list">			
	<thead>
		<tr> 
			<th field="no" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
			<th field="name" width="250" sortable="true"><fmt:message key="ui.label.PartName"/></th>
			<th field="price" width="100" align="right" sortable="true" formatter="numeric"><fmt:message key="ui.label.unitPrice"/></th>
			<th field="currency" width="50" align="center" sortable="true"><fmt:message key="ui.label.currency"/></th>
			<th field="localized" width="50" align="center" sortable="true" ><fmt:message key="ui.label.localized"/></th>
			<th field="enabled" width="50" align="center" sortable="true"><fmt:message key="ui.label.enabled"/></th>
		</tr>	
	</thead>
</table>

<!-- 툴바 -->
    <div  id="toolbar" style="padding:5px;height:auto;">
	    <div style="margin-top:.5em;">
	    
	     	<span style="margin-left:1em;margin-right:.2em;"><fmt:message key="ui.label.category"/></span>
		    <span style="background-color:white;padding:4px;" >
		    <input type="radio"  name="cate" value="1001" checked="checked"/><fmt:message key="ui.label.product"/>
		    <input type="radio"  name="cate" value="1002"  style="margin-left:.5em;"/><fmt:message key="ui.label.material"/>
		    </span>
		    
		    <span style="margin-left:1em;margin-right:.2em;"><fmt:message key="ui.label.type"/></span>
		    <span style="background-color:white;padding:4px;">
		    <input type="radio"  name="localized" value="N" checked="checked"/><fmt:message key="ui.element.All"/>
		    <input type="radio"  name="localized" value="Y"  style="margin-left:.5em;"/><fmt:message key="ui.label.localItem"/>
		    </span>
		    
		     <span style="margin-left:1em;margin-right:.2em;"><fmt:message key="ui.label.PartNo"/></span>
		    <input id="searchItem" name="searchItem" style="width:200px;"/>
		    <span style="margin-left:2em;"><a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="reloadGrid()"><fmt:message key="ui.button.Search"/></a></span>
	    </div>
	    <div style="text-align:right;">
	    	<a href="#" class="easyui-linkbutton" id="btnLocalize" iconCls="icon-brick-add" onclick="bindItemToDlg()" plain="true"><fmt:message key="ui.label.localizeItem"/></a>
	    	<a href="#" class="easyui-linkbutton" id="btnEdit" iconCls="icon-pencil" onclick="bindItemToDlg()" plain="true"><fmt:message key="ui.button.Edit"/></a>
	    	<a href="#" class="easyui-linkbutton" id="btnPartner" iconCls="icon-table-money" onclick="goTo()" plain="true"><fmt:message key="ui.label.pricePerPartner"/></a>
	    </div>
    </div>
</div>

<div id="itemEditDlg" closed="true" title='<fmt:message key="ui.button.Edit"/>' iconCls="icon-page-edit" style="width:400px;height:200px;" modal="true">
<form name="itemForm" action="itemLocalization/updateLocalItem" method="post">
<input type="hidden" name="type"/>
<table class="simple-table" style="margin-top:6px; width:100%;">
<tr>
<th><fmt:message key="ui.label.PartNo"/></th>
<td><input type="text" readonly="readonly" name="itemNo" style="border:none;width:200px;"/></td>
</tr>
<tr>
<th><fmt:message key="ui.label.PartName"/></th>
<td><input type="text" readonly="readonly" name="itemName" style="border:none;width:200px;"/></td>
</tr>
<tr>
<th><fmt:message key="ui.label.unitPrice"/></th>
<td>
<input type="text" name="price" id="dlgPrice"  class="easyui-numberbox" required="true" min="0" precision="2"/>
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
