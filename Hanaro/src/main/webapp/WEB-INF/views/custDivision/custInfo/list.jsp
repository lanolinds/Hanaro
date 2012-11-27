<!-- 제작일 : 2011. 10. 18.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
	<title><fmt:message key="menu.qualityIssueReg" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>	
	<style type="text/css">
		#form th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#form td {border:1px dotted silver;width:170px;}
		#form input{border:0px;width:250px;}
		#form select{width:250px;}
						
	</style>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>	
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	<script type="text/javascript">
	$(document).ready(function(){			
		url:"getCustList";
		var params = {};
		params.keyfield = ""; 
		$("#resultDataGrid").datagrid("load",params);
		
		// 그리드 랜더링. 1번탭(처리완료)
		$("#resultDataGrid").datagrid({
			onLoadSuccess:function(data){
				
			},
			onDblClickRow:function(i,row){
				if(row.DATA2=="${user}"){
					$("form[name='custInfoForm'] input[name='custCd']").val(row.DATA2);
					$("form[name='custInfoForm']").attr("action","viewCustInfo").submit();
				}
			}
		});
	});

	//사원정보 등록 리스트 조회하기
	function searchList(){
		var params = {};
		params.keyfield = $("#keyfield").val(); 
		$("#resultDataGrid").datagrid("load",params);
		
	}
	</script> 

</head> 

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp"%>
</div>
<div region="center" style="padding:10px;">	
<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:880px;height:725px;" 
title='<fmt:message key="ui.label.cust.custList"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"  
		 singleSelect="true" striped="true"   url="getCustSearchList" >
	<thead>
	        <tr> 
	            <th field="DATA1" width="80" sortable="true" align="center"><fmt:message key="ui.label.cust.custType" /></th>  
	            <th field="DATA2" width="70" sortable="true" align="center"><fmt:message key="ui.label.cust.custCd" /></th>   		
	            <th field="DATA3" width="160" sortable="true" align="center"><fmt:message key="ui.label.cust.custNm" /></th>   				      
	            <th field="DATA7" width="90" sortable="true" align="center" ><fmt:message key="ui.label.cust.officePhone" /></th>  
	            <th field="DATA8" width="90" sortable="true" align="center"><fmt:message key="ui.label.cust.officeFax" /></th>
	            <th field="DATA10" width="200" sortable="true" align="center"><fmt:message key="ui.label.cust.email" /></th>  
	            <th field="DATA12" width="80" sortable="true" align="center"><fmt:message key="ui.label.cust.stdDt" /></th>
	            <th field="DATA13" width="80" sortable="true" align="center"><fmt:message key="ui.label.cust.endDt" /></th>     
 		</tr>
	</thead>
</table>
</div>

 <div id="divSearch" style="padding:5px;height:auto">
       <div>        
		<input id="keyfield" style="width:120px;"  value=""  />
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>		
		<form name="custInfoForm" method="post" action="viewCustInfo">
    		<input type="hidden" name="custCd"/>
    	</form>
     </div>
 </div>  
</body>

</html>
