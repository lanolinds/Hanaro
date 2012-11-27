<!-- 제작일 : 2011. 11. 24.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
	<title><fmt:message key="menu.changePassword" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		input:password{border:1px dotted silver;width:170px;}
	</style>	
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
		function changePwd(){			
			if($("#changeForm").form("validate")){			
				$("#changeForm").submit();
			}else{
				return false;
			}			
		}
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;" align="center">
	<table width="100%" height="100%">
		<tr>
			<td align="center"  style="vertical-align: middle;">
				
				<div iconCls="icon-change-password" title="<fmt:message key='menu.changePassword' />" class="easyui-dialog" buttons="#submitBt"  closable="false" minimizable="false" maximizable="false" draggable="false" resizable="false" collapsible="false" style="width:460px;height:280px;">
				<form id="changeForm" action="changePassword" method="post">				
				<table  >
					<tr>
						<td style="background-color:white;padding:20px;width:450px;height:170px;" align="center">				
							<span class="label-Leader-black" style="width:90px;text-align: left;"><fmt:message key="ui.label.account" /></span>
							<span style="width:190px;text-align: left;"><input style="border: 0px;" type="text" size="35" value="${uid}" /></span>
							<br>							
							<span  class="label-Leader-black" style="width:90px;text-align: left;"><fmt:message key="ui.label.cntPwd" /></span>
							<span style="width:190px;text-align: left;"><input name="cntPwd" type="password" size="35" class="easyui-validatebox" required="true" /></span>
							<br>							
							<span  class="label-Leader-green" style="width:90px;text-align: left;"><fmt:message key="ui.label.newPwd" /></span>
							<span style="width:190px;text-align: left;"><input name="newPwd" type="password" size="35" class="easyui-validatebox" required="true" /></span>
							<br>
							<br>
							<hr>
							<br>
							<span style="color:#666666;"><fmt:message key="info.changePwd"><fmt:param value="${uid}"/></fmt:message></span>
						</td>
					</tr>										
				</table>
				</form>
				</div>
				
			</td>
		</tr>
	</table>
</div>
<div id="submitBt" align="center">		
	<c:if test="${not empty fail}"><span style="color:red;text-align: left;"><fmt:message key="error.failCntPwd" /></span></c:if>
	<c:if test="${not empty changed}"><span style="color:blue;text-align: left;"><fmt:message key="error.changedPwd" /></span></c:if>												
	<a href="#" onclick="javascript:changePwd();"  class="easyui-linkbutton" iconCls="icon-accept" id="btChange"><fmt:message key="ui.label.change"/></a>
</div>
</body>

</html>
