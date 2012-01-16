<!-- 제작일 : 2012. 1. 13.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.materInoutMgmt"></fmt:message></title>
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
    <div id="tt" class="easyui-tabs" style="width:500px;height:250px;">
        <div title="<fmt:message key='menu.incomeMgmt' />" iconCls="icon-basket-add" style="padding:20px;display:none;">  
            tab3  
        </div>
        <div title="<fmt:message key='menu.outgoMgmt' />" iconCls="icon-basket-delete" style="padding:20px;display:none;">  
            tab3  
        </div>      
        <div title="<fmt:message key='menu.inoutSearch' />" iconCls="icon-table-refresh" style="padding:20px;display:none;">  
            tab3  
        </div>
        <div title="<fmt:message key='menu.currentStock' />" iconCls="icon-text-align-justity" style="padding:20px;display:none;">  
            tab3  
        </div>                      
    </div> 
</div>
</body>

</html>
