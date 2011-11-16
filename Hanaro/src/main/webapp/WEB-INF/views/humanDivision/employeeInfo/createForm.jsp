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
			params.keyword = $("#keyword").val();
			params.keyfield = $("#keyfield").val(); 
			$("#resultDataGrid").datagrid("load",params);
			
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
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:400px;height:725px;" title='<fmt:message key="menu.employeeForm"/>'>
					<form:form action="addEmployeeInfo" method="POST"  modelAttribute="employeeInfo"  id="form" name="frm"  enctype="multipart/form-data">
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black"  ><fmt:message key="ui.label.employee.photo" /></span>
								</th>
								<td>	
									<input type = "file"  id="photoImg"  name = "photoImg"  />							
									<input type="hidden" name="setType" value="INSERT" >
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.empNo"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox" readonly="true"  path="empNo"  id="empNo"  />		
								</td>
							</tr>
							<tr>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.empNm"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"   path="empNm"  id="empNm"  />		
								</td>  
							</tr>	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.ssn"  /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox" path="ssn"  id='ssn'  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.gender" /></span>
								</th>
								<td>								
									<form:select class="easyui-validatebox" path="gender"   required='true'   id="gender">
										<option value=""><fmt:message key="ui.element.Select"/></option>
										<option value="M"><fmt:message key="ui.label.employee.man"/></option>
										<option value="F"><fmt:message key="ui.label.employee.woman"/></option>
									</form:select>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.birthday"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="birthday"  required='true'  style="width:100px;"  id="bithday"  editable="false"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.employDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="employDt"  required='true'  style="width:100px;"  id="employDt"  editable="false"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.deptNm"/></span>
								</th>
								<td>				
									<form:select path="deptCd" id="deptCd" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
											<form:options items="${deptList }"  />
									</form:select>	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.position"/></span>
								</th>
								<td>				
									<form:select path="positionCd" id="positionCd" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
										<form:options items="${positionList }"  />
									</form:select>	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.role"/></span>
								</th>
								<td>				
									<form:select path="roleCd" id="roleCd" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
										<form:options items="${roleList }"  />
									</form:select>	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.marry"/></span>
								</th>
								<td>								
									<form:select class="easyui-validatebox" path="marry"   required='true'   id="marry">
										<option value=""><fmt:message key="ui.element.Select"/></option>
										<option value="Y">Y</option>
										<option value="N">N</option>
									</form:select>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.marryDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="marryDt"  style="width:100px;"  id="marryDt"  editable="false"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.phone"/></span>
								</th>
								<td>								
									<form:input path="phone"  id='phone'   style="width:120px;"  />
								</td>  
							</tr>	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.cellPhone"/></span>
								</th>
								<td>								
									<form:input path="cellPhone"  id='cellPhone'   style="width:120px;"  />
								</td>  
							</tr>						
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.email"/></span>
								</th>
								<td>								
									<form:input path="email"  id='email'   style="width:100px;"  />
								</td> 
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.retireDt"/></span>
								</th>
								<td>								
									<form:input class="easyui-datebox"  path="retireDt"  style="width:100px;"  id="retireDt"  editable="false"  />
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
				<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:800px;height:725px;" 
				title='<fmt:message key="ui.label.employee.empList"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"   singleSelect="true" striped="true"   url="getEmployeeList" >
					<thead frozen="true">
						        <tr> 
						        	<th field="DATA0" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.photo" /></th>  
						            <th field="DATA1" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.deptNm" /></th>  
						            <th field="DATA2" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.empNm" /></th>   				      
						            <th field="DATA3" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.employDt" /></th>  
						            <th field="DATA4" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.phone" /></th>
						            <th field="DATA5" width="100" sortable="true" align="center"><fmt:message key="ui.label.employee.cellPhone" /></th>  
						            <th field="DATA6" width="200" sortable="true" align="center"><fmt:message key="ui.label.employee.email" /></th>       
      						  </tr>
					</thead>
				</table>
			</td>
		</tr>
	</table>
</div>

 <div id="divSearch" style="padding:5px;height:auto">
       <div>        
		<select  id='keyword' >
				<option value="1"><fmt:message key="ui.element.All"/></option>
				<option value="DEPT"><fmt:message key="ui.label.employee.deptNm"/></option>
				<option value="EMP"><fmt:message key="ui.label.employee.empNm"/></option>
		</select>
		<input id="keyfield" style="width:120px;"  value=""  />
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
