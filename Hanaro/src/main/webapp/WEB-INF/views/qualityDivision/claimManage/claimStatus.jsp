<!-- 제작일 : 2012. 4. 20.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.qualityClaimStatus"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		.padding10{padding:5px 10px;background-color:#EFEFEF;width:100%;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	function searchList(){
		
	}
		$(document).ready(function(){
			$("#datebox1").datebox(
					{
						width:100,
						onSelect:function(date){
							{
								var year = date.getYear();
								var mon = date.getMonth();
								var day = date.getDate();
	 							$("input[name='year1']").val(year);
	 							$.get("../qualityIssue/getWeekOfYear",{year:year,month:mon,day:day},function(result){
	 								$("input[name='date1']").val(result);
	 							});
							}
						}
					}
			);
			$("#datebox2").datebox(
					{
						width:100,
						onSelect:function(date){
							{
								var year = date.getYear();
								var mon = date.getMonth();
								var day = date.getDate();
	 							$("input[name='year2']").val(year);
	 							$.get("../qualityIssue/getWeekOfYear",{year:year,month:mon,day:day},function(result){
	 								$("input[name='date2']").val(result);
	 							});
							}
						}
					}
			);
		});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
	<div iconCls="icon-system-monitor" class="easyui-panel" style="width:1194px;" title='<fmt:message key="menu.qualityClaimStatus"/>'>
	<div class="padding10">
		<fmt:message key="ui.label.searchDateType" /> : 
		<input type="radio" name="selectTerm" value="M"  onclick="javascript:$('#monthSearch').css('display','inline');$('#weekSearch').css('display','none');" checked><fmt:message key='ui.label.byMonth' />
		<input type="radio" name="selectTerm" value="W" onclick="javascript:$('#monthSearch').css('display','none');$('#weekSearch').css('display','inline');"><fmt:message key='ui.label.byWeek' />
	</div>	
	<div class="padding10" id='monthSearch'>
		<fmt:message key="ui.label.SearchDate" /> : 
		<select  name="year1" class="searchBorder">
		<c:forEach items="${years}" var="item">
			<option value="${item}">${item}</option>
		</c:forEach>
		</select>
		<select name="date1">
		<c:forEach begin="1" end="12" varStatus="state">
			<option value="${state.index}">${state.index}</option>
		</c:forEach>	
		</select>
		<span style="margin: 0em .3em;">~</span>
		<select  name="year2">
		<c:forEach items="${years}" var="item">
			<option value="${item}">${item}</option>
		</c:forEach>
		</select>
		<select name="date2">
		<c:forEach begin="1" end="12" varStatus="state">
			<option value="${state.index}">${state.index}</option>
		</c:forEach>	
		</select>	
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>					
	</div>
	<div class="padding10" id='weekSearch' style="display:none;">
		<fmt:message key="ui.label.SearchDate" /> : 
		<input type="text" id="datebox1" editable="false">
		<input type="text" name="year1" readonly="true" size="4">
		<input type="text"  name="date1" readonly="true" size="2">
		<span style="margin: 0em .3em;">~</span>
		<input type="text" id="datebox2" editable="false">
		<input type="text"  name="year2" readonly="true" size="4">
		<input type="text"  name="date2" readonly="true" size="2">
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>
	</div>
	<div id="tabsong" class="easyui-tabs" style="width:1192px;height:730px;">  
	    <div title="<fmt:message key='tab.issueClaim'/>" iconCls="icon-error"  style="padding:20px;">  
	        tab1  
	    </div>  
	    <div title="<fmt:message key='tab.issueTeam'/>" iconCls="icon-group" style="padding:20px;">  
	        tab2  
	    </div>  
	    <div title="<fmt:message key='tab.issueCust'/>" iconCls="icon-lorry" style="padding:20px;">  
	        tab3  
	    </div>
	    <div title="<fmt:message key='tab.issueDate'/>" iconCls="icon-date" style="padding:20px;">  
	        tab4  
	    </div>        
	</div>  
</div>
</div>
</body>

</html>
