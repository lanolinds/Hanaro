<!-- 제작일 : 2012. 5. 31.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.supplierManager"/></title>
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
	<script type="text/javascript">
	//거래처선택 자동완성
	function workCustListCallbak(){		
	    $("input[name='custCode']").combobox({
	    	panelWidth:350,
	        url : 'codeCustOptionLongCallbak?searchType=LOCALCUST',
	    	valueField:'DATA0',  
	    	textField:'DATA1',
	        mode:'remote',	  
	        required:true
	     });
	}		
	function resetForm(){
		$('form')[0].reset();
		$("input[name='procType']").val("INSERT");
	}
	
	
	function validate(){
		if($("#form").form("validate")){			
			$("#form").submit();
		}else{
			return false;
		}
	}	
	function searchList(){
		var params = {};
		params.custCode = $("#searchCust").val();
		params.memberName = $("#searchName").val();
		$("#resultDataGrid").datagrid("load",params);
		
	}
	
	function insertForm(){
		var record = $("#resultDataGrid").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$("#custCode").combobox("setValue",record.custCode);
		$("input[name='memberName']").val(record.name);
		$("input[name='memberEmail']").val(record.email);
		$("input[name='memberPhone']").val(record.phone);
		$("textarea[name='remark']").val(record.remark);
		$("input[name='seq']").val(record.seq);
		$("input[name='procType']").val("UPDATE");		
	}
	
	function deleteList(){
		var record = $("#resultDataGrid").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='warn.wannaDelete' />",function(r){  
		    if (r){  
				$("input[name='procType']").val("DELETE");
				var form = document.frm;		
				form.seq.value = record.seq;
				form.submit();		  
		    }  
		});	
	}	
	
	$(document).ready(function(){
		workCustListCallbak();
	});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
	<table>
		<tr>
			<td>
				<div iconCls="icon-group" class="easyui-panel" style="width:380px;height:725px;" title='<fmt:message key="menu.supplierManager"/>'>
					<form action="view" method="POST" id="form" name="frm"  >
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black"  ><fmt:message key="ui.label.partner"/></span>
								</th>
								<td>								
									<input class="easyui-validatebox" readonly="true"  name="custCode" id="custCode" style="width:250px;" />
									<input type="hidden" name="procType" value="INSERT" >
									<input type="hidden" name="seq" value="" >
								</td>  
							</tr>		
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.name"/></span>
									</th><td>								
									<input class="easyui-validatebox" name='memberName' required='true'  />
								</td>  
							</tr>								
							<tr>
								<th>
									<span  class="label-Leader-black" >E-MAIL</span>
									</th><td>								
									<input class="easyui-validatebox" name='memberEmail' required='true'  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.officePhone"/></span>
									</th><td>								
									<input class="easyui-validatebox" name='memberPhone' required='true'  />
								</td> 
							</tr>	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.remark"/></span>
									</th><td>								
									<textarea class="easyui-validatebox" name='remark' cols="33" rows="4"></textarea>
								</td> 
							</tr>
							<tr>
								<th colspan='2' style="text-align:center;"  id="tdButton">										
									<a href="#" onclick="javascript:validate();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btInsert"><fmt:message key="ui.button.Save"/></a>																		
									<a href="#" onclick="javascript:resetForm()" class="easyui-linkbutton"  iconCls="icon-arrow-redo" id="btCancel"><fmt:message key="ui.button.Cancel"/></a>
								</th>
							</tr>																																					
						</table>
					</form>
				</div>
			</td>
			<td>
				<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:800px;height:725px;" 
				title='<fmt:message key="ui.label.RegList"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"   singleSelect="true" striped="true"   url="getMemberList" >
		
		        <tr>						        	  
		            <th field="cust_nm" width="150" sortable="true" align="center"><fmt:message key="ui.label.cust.custNm" /></th>  
		            <th field="custCode" width="50" hidden="true"></th>  
		            <th field="name" width="130" sortable="true" align="left"><fmt:message key="ui.label.name" /></th>						      
		            <th field="email" width="200" sortable="true" align="left">E-MAIL</th>  
		            <th field="phone" width="130" sortable="true" align="left"><fmt:message key="ui.label.cust.officePhone" /></th>
		            <th field="remark" width="150" sortable="true" align="left"><fmt:message key="ui.label.remark" /></th>
		            <th field="seq" width="50" hidden="true"></th>						            
  				</tr> 
		
					
				</table>
			</td>
		</tr>
	</table>
</div>
<div id="divSearch" style="padding:5px;height:auto">
       <div>        
         <fmt:message key="ui.label.partner"/>
		<select  id='searchCust' >
				<option value=""><fmt:message key="ui.element.All"/></option>									
				<c:forEach items="${custList}" var="item">
					<option value="${item.DATA0}">${item.DATA1}</option>
				</c:forEach>
		</select>
		 <fmt:message key="ui.label.name"/>
		<input id="searchName" type="text" style="width:120px;"  value=""  />
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>		
		  
     </div>
      
     <div style="margin-bottom:5px" align="right"'>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:resetForm();"><fmt:message key="ui.button.Reg"/></a>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="javascript:insertForm();"><fmt:message key="ui.button.Edit"/></a>           
         <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="javascript:deleteList();"><fmt:message key="ui.button.Delete"/></a>
      </div>

 
 </div>  
</body>

</html>
