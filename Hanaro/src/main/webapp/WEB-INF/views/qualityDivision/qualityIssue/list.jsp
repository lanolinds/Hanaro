<!-- 제작일 : 2011. 10. 26.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.qualityIssueList"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	$(document).ready(function(){
		$("#undoneList").datagrid({onLoadSuccess:function(data){
			$("#readyCount").css("color","blue").text("("+data.total+")");
		}});
	});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

    <div class="easyui-tabs" style="width:1000px;height:700px;">  
        <div title='<fmt:message key="ui.label.qualityIssue.ready"/><span id="readyCount"></span>' iconCls="icon-document-prepare" style="padding:10px;">  
            <table id="undoneList" iconCls="icon-to-do-list" pagination="true" pageList="[50,100,200,300]"
						style="width: 900px; height: 600px;" fitColumns="true" title='<fmt:message key="ui.label.qualityIssue.readyList"/>' idField="regNo" url="list/gridCallback" >			
				<thead>
					<tr>
						<th field="ck" checkbox="true"></th>  
						<th field="regNo" width="250" sortable="true"><fmt:message key="ui.label.RegNo"/></th>
						<th field="date" width="150" align="center" sortable="true"><fmt:message key="ui.label.OccurHour"/></th>
						<th field="item" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="count" width="100" align="right" sortable="true"><fmt:message key="ui.label.count"/></th>
						<th field="comment" width="100" ><fmt:message key="ui.label.remark"/></th>
					</tr>
				</thead>
			</table>
        </div>  
        <div title='<fmt:message key="ui.label.qualityIssue.done"/>'  iconCls="icon-document-mark-as-final">

        </div>  
    </div>  

</div>
</body>

</html>
