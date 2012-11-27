<!-- 제작일 : 2012. 2. 20.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
	<title><fmt:message key="ui.label.detailStatus"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>		
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>	
	<style type="text/css">
	.fileDown{cursor:pointer;color:blue;font-weight:bold;}			 
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>	
	<script type="text/javascript">
	
	function searchProcess(){
		$("#resultDataGrid").datagrid({
			queryParams:{
				p1:"${term}"
				,p2:"${seq1}"
				,p3:"${seq2}"
				,p4:"${seq3}"
				,p5:"${cate}"
				,p6:$("#beltFilter").val()
				,p7:"${sLocale}"
				,group:$("#groupFilter").val()}
		});		
	}
	
	function rowStyle(rowIdx,rowData){		
		if(rowData.DATA4==""){
			return 'color:blue;font-weight:bold;font-size:1.2em;';
		}else if(rowData.DATA0==""){
			return 'background-color:#F3F3F3;font-weight:bold;';
		}
	}
	function popDetail(value){
        var win = window.open("ncrManageDetail?ncrNo="+value,"NCRDetail", "width=1145,height=797,location=no,menubar=no,resizable=no,scrollbars=yes,status=no,toolbar=no");
        win.focus();
	}		
	function ncrPop(value,rowData){
		if(value)
			return"<span class='fileDown' onclick='javascript:popDetail("+value+")'><b>"+value+"</b></span>";
	}
	
	$(document).ready(function(){
		$("#resultDataGrid").datagrid({
			showFooter:"true",
			queryParams:{
				p1:"${term}"
				,p2:"${seq1}"
				,p3:"${seq2}"
				,p4:"${seq3}"
				,p5:"${cate}"
				,p6:$("#beltFilter").val()
				,p7:"${sLocale}"
				,group:$("#groupFilter").val()},
			onDblClickRow:function(rowIndex, rowData){
				if(rowData.DATA4==""||rowData.DATA0=="")
					return;
                var params=[];
                params.push("machineType="+rowData.DATA1);
                params.push("partNo="+rowData.DATA4);
                params.push("error="+rowData.DATA14);
                params.push("errornm="+encodeURIComponent(rowData.DATA3));
                params.push("rcustnm="+encodeURIComponent(rowData.DATA8));
                params.push("rcust="+rowData.DATA15);
                params.push("searchLocale="+"${sLocale}");
                params = params.join("&");
                var url = "issueSummaryDetailPop?"+params;			                  
                var popup = window.open(url,'','width=1150,height=760,resizable=yes,scrollbars=yes');
                popup.focus();
				
			}
		});	
	
	});
	
	</script>
</head>

<body>
	<table iconCls="icon-application-view-list" style="width:1100px;height:720px;"  
		title='<fmt:message key="menu.qualityIssueList"/><fmt:message key="ui.label.detailList"/>' toolbar="#divSearch"  id="resultDataGrid"  singleSelect="true" striped="false"   url="getIssueSummaryDetail" rowStyler ="rowStyle">
			<thead>
		       <tr>	            
	      			<th field="DATA0" width="60" sortable="false" align="center"><fmt:message key="ui.label.Car"/></th> 
	                <th field="DATA1" width="60" sortable="false" align="center"><fmt:message key="ui.label.Model"/></th> 
	                <th field="DATA2" width="110" sortable="false" align="center"><fmt:message key="ui.label.process"/></th> 
	                <th field="DATA3" width="110" sortable="false" align="center"><fmt:message key="ui.label.qualityIssueType"/></th> 
	                <th field="DATA4" width="130" sortable="false" align="center"><fmt:message key="ui.label.PartNo"/></th> 
	                <th field="DATA5" width="200" sortable="false" align="center"><fmt:message key="ui.label.PartName"/></th> 
	                <th field="DATA6" width="60" sortable="false" align="center"><fmt:message key="chartYName.issueCount"/></th> 
	                <th field="DATA7" width="60" sortable="false" align="center"><fmt:message key="chartYName.issueAmount"/></th> 
	                <th field="DATA8" width="110" sortable="false" align="center"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th> 
	                <th field="DATA9" width="60" sortable="false" align="center"><fmt:message key="ui.label.lossMoney"/></th> 
	                <th field="DATA10" width="80" sortable="false" align="center"><fmt:message key="ui.label.RegDate"/></th> 
	                <th field="DATA12" width="110" sortable="false" align="center" formatter="ncrPop"><fmt:message key="ui.label.ncrPublish"/></th> 
	                <th field="DATA13" width="60" sortable="false" align="center" hidden="true"><fmt:message key="ui.label.seq"/></th> 
	                <th field="DATA11" width="150" sortable="false" align="center"><fmt:message key="ui.label.remark"/></th>
	                <th field="DATA14" width="150" sortable="false" align="center"  hidden="true"></th>
	                <th field="DATA15" width="150" sortable="false" align="center"  hidden="true"></th>
  			  </tr> 
			</thead>
		</table>
		<div id="divSearch" style="padding:0px;height:auto">
		<table id="tableTerm">
			<tr>
				<th><fmt:message key="ui.label.Model"/></th>
				<td>
					<select id="beltFilter" style="width:100px;">
					<option value=""><fmt:message key="ui.element.All"/></option>
					<c:forEach items="${machineType}" var="item">
						<option value="${item.value}">${item.value}</option>
					</c:forEach>
					</select>
				</td>
				<th><fmt:message key="ui.label.group"/></th>
				<td>
					<select id="groupFilter" style="width:100px;">
						<option value = "DATA0"><fmt:message key="ui.label.Car"/></option>
						<option value = "DATA1"><fmt:message key="ui.label.Model"/></option>
						<option value = "DATA2"><fmt:message key="ui.label.process"/></option>
						<option value = "DATA3"><fmt:message key="ui.label.qualityIssueType"/></option>
					</select>
				</td>
				<td style="text-align:center; width:80;border:0px;" >
					<a href="#" onclick="javascript:searchProcess();" class="easyui-linkbutton"  iconCls="icon-search"  id="btInsert"><fmt:message key="ui.button.Search"/></a>					
				</td>
					<td style="text-align:center;border:0px;">										
					<c:choose>
						<c:when test="${term eq 'sday'}">
							<fmt:message key="ui.label.day"/>:${seq1}<fmt:message key="ui.label.year"/> ${seq2}<fmt:message key="ui.label.month"/> ${seq3}<fmt:message key="ui.label.day2"/>
						</c:when>
						<c:when test="${term eq 'sweek'}">
							<fmt:message key="ui.label.byWeek"/>:${seq1}<fmt:message key="ui.label.year"/> ${seq2}<fmt:message key="ui.label.week"/>
						</c:when>
						<c:when test="${term eq 'smonth'}">
							<fmt:message key="ui.label.byMonth"/>:${seq1}<fmt:message key="ui.label.year"/> ${seq2}<fmt:message key="ui.label.month"/>						
						</c:when>
						<c:when test="${term eq 'squarter'}">
							<fmt:message key="ui.label.quater"/>:${seq1}<fmt:message key="ui.label.year"/> ${seq2}<fmt:message key="ui.label.quater"/>						
						</c:when>
						<c:otherwise>
							<fmt:message key="ui.label.byYear"/>:${seq1}<fmt:message key="ui.label.year"/>						
						</c:otherwise>						
					</c:choose>
					</td>
			</tr>
		</table>
		 
		 </div>  		
</body>
</html>
