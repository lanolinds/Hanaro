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
		
	});
		//등록전에 검사 확인하기
		function validate(){
			if($("#form").form("validate")){			
				$("#form").submit();
			}else{
				return false;
			}
		}
		
		//사원정보 등록 리스트 조회하기
		function searchList(){
			var params = {};
			params.keyfield = $("#keyfield").val(); 
			$("#resultDataGrid").datagrid("load",params);
			
		}
		
		function resetForm(){
			$('form')[0].reset();
			$('#setType').val('INSERT');
		}
		
		
		//품질문제등록 내용을 폼에 넣는다.
		function insertForm(){
			var record = $("#resultDataGrid").datagrid("getSelected");
			if(record ==null){
				$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
				return;
			}

			$("#custType").val(record.DATA0);
			$("#custCd").val(record.DATA2);
			$("input[name='setType']").val("UPDATE");
			$("#custNm").val(record.DATA3);
			$("#chief").val(record.DATA5);		
			$("#custNo").val(record.DATA4);
			$("#mobileChief").val(record.DATA6);
			$("#phoneOffice").val(record.DATA7);
			$("#phoneFax").val(record.DATA8);
			$("#address").val(record.DATA11);
			$("#email").val(record.DATA10);
			$("#homepage").val(record.DATA9);
			$("#stdDT").datebox('setValue',record.DATA12);
			$("#endDtDt").datebox('setValue',record.DATA13);			
		}
	</script> 

</head> 

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp"%>
</div>
<div region="center" style="padding:10px;">	
	<table>
		<tr>
			<td>
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:370px;height:725px;" title='<fmt:message key="menu.custForm"/>'>
					<form:form action="addCustInfo" method="POST"  modelAttribute="custInfo"  id="form" name="frm" >
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custType"  /></span>
									<input type="hidden" name="setType" value="INSERT" >
								</th>
								<td>						
									<form:select path="custType" id="custType" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
											<form:options items="${custTypeList }"  />
									</form:select>	
								</td>
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custCd"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox" readonly="true"  path="custCd"  id="custCd"  />		
								</td>
							</tr>
							<tr>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custNm"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"   path="custNm"  style="width:100%;"  id="custNm"  />		
								</td>  
							</tr>	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.chief"  /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox" path="chief"  style="width:100%;"  id="chief" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.chiefPhone" /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox"   path="mobileChief"  style="width:100%;"   id="mobileChief"  />		
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.officePhone"/></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"  path="phoneOffice"  style="width:100%;"   id="phoneOffice"    />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.officeFax"/></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"  path="phoneFax"  style="width:100%;"   id="phoneFax"    />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.address"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="address"   style="width:100%;"  id="address"    />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.email"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="email" style="width:100%;"  id="email"    />	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.homepage"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="homepage" style="width:100%;"  id="homepage"    />	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.stdDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="stdDt"  style="width:100px;"  id="stdDt"  editable="false"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.endDt"/></span>
								</th>
								<td>								
									<form:input class="easyui-datebox"  path="endDt"  style="width:100px;"  id="endDt"  editable="false"  />
								</td>  
							</tr>	
							<tr>
								<th colspan='2' style="text-align:center;"  id="tdButton">										
									<a href="#" onclick="javascript:validate();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btInsert"><fmt:message key="ui.button.Save"/></a>																		
									<a href="#" onclick="javascript:resetForm()" class="easyui-linkbutton"  iconCls="icon-arrow-redo" id="btCancel"><fmt:message key="ui.button.Cancel"/></a>
								</th>
							</tr>															
						</table>
					</form:form>
				</div>
			</td>
			<td>
				<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:880px;height:725px;" 
				title='<fmt:message key="ui.label.cust.custList"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"   singleSelect="true" striped="true"  url="getCustList" >
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
			</td>
		</tr>
	</table>
</div>

 <div id="divSearch" style="padding:5px;height:auto">
       <div>        
		<fmt:message key="ui.label.cust.custNm"/>
		<input id="keyfield" style="width:120px;"  value=""  />
		<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>		
     </div>
      
     <div style="margin-bottom:5px" align="right"'>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="javascript:resetForm();"><fmt:message key="ui.button.Reg"/></a>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="javascript:insertForm();"><fmt:message key="ui.button.Edit"/></a>           
      </div>

 
 </div>  
</body>

</html>
