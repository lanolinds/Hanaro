<!-- 제작일 : 2011. 10. 4.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title>Access Denied</title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
	
	</style>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
</head>
  
<body>
<table style="margin-left: 50px; margin-top: 50px;">
<tr>
<td>
<img style="vertical-align: text-bottom;" src='<c:url value="/resources/images/access-denied.png"/>'>
</td>
<td style="vertical-align: bottom; padding-left: 100px;padding-bottom: 1em;">
<div style="color:red;">
<h1 style="font-size: xx-large;"><fmt:message key="warn.accessDenied"/></h1>
<p style="max-width: 400px;"><fmt:message key="warn.needPermission"/></p>
<a href="javascript:history.go(-1)" class="easyui-linkbutton"  iconCls="icon-back" ><fmt:message key="ui.label.goback"/></a>
</div>
</td> 
</tr>
</table> 

</body>

</html>
