<!-- 제작일 : 2011. 11. 25.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title><fmt:message key="menu.multiLangSupport"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	
	$(document).ready(function(){
		$("#properties").datagrid({
			onBeforeEdit:function(index,row){  
	            row.editing = true;  
	            updateActions();  
	        },  
	        onAfterEdit:function(index,row){ 
	        	var $form = $("form[name='editForm']");
	        	$("input[name='key']",$form).val(row.key);
	        	$("input[name='val']",$form).val(row.local);
	           	$("form[name='editForm']").submit();
	        },  
	        onCancelEdit:function(index,row){  
	            row.editing = false;  
	            updateActions();  
	        },
	        queryParams:{status:"done"}
		});
	});
	function editFormatter(value,row,index){  
        if (row.editing){  
            var s = '<a href="#" onclick="saverow('+index+')"><fmt:message key="ui.button.Save"/></a> ';  
            var c = '<a href="#" onclick="cancelrow('+index+')"><fmt:message key="ui.button.Cancel"/></a>';  
            return s+c;  
        } else {  
            var e = '<a href="#" onclick="editrow('+index+')"><fmt:message key="ui.button.Edit"/></a> ';  
      
            return e;  
        }  
    } 
    function editrow(index){  
        $('#properties').datagrid('beginEdit', index);  
    }  
      
    function saverow(index){  
        $('#properties').datagrid('endEdit', index);  
    }  
    function cancelrow(index){  
        $('#properties').datagrid('cancelEdit', index);  
    }  
    function updateActions(){  
        var rowcount = $('#properties').datagrid('getRows').length;  
        for(var i=0; i<rowcount; i++){  
            $('#properties').datagrid('updateRow',{  
                index:i,  
                row:{action:''}  
            });  
        }  
    }  
    
    function reloadGrid(){
    	var params={};
    	params.status=$("input[name='status']:checked").val();
    	$("#properties").datagrid("load",params);
    }
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
<div style="width:1000px;text-align: right;">
<form name = "editForm" action="editLang" method="post">
<input type="hidden" name="key"/>
<input type="hidden" name="val"/>
</form>
<fmt:message key="ui.label.currentLang"/>:<b>${lang}</b>
</div>
<table id="properties" idField="key" pagination="true" pageSize="20" pageList="[30,50,70,100]" 
 toolbar="#toolbar"  singleSelect="true" style="width:1000px; height:600px;" fitColumns="true" 
 title='<fmt:message key="ui.label.multiLangList"/>' iconCls="icon-world" url = "langSupport/gridCallback">			
	<thead>
		<tr> 
			<th field="key" width="200" sortable="true">key</th>
			<th field="std" width="350" sortable="true"><fmt:message key="ui.label.indexLang"/></th>
			<th field="local" width="350"  editor="textarea"><fmt:message key="ui.label.localLang"/></th>
			<th field="action" width="100"  formatter="editFormatter" align="center">#</th>
		</tr>	
	</thead>
</table>

<!-- 툴바 -->
<div  id="toolbar" style="padding:5px;height:auto;">
 <div margin-top:.5em;">
 	<input type="radio" name="status" value="done" checked="checked"/><fmt:message key="ui.label.complete"/>
 	<input type="radio" name="status" value="ready"/><fmt:message key="ui.label.ready"/>
 	<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="reloadGrid()" style="margin-left:2em;"><fmt:message key="ui.button.Search"/></a>
 </div>
</div>
</div>
</body>
</html>
