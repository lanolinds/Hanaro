<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<%@page import="org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter" %>
<c:set var="caching" value="14" scope="page" />
<%response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hanaro System Login Page</title>
<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
<link rel="shortcut icon" href='<c:url value="/resources/images/favi.ico"/>' />
<link rel="stylesheet" href="resources/scripts/easyui/themes/gray/easyui.css"/>
<link rel="stylesheet" href="resources/scripts/easyui/themes/icon.css"/>
<link rel="stylesheet" href="resources/styles/app.default.css"/>
<style type="text/css">
.loginError{color:red;}
</style>	
 
<script type="text/javascript" src="resources/scripts/jquery/jquery.latest.js"></script>
<script type="text/javascript" src="resources/scripts/jqueryui/js/jquery-ui-latest.min.js"></script>
<script type="text/javascript" src="resources/scripts/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"></script>
<script type="text/javascript" src="resources/scripts/cookie/jquery.cookie.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	//쿠키를 읽어온다.
	var remember = $.cookie('hanaro.remember');
	if(remember=='true'){
		$("#j_username").val($.cookie("hanaro.id"));
		$("#rememberId").attr("checked",true);
	}
	
	$("#rememberId").change(function(){ 
		if($(this).attr("checked")){
			$.cookie('hanaro.remember',true, { expires: 14 });
			$.cookie('hanaro.id',$.trim($("#j_username").val()), { expires: 14 });
		}
		else{
			$.cookie('hanaro.remember',null);
			$.cookie('hanaro.id',null);
		}
		$(this).blur();
	});
	
	//로그인 에러가 있는지 확인.(에러가 있으면 로그인 폼 한 번 떨어주자 ㅋㅋ)
	if($.trim($(".loginError").text()).length>0){
			$("#loginDlg").dialog("dialog").effect("shake",{},50); //로그인 창.
			$(".window-shadow").effect("shake",{},50); // 로그인 창 그림자.
	}	
});

</script>
</head>
<body onload="javascript:$('#j_username').select().focus();">
<div id="loginDlg" class="easyui-dialog" title="Please enter your credentials" closable="false" draggable="false" resizable="false" buttons="#buttonBag" style="width:300px; height:210px;padding:10px;">
<form name="loginForm" action="j_spring_security_check" method="post">
<table style="width:250px;margin-left:auto; margin-right:auto;margin-top:5px;">
<tr>
<td colspan="2" align="right">
<span class="loginError">
<c:choose>
<c:when test="${not empty param.login_error}"><fmt:message key="error.loginFail"/></c:when>
<c:when test="${not empty param.timeout}"><fmt:message key="error.sessionTimeout"/></c:when>
<c:otherwise>&nbsp;</c:otherwise>
</c:choose>
</span></td>
</tr>
<tr>
<td><span class="icon-user-silhouette" style="padding-left:20px;">ID</span></td>
<td align="right"><input type="text" name="j_username" id="j_username" style="width:150px;" <c:if test="${not empty param.login_error}">value='<%= session.getAttribute(UsernamePasswordAuthenticationFilter.SPRING_SECURITY_LAST_USERNAME_KEY) %>'</c:if>/></td>
</tr>
<tr>
<td><span class="icon-key" style="padding-left:20px;">PASSWORD</span></td>
<td align="right"><input type="password" name="j_password" id="j_password" style="width:150px;" onkeypress="javascript:if(event.keyCode==13) document.loginForm.submit()"/></td>
</tr>
<tr>
<td colspan="2" align="right"><input type="checkbox" id="rememberId" title='<fmt:message key="info.rememberMe"><fmt:param value="${caching}"/></fmt:message>'>Remember ID</td>
</tr>
</table>
<div id="buttonBag">
<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:document.loginForm.reset();$('#j_username').focus();">Cancel</a>
<a href="#" class="easyui-linkbutton" iconCls="icon-door-in" onclick="javascript:document.loginForm.submit()">Login</a>
</div>
</form>
</div>
</body>
</html>
