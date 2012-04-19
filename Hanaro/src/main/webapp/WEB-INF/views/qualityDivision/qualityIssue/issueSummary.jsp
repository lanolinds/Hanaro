<!-- 제작일 : 2012. 2. 16.-->
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
		#termTable th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left;white-space:nowrap;}
		#termTable td {border:0px;}
		#resultTable {border-collapse:collapse;margin:10px;}		
		#resultTable th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: center;white-space:nowrap; border:1px solid #d9d9d9;}
		#resultTable td {border:1px solid #d9d9d9;text-align: right;}
		
	</style>	
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/highcharts/highcharts.js" />' ></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js" />' ></script>
	<script type="text/javascript">
		function changeTeam(val){
			$(".termDisplay").css("display","none");
			$(".termDisplay[name='"+val+"']").css("display","inline");
		}
		
		function searchData(){
			
			var stdYear = "";
			var stdMonth = "";
			var stdDay = "";
			var endYear = "";
			var endMonth = "";
			var endDay = "";
			var searchType = "";			
			var searchLocale = "";
			if($("#searchLocale").val() || $("#searchLocale").val()=="")
				searchLocale =$("#searchLocale").val();
			else
				searchLocale = "${authLocale}";
			
			if(($("div[name='sday']").css("display"))=="inline"){
				if($("#dayStdDate").datebox("getValue")=="" || $("#dayEndDate").datebox("getValue")=="" ){
					$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.noInputSearchDate' />");
					return;
				}
				searchType = "sday";
				stdYear = $("#dayStdDate").datebox("getValue").substring(0,4);
				stdMonth = $("#dayStdDate").datebox("getValue").substring(5,7);
				stdDay = $("#dayStdDate").datebox("getValue").substring(8,10);				
				endYear = $("#dayEndDate").datebox("getValue").substring(0,4);
				endMonth = $("#dayEndDate").datebox("getValue").substring(5,7);
				endDay = $("#dayEndDate").datebox("getValue").substring(8,10);				
			}else if(($("div[name='sweek']").css("display"))=="inline"){
				if($("#weekStdDate").datebox("getValue")=="" || $("#weekEndDate").datebox("getValue")=="" ){
					$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.noInputSearchDate' />");
					return;
				}				
				searchType = "sweek";
				stdYear = $("#weekStdDate").datebox("getValue").substring(0,4);
				stdMonth = $("#weekStdText").val();
				endYear = $("#weekEndDate").datebox("getValue").substring(0,4);
				endMonth = $("#weekEndText").val();
			}else if(($("div[name='smonth']").css("display"))=="inline"){
				searchType = "smonth";
				stdYear = $("#monthStdYear").val();
				stdMonth = $("#monthStdMonth").val();
				endYear = $("#monthEndYear").val();
				endMonth = $("#monthEndMonth").val();								
			}else if(($("div[name='squarter']").css("display"))=="inline"){
				searchType = "squarter";
				stdYear = $("#quaterStdYear").val();
				stdMonth = $("#quaterStdMonth").val();
				endYear = $("#quaterEndYear").val();
				endMonth = $("#quaterEndMonth").val();
			}else{
				searchType = "syear";
				stdYear = $("#yearStdYear").val();				
				endYear = $("#yearEndYear").val();
			}			
			$.each($("input[name='tabTerm']"),function(i,cell){
				$("#tabx").tabs("close",cell.title);
				if(cell.checked)
					setTab(cell.value,cell.title,searchType,stdYear,stdMonth,stdDay,endYear,endMonth,endDay,searchLocale);
			});
		}
		
		function setTab(id,nameTag,searchType,stdYear,stdMonth,stdDay,endYear,endMonth,endDay,searchLocale){			
			$("#tabx").tabs("add",{
			    title:nameTag,
			    closable:true 
			});
			var category = [];			
			var issueAmount = [];
			var actualMoney = [];
			var actualPpm = [];
			var issueCount = [];
			var planPpm = [];
			var planMoney = [];
			var panel = $("#tabx").tabs("getTab",nameTag);
			$("body").css("cursor","wait");
			$.getJSON("getIssueSummaryData",{p1:id,p2:searchType,p3:stdYear,p4:stdMonth,p5:stdDay,p6:endYear,p7:endMonth,p8:endDay,p9:searchLocale},function(list){
				
			   var textTable1 = "<div style='overflow:auto;width:1100px;height:195px;'><table id='resultTable' cellspancing='0'><tr>";
			   var textTable2 = "<tr>";
			   var textTable3 = "<tr>";
			   var textTable4 = "<tr>";
			   var textTable5 = "<tr>";
			   var textTable6 = "<tr>";
			   var textTable7 = "<tr>";
			   textTable1+="<th colspan='2'>"+$("#searchType option:selected").text()+"</th>";
			   textTable2+="<th colspan='2'><fmt:message key='chartYName.issueCount'/></th>";
			   textTable3+="<th colspan='2'><fmt:message key='chartYName.issueAmount'/></th>";
			   textTable4+="<th rowspan='2'>PPM</th><th><fmt:message key='ui.label.plan'/></th>";
			   textTable5+="<th><fmt:message key='ui.label.actual'/></th>";
			   textTable6+="<th rowspan='2'><fmt:message key='ui.label.money'/></th><th><fmt:message key='ui.label.plan'/></th>";
			   textTable7+="<th><fmt:message key='ui.label.actual'/></th>";
			   var selectedPart = id;
			   
			   
			   
			   
				$.each(list,function(i,cell){
					textTable1+="<th>"+cell.DATA2+"</th>";
					textTable2+="<td>"+numeric(cell.DATA8)+"</td>";
					textTable3+="<td>"+numeric(cell.DATA4)+"</td>";
					textTable4+="<td>"+numeric(cell.DATA9)+"</td>";
					textTable5+="<td>"+numeric(cell.DATA7)+"</td>";
					textTable6+="<td>"+numeric(cell.DATA10)+"</td>";
					textTable7+="<td>"+numeric(cell.DATA5)+"</td>";
					category.push(cell.DATA2);
					issueAmount.push({y:Number(cell.DATA4),year:cell.DATA1});
					actualMoney.push({y:Number(cell.DATA5),year:cell.DATA1});
					actualPpm.push({y:Number(cell.DATA7),year:cell.DATA1});
					issueCount.push({y:Number(cell.DATA8),year:cell.DATA1});
					planPpm.push({y:Number(cell.DATA9),year:cell.DATA1});
					planMoney.push({y:Number(cell.DATA10),year:cell.DATA1});
				});
				
				 chart = new Highcharts.Chart({
				      chart: {
				         renderTo: $(panel)[0],
				         zoomType: 'xy',
				         margin: [80, 250, 60, 100],
				         width:1100,
				         height:370
				      },
				      title: {
				         text: ''
				      },
				      subtitle: {
				         text: nameTag+'현황'
				      },
				      xAxis: [{
				         categories: category
				         
				      }],
				      yAxis: [{ // Primary yAxis
				         labels: {
				            formatter: function() {
				               return this.value +'EA';
				            },
				            style: {
				               color: '#DDDF00'
				            }
				         },
				         title: {
				            text: '<fmt:message key="chartYName.issueAmount"/>',
				            style: {
				               color: '#DDDF00'
				            }
				         },
				         opposite: true
				         
				      }, { // Secondary yAxis
				         gridLineWidth: 0,
				         title: {
				            text: 'PPM',
				            style: {
				               color: '#058DC7'
				            }
				         },
				         labels: {
				            formatter: function() {
				               return this.value +' PPM';
				            },
				            style: {
				               color: '#058DC7'
				            }
				         }
				         
				      }, { // Tertiary yAxis
				         gridLineWidth: 0,
				         title: {
				            text: '<fmt:message key="chartYName.claimMoney"/>',
				            style: {
				               color: '#50B432'
				            }
				         },
				         labels: {
				            formatter: function() {
				               return this.value ;
				            },
				            style: {
				               color: '#50B432'
				            }
				         },opposite: true
				     
				      }, {
				         gridLineWidth: 0,
				         title: {
				            text: '<fmt:message key="chartYName.issueCount"/>',
				            style: {
				               color: '#ED561B'
				            }
				         },
				         labels: {
				            formatter: function() {
				               return this.value;
				            },
				            style: {
				               color: '#ED561B'
				            }
				         },
				         opposite: true
				      }],
				      tooltip: {
				         formatter: function() {
 				            var unit = {
 				               'PPM': 'ppm',
 				               '<fmt:message key="chartYName.issueAmount"/>': 'EA',
 				               '<fmt:message key="chartYName.issueCount"/>': '',
 				               '<fmt:message key="chartYName.claimMoney"/>': '',
 				               '<fmt:message key="chartYName.planPpm"/>' : 'ppm',
 				              '<fmt:message key="chartYName.planMoney"/>' : ''
 				            }[this.series.name];
				            
				            return ''+
				               this.x +': '+ this.y +' '+unit;
				         }
				      },
				      legend: {
				         layout: 'vertical',
				         align: 'left',
				         x: 120,
				         verticalAlign: 'top',
				         y: 80,
				         floating: true				         
				      },
				      series: [{
				         name: 'PPM',
				         color: '#058DC7',
				         type: 'column',
				         yAxis: 1,				         
				         data: actualPpm      
				      
				      }, {
				         name: '<fmt:message key="chartYName.claimMoney"/>',
				         type: 'column',
				         color: '#50B432',
				         yAxis: 2,
				         data: actualMoney
				      }, {
				         name: '<fmt:message key="chartYName.issueCount"/>',
				         color: '#ED561B',
				         type: 'column',
				         yAxis: 3,
				         yearTag:'2088',
				         data: issueCount
				      }, {
				         name: '<fmt:message key="chartYName.issueAmount"/>',
				         color: '#DDDF00',
				         type: 'column',
				         data: issueAmount
					  }, {
				         name: '<fmt:message key="chartYName.planPpm"/>',
				         color: '#FF0000',
				         type: 'line',
				         yAxis: 1,
				         data: planPpm
					  },{
				         name: '<fmt:message key="chartYName.planMoney"/>',
				         color: '#9932CC',
				         type: 'line',
				         yAxis: 2,
				         data: planMoney
					  }]
					  ,plotOptions:{
			                series:{cursor:"pointer",point:{events:{click:function(event){
			                  //조회항목 파악.			                  
			                  var selectedTabLabel = selectedPart;
			                  // 검색 구분 파악.
			                  var term = $("#searchType").val();
			                  var seg1=0;
			                  var seg2=0;
			                  var seg3=0;
			                  if(term=="sday"){
			                    var tmp = this.category.split("-");
			                    seg1 = tmp[0];
			                    seg2 = tmp[1];
			                    seg3 = tmp[2];
			                  }
			                  else if(term=="sweek"){			                	
			                    seg1 = this.year;
			      				seg2 = this.category;
			      				seg3 = 0;
			                  }
			                  else if(term=="smonth"){
			                	seg1 = this.year;
			      				seg2 = this.category;
			      				seg3 = 0;
			                  }
			                  else if(term=="squarter"){
			                	seg1 = this.year;
			      				seg2 = this.category;
			      				seg3 = 0;
			                  }
			                  else{
			                	seg1 = this.year;
			      				seg2 = 0;
			      				seg3 = 0;
			                  }
			                  var params=[];
			                  params.push("cate="+selectedTabLabel);
			                  params.push("term="+term);
			                  params.push("seg1="+seg1);
			                  params.push("seg2="+seg2);
			                  params.push("seg3="+seg3);
			                  params.push("sLocale="+searchLocale);
			                  params = params.join("&");
			                  var url = "issueSummaryDetail?"+params;			                  
			                  var popup = window.open(url,'','width=1150,height=760,resizable=yes,scrollbars=yes');
			                  popup.focus();
			                  }}}}
			           }
				      
				   });		
				 
					textTable1+="</tr>";
					textTable2+="</tr>";
					textTable3+="</tr>";
					textTable4+="</tr>";
					textTable5+="</tr>";
					textTable6+="</tr>";
					textTable7+="</tr></table></div>";
					$(panel).append(textTable1+textTable2+textTable3+textTable4+textTable5+textTable6+textTable7);
					$("body").css("cursor","default");
								
			});			
			
		  
		}
		
		$(document).ready(function(){
		    $('#weekStdDate').datebox({  
		        onSelect:function(){
		        	$.get("getDateToWeek",{date:$(this).datebox("getValue"),t:new Date().getTime()},function(result){
		        		$("#weekStdText").val($.trim(result));		        		
		        	});
		        }  
		    });
		    $('#weekEndDate').datebox({  
		        onSelect:function(){
		        	$.get("getDateToWeek",{date:$(this).datebox("getValue"),t:new Date().getTime()},function(result){
		        		$("#weekEndText").val($.trim(result));		        		
		        	});
		        }    
		    });  		    
		    
		});
	</script>
	

	
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">	
	<div class="easyui-panel"  title="<fmt:message key='menu.qualityIssueSummary' />" style="width:750px;height:145px;">			
    	<table id="termTable">	
    		<tr>
    			<th style="width:120px;"><span  class="label-Leader-black"><fmt:message key="ui.label.searchTeam"/></span></th>
				<td style="width:528px;" align="left">
					<c:if test="${authLocale eq 'KR' }">						
					<select id="searchLocale">					
					<option value="CN"><fmt:message key="country.china"/></option>
					<option value="CZ"><fmt:message key="country.czech"/></option>
					<option value="IN"><fmt:message key="country.india"/></option>
					</select>
					</c:if>
					<select id="searchType" onchange="javascript:changeTeam(this.value);">
						<option value="sday"><fmt:message key="ui.label.day"/></option>
						<option value="sweek"><fmt:message key="ui.label.byWeek"/></option>
						<option value="smonth"><fmt:message key="ui.label.byMonth"/></option>
						<option value="squarter"><fmt:message key="ui.label.quater"/></option>
						<option value="syear"><fmt:message key="ui.label.byYear"/></option>
					</select>					
					<div class="termDisplay" style="display:none;" name ="sweek">					
						<input class="easyui-datebox" id="weekStdDate"  editable = "false"/>
						<input type="text" id="weekStdText" size="3" readonly />
						<fmt:message key="ui.label.week"/>
						<span style="margin: 0em .3em;">~</span>					
						<input class="easyui-datebox" id="weekEndDate"  editable = "false"/>
						<input type="text" id="weekEndText" size="3" readonly/>
						<fmt:message key="ui.label.week"/>
					</div>
					<div class="termDisplay" style="display:none;" name ="squarter">
						<select id="quaterStdYear">
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
						<select id="quaterStdMonth">
							<c:forEach begin="1" end="4" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.quater"/>
						<span style="margin: 0em .3em;">~</span>
						<select id="quaterEndYear">
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
						<select id="quaterEndMonth">
							<c:forEach begin="1" end="4" step="1" varStatus="item">
								<option value="${item.count}">${item.count}</option>
							</c:forEach>
						</select>		
						<fmt:message key="ui.label.quater"/>
					</div>			

					<div class="termDisplay" style="display:none;" name ="smonth">
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
					
					
					<div class="termDisplay" style="display:none;" name ="syear">
						<select id="yearStdYear">
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
						<fmt:message key="ui.label.year"/>
						<span style="margin: 0em .3em;">~</span>
						<select id="yearEndYear">
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
						<fmt:message key="ui.label.year"/>
					</div>				
					
					<div class="termDisplay" style="display:inline;" name ="sday">					
						<input class="easyui-datebox" id="dayStdDate" editable = "false"/>
						<span style="margin: 0em .3em;">~</span>					
						<input class="easyui-datebox" id="dayEndDate" editable = "false"/>
					</div>									
				</td>			
				<td style="width:80px;">
					<a href="#" onclick="javascript:searchData();" class="easyui-linkbutton"  iconCls="icon-search"  id="btInsert"><fmt:message key="ui.button.Search"/></a>
				</td>			
    		</tr>    	
    		<tr>
    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.searchTerm"/></span></th>
    			<td colspan="2">
    				<fieldset>
    					<legend><fmt:message key="ui.label.custQuality"/></legend>
    					<input type="checkbox" value="aa" name="tabTerm" title="<fmt:message key="ui.label.issueAA"/>">
    					<fmt:message key="ui.label.issueAA"/>
    					<input type="checkbox" value="ab" name="tabTerm" title="<fmt:message key="ui.label.issueAB"/>">
    					<fmt:message key="ui.label.issueAB"/>
    					<input type="checkbox" value="ac" name="tabTerm" title="<fmt:message key="ui.label.issueAC"/>">
    					<fmt:message key="ui.label.issueAC"/>
    					<input type="checkbox" value="ad" name="tabTerm" title="<fmt:message key="ui.label.issueAD"/>">
    					<fmt:message key="ui.label.issueAD"/>    					    					 
    				</fieldset>
    				<fieldset>
    					<legend><fmt:message key="ui.label.insideQuality"/></legend>
    					<input type="checkbox" value="ca" name="tabTerm" title="<fmt:message key="ui.label.issueCA"/>">
    					<fmt:message key="ui.label.issueCA"/>
    					<input type="checkbox" value="cb" name="tabTerm" title="<fmt:message key="ui.label.issueCB"/>">
    					<fmt:message key="ui.label.issueCB"/>
    					<input type="checkbox" value="cc" name="tabTerm" title="<fmt:message key="ui.label.issueCC"/>">
    					<fmt:message key="ui.label.issueCC"/>
    					<input type="checkbox" value="cd" name="tabTerm" title="<fmt:message key="ui.label.issueCD"/>">
    					<fmt:message key="ui.label.issueCD"/>    					
    				</fieldset>
    			</td>
    		</tr>	   		    		  		    		    		    			    			      		    		    		    		    		
    	</table>			
	</div>
	<hr>
	<div id="tabx" class="easyui-tabs" style="height:600px;"></div>   	
</div>
</body>

</html>
