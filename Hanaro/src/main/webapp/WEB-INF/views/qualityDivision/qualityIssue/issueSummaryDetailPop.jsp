<!-- 제작일 : 2012. 2. 21.-->
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
		#tableTerm th{text-align:left;}			 
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>	
	<script type="text/javascript">
	
	function searchProcess(){

		var pp2 = "";
		var pp3 = "";
		var pp4 = "";
		var pp5 = "";		
		var pp6 = "";
		var pp7 = "";
		var pp8 = "";
		var pp9 = "";
		if($("#cmtype")[0].checked)
			pp6 = $("#cmtype").val();
		if($("#cerror")[0].checked)
			pp7 = $("#cerror").val();
		if($("#cpartNo")[0].checked)
			pp8 = $("#cpartNo").val();
		if($("#crcust")[0].checked)
			pp9 = $("#crcust").val();
		if($("#cdateType").val()=="smonth"){
			pp2 = $("#monthStdYear").val();
			pp3 = $("#monthStdMonth").val();
			pp4 = $("#monthEndYear").val();
			pp5 = $("#monthEndMonth").val();				
		}else{
			pp2 = $("#weekStdYear").val();
			pp3 = $("#weekStdMonth").val();
			pp4 = $("#weekEndYear").val();
			pp5 = $("#weekEndMonth").val();			
		}
		
		
		$("#resultDataGrid").datagrid({
			queryParams:{
				p1:$("#cdateType").val()
				,p2: pp2
				,p3: pp3
				,p4: pp4
				,p5: pp5				
				,p6: pp6
				,p7: pp7
				,p8: pp8
				,p9: pp9
				,p10:"${searchLocale}"
			}
		});		
	}
	
	function popDetail(value){
        var win = window.open("ncrManageDetail?ncrNo="+value,"NCRDetail", "width=1145,height=797,location=no,menubar=no,resizable=no,scrollbars=yes,status=no,toolbar=no");
        win.focus();
	}	
	
	function ncrPop(value,rowData){
		if(value)
			return"<span class='fileDown' onclick='javascript:popDetail("+value+")'><b>"+value+"</b></span>";
	}
	function changeTeam(val){
		$(".termDisplay").css("display","none");
		$(".termDisplay[name='"+val+"']").css("display","inline");
	}	
	
	$(document).ready(function(){
		$("#resultDataGrid").datagrid({			 
			queryParams:{
				p1:$("#cdateType").val()
				,p2: $("#monthStdYear").val()
				,p3: $("#monthStdMonth").val()
				,p4: $("#monthEndYear").val()
				,p5: $("#monthEndMonth").val()				
				,p6: $("#cmtype").val()
				,p7: $("#cerror").val()
				,p8: $("#cpartNo").val()
				,p9: $("#crcust").val()
				,p10:"${searchLocale}"
			}
		});	
	
	});
	
	</script>
</head>

<body>
	<table iconCls="icon-application-view-list" style="width:1100px;height:720px;"  
		title='<fmt:message key="menu.qualityIssueList"/><fmt:message key="ui.label.detailList"/>' toolbar="#divSearch"  id="resultDataGrid"  singleSelect="true" striped="false"   url="getIssueSummaryDetailPop">
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
				<th><span  class="label-Leader-black"><fmt:message key="ui.label.Model"/></span></th>
				<td>
					<input type="checkbox" id="cmtype" value="${mType}" checked> 
					<span  style="color:blue;">${mType}</span>
				</td>
				<th><span  class="label-Leader-black"><fmt:message key="ui.label.qualityIssueType"/></span></th>
				<td colspan="2">
					<input type="checkbox" id="cerror" value="${error}" checked>
					<span  style="color:blue;">${errornm}</span>
				</td>
			</tr>
			<tr>
				<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartNo"/></span></th>
				<td>
					<input type="checkbox" id="cpartNo" value="${partNo}" checked>
					<span  style="color:blue;">${partNo}</span>
				</td>
				<th><span  class="label-Leader-black"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></span></th>
				<td colspan="2">
					<input type="checkbox" id="crcust" value="${rcust}" checked>
					<span  style="color:blue;">${rcustnm}</span>
				</td>
			</tr>	
			<tr>
				<th><span  class="label-Leader-black"><fmt:message key="ui.label.ncrStatusDate"/></span></th>
				<td colspan="3">
					<select id="cdateType" onchange="javascript:changeTeam(this.value);">
						<option value="smonth"><fmt:message key="ui.label.byMonth"/></option>
						<option value="sweek"><fmt:message key="ui.label.byWeek"/></option>
					</select>				
					<div class="termDisplay" style="display:inline;" name ="smonth">
						<select id="monthStdYear">
							<c:forEach begin="0" end="10" step="1" varStatus="item" >
							<c:choose>
							<c:when test="${today.getYear()==today.getYear()-(item.count-5)}">							
								<option value="${today.getYear()-(item.count-5)}" selected>${today.getYear()-(item.count-5)}</option>
							</c:when>	
							<c:otherwise>
								<option value="${today.getYear()-(item.count-5)}">${today.getYear()-(item.count-5)}</option>
							</c:otherwise>
							</c:choose>
							</c:forEach>
						</select>		
						<select id="monthStdMonth">
							<c:forEach begin="1" end="12" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.month"/>
						<span style="margin: 0em .3em;">~</span>
						<select id="monthEndYear">
							<c:forEach begin="0" end="10" step="1" varStatus="item" >
							<c:choose>
							<c:when test="${today.getYear()==today.getYear()-(item.count-5)}">							
								<option value="${today.getYear()-(item.count-5)}" selected>${today.getYear()-(item.count-5)}</option>
							</c:when>	
							<c:otherwise>
								<option value="${today.getYear()-(item.count-5)}">${today.getYear()-(item.count-5)}</option>
							</c:otherwise>
							</c:choose>
							</c:forEach>
						</select>		
						<select id="monthEndMonth">
							<c:forEach begin="1" end="12" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.month"/>
					</div>	
					
					<div class="termDisplay" style="display:none;" name ="sweek">
						<select id="weekStdYear">
							<c:forEach begin="0" end="10" step="1" varStatus="item" >
							<c:choose>
							<c:when test="${today.getYear()==today.getYear()-(item.count-5)}">							
								<option value="${today.getYear()-(item.count-5)}" selected>${today.getYear()-(item.count-5)}</option>
							</c:when>	
							<c:otherwise>
								<option value="${today.getYear()-(item.count-5)}">${today.getYear()-(item.count-5)}</option>
							</c:otherwise>
							</c:choose>
							</c:forEach>
						</select>		
						<select id="weekStdMonth">
							<c:forEach begin="1" end="54" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.week"/>
						<span style="margin: 0em .3em;">~</span>
						<select id="weekEndYear">
							<c:forEach begin="0" end="10" step="1" varStatus="item" >
							<c:choose>
							<c:when test="${today.getYear()==today.getYear()-(item.count-5)}">							
								<option value="${today.getYear()-(item.count-5)}" selected>${today.getYear()-(item.count-5)}</option>
							</c:when>	
							<c:otherwise>
								<option value="${today.getYear()-(item.count-5)}">${today.getYear()-(item.count-5)}</option>
							</c:otherwise>
							</c:choose>
							</c:forEach>
						</select>		
						<select id="weekEndMonth">
							<c:forEach begin="1" end="54" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.week"/>
					</div>						
				</td>
				<td>
					<a href="#" onclick="javascript:searchProcess();" class="easyui-linkbutton"  iconCls="icon-search"  id="btInsert"><fmt:message key="ui.button.Search"/></a>
				</td>
			</tr>
		</table>
		 
		 </div>  		
</body>
</html>
