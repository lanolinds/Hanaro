<!-- 제작일 : 2011. 10. 4.-->
<!-- 제작자 : IP-HJW-->
<%@page import="java.io.PrintWriter"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<% 
response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
Exception ex = (Exception)request.getAttribute("exception");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Database Processing Error</title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
</head> 
 
<body style="margin-left: 50px; margin-top: 50px;">
<table>
<tr>
<td>
<img style="vertical-align: text-bottom;" src='<c:url value="/resources/images/databases.jpg"/>'>
</td>
<td style="vertical-align: bottom; padding-left: 30px;padding-bottom: 1em;">
<div style="color:red;">
<h1 style="font-size: xx-large;"><fmt:message key="error.databaseError"/></h1>
<p style="max-width: 550px;font-size: smaller;"><fmt:message key="error.dataAccessError"/></p>
<p style="font-style: italic; font-size: smaller; color:blue;max-width: 550px;"><%=ex.getMessage()%></p>
<a href="javascript:history.go(-1)" class="easyui-linkbutton"  iconCls="icon-back" ><fmt:message key="ui.label.goback"/></a>
</div>
</td>
</tr>
</table> 
<br/>
<div class="easyui-panel" title="Contents of Java statck trace" style="width:1000px;height:400px;padding:10px;background:#000000;color:#ffffff;"  
        iconCls="icon-bug-error" collapsible="true" minimizable="false" maximizable="false">  
    <p><%ex.printStackTrace(new PrintWriter(out));%></p>  
</div>
</body>

</html>
