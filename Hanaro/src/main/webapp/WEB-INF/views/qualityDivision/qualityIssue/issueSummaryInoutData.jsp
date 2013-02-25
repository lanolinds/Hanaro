<!-- 제작일 : 2013. 2. 22.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head> 
	<title><fmt:message key="menu.qualityIssueSummary"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		#termTable  th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left;white-space:nowrap;}
		#termTable  td {border:0px;}
		.hCap  {border:1px solid #E5E5E5;background-color: #FAFAFA;height:22px; font-weight:normal; text-align: center; white-space:nowrap;}
		.dCap  {border:1px dotted silver;}
		.dCap input{border:0px;width:45px;text-align:right;}	
		
		
	</style>	
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>	
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	<script type="text/javascript">
	
	function searchData(){
		var stdYear = $("#monthStdYear").val();
		var stdMonth = $("#monthStdMonth").val();
		var tr1 = "<tr><th class='hCap' colspan='2'><fmt:message key='ui.label.cagegory'/></th>";
		var tr2 = "<tr><th class='hCap' rowspan='2'><fmt:message key='ui.label.material'/></th><th class='hCap'><fmt:message key='ui.label.income'/></th>";
		var tr3 = "<tr><th class='hCap'><fmt:message key='ui.label.outgo'/></th>";
		var tr4 = "<tr><th class='hCap' rowspan='2'><fmt:message key='ui.label.product'/></th><th class='hCap'><fmt:message key='ui.label.income'/></th>";
		var tr5 = "<tr><th class='hCap'><fmt:message key='ui.label.outgo'/></th>";
		
		$.getJSON("getIssueSummaryInoutData",{p1:stdYear,p2:stdMonth,t:new Date().getTime()},function(list){			
			$.each(list,function(i,cell){
				tr1+="<th class='hCap' align='center'>"+cell.dayView+"<fmt:message key='ui.label.day2'/><input type='hidden' value='"+cell.stdDt+"'/></th>";
				tr2+="<th class='dCap'><input type='text' value='"+cell.mIncome+"'/></th>";
				tr3+="<th class='dCap'><input type='text' value='"+cell.mOutgo+"'/></th>";
				tr4+="<th class='dCap'><input type='text' value='"+cell.pIncome+"'/></th>";
				tr5+="<th class='dCap'><input type='text' value='"+cell.pOutgo+"'/></th>";
			});
			tr1+="</tr>";
			tr2+="</tr>";
			tr3+="</tr>";
			tr4+="</tr>";
			tr5+="</tr>";
			$("#resultTable ").empty().append(tr1+tr2+tr3+tr4+tr5);
		});
		
	}
	
	function saveData(){
		
		var $table =	$("#resultTable");
		var thLength = $("th",$("#resultTable tr:eq(0)")).length-1;
		var p1 = [];
		var p2 = [];
		var p3 = [];
		var p4 = [];
		var p5 = [];
		
		for(var i=0;i<thLength;i++){
			p1.push($("th:eq("+(1+i)+") input",$("#resultTable tr:eq(0)")).val());
			p2.push($("th:eq("+(2+i)+") input",$("#resultTable tr:eq(1)")).val());
			p3.push($("th:eq("+(1+i)+") input",$("#resultTable tr:eq(2)")).val());
			p4.push($("th:eq("+(2+i)+") input",$("#resultTable tr:eq(3)")).val());
			p5.push($("th:eq("+(1+i)+") input",$("#resultTable tr:eq(4)")).val());
		}
		
		$.post("procIssueSummaryInoutData",{p1:p1,p2:p2,p3:p3,p4:p4,p5:p5,t:new Date().getTime()},function(result){
			if($.trim(result)=="OK"){
				alert("Complete");
			}else{
				alert("Error!");
			}
		});	
	}
	
		$(document).ready(function(){
			searchData();
		});
	</script>
	

	
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">	
	<div class="easyui-panel"  title="<fmt:message key='ui.label.qualityInoutData' />" style="width:1680px;height:225px;">			
    	<table id="termTable">
    		<tr>
    			<th style="width:120px;"><span  class="label-Leader-black"><fmt:message key="ui.label.searchTeam"/></span></th>
				<th style="width:120px;" align="left">
					
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
				</th>			 
				<td style="width:85px;" >				
					<a href="#" onclick="javascript:searchData();" class="easyui-linkbutton"  iconCls="icon-search"  id="btSearch"><fmt:message key="ui.button.Search"/></a>
				</td>
				<td style="width:85px;">
					<a href="#" onclick="javascript:saveData();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btSave"><fmt:message key="ui.button.Save"/></a>
				</td>			
    		</tr>		    			    			      		    		    		    		    		
    	</table>
    	<br><br>
    	
    	<table id="resultTable">
    	</table>
	</div>
</div>
</body>

</html>
