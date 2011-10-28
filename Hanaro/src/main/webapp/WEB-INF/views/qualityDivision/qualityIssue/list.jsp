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
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script>
	<script type="text/javascript">
	
	
	$(document).ready(function(){
		
		// 그리드 랜더링.
		$("#undoneList").datagrid({queryParams:{fromDate:'${fromDate}',toDate:'${toDate}',item:''},
			onLoadSuccess:function(data){$("#readyCount").css("color","blue").text("("+data.total+")");}});
		
		//검색 필터 아이템에 자동완성 랜더링.
		$("#item").combogrid({
			panelWidth:500,
			idField:"item",
			textField:"item",
			url:"list/itemAssistCallback",
			columns:[[{field:"item",title:'<fmt:message key="ui.label.PartNo"/>',width:150},
			          {field:"name",title:'<fmt:message key="ui.label.PartName"/>',width:200},
			          {field:"car",title:'<fmt:message key="ui.label.Car"/>',width:50,align:"center"},
			          {field:"model",title:'<fmt:message key="ui.label.Model"/>',width:50,align:"center"}
			          ]]
		});
	});
	
	function validFilter(){
		var params={};
		params.fromDate=$("#fromDate").datebox("getValue");
		params.toDate=$("#toDate").datebox("getValue");
		params.item=$("#item").combogrid("getValue");
		
		$("#undoneList").datagrid("load",params);
		
	}
	
	function proceedSelectedIssues(){
		var selected =$("#undoneList").datagrid("getSelections");
		alert(selected.length);
	}
	
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">

<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
   
   
    <div class="easyui-tabs" style="width:1024px;height:720px;">  
        <div title='<fmt:message key="ui.label.qualityIssue.ready" /><span id="readyCount" style="margin-left:.3em;"></span>'  iconCls="icon-document-prepare"  >  
            <table id="undoneList" iconCls="icon-to-do-list" pagination="true" pageList="[50,100,200,300]"  border="false"
						fit="true" fitColumns="true" idField="regNo" url="list/gridCallback"  toolbar="#toolbar" >			
				<thead>
					<tr>
						<th field="ck" checkbox="true"></th>  
						<th field="regNo" width="250" sortable="true"><fmt:message key="ui.label.RegNo"/></th>
						<th field="date" width="150" align="center" sortable="true"><fmt:message key="ui.label.OccurHour"/></th>
						<th field="item" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="count" width="100" align="right" sortable="true" formatter="numeric"><fmt:message key="ui.label.count"/></th>
						<th field="comment" width="100" ><fmt:message key="ui.label.remark"/></th>
					</tr>	
				</thead>
			</table>
        </div>  
        <div title='<fmt:message key="ui.label.qualityIssue.done"/>'  iconCls="icon-document-mark-as-final">
        </div>  
    </div>
    
     
    <!-- 툴바 -->
    <div  id="toolbar" style="padding:5px;height:auto;">
    <div style="margin-top:.5em;">
	    <span style="margin-right:.5em"><fmt:message key="ui.label.SearchDate"/></span>
	    <input id="fromDate" class="easyui-datebox" required="true" editable="false" value='<fmt:formatDate value="${fromDate}" pattern='yyyy-MM-dd'/>' style="width:100px;"/>
	    <span style="margin: 0em .3em;">~</span>
	    <input id="toDate" class="easyui-datebox"  required="true" editable="false" value='<fmt:formatDate value="${toDate}" pattern='yyyy-MM-dd'/>' style="width:100px;"/>
	     <span style="margin-left:1em;margin-right:.5em;"><fmt:message key="ui.label.PartNo"/></span>
	    <input id="item" style="width:200px;"/>
	    <span style="margin-left:2em;"><a href="javascript:validFilter()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
    </div>
    <div style="text-align:right;">
    	<a href="javascript:proceedSelectedIssues()" class="easyui-linkbutton" iconCls="icon-document-todo" plain="true"><fmt:message key="ui.label.doSelected"/></a>
    </div>
    </div>
     
</div>
</body>

</html>
