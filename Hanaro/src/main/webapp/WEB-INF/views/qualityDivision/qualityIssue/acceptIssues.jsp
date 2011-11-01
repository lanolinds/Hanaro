<!-- 제작일 : 2011. 10. 31.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>품질문제 처리</title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
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
	<table id="issueList" class="easyui-datagrid" title="품질 문제 처리 리스트" iconCls="icon-text-list-bullets" 
	style="width:300px;height:200px;" idField="regNo" singleSelect="true" striped="true" rownumbers="true" fitColumns="true">
	<thead>
	<tr>
	<th field="regNo" width="200">등록번호</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="issue" items="${issues }">
	<tr><td>${issue}</td></tr>
	</c:forEach>
	</tbody>
	</table>
</td>
<td>
<div id="issueDetails" class="easyui-panel" title="상세내역" iconCls="icon-document-info" style="width:800px;height:200px;">
<fieldset style="margin-top:.5em;">
<legend>기본정보</legend>

</fieldset>
</div>
</td>
</tr>
</table>
</div>
</body>

</html>
