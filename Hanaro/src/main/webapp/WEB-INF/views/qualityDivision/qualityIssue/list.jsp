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
		
		// 그리드 랜더링. 1번탭(처리대기)
		$("#undoneList").datagrid({queryParams:{fromDate:'<fmt:formatDate value="${fromDate}" pattern="yyyy-MM-dd"/>',
			toDate:'<fmt:formatDate value="${toDate}" pattern="yyyy-MM-dd"/>',item:''},
			onLoadSuccess:function(data){
				$("#readyCount").css("color","blue").text("("+data.total+")");
			},
			onLoadError:function(error){
				handleAjaxError(error);
			},
			onDblClickRow:function(i,row){
				acceptSelectedIssue();
			}
		});
		
		// 그리드 랜더링. 1번탭(처리완료)
		$("#doneList").datagrid({queryParams:{fromDate:'<fmt:formatDate value="${fromDate}" pattern="yyyy-MM-dd"/>',
			toDate:'<fmt:formatDate value="${toDate}" pattern="yyyy-MM-dd"/>',item:''},
			onLoadSuccess:function(data){
				$("#doneCount").css("color","blue").text("("+data.total+")");
			},
			onLoadError:function(error){
				handleAjaxError(error);
			},
			onDblClickRow:function(i,row){
				editSelectedIssue();
			}
		});
		
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
		
		//검색 필터 아이템에 자동완성 랜더링.
		$("#item2").combogrid({
			panelWidth:500,
			idField:"item",
			textField:"item",
			url:"list/itemAssistCallback2",
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
		
		$("#undoneList").datagrid("clearSelections");
		$("#undoneList").datagrid("load",params);
		
	}
	
	function validFilter2(){
		var params={};
		params.fromDate=$("#fromDate2").datebox("getValue");
		params.toDate=$("#toDate2").datebox("getValue");
		params.item=$("#item2").combogrid("getValue");
		
		$("#doneList").datagrid("clearSelections");
		$("#doneList").datagrid("load",params);
		
	}
	
	function acceptSelectedIssue(){
		var selected =$("#undoneList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		
		$("form[name='acceptForm'] input[name='regNo']").val(selected.regNo);
		$("form[name='acceptForm']").submit();
		
	}
	
	function editSelectedIssue(){
		var selected =$("#doneList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		
		$("form[name='approvalForm'] input[name='regNo']").val(selected.regNo);
		$("form[name='approvalForm'] input[name='no']").val(selected.approvalNo);
		$("form[name='approvalForm']").attr("action","acceptIssues").submit();
	}
	
	function cancelApproval(){
		var selected =$("#doneList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		var title='<fmt:message key="ui.label.cancelAction"/>';
		var question='<fmt:message key="question.cancelQualityIssueAction"/>';
		$.messager.confirm(title,question,function(yes){
			if(yes){
				$("form[name='approvalForm'] input[name='regNo']").val(selected.regNo);
				$("form[name='approvalForm'] input[name='no']").val(selected.approvalNo);
				$("form[name='approvalForm']").attr("action","cancelAccept").submit();
			}
		});
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
            <table id="undoneList" pagination="true" pageList="[50,100,200,300]"  border="false"
						fit="true" fitColumns="true" idField="regNo" url="list/gridCallback"  toolbar="#toolbar"  singleSelect="true">			
				<thead>
					<tr> 
						<th field="regNo" width="250" sortable="true"><fmt:message key="ui.label.RegNo"/></th>
						<th field="date" width="150" align="center" sortable="true"><fmt:message key="ui.label.OccurHour"/></th>
						<th field="place" width="100" sortable="true"><fmt:message key="ui.label.RegPlace"/></th>
						<th field="placeCode" hidden="true"></th>
						<th field="item" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="count" width="100" align="right" sortable="true" formatter="numeric"><fmt:message key="ui.label.count"/></th>
						<th field="comment" width="100" ><fmt:message key="ui.label.remark"/></th>
					</tr>	
				</thead>
			</table>
        </div>  
        <div title='<fmt:message key="ui.label.qualityIssue.done"/><span id="doneCount" style="margin-left:.3em;"></span>'  iconCls="icon-document-mark-as-final">
        	<table id="doneList" pagination="true" pageList="[50,100,200,300]"  border="false"
						fit="true" fitColumns="true" idField="approvalNo" url="list/gridCallback2"  toolbar="#toolbar2"  singleSelect="true">			
				<thead>
					<tr>
						<th field="approvalNo" width="100" sortable="true" align="center;"><fmt:message key="ui.label.actionNo"/></th>
						<th field="accepter" width="100" sortable="true"><fmt:message key="ui.label.actor"/></th> 
						<th field="regNo" width="250" sortable="true"><fmt:message key="ui.label.RegNo"/></th>
						<th field="date" width="150" align="center" sortable="true"><fmt:message key="ui.label.OccurHour"/></th>
						<th field="place" width="100" sortable="true"><fmt:message key="ui.label.RegPlace"/></th>
						<th field="placeCode" hidden="true"></th>
						<th field="item" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
						<th field="count" width="100" align="right" sortable="true" formatter="numeric"><fmt:message key="ui.label.count"/></th>
						<th field="comment" width="100" ><fmt:message key="ui.label.remark"/></th>
					</tr>	
				</thead>
			</table>
        </div>  
    </div>
    
     
    <!-- 툴바 -->
    <div  id="toolbar" style="padding:5px;height:auto;">
    <div style="margin-top:.5em;">
	    <span style="margin-right:.5em"><fmt:message key="ui.label.SearchDate"/></span>
	    <input id="fromDate" class="easyui-datebox" editable="false" value='<fmt:formatDate value="${fromDate}" pattern="yyyy-MM-dd"/>' style="width:100px;"></input>
	    <span style="margin: 0em .3em;">~</span>
	    <input id="toDate" class="easyui-datebox" editable="false" value='<fmt:formatDate value="${toDate}" pattern="yyyy-MM-dd"/>' style="width:100px;"></input>
	     <span style="margin-left:1em;margin-right:.5em;"><fmt:message key="ui.label.PartNo"/></span>
	    <input id="item" style="width:200px;"/>
	    <span style="margin-left:2em;"><a href="javascript:validFilter()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
    </div>
    <div style="text-align:right;">
    	<form name="acceptForm" method="post" action="readyApproval">
    		<input type="hidden" name="regNo"/>
    	</form>

    	<a href="#" class="easyui-linkbutton" iconCls="icon-document-next" onclick="acceptSelectedIssue()" plain="true"><fmt:message key="ui.label.doSelected"/></a>
    </div>
    </div>
    
    <!-- 툴바2 -->
    <div  id="toolbar2" style="padding:5px;height:auto;">
    <div style="margin-top:.5em;">
	    <span style="margin-right:.5em"><fmt:message key="ui.label.SearchDate"/></span>
	    <input id="fromDate2" class="easyui-datebox" editable="false" value='<fmt:formatDate value="${fromDate}" pattern="yyyy-MM-dd"/>' style="width:100px;"></input>
	    <span style="margin: 0em .3em;">~</span>
	    <input id="toDate2" class="easyui-datebox" editable="false" value='<fmt:formatDate value="${toDate}" pattern="yyyy-MM-dd"/>' style="width:100px;"></input>
	     <span style="margin-left:1em;margin-right:.5em;"><fmt:message key="ui.label.PartNo"/></span>
	    <input id="item2" style="width:200px;"/>
	    <span style="margin-left:2em;"><a href="javascript:validFilter2()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
    </div>
    <div style="text-align:right;">
    	<form name="approvalForm" method="post" action="acceptIssues">
    		<input type="hidden" name="no" />
    		<input type="hidden" name="regNo"/>
    	</form>
		<a href="#" class="easyui-linkbutton" iconCls="icon-page-delete" onclick="javascript:cancelApproval();"  plain="true"><fmt:message key="ui.label.cancelAction"/></a>
    	<a href="#" class="easyui-linkbutton" iconCls="icon-pencil" onclick="javascript:editSelectedIssue();"  plain="true"><fmt:message key="ui.label.editAction"/></a>
    </div>
    </div>
     
</div>
</body>

</html>
