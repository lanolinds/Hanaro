<!-- 제작일 : 2012. 1. 12.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.productInoutMgmt"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		#incomeForm th {background-color: #FAFAFA;height:22px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		#incomeForm td {border:1px dotted silver;width:200px;}
		#incomeForm input{border:0px;width:200px;}
		#incomeForm select{width:200px;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	
	<script type="text/javascript">
	function searchIncomeList(){
		var params = {};
		params.category= "income";		 
		params.stdDt = $("#fromDate").datebox("getValue");
		params.endDt=$("#toDate").datebox("getValue");
		$("#incomeList").datagrid("load",params);
		
	}	
	
	function saveIncome(){	
		if($("#incomeForm").form("validate")){		
			$("input[name='category']").val("income");
			$("input[name='pType']").val("insert");			
			$("#incomeForm").submit();
		}else{
			return false;
		}
	}
	function updateIncome(){	
	}
	function deleteIncome(){	
	}
	function saveOutgo(){	
	}
	function updateOutgo(){	
	}
	function deleteOutgo(){	
	}	
	
		$(document).ready(function(){			
			 
			$("#incomeList").datagrid({				
				onDblClickRow:function(i,row){
					
				}
			});	
			
		    $('#inPartCode').combogrid({
		    	panelWidth:400,
		        url : 'getPartListCallBak?type=1001',
		        columns:[[  
		                  {field:'partCode',title:'<fmt:message key="ui.label.PartNo"/>',width:120},  
		                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:255}
		              ]],
		        idField:'partCode',  
		        textField:'partCode',
		        mode:'remote',
		        onSelect:function(rowIndex, rowData){
		        	$("#inPartName").val(rowData.partName);		        	
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
    <div class="easyui-tabs" style="width:1180px;height:720px;">
        <div title="<fmt:message key='menu.incomeMgmt' />" iconCls="icon-brick-add" >
        <table>
        	<tr>
        		<td style="width:850px;height:680px;">
		            <table id="incomeList" pagination="true" pageList="[50,100,200,300]"  border="false"
								fit="true"  idField="DATA0"  toolbar="#toolbar"  singleSelect="true" url="getIncomeOutgoList">			
						<thead>
							<tr>
								<th field="DATA0" hidden="true"></th>
								<th field="DATA1" width="80" sortable="true"><fmt:message key="ui.label.incomeDate"/></th>
								<th field="DATA2" width="150" sortable="true"><fmt:message key="ui.label.incomeType"/></th> 
								<th field="DATA3" width="100" sortable="true"><fmt:message key="ui.label.supplyPlace"/></th>
								<th field="DATA4" width="150" sortable="true"><fmt:message key="ui.label.PartNo"/></th>
								<th field="DATA5" width="250" sortable="true"><fmt:message key="ui.label.PartName"/></th>
								<th field="DATA6" width="100" sortable="true"><fmt:message key="ui.label.LotNo"/></th>
								<th field="DATA7" width="100" sortable="true"><fmt:message key="ui.label.count"/></th>
								<th field="DATA8" width="200" sortable="false"><fmt:message key="ui.label.remark"/></th>
								<th field="DATA9" width="120" sortable="false"><fmt:message key="ui.label.inputBy"/></th>
								<th field="DATA10" width="80" sortable="false"><fmt:message key="ui.label.inputDt"/></th>
								<th field="DATA11" hidden="true"></th>
							</tr>	
						</thead>
					</table>        		
        		</td>
        		<td>
					<div iconCls="icon-brick-edit" class="easyui-panel"  title="<fmt:message key='menu.incomeMgmt' />" style="width:330px;height:680px;" buttons="#incomeBt" >  
					    <form:form action="inoutManagement" modelAttribute="incomeSheet"  id="incomeForm"   method="POST" >
					    	<table style="margin:5px;">
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.incomeDate"/></span></th>
					    			<td>
					    				<form:input path="stdDt" class="easyui-datebox"  editable="false" required='true' id="inStdDt" />
					    				<input type="hidden" name="category" />
					    				<input type="hidden" name="pType" />					    				
					    			</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.incomeType"/></span></th>
					    			<td>
									<form:select path="inoutType" class="easyui-validatebox" required='true' id="inInoutType" >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${incomeType }"  />
									</form:select>
									</td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.supplyPlace"/></span></th>
					    			<td>
									<form:select path="fromTo" class="easyui-validatebox" required='true' id="inFromLine" >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${lineCode }"  />
									</form:select>
									</td>
					    		</tr>    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartNo"/></span></th>
									<td><form:input path="partCode" required='true' id='inPartCode' /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.PartName"/></span></th>
									<td><input id="inPartName" readonly  /></td>
					    		</tr>
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.LotNo"/></span></th>
					    			<td><form:input path="lotNo" id="inLotNo" /></td>				
					    		</tr>    	    		
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.count"/></span></th>
									<td><form:input path="amount" class="easyui-numberspinner"  id="inAmount" /></td>
					    		</tr>    	
					    		<tr>
					    			<th><span  class="label-Leader-black"><fmt:message key="ui.label.remark"/></span></th>
					    			<td><form:input path="comment" id="inComment" /></td>				
					    		</tr>     		
					    		<tr>
					    			<th colspan="2"  style="text-align:center;" >
					    			<a href="#" onclick="javascript:saveIncome();"  class="easyui-linkbutton" iconCls="icon-accept" id="btChange"><fmt:message key="ui.button.Save"/></a>
					    			</th>
					    		</tr>	    		    		    		    		    		
					    	</table>
					    </form:form>
					</div>        		
        		</td>
        	</tr>
        </table>
        </div>
        <div title="<fmt:message key='menu.outgoMgmt' />" iconCls="icon-brick-delete" >  
            tab3  
        </div>      
        <div title="<fmt:message key='menu.inoutSearch' />" iconCls="icon-table-refresh">  
            tab3  
        </div>
        <div title="<fmt:message key='menu.currentStock' />" iconCls="icon-text-align-justity">  
            tab3  
        </div>                      
    </div> 
</div>
 
<!-- 툴바 -->
<div  id="toolbar" style="padding:5px;height:auto;">
	<div style="margin-top:.5em;">
		<span style="margin-right:.5em"><fmt:message key="ui.label.incomeDate"/></span>
	 	<input id="fromDate" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin: 0em .3em;">~</span>
	 	<input id="toDate" class="easyui-datebox" editable="false" value="${today}" style="width:100px;"></input>
	 	<span style="margin-left:2em;"><a href="javascript:searchIncomeList()" class="easyui-linkbutton" iconCls="icon-search"><fmt:message key="ui.button.Search"/></a></span>
	</div>
	<div style="text-align:right;">
	         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:resetForm();"><fmt:message key="ui.button.Reg"/></a>  
	         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="javascript:insertForm();"><fmt:message key="ui.button.Edit"/></a>           
	         <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="javascript:deleteList();"><fmt:message key="ui.button.Delete"/></a>
	</div>
</div>


</body>

</html>
