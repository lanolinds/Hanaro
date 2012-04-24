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
			.table {border-collapse: collapse;}
			.table th{border:1px solid #969696;background-color:#EFEFEF;}
			.table td{border:1px solid #969696;text-align:center;}
			.cnStyle{background-color:#FDF7F6;}			
			.inStyle{background-color:#F6FCFD;}
			.czStyle{background-color:#FDF6FC;}
			.hover1{background-color: #FFFFFF;cursor:pointer;}
			.hover11{background-color: #FFFFFF;}
			.hover2{background-color: #FFFFFF;cursor:pointer;}
			.hover3{background-color: #FFFFFF;cursor:pointer;}
			.hover4{background-color: #FFFFFF;cursor:pointer;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/res	ources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/highcharts/highcharts.js" />' ></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/common-utils.js"/>'></script>
	<script type="text/javascript">
	var selectedTab = "";
	var countryCN = '<fmt:message key="country.china"/>';
	var countryIN = '<fmt:message key="country.india"/>';
	var countryCZ = '<fmt:message key="country.czech"/>';
	
	var checkLocale = "";
	
	
	function popDialog(selLocale,dateType,y1,d1,y2,d2,q1,q2,q3,q4){
		var params = {};
		params.selLocale = selLocale;
		params.dateType = dateType;
		params.stdYy = y1;
		params.stdDt = d1;
		params.endYy = y2;
		params.endDt = d2;
		params.q1 = q1;
		params.q2 = q2;
		params.q3 = q3;
		params.q4 = q4;
		$("#dialogTotalList").datagrid("load",params);
		$("#dialogTotalListPanel").dialog({modal:true});
	}

	
	function searchList(selectedTab){
		var tableCN = "";
		var tableIN = "";
		var tableCZ = "";

		var year1 =""; 
		var date1 =""; 
		var year2 =""; 
		var date2 ="";
		var dateType = $("input[name='selectTerm']:checked").val();
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
		
		var locale = ("${cLocale}"=="KR")?$("#searchLocale").val():"${cLocale}";
		changeLocaleDiv(locale);
		if(selectedTab=='<fmt:message key="ui.element.All"/>'){
			var chartMoneyCN = [];
			var chartCountCN = [];
			var chartMoneyIN = [];
			var chartCountIN = []; 
			var chartMoneyCZ = [];
			var chartCountCZ = [];			
			chartMoneyCN = [0,0,0];
			chartCountCN = [0,0,0];
			chartMoneyIN = [0,0,0];
			chartCountIN = [0,0,0];
			chartMoneyCZ = [0,0,0];
			chartCountCZ = [0,0,0];	
			$.getJSON("getClaimStatusMain?",{selLocale:locale,tab:"TEAM",dateType:dateType,stdYy:year1,stdDt:date1,endYy:year2,endDt:date2,t:new Date().getTime()},function(list){
				$.each(list,function(i,cell){
					if("CN"==cell.DATA0){						
						chartMoneyCN[0] += Number(cell.DATA2);
						chartMoneyCN[1] += Number(cell.DATA4);
						chartMoneyCN[2] += Number(cell.DATA7);
						chartCountCN[0] += Number(cell.DATA3);
						chartCountCN[1] += Number(cell.DATA5);
						chartCountCN[2] += Number(cell.DATA8);
						tableCN+="<tr class='hover1' onmouseover='javascript:hover1(this);' onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','"+cell.DATA1+"','','','');\"><td rowspan='2'>"+cell.DATA10+"</td>";
						tableCN+="<td><fmt:message key='ui.label.ea'/></td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA3)+"</td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA5)+"</td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA8)+"</td></tr><tr class='hover11'>";
						tableCN+="<td><fmt:message key='ui.label.money'/></td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA2)+"</td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA4)+"</td>";
						tableCN+="<td style='text-align:right;'>"+numeric(cell.DATA7)+"</td></tr>";						
					}else if("IN"==cell.DATA0){
						chartMoneyIN[0] += Number(cell.DATA2);
						chartMoneyIN[1] += Number(cell.DATA4);
						chartMoneyIN[2] += Number(cell.DATA7);
						chartCountIN[0] += Number(cell.DATA3);
						chartCountIN[1] += Number(cell.DATA5);
						chartCountIN[2] += Number(cell.DATA8);	
						tableIN+="<tr class='hover1' onmouseover='javascript:hover1(this);' onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','"+cell.DATA1+"','','','');\"><td rowspan='2'>"+cell.DATA10+"</td>";
						tableIN+="<td><fmt:message key='ui.label.ea'/></td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA3)+"</td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA5)+"</td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA8)+"</td></tr><tr class='hover11'>";
						tableIN+="<td><fmt:message key='ui.label.money'/></td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA2)+"</td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA4)+"</td>";
						tableIN+="<td style='text-align:right;'>"+numeric(cell.DATA7)+"</td></tr>";							
					}else if("CZ"==cell.DATA0){
						chartMoneyCZ[0] += Number(cell.DATA2);
						chartMoneyCZ[1] += Number(cell.DATA4);
						chartMoneyCZ[2] += Number(cell.DATA7);
						chartCountCZ[0] += Number(cell.DATA3);
						chartCountCZ[1] += Number(cell.DATA5);
						chartCountCZ[2] += Number(cell.DATA8);
						tableCZ+="<tr class='hover1' onmouseover='javascript:hover1(this);' onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','"+cell.DATA1+"','','','');\"><td rowspan='2'>"+cell.DATA10+"</td>";
						tableCZ+="<td><fmt:message key='ui.label.ea'/></td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA3)+"</td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA5)+"</td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA8)+"</td></tr><tr class='hover11'>";
						tableCZ+="<td><fmt:message key='ui.label.money'/></td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA2)+"</td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA4)+"</td>";
						tableCZ+="<td style='text-align:right;'>"+numeric(cell.DATA7)+"</td></tr>";							
					}
				});
				$("#table0CN tbody").empty().append(tableCN);
				$("#table0IN tbody").empty().append(tableIN);
				$("#table0CZ tbody").empty().append(tableCZ);
				var cate = ['<fmt:message key="ui.label.publish" />',
				             '<fmt:message key="ui.label.qualityIssue.ready" />',
				             '<fmt:message key="ui.label.qualityIssue.done" />'];
				chartM('0CN',countryCN,chartMoneyCN,chartCountCN,'spline',cate,"#FDF7F6");
				chartM('0IN',countryIN,chartMoneyIN,chartCountIN,'spline',cate,"#F6FCFD");
				chartM('0CZ',countryCZ,chartMoneyCZ,chartCountCZ,'spline',cate,"#FDF6FC");
			});
		}
		else if(selectedTab=='<fmt:message key="tab.issueClaim"/>'){
			var chartMoneyCN = [];
			var chartCountCN = [];
			var countTotalCN = [];
			var chartMoneyIN = [];
			var chartCountIN = [];
			var countTotalIN = [];
			var chartMoneyCZ = [];
			var chartCountCZ = [];
			var countTotalCZ = [];
			
			chartMoneyCN = [0,0,0,0];
			chartCountCN = [0,0,0,0];			
			chartMoneyIN = [0,0,0,0];
			chartCountIN = [0,0,0,0];
			chartMoneyCZ = [0,0,0,0];
			chartCountCZ = [0,0,0,0];			
			countTotalCN = [0,0,0];
			countTotalIN = [0,0,0];
			countTotalCZ = [0,0,0];
			$.getJSON("getClaimStatusMain?",{selLocale:locale,tab:"ISSUE",dateType:dateType,stdYy:year1,stdDt:date1,endYy:year2,endDt:date2,t:new Date().getTime()},function(list){
				$.each(list,function(i,cell){
					if("CN"==cell.DATA0){			
						countTotalCN[0] += Number(cell.DATA3);
						countTotalCN[1] += Number(cell.DATA5);
						countTotalCN[2] += Number(cell.DATA8);						
						switch(cell.DATA1){
						case 'LS' :  chartMoneyCN[0] = Number(cell.DATA7);chartCountCN[0]  = Number(cell.DATA8); break;
						case 'RW' :  chartMoneyCN[1] = Number(cell.DATA7);chartCountCN[1]  = Number(cell.DATA8); break;
						case 'SW' :  chartMoneyCN[2] = Number(cell.DATA7);chartCountCN[2]  = Number(cell.DATA8); break;
						case 'EX' :  chartMoneyCN[3] = Number(cell.DATA7);chartCountCN[3]  = Number(cell.DATA8); break;
						default : break;
						}
					}else if("IN"==cell.DATA0){
						countTotalIN[0] += Number(cell.DATA3);
						countTotalIN[1] += Number(cell.DATA5);
						countTotalIN[2] += Number(cell.DATA8);							
						switch(cell.DATA1){
						case 'LS' :  chartMoneyIN[0] = Number(cell.DATA7);chartCountIN[0]  = Number(cell.DATA8); break;
						case 'RW' :  chartMoneyIN[1] = Number(cell.DATA7);chartCountIN[1]  = Number(cell.DATA8); break;
						case 'SW' :  chartMoneyIN[2] = Number(cell.DATA7);chartCountIN[2]  = Number(cell.DATA8); break;
						case 'EX' :  chartMoneyIN[3] = Number(cell.DATA7);chartCountIN[3]  = Number(cell.DATA8); break;
						default : break;
						}					
					}else if("CZ"==cell.DATA0){
						countTotalCZ[0] += Number(cell.DATA3);
						countTotalCZ[1] += Number(cell.DATA5);
						countTotalCZ[2] += Number(cell.DATA8);
						switch(cell.DATA1){
						case 'LS' :  chartMoneyCZ[0] = Number(cell.DATA7);chartCountCZ[0]  = Number(cell.DATA8); break;
						case 'RW' :  chartMoneyCZ[1] = Number(cell.DATA7);chartCountCZ[1]  = Number(cell.DATA8); break;
						case 'SW' :  chartMoneyCZ[2] = Number(cell.DATA7);chartCountCZ[2]  = Number(cell.DATA8); break;
						case 'EX' :  chartMoneyCZ[3] = Number(cell.DATA7);chartCountCZ[3]  = Number(cell.DATA8); break;
						default : break;
						}						
					}
				});
				
				tableCN+="<tr class='hover2' ><td><fmt:message key='ui.label.ea'/></td>";
				tableCN+="<td style='text-align:right;'  onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartCountCN[0])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartCountCN[1])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartCountCN[2])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartCountCN[3])+"</td></tr>";
				tableCN+="<tr class='hover2'><td><fmt:message key='ui.label.money'/></td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartMoneyCN[0])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartMoneyCN[1])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartMoneyCN[2])+"</td>";
				tableCN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartMoneyCN[3])+"</td></tr>";
				tableIN+="<tr class='hover2'><td><fmt:message key='ui.label.ea'/></td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartCountIN[0])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartCountIN[1])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartCountIN[2])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartCountIN[3])+"</td></tr>";
				tableIN+="<tr class='hover2'><td><fmt:message key='ui.label.money'/></td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartMoneyIN[0])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartMoneyIN[1])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartMoneyIN[2])+"</td>";
				tableIN+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('IN','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartMoneyIN[3])+"</td></tr>";
				tableCZ+="<tr class='hover2'><td><fmt:message key='ui.label.ea'/></td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartCountCZ[0])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartCountCZ[1])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartCountCZ[2])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartCountCZ[3])+"</td></tr>";
				tableCZ+="<tr class='hover2'><td><fmt:message key='ui.label.money'/></td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','LS','','');\">"+numeric(chartMoneyCZ[0])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','RW','','');\">"+numeric(chartMoneyCZ[1])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','SW','','');\">"+numeric(chartMoneyCZ[2])+"</td>";
				tableCZ+="<td style='text-align:right;' onmouseover='javascript:hover2(this);' onclick=\"javascript:popDialog('CZ','"+dateType+"','"+year1+"','"+date1+"','"+year2+"','"+date2+"','','EX','','');\">"+numeric(chartMoneyCZ[3])+"</td></tr>";					
				
				

				$("b:eq(1)",$("#table1CN thead tr td")).empty().append(countTotalCN[0]);
				$("b:eq(3)",$("#table1CN thead tr td")).empty().append(countTotalCN[1]);
				$("b:eq(5)",$("#table1CN thead tr td")).empty().append(countTotalCN[2]);
				$("b:eq(1)",$("#table1IN thead tr td")).empty().append(countTotalIN[0]);
				$("b:eq(3)",$("#table1IN thead tr td")).empty().append(countTotalIN[1]);
				$("b:eq(5)",$("#table1IN thead tr td")).empty().append(countTotalIN[2]);
				$("b:eq(1)",$("#table1CZ thead tr td")).empty().append(countTotalCZ[0]);
				$("b:eq(3)",$("#table1CZ thead tr td")).empty().append(countTotalCZ[1]);
				$("b:eq(5)",$("#table1CZ thead tr td")).empty().append(countTotalCZ[2]);				
				
				
				$("#table1CN tbody").empty().append(tableCN);
				$("#table1IN tbody").empty().append(tableIN);
				$("#table1CZ tbody").empty().append(tableCZ);
				var cate = ['${claimType[1].name}',
				             '${claimType[2].name}',
				             '${claimType[3].name}',
				             '${claimType[0].name}'];				
				chartM('1CN',countryCN,chartMoneyCN,chartCountCN,'column',cate,"#FDF7F6");
				chartM('1IN',countryIN,chartMoneyIN,chartCountIN,'column',cate,"#F6FCFD");
				chartM('1CZ',countryCZ,chartMoneyCZ,chartCountCZ,'column',cate,"#FDF6FC");
			});
		}		
		else if(selectedTab=='<fmt:message key="tab.issueCust"/>'){
			var chartCateCN = [];
			var chartCateIN = [];
			var chartCateCZ = [];
			var chartMoneyCN = [];
			var chartCountCN = [];
			var countTotalCN = [];
			var chartMoneyIN = [];
			var chartCountIN = [];
			var countTotalIN = [];
			var chartMoneyCZ = [];
			var chartCountCZ = [];
			var countTotalCZ = [];
						
			countTotalCN = [0,0,0];
			countTotalIN = [0,0,0];
			countTotalCZ = [0,0,0];
			$.getJSON("getClaimStatusMain?",{selLocale:locale,tab:"CUST",dateType:dateType,stdYy:year1,stdDt:date1,endYy:year2,endDt:date2,t:new Date().getTime()},function(list){
				$.each(list,function(i,cell){
					if("CN"==cell.DATA0){			
						chartCateCN.push(cell.DATA10);
						countTotalCN[0] += Number(cell.DATA3);
						countTotalCN[1] += Number(cell.DATA5);
						countTotalCN[2] += Number(cell.DATA8);
						chartMoneyCN.push(Number(cell.DATA7));
						chartCountCN.push(Number(cell.DATA8));
						tableCN+="<tr class='hover3' onmouseover='javascript:hover3(this);'  onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','','','"+cell.DATA1+"','');\"><td>"+cell.DATA10+"</td>";
						tableCN+="<td>"+numeric(cell.DATA8)+"</td>";
						tableCN+="<td>"+numeric(cell.DATA7)+"</td></tr>";
					}else if("IN"==cell.DATA0){
						chartCateIN.push(cell.DATA10);
						countTotalIN[0] += Number(cell.DATA3);
						countTotalIN[1] += Number(cell.DATA5);
						countTotalIN[2] += Number(cell.DATA8);							
						chartMoneyIN.push(Number(cell.DATA7));
						chartCountIN.push(Number(cell.DATA8));
						tableIN+="<tr class='hover3' onmouseover='javascript:hover3(this);'   onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','','','"+cell.DATA1+"','');\"><td>"+cell.DATA10+"</td>";
						tableIN+="<td>"+numeric(cell.DATA8)+"</td>";
						tableIN+="<td>"+numeric(cell.DATA7)+"</td></tr>";						
					}else if("CZ"==cell.DATA0){
						chartCateCZ.push(cell.DATA10);
						countTotalCZ[0] += Number(cell.DATA3);
						countTotalCZ[1] += Number(cell.DATA5);
						countTotalCZ[2] += Number(cell.DATA8);
						chartMoneyCZ.push(Number(cell.DATA7));
						chartCountCZ.push(Number(cell.DATA8));		
						tableCZ+="<tr class='hover3' onmouseover='javascript:hover3(this);'   onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','"+cell.DATA15+"','','','"+cell.DATA1+"','');\"><td>"+cell.DATA10+"</td>";
						tableCZ+="<td>"+numeric(cell.DATA8)+"</td>";
						tableCZ+="<td>"+numeric(cell.DATA7)+"</td></tr>";						
					}
				});

				$("b:eq(1)",$("#table2CN thead tr td")).empty().append(countTotalCN[0]);
				$("b:eq(3)",$("#table2CN thead tr td")).empty().append(countTotalCN[1]);
				$("b:eq(5)",$("#table2CN thead tr td")).empty().append(countTotalCN[2]);
				$("b:eq(1)",$("#table2IN thead tr td")).empty().append(countTotalIN[0]);
				$("b:eq(3)",$("#table2IN thead tr td")).empty().append(countTotalIN[1]);
				$("b:eq(5)",$("#table2IN thead tr td")).empty().append(countTotalIN[2]);
				$("b:eq(1)",$("#table2CZ thead tr td")).empty().append(countTotalCZ[0]);
				$("b:eq(3)",$("#table2CZ thead tr td")).empty().append(countTotalCZ[1]);
				$("b:eq(5)",$("#table2CZ thead tr td")).empty().append(countTotalCZ[2]);				
				
				
				$("#table2CN tbody").empty().append(tableCN);
				$("#table2IN tbody").empty().append(tableIN);
				$("#table2CZ tbody").empty().append(tableCZ);					
				chartBar('2CN',countryCN,chartMoneyCN,chartCountCN,chartCateCN,"#FDF7F6");
				chartBar('2IN',countryIN,chartMoneyIN,chartCountIN,chartCateIN,"#F6FCFD");
				chartBar('2CZ',countryCZ,chartMoneyCZ,chartCountCZ,chartCateCZ,"#FDF6FC");
			});
		}		
		else if(selectedTab=='<fmt:message key="tab.issueDate"/>'){
			var chartCateCN = [];
			var chartCateIN = [];
			var chartCateCZ = [];
			var chartMoneyCN = [];
			var chartCountCN = [];
			var countTotalCN = [];
			var chartMoneyIN = [];
			var chartCountIN = [];
			var countTotalIN = [];
			var chartMoneyCZ = [];
			var chartCountCZ = [];
			var countTotalCZ = [];
						
			countTotalCN = [0,0,0];
			countTotalIN = [0,0,0];
			countTotalCZ = [0,0,0];
			$.getJSON("getClaimStatusMain?",{selLocale:locale,tab:"DATE",dateType:dateType,stdYy:year1,stdDt:date1,endYy:year2,endDt:date2,t:new Date().getTime()},function(list){
				$.each(list,function(i,cell){
					if("CN"==cell.DATA0){			
						chartCateCN.push(cell.DATA1);
						countTotalCN[0] += Number(cell.DATA3);
						countTotalCN[1] += Number(cell.DATA5);
						countTotalCN[2] += Number(cell.DATA8);
						chartMoneyCN.push(Number(cell.DATA7));
						chartCountCN.push(Number(cell.DATA8));
						tableCN+="<tr class='hover4' onmouseover='javascript:hover4(this);'   onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA10+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','','','','"+cell.DATA1+"');\"><td>"+cell.DATA1+"</td>";
						tableCN+="<td>"+numeric(cell.DATA8)+"</td>";
						tableCN+="<td>"+numeric(cell.DATA7)+"</td></tr>";
					}else if("IN"==cell.DATA0){
						chartCateIN.push(cell.DATA1);
						countTotalIN[0] += Number(cell.DATA3);
						countTotalIN[1] += Number(cell.DATA5);
						countTotalIN[2] += Number(cell.DATA8);							
						chartMoneyIN.push(Number(cell.DATA7));
						chartCountIN.push(Number(cell.DATA8));
						tableIN+="<tr class='hover4' onmouseover='javascript:hover4(this);'  onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA10+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','','','','"+cell.DATA1+"');\"><td>"+cell.DATA1+"</td>";
						tableIN+="<td>"+numeric(cell.DATA8)+"</td>";
						tableIN+="<td>"+numeric(cell.DATA7)+"</td></tr>";						
					}else if("CZ"==cell.DATA0){
						chartCateCZ.push(cell.DATA1);
						countTotalCZ[0] += Number(cell.DATA3);
						countTotalCZ[1] += Number(cell.DATA5);
						countTotalCZ[2] += Number(cell.DATA8);
						chartMoneyCZ.push(Number(cell.DATA7));
						chartCountCZ.push(Number(cell.DATA8));		
						tableCZ+="<tr class='hover4' onmouseover='javascript:hover4(this);'  onclick=\"javascript:popDialog('"+cell.DATA0+"','"+cell.DATA10+"','"+cell.DATA11+"','"+cell.DATA12+"','"+cell.DATA13+"','"+cell.DATA14+"','','','','"+cell.DATA1+"');\"><td>"+cell.DATA1+"</td>";
						tableCZ+="<td>"+numeric(cell.DATA8)+"</td>";
						tableCZ+="<td>"+numeric(cell.DATA7)+"</td></tr>";						
					}
				});

				$("b:eq(1)",$("#table3CN thead tr td")).empty().append(countTotalCN[0]);
				$("b:eq(3)",$("#table3CN thead tr td")).empty().append(countTotalCN[1]);
				$("b:eq(5)",$("#table3CN thead tr td")).empty().append(countTotalCN[2]);
				$("b:eq(1)",$("#table3IN thead tr td")).empty().append(countTotalIN[0]);
				$("b:eq(3)",$("#table3IN thead tr td")).empty().append(countTotalIN[1]);
				$("b:eq(5)",$("#table3IN thead tr td")).empty().append(countTotalIN[2]);
				$("b:eq(1)",$("#table3CZ thead tr td")).empty().append(countTotalCZ[0]);
				$("b:eq(3)",$("#table3CZ thead tr td")).empty().append(countTotalCZ[1]);
				$("b:eq(5)",$("#table3CZ thead tr td")).empty().append(countTotalCZ[2]);				
				
				
				$("#table3CN tbody").empty().append(tableCN);
				$("#table3IN tbody").empty().append(tableIN);
				$("#table3CZ tbody").empty().append(tableCZ);					
				chartM('3CN',countryCN,chartMoneyCN,chartCountCN,'column',chartCateCN,"#FDF7F6");
				chartM('3IN',countryIN,chartMoneyIN,chartCountIN,'column',chartCateIN,"#F6FCFD");
				chartM('3CZ',countryCZ,chartMoneyCZ,chartCountCZ,'column',chartCateCZ,"#FDF6FC");
			});
		}		
		else if(selectedTab=='<fmt:message key="ui.chart.list"/>'){
			var params = {};
			params.selLocale = locale;
			params.tab = "LIST";
			params.dateType = dateType;
			params.stdYy = year1;
			params.stdDt = date1;
			params.endYy = year2;
		 	params.endDt = date2;
			$("#totalList").datagrid("load",params);
		}	
	}
	
	function changeLocaleDiv(locale){
		if(locale=="KR"){
			$("#tableAll div").css("display","inline");
			$("#tableAll table").css("display","inline");
			$("#tableIssue div").css("display","inline");
			$("#tableIssue table").css("display","inline");
			$("#tableCust div").css("display","inline");
			$("#tableCust table").css("display","inline");
			$("#tableDate div").css("display","inline");
			$("#tableDate table").css("display","inline");
			$(".hrtr").css("display","inline");
			
		}else{
			$(".hrtr").css("display","none");
			$("#tableAll div").css("display","none");
			$("#tableAll table").css("display","none");			
			$("#chart0"+locale).css("display","inline");
			$("#table0"+locale).css("display","inline");
			$("#tableIssue div").css("display","none");
			$("#tableIssue table").css("display","none");			
			$("#chart1"+locale).css("display","inline");
			$("#table1"+locale).css("display","inline");
			$("#tableCust div").css("display","none");
			$("#tableCust table").css("display","none");			
			$("#chart2"+locale).css("display","inline");
			$("#table2"+locale).css("display","inline");
			$("#tableDate div").css("display","none");
			$("#tableDate table").css("display","none");
			$("#chart3"+locale).css("display","inline");
			$("#table3"+locale).css("display","inline");			
		}
	}
	
	function fnSelectTab(title){	
		if(title==null)
			title = selectedTab;
		selectedTab = title; 
		searchList(title);
	}
	function chartM(locale,country,claimMoney,claimCount,type2,cate,color){
		chart = new Highcharts.Chart({
			chart: {
				renderTo: 'chart'+locale,
				zoomType: 'xy',
				height:210,
				backgroundColor:color
			},
			title: {
				text: null
			},
			subtitle: {
				text: country
			},
			xAxis: [{
				categories:cate
			}],
			yAxis: [{
				labels: {
					formatter: function() {
						return this.value +'<fmt:message key="ui.label.ea" />';
					},
					style: {
						color: '#DB2F00'
					}
				},
				title: {
					text: '<fmt:message key="chartYName.issueCount" />',
					style: {
						color: '#DB2F00'
					}
				},
				min:0
			}, {
				labels: {					
					style: {
						color: '#011F8C'
					}
				},	
				title: {
					text: '<fmt:message key="ui.label.claimCost" />',
					style: {
						color: '#011F8C'
					}
				},
				opposite: true,
				min:0
				
			}],
			tooltip: {
				formatter: function() {
					return ''+
						this.series.name +
						': '+
						numeric(this.y) +
						(this.series.name == '<fmt:message key="chartYName.issueCount" />' ? '<fmt:message key="ui.label.ea" />' : '');
				}
			},
			legend: {
				layout: 'horizontal',
				align: 'right',
				x: -50,
				verticalAlign: 'top',
				y: 10,
				floating: true,
				backgroundColor: '#FFFFFF'
			},
			series: [{
				name: '<fmt:message key="ui.label.claimCost" />',
				color: '#011F8C',
				type: 'column',
				yAxis: 1,
				data: claimMoney

			}, {
				name: '<fmt:message key="chartYName.issueCount" />',
				color: '#DB2F00',
				type: type2,
				data: claimCount
			}]
		});		
	}
	
	function chartBar(locale,country,claimMoney,claimCount,cate,color){
		chart = new Highcharts.Chart({
			chart: {
				renderTo: 'chart'+locale,
				zoomType: 'xy',
				backgroundColor:color
			},
			title: {
				text: null
			},
			subtitle: {
				text: country
			},
			xAxis: [{
				categories:cate
			}],
			yAxis: [{
				labels: {
					formatter: function() {
						return this.value +'<fmt:message key="ui.label.ea" />';
					},
					style: {
						color: '#DB2F00'
					}
				},
				title: {
					text: '<fmt:message key="chartYName.issueCount" />',
					style: {
						color: '#DB2F00'
					}
				},
				min:0
			}, {
				labels: {					
					style: {
						color: '#011F8C'
					}
				},	
				title: {
					text: '<fmt:message key="ui.label.claimCost" />',
					style: {
						color: '#011F8C'
					}
				},
				opposite: true,
				min:0
				
			}],
			tooltip: {
				formatter: function() {
					return ''+
						this.series.name +
						': '+
						numeric(this.y) +
						(this.series.name == '<fmt:message key="chartYName.issueCount" />' ? '<fmt:message key="ui.label.ea" />' : '');
				}
			},
			legend: {
				layout: 'horizontal',
				align: 'right',
				x: -50,
				verticalAlign: 'top',
				y: 10,
				floating: true,
				backgroundColor: '#FFFFFF'
			},
			series: [{
				name: '<fmt:message key="ui.label.claimCost" />',
				color: '#011F8C',
				type: 'bar',
				yAxis: 1,
				data: claimMoney

			}, {
				name: '<fmt:message key="chartYName.issueCount" />',
				color: '#DB2F00',
				type: 'bar',
				data: claimCount
			}]
		});		
	}
	
	function claimCate(value,rowData,rowIndex){
		if(rowData.DATA2=="LS")
			return "color:red;";
		else if(rowData.DATA2=="RW")
			return "color:blue;";
		else if(rowData.DATA2=="SW")
			return "color:#089B00;";
		else
			return "color:#DEA300;";
	}
	function rowStyAgree(rowIndex,rowData){
		if(rowData.DATA13=="AGREE")
			return "background-color:#E7FAFD;";
		else if(rowData.DATA13=="WAIT")
			return "background-color:#FCE5FC;";
	}
	
	function agreeClick(rowIndex, rowData){
		var claimNo = rowData.DATA0;
        var win = window.open("claimAgree?claimNo="+claimNo,"AgreeDetail","width=930,height=680,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no");
        win.focus();
	}
	
	function hover1(ob){
		$(".hover1").css("background-color","#FFFFFF");
		$(".hover11").css("background-color","#FFFFFF");
		$("td:eq(0)",$(".hover1")).css("text-decoration","none").css("color","black");
		$(ob).css("background-color","#C4DCFD");		
		$(ob).next().css("background-color","#C4DCFD");
		$("td:eq(0)",$(ob)).css("text-decoration","underline").css("color","blue");
	}
	
	function hover2(ob){
		$(".hover2 td").css("background-color","#FFFFFF");
		var idx =$('td',$(ob).parent()).index($(ob));
		var $table = $(ob).parent().parent();
		$("td:eq("+idx+")",$("tr:eq(0)",$table)).css("background-color","#C4DCFD");
		$("td:eq("+idx+")",$("tr:eq(1)",$table)).css("background-color","#C4DCFD");
	}
	function hover3(ob){
		$(".hover3").css("background-color","#FFFFFF");
		$(ob).css("background-color","#C4DCFD");
	}
	
	function hover4(ob){
		$(".hover4").css("background-color","#FFFFFF");
		$(ob).css("background-color","#C4DCFD");
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
			$("#tabsong").tabs({onSelect:fnSelectTab});		
			$("#totalList").datagrid({onDblClickRow:agreeClick});
			$("#dialogTotalList").datagrid({onDblClickRow:agreeClick});
			
			
			
		});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;" >
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
	<div iconCls="icon-system-monitor" class="easyui-panel" style="width:1194px;" title='<fmt:message key="menu.qualityClaimStatus"/>'>
	<div class="padding10">
		<span class="label-Leader-blue"><fmt:message key="ui.label.searchDateType" /></span> : 
		<input type="radio" name="selectTerm" value="M"  onclick="javascript:$('#monthSearch').css('display','inline');$('#weekSearch').css('display','none');" checked><fmt:message key='ui.label.byMonth' />
		<input type="radio" name="selectTerm" value="W" onclick="javascript:$('#monthSearch').css('display','none');$('#weekSearch').css('display','inline');"><fmt:message key='ui.label.byWeek' />       	 
       	 <c:if test="${cLocale=='KR'}">
       	 	 <span style="width:50px;">&nbsp;</span>
			 <span class="label-Leader-blue"><fmt:message key="ui.label.local"/></span>
			 <select id="searchLocale">
			 	<option value="KR"><fmt:message key="ui.element.All"/></option>
			 	<option value="CN"><fmt:message key="country.china"/></option>
			 	<option value="IN"><fmt:message key="country.india"/></option>
			 	<option value="CZ"><fmt:message key="country.czech"/></option>
			 </select><span style="width:20px;">&nbsp;&nbsp;</span>
		 </c:if> 		
	</div>	
	<div class="padding10" id='monthSearch'>
		<span class="label-Leader-blue">
		<fmt:message key="ui.label.SearchDate" /></span> :
		 
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
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:fnSelectTab();"><fmt:message key="ui.button.Search"/></a>					
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
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:fnSelectTab();"><fmt:message key="ui.button.Search"/></a>
	</div>
	<div id="tabsong" style="width:1192px;height:640px;">
	    <div title="<fmt:message key='ui.element.All'/>" iconCls="icon-workspace"  style="padding:20px;">
	    	<table id="tableAll">
	    		<tr>
	    			<td class="cnStyle"><div id="chart0CN"></div></td>
	    			<td class="cnStyle">
	    				<table id="table0CN" class="table">
	    					<thead>
	    						<tr>
	    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.employee.deptNm"/></th>
	    						<th style="width:50px;"><fmt:message key="ui.label.cagegory"/></th>
	    						<th style="width:120px;"><fmt:message key="ui.label.publish"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.ready"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.qualityIssue.done"/></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    		
	    			<td class="inStyle"><div id="chart0IN"></div></td>
	    			<td class="inStyle">
	    				<table id="table0IN"  class="table">
	    					<thead>
	    						<tr>
	    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.employee.deptNm"/></th>
	    						<th  style="width:50px;"><fmt:message key="ui.label.cagegory"/></th>
	    						<th style="width:120px;"><fmt:message key="ui.label.publish"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.ready"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.qualityIssue.done"/></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="czStyle"><div id="chart0CZ"></div></td>
	    			<td class="czStyle">
	    				<table id="table0CZ"  class="table">
	    					<thead>
	    						<tr>
	    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.employee.deptNm"/></th>
	    						<th style="width:50px;"><fmt:message key="ui.label.cagegory"/></th>
	    						<th style="width:120px;"><fmt:message key="ui.label.publish"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.ready"/></th>	    						
	    						<th style="width:120px;"><fmt:message key="ui.label.qualityIssue.done"/></th>
	    						</tr>	    						
	    					</thead>
	    					<tbody></tbody>	    				
	    				</table>
	    			</td>
	    		</tr>	    			    		
	    	</table>
	    </div>  	  
	    <div title="<fmt:message key='tab.issueClaim'/>" iconCls="icon-error"  style="padding:20px;">  
			<table id="tableIssue">
	    		<tr>
	    			<td class="cnStyle"><div id="chart1CN"></div></td>
	    			<td class="cnStyle">
	    				<table id="table1CN" class="table">
	    					<thead>	    		
	    						<tr>
	    							<td colspan="5" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>
	    						<tr>				
		    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.cagegory"/></th>
		    						<th style="width:120px;">${claimType[1].name}</th>
		    						<th style="width:120px;">${claimType[2].name}</th>	    						
		    						<th style="width:120px;">${claimType[3].name}</th>	    						
		    						<th style="width:120px;">${claimType[0].name}</th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="inStyle"><div id="chart1IN"></div></td>
	    			<td class="inStyle">
	    				<table id="table1IN"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="5" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
	    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.cagegory"/></th>
	    						<th style="width:120px;">${claimType[1].name}</th>
	    						<th style="width:120px;">${claimType[2].name}</th>	    						
	    						<th style="width:120px;">${claimType[3].name}</th>	    						
	    						<th style="width:120px;">${claimType[0].name}</th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="czStyle"><div id="chart1CZ"></div></td>
	    			<td class="czStyle">
	    				<table id="table1CZ"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="5" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
	    						<th style="width:50px;height:25px;"><fmt:message key="ui.label.cagegory"/></th>
	    						<th style="width:120px;">${claimType[1].name}</th>
	    						<th style="width:120px;">${claimType[2].name}</th>	    						
	    						<th style="width:120px;">${claimType[3].name}</th>	    						
	    						<th style="width:120px;">${claimType[0].name}</th>
	    						</tr>	    						
	    					</thead>
	    					<tbody></tbody>	    				
	    				</table>
	    			</td>
	    		</tr>	    			    		
	    	</table>  
	    </div>
	    <div title="<fmt:message key='tab.issueCust'/>" iconCls="icon-lorry" style="padding:20px;">  
			<table id="tableCust">
	    		<tr>
	    			<td class="cnStyle"><div id="chart2CN"></div></td>
	    			<td class="cnStyle">
	    				<table id="table2CN" class="table">
	    					<thead>	    		
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>
	    						<tr>				
		    						<th style="width:200px;height:25px;"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th>	    						
		    						<th style="width:70px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="inStyle"><div id="chart2IN"></div></td>
	    			<td class="inStyle">
	    				<table id="table2IN"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
		    						<th style="width:200px;height:25px;"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th>	    						
		    						<th style="width:70px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="czStyle"><div id="chart2CZ"></div></td>
	    			<td class="czStyle">
	    				<table id="table2CZ"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
		    						<th style="width:200px;height:25px;"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th>	    						
		    						<th style="width:70px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>	    						
	    					</thead>
	    					<tbody></tbody>	    				
	    				</table>
	    			</td>
	    		</tr>	    			    		
	    	</table>  
	    </div>
	    <div title="<fmt:message key='tab.issueDate'/>" iconCls="icon-date" style="padding:20px;">  
			<table id="tableDate">
	    		<tr>
	    			<td class="cnStyle"><div id="chart3CN"></div></td>
	    			<td class="cnStyle">
	    				<table id="table3CN" class="table">
	    					<thead>	    		
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>
	    						<tr>				
		    						<th style="width:60px;height:25px;"><fmt:message key="ui.label.datetime"/></th>	    						
		    						<th style="width:60px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="inStyle"><div id="chart3IN"></div></td>
	    			<td class="inStyle">
	    				<table id="table3IN"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
		    						<th style="width:60px;height:25px;"><fmt:message key="ui.label.datetime"/></th>	    						
		    						<th style="width:60px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>
	    					</thead>
	    					<tbody></tbody>
	    				</table>
	    			</td>
	    		</tr>
	    		<tr class="hrtr"><td colspan="2"><hr></td></tr>
	    		<tr>
	    			<td class="czStyle"><div id="chart3CZ"></div></td>
	    			<td class="czStyle">
	    				<table id="table3CZ"  class="table">
	    					<thead>
	    						<tr>
	    							<td colspan="3" style="color:blue;border:0px;text-align:left;">
	    							<b><fmt:message key="ui.label.publish"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.ready"/> : </b>
	    							<b></b><span style="width:50px;">&nbsp;</span>
	    							<b><fmt:message key="ui.label.qualityIssue.done"/> : </b>
	    							<b></b>
	    							</td>
	    						</tr>	    					
	    						<tr>
		    						<th style="width:60px;height:25px;"><fmt:message key="ui.label.datetime"/></th>	    						
		    						<th style="width:60px;"><fmt:message key="ui.chart.agreeCount" /></th>	    						
		    						<th style="width:100px;"><fmt:message key="ui.label.claimCost" /></th>
	    						</tr>	    						
	    					</thead>
	    					<tbody></tbody>	    				
	    				</table>
	    			</td>
	    		</tr>	    			    		
	    	</table>  
	    </div>        
	    <div title="<fmt:message key='ui.chart.list'/>" iconCls="icon-application-view-list"  style="padding:0px;">  
	     <table id="totalList" fit="true"  idField="DATA0" singleSelect="true" url="getClaimStatusMain" pagination="false" pageSize="100000000"
	     	rowStyler = "rowStyAgree"  toolbar="#tabBox" >			
			<thead>
				<tr>
					<th field="DATA0" hidden="true"></th>
					<th field="DATA1" width="80" sortable="true"  align="center"><fmt:message key="ui.label.OccurDate"/></th>
					<th field="DATA2" hidden="true"></th>										
					<th field="DATA3" width="90" sortable="true"  align="center" styler="claimCate"><fmt:message key="ui.label.cagegory"/></th>
		            <th field="DATA4" width="110" sortable="true" align="center">INVOICE NO</th>
		            <th field="DATA5" width="120" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>
		            <th field="DATA6" width="200" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartName" /></th>
		            <th field="DATA7" width="90" sortable="true" align="center">LOT NO</th>
		            <th field="DATA8" width="90" sortable="true" align="center"><fmt:message key="ui.label.refTeam" /></th>
		            <th field="DATA9" width="200" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>
		            <th field="DATA10" width="120" sortable="true" align="left"><fmt:message key="ui.label.claimContent" /></th>
		            <th field="DATA11" width="80" sortable="true" align="right" formmater="numeric"> <fmt:message key="chartYName.issueAmount" /></th>
		            <th field="DATA12" width="80" sortable="true" align="right" formmater="numeric"><fmt:message key="ui.label.claimCost" /></th>
		            <th field="DATA13" hidden="true"></th>
		            <th field="DATA14" width="90" sortable="true" align="right" formmater="numeric"><fmt:message key="ui.label.claimReward"/></th>
				</tr>	
			</thead>
		 </table>
	    </div>  	  	    
	</div> 
</div>
</div>
<div id="dialogTotalListPanel" style="width:1150px;height:400px;"  title="<fmt:message key="ui.label.detailStatus"/>" iconCls="icon-script-error" >
  <table id="dialogTotalList"  fit="true"  idField="DATA0" singleSelect="true" url="getClaimStatusSub" pagination="false" pageSize="100000000"
     	rowStyler = "rowStyAgree"  toolbar="#tabBox2" >			
		<thead>
			<tr>
				<th field="DATA0" hidden="true"></th>
				<th field="DATA1" width="80" sortable="true"  align="center"><fmt:message key="ui.label.OccurDate"/></th>
				<th field="DATA2" hidden="true"></th>										
				<th field="DATA3" width="90" sortable="true"  align="center" styler="claimCate"><fmt:message key="ui.label.cagegory"/></th>
	            <th field="DATA4" width="110" sortable="true" align="center">INVOICE NO</th>
	            <th field="DATA5" width="120" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartNo" /></th>
	            <th field="DATA6" width="200" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonPartName" /></th>
	            <th field="DATA7" width="90" sortable="true" align="center">LOT NO</th>
	            <th field="DATA8" width="90" sortable="true" align="center"><fmt:message key="ui.label.refTeam" /></th>
	            <th field="DATA9" width="200" sortable="true" align="left"><fmt:message key="ui.label.qualityIssue.reasonOrgan" /></th>
	            <th field="DATA10" width="120" sortable="true" align="left"><fmt:message key="ui.label.claimContent" /></th>
	            <th field="DATA11" width="80" sortable="true" align="right" formmater="numeric"> <fmt:message key="chartYName.issueAmount" /></th>
	            <th field="DATA12" width="80" sortable="true" align="right" formmater="numeric"><fmt:message key="ui.label.claimCost" /></th>
	            <th field="DATA13" hidden="true"></th>
	            <th field="DATA14" width="90" sortable="true" align="right" formmater="numeric"><fmt:message key="ui.label.claimReward"/></th>
			</tr>	
		</thead>
	 </table>
</div>
<div id="tabBox" style="padding:10px;text-align:right;">
   	<span style="background-color:#E7FAFD;padding:3px 7px;border:1px solid #B5B5B5;">${actState[0].name}</span>
   	<span style="background-color:#FCE5FC;padding:3px 7px;border:1px solid #B5B5B5;">${actState[2].name}</span>
   	<span style="background-color:#FFFFFF;padding:3px 7px;border:1px solid #B5B5B5;">${actState[1].name}</span>  
</div>
<div id="tabBox2" style="padding:10px;text-align:right;">
   	<span style="background-color:#E7FAFD;padding:3px 7px;border:1px solid #B5B5B5;">${actState[0].name}</span>
   	<span style="background-color:#FCE5FC;padding:3px 7px;border:1px solid #B5B5B5;">${actState[2].name}</span>
   	<span style="background-color:#FFFFFF;padding:3px 7px;border:1px solid #B5B5B5;">${actState[1].name}</span>  
</div>

</body>

</html>

