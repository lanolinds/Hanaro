<!-- 제작일 : 2011. 11. 17.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.qualityNcrStatus" /></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		.padding10{padding:5px 10px;background-color:#EFEFEF;width:100%;}		
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/highcharts/highcharts.js" />' ></script>
	<script type="text/javascript">
	var checkedSearch=false;
	var selectedTab ="";
	
	//선택된 조회Type에 따라서 검색조건DIV을 변경한다.
	function changeSearchTab(object){
		alert(object.value);
	}
	
	
	function chartView(id,datas,title){
		 $("#"+id).empty();
		 chart = new Highcharts.Chart({
		 chart: {
		         renderTo: id,
		         defaultSeriesType: 'line',
		         marginRight: 130,
		         marginLeft: 40,
		         marginBottom: 70
		      },
		      title: {
		         text: title+' <fmt:message key="menu.qualityNcrStatus" />',
		         x: -20, 
		         style:{
		        	 fontSize: '10px'
		         }		         
		      },
		      subtitle: {
		         text: null,
		         x: -20
		      },
		      xAxis: {
		         categories: [
		                      '<span><fmt:message key="ui.label.ncrStatus1" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus2" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus3" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus4" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus5" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus6" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus7" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus8" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus9" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus10" /></span>',
		                      '<span><fmt:message key="ui.label.ncrStatus11" /></span>'
		                      ],
		         labels: {
		        	 rotation:-30,align:'right',style:{fontSize:'8'}
  		         }		 		                      
		      },
		      yAxis: {
		         title: {
		            text: null
		         }
		      },
		      tooltip: {
		         formatter: function() {
		                   return '<b>'+ this.series.name +'</b><br/>'+
		               this.x +': '+ this.y +'<fmt:message key="ui.label.ea" />';
		         }
		      },
		      legend: {
		         layout: 'vertical',
		         align: 'left',
		         verticalAlign: 'top',
		         x: 950,
		         y: 10,
		         borderWidth: 0
		      },
		      series:datas
		   });
		   		
	}	
	
	//내용을 조회한다.
	function searchList(){
		checkedSearch=true;
		var queryParam = {};
		queryParam.searchType = $("input[name='selectTerm']:checked").val();		
		var year1 =""; 
		var date1 =""; 
		var year2 =""; 
		var date2 ="";
		
		if($("input[name='selectTerm']:checked").val()=="M"){
			year1 = $("select[name='year1']").val();
			date1 = $("select[name='date1']").val();
		    year2 = $("select[name='year2']").val();
		    date2 =$ ("select[name='date2']").val();
		}else{
			year1 = $("input[name='year1']").val();
			date1 = $("input[name='date1']").val();
		    year2 = $("input[name='year2']").val();
		    date2 =$ ("input[name='date2']").val();			
		}
		
		if($("input[name='selectPoint']:checked").val()=="REG"){
			queryParam.regStdYear = year1;
			queryParam.regStdDate = date1;
			queryParam.regEndYear = year2;
			queryParam.regEndDate = date2;				
		}else{
			queryParam.ncrStdYear = year1;
			queryParam.ncrStdDate = date1;
			queryParam.ncrEndYear = year2;
			queryParam.ncrEndDate =	date2;
		}
		
		if(selectedTab=="ALL"){
			queryParam.searchTab = "ALL";
			$("#tableAll").datagrid("load",queryParam);
			$.getJSON("getNcrStatus",queryParam,function(list){
				var data =[];
				$.each(list.rows,function(i,cell){
					var ob ={};
					var datas =[];
					ob.name = cell.DATA0;
					for(var x=1;x<12;x++)
						datas.push(Number(cell["DATA"+x]));
					ob.data = datas;
					data.push(ob);
				});
				chartView("chartAll",data,'<fmt:message key="ui.element.All" />');
			});		
		}
		if(selectedTab=="SITE"){
			queryParam.searchTab = "SITE";
			$("#tableSite").datagrid("load",queryParam);
			$.getJSON("getNcrStatus",queryParam,function(list){
				var data =[];
				$.each(list.rows,function(i,cell){
					var ob ={};
					var datas =[];
					ob.name = cell.DATA1;
					for(var x=2;x<13;x++)
						datas.push(Number(cell["DATA"+x]));
					ob.data = datas;
					data.push(ob);
				});
				chartView("chartSite",data,'<fmt:message key="ui.label.ncrByOccurSite" />');
			});		
		}
		if(selectedTab=="REASON"){
			queryParam.searchTab = "REASON";
			$("#tableReason").datagrid("load",queryParam);
			$.getJSON("getNcrStatus",queryParam,function(list){
				var data =[];
				$.each(list.rows,function(i,cell){
					var ob ={};
					var datas =[];
					ob.name = cell.DATA0;
					for(var x=1;x<12;x++)
						datas.push(Number(cell["DATA"+x]));
					ob.data = datas;
					data.push(ob);
				});
				chartView("chartReason",data,'<fmt:message key="ui.label.ncrByReason" />');
			});		
		}
		if(selectedTab=="DEFECT"){
			queryParam.searchTab = "DEFECT";
			$("#tableDefect").datagrid("load",queryParam);
			$.getJSON("getNcrStatus",queryParam,function(list){
				var data =[];
				$.each(list.rows,function(i,cell){
					var ob ={};
					var datas =[];
					ob.name = cell.DATA0;
					for(var x=1;x<12;x++)
						datas.push(Number(cell["DATA"+x]));
					ob.data = datas;
					data.push(ob);
				});
				chartView("chartDefect",data,'<fmt:message key="ui.label.ncrByDefect" />');
			});		
		}

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
 							$.get("getWeekOfYear",{year:year,month:mon,day:day},function(result){
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
 							$.get("getWeekOfYear",{year:year,month:mon,day:day},function(result){
 								$("input[name='date2']").val(result);
 							});
						}
					}
				}
		);
		$("#tt").tabs({
		    onSelect:function(title){  
		    	switch(title){
		    	case "<fmt:message key='ui.element.All' />" : selectedTab ="ALL"; break;
		    	case "<fmt:message key='ui.label.ncrByOccurSite' />" : selectedTab ="SITE"; break; 
		    	case "<fmt:message key='ui.label.ncrByReason' />" : selectedTab ="REASON"; break;
		    	case "<fmt:message key='ui.label.ncrByDefect'  />" :  selectedTab ="DEFECT"; break;
		    	default :  selectedTab =""; break;
		    	}
		    	if(checkedSearch)
		    		searchList();
		    	
		
		    }  
		});  

	});
	
	</script>
</head>

<body class="easyui-layout" style="min-width: 1174px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
	<div iconCls="icon-chart-pie" class="easyui-panel" style="width:1150px;" title='<fmt:message key="menu.qualityNcrStatus" />'>
		<div class="padding10">
			<fmt:message key="ui.label.searchDateType" /> : 
			<input type="radio" name="selectTerm" value="M"  onclick="javascript:$('#monthSearch').css('display','inline');$('#weekSearch').css('display','none');" checked><fmt:message key='ui.label.byMonth' />
			<input type="radio" name="selectTerm" value="W" onclick="javascript:$('#monthSearch').css('display','none');$('#weekSearch').css('display','inline');"><fmt:message key='ui.label.byWeek' />
			<span style="width:100px;"></span>
			<fmt:message key="ui.label.searchDatePoint" /> : 
			<input type="radio" name="selectPoint" value="REG"   checked><span style="color:blue;"><fmt:message key='ui.label.ncrByRegDate' /></span>
			<input type="radio" name="selectPoint" value="ACT" ><span style="color:red;"><fmt:message key='ui.label.ncrByNcrDate' /></span>			
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
			<input type="text" id="datebox1">
			<input type="text" name="year1" readonly="true" size="4">
			<input type="text"  name="date1" readonly="true" size="2">
			<span style="margin: 0em .3em;">~</span>
			<input type="text" id="datebox2">
			<input type="text"  name="year2" readonly="true" size="4">
			<input type="text"  name="date2" readonly="true" size="2">
			<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>
		</div>				
	    <div id="tt"  style="width:1147px;">  
	        <div title="<fmt:message key='ui.element.All' />" style="padding:10px;">  
	        	<div id="chartAll" style="width:1075px;height:430px;"></div>
	            <table class="easyui-datagrid"  id="tableAll" style="width:1075px;height:300px;"    singleSelect="true" striped="true" url="getNcrStatus">
	            	<thead>
		            	<tr>
		            		<th field="DATA0" width="60" align="center" rowspan="2" ><fmt:message key="ui.label.ncrStatusDate" /></th>
		            		<th align="center" colspan="7"><fmt:message key="ui.label.ncrMeasureStatus" /></th>
		            		<th align="center" colspan="4"><fmt:message key="ui.label.ncrEvaluationStatus" /></th>
		            	</tr>
		            	<tr>
		            		<th field="DATA1"  width="100"  align="center"><fmt:message key="ui.label.ncrStatus1" /></th>
		            		<th field="DATA2" width="90"  align="center"><fmt:message key="ui.label.ncrStatus2" /></th>
		            		<th field="DATA3" width="90" align="center"><fmt:message key="ui.label.ncrStatus3" /></th>
		            		<th field="DATA4" width="100" align="center"><fmt:message key="ui.label.ncrStatus4" /></th>
		            		<th field="DATA5" width="110"  align="center"><fmt:message key="ui.label.ncrStatus5" /></th>
		            		<th field="DATA6" width="80" align="center"><fmt:message key="ui.label.ncrStatus6" /></th>
		            		<th field="DATA7" width="90"  align="center"><fmt:message key="ui.label.ncrStatus7" /></th>
		            		<th field="DATA8" width="80" align="center"><fmt:message key="ui.label.ncrStatus8" /></th>
		            		<th field="DATA9" width="80" align="center"><fmt:message key="ui.label.ncrStatus9" /></th>
		            		<th field="DATA10" width="80" align="center"><fmt:message key="ui.label.ncrStatus10" /></th>
		            		<th field="DATA10" width="80" align="center"><fmt:message key="ui.label.ncrStatus11" /></th>
		            	</tr>	            		
	            	</thead>
	            </table>
	        </div>  
	        <div title="<fmt:message key='ui.label.ncrByOccurSite' />"  style="padding:10px;">
	        	<div id="chartSite" style="width:1075px;height:430px;"></div>
	            <table class="easyui-datagrid"  id="tableSite" style="width:1095px;height:300px;"    singleSelect="true" striped="true" url="getNcrStatus">
	            	<thead>
		            	<tr>
		            		<th field="DATA1" width="80" align="center" rowspan="2" ><fmt:message key="ui.label.QualityIssue.OccurSite" /></th>
		            		<th align="center" colspan="7"><fmt:message key="ui.label.ncrMeasureStatus" /></th>
		            		<th align="center" colspan="4"><fmt:message key="ui.label.ncrEvaluationStatus" /></th>
		            	</tr>
		            	<tr>
		            		<th field="DATA2"  width="100"  align="center"><fmt:message key="ui.label.ncrStatus1" /></th>
		            		<th field="DATA3" width="90"  align="center"><fmt:message key="ui.label.ncrStatus2" /></th>
		            		<th field="DATA4" width="90" align="center"><fmt:message key="ui.label.ncrStatus3" /></th>
		            		<th field="DATA5" width="100" align="center"><fmt:message key="ui.label.ncrStatus4" /></th>
		            		<th field="DATA6" width="110"  align="center"><fmt:message key="ui.label.ncrStatus5" /></th>
		            		<th field="DATA7" width="80" align="center"><fmt:message key="ui.label.ncrStatus6" /></th>
		            		<th field="DATA8" width="90"  align="center"><fmt:message key="ui.label.ncrStatus7" /></th>
		            		<th field="DATA9" width="80" align="center"><fmt:message key="ui.label.ncrStatus8" /></th>
		            		<th field="DATA10" width="80" align="center"><fmt:message key="ui.label.ncrStatus9" /></th>
		            		<th field="DATA11" width="80" align="center"><fmt:message key="ui.label.ncrStatus10" /></th>
		            		<th field="DATA12" width="80" align="center"><fmt:message key="ui.label.ncrStatus11" /></th>
		            	</tr>	            		
	            	</thead>
	            </table>  
	        </div>  
	        <div title="<fmt:message key='ui.label.ncrByReason' />"  style="padding:10px;">
	        	<div id="chartReason" style="width:1075px;height:430px;"></div>    
	            <table class="easyui-datagrid"  id="tableReason" style="width:1125px;height:300px;"    singleSelect="true" striped="true" url="getNcrStatus">
	            	<thead>
		            	<tr>
		            		<th field="DATA0" width="100" align="center" rowspan="2" ><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>
		            		<th align="center" colspan="7"><fmt:message key="ui.label.ncrMeasureStatus" /></th>
		            		<th align="center" colspan="4"><fmt:message key="ui.label.ncrEvaluationStatus" /></th>
		            	</tr>
		            	<tr>
		            		<th field="DATA1"  width="100"  align="center"><fmt:message key="ui.label.ncrStatus1" /></th>
		            		<th field="DATA2" width="90"  align="center"><fmt:message key="ui.label.ncrStatus2" /></th>
		            		<th field="DATA3" width="90" align="center"><fmt:message key="ui.label.ncrStatus3" /></th>
		            		<th field="DATA4" width="100" align="center"><fmt:message key="ui.label.ncrStatus4" /></th>
		            		<th field="DATA5" width="110"  align="center"><fmt:message key="ui.label.ncrStatus5" /></th>
		            		<th field="DATA6" width="80" align="center"><fmt:message key="ui.label.ncrStatus6" /></th>
		            		<th field="DATA7" width="90"  align="center"><fmt:message key="ui.label.ncrStatus7" /></th>
		            		<th field="DATA8" width="80" align="center"><fmt:message key="ui.label.ncrStatus8" /></th>
		            		<th field="DATA9" width="80" align="center"><fmt:message key="ui.label.ncrStatus9" /></th>
		            		<th field="DATA10" width="80" align="center"><fmt:message key="ui.label.ncrStatus10" /></th>
		            		<th field="DATA11" width="80" align="center"><fmt:message key="ui.label.ncrStatus11" /></th>
		            	</tr>	            		
	            	</thead>
	            </table> 
	        </div>
	        <div title="<fmt:message key='ui.label.ncrByDefect' />"  style="padding:10px;">
	        	<div id="chartDefect" style="width:1075px;height:430px;"></div>  
	            <table class="easyui-datagrid"  id="tableDefect" style="width:1125px;height:300px;"    singleSelect="true" striped="true" url="getNcrStatus">
	            	<thead>
		            	<tr>
		            		<th field="DATA0" width="100" align="center" rowspan="2" ><fmt:message key="ui.label.QualityIssue.Defect" /></th>
		            		<th align="center" colspan="7"><fmt:message key="ui.label.ncrMeasureStatus" /></th>
		            		<th align="center" colspan="4"><fmt:message key="ui.label.ncrEvaluationStatus" /></th>
		            	</tr>
		            	<tr>
		            		<th field="DATA1"  width="100"  align="center"><fmt:message key="ui.label.ncrStatus1" /></th>
		            		<th field="DATA2" width="90"  align="center"><fmt:message key="ui.label.ncrStatus2" /></th>
		            		<th field="DATA3" width="90" align="center"><fmt:message key="ui.label.ncrStatus3" /></th>
		            		<th field="DATA4" width="100" align="center"><fmt:message key="ui.label.ncrStatus4" /></th>
		            		<th field="DATA5" width="110"  align="center"><fmt:message key="ui.label.ncrStatus5" /></th>
		            		<th field="DATA6" width="80" align="center"><fmt:message key="ui.label.ncrStatus6" /></th>
		            		<th field="DATA7" width="90"  align="center"><fmt:message key="ui.label.ncrStatus7" /></th>
		            		<th field="DATA8" width="80" align="center"><fmt:message key="ui.label.ncrStatus8" /></th>
		            		<th field="DATA9" width="80" align="center"><fmt:message key="ui.label.ncrStatus9" /></th>
		            		<th field="DATA10" width="80" align="center"><fmt:message key="ui.label.ncrStatus10" /></th>
		            		<th field="DATA11" width="80" align="center"><fmt:message key="ui.label.ncrStatus11" /></th>
		            	</tr>	            		
	            	</thead>
	            </table> 
	        </div>	          
	    </div>  
	</div> 
</div>
</body>

</html>
