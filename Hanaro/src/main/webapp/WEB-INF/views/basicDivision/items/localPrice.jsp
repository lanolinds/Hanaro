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
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

<div id="itemDetails" class="easyui-panel" title='<fmt:message key="ui.label.regInfo"/>' iconCls="icon-document-info" style="width:1000px;height:auto;padding:2px;">
<table class="simple-table" style="width:100%;">
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
<table id="partnerList" class="easyui-datagrid" idField="code" url="gridCallback" 
 toolbar="#toolbar"  singleSelect="true" style="width:1000px; height:400px;" fitColumns="true" 
 title='<fmt:message key="ui.label.localItemPriceStatus"/>' iconCls="icon-table-money">			
	<thead>
		<tr> 
			<th field="code" width="150" ><fmt:message key="ui.label.cust.custCd"/></th>
			<th field="name" width="250" sortable="true"><fmt:message key="ui.label.cust.custNm"/></th>
			<th field="price" width="100" align="right" sortable="true"><fmt:message key="ui.label.unitPrice"/></th>
			<th field="currency" width="50" align="center" sortable="true"><fmt:message key="ui.label.currency"/></th>
		</tr>	
	</thead>
	<tbody>
	<c:forEach var="partner" items="${partners }">
	<tr>
		<td>${partner.code }</td>
		<td>${partner.name }</td>
		<td><fmt:formatNumber  minFractionDigits="2" value="${partner.price }"/></td>
		<td>${partner.currency }</td>
	</tr>
	</c:forEach>
	</tbody>
</table>

<!-- 툴바 -->
<div  id="toolbar" style="padding:5px;height:auto;">
 <div style="text-align:right;margin-top:.5em;">
 	<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="" plain="true"><fmt:message key="ui.button.Add"/></a>
 	<a href="#" class="easyui-linkbutton" iconCls="icon-pencil" onclick="" plain="true"><fmt:message key="ui.button.Edit"/></a>
 	<a href="#" class="easyui-linkbutton" iconCls="icon-delete" onclick="" plain="true"><fmt:message key="ui.button.Delete"/></a>
 </div>
</div>
</div>
</body>
</html>
