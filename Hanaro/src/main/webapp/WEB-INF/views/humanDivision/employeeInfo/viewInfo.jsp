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
		url:"getEmployeeList";
		var params = {};
		params.keyword = "";
		params.keyfield = ""; 
		$("#resultDataGrid").datagrid("load",params);
		
		if("${view.EMP_PHOTO}" !="")
			$("b",$("#photoImg").parent()).append("<img src='getEmployeeFile?empNo=${view.EMP_NO}&fileName="+encodeURIComponent("${view.EMP_PHOTO}")+"' width='60' height='60'><br><a  href='getEmployeeFile?empNo=${view.EMP_NO}&fileName="+encodeURIComponent("${view.EMP_PHOTO}")+"' >${view.EMP_PHOTO}</a>");
		
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
			params.keyword = $("#keyword").val();
			params.keyfield = $("#keyfield").val(); 
			$("#resultDataGrid").datagrid("load",params);
			
		}
		
		function fileDownImg1(value,rowData){
			var empNo = rowData.DATA1;				
			var format = "";		
			if(value !="")
				format = "<a  href='getEmployeeFile?empNo="+empNo+"&fileName="+encodeURIComponent(value)+"  class='icon-disk' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>";
			
			return format;
			
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
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:800px" title='<fmt:message key="menu.employeeView"/>'>
					<form:form action="updateEmployeeInfo" method="POST"  modelAttribute="employeeInfo"  id="form" name="frm"  enctype="multipart/form-data">
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black"  ><fmt:message key="ui.label.employee.photo" /></span>
								</th>
								<td>	
									<input type = "file"  id="photoImg"  name = "photoImg"  /><br><b></b>						
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.empNo"  /></span>
									<input type="hidden" name="setType" value="UPDATE" >
								</th>
								<td>						
									<form:input class="easyui-validatebox" readonly="true"  path="empNo"  id="empNo"  value="${view.EMP_NO}" />		
								</td>
							</tr>
							<tr>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.empNm"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"   path="empNm"  id="empNm"  value="${view.EMP_NM}" />		
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.ssn"  /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox" path="ssn"  id='ssn'  value="${view.EMP_SSN}" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.gender" /></span>
								</th>
								<td>								
									<form:select class="easyui-validatebox" path="gender"   required='true'   id="gender">
										<option value=""><fmt:message key="ui.element.Select"/></option>
										<option value="M" ${view.GENDER eq 'M' ?'selected':''}><fmt:message key="ui.label.employee.man"/></option>
										<option value="F" ${view.GENDER eq 'F' ?'selected':''}><fmt:message key="ui.label.employee.woman"/></option>
									</form:select>
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.birthday" /></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="birthday"  required='true'  style="width:100px;"  id="birthday"  editable="false"  value="${view.BIRTH_DT}" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.employDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="employDt"  required='true'  style="width:100px;"  id="employDt"  editable="false"  value="${view.EMPLOY_DT}"/>
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.deptNm"/></span>
								</th>
								<td>				
									<form:select path="deptCd" id="deptCd" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
											<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
											<c:forEach var="dept" items="${deptList}">
											<option value="${dept.key}" ${dept.key eq view.DEPT_CD ?'selected':''}>${dept.value }</option>
											</c:forEach>
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
										<c:forEach var="position" items="${positionList}">
										<option value="${position.key}" ${positionList.key eq view.POSITION_CD ?'selected':''}>${position.value }</option>
										</c:forEach>
									</form:select>	
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.role"/></span>
								</th>
								<td>				
									<form:select path="roleCd" id="roleCd" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
										<c:forEach var="role" items="${roleList}">
										<option value="${role.key}" ${role.key eq view.ROLE_CD ?'selected':''}>${role.value }</option>
										</c:forEach>
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
										<option value="Y" ${view.MARRY_YN eq 'Y' ?'selected':''}>Y</option>
										<option value="N" ${view.MARRY_YN eq 'N' ?'selected':''}>N</option>
									</form:select>
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.marryDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="marryDt"  style="width:100px;"  id="marryDt"  editable="false"  value="${view.MARRY_DT}"/>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.phone"/></span>
								</th>
								<td>								
									<form:input path="phone"  id='phone'   style="width:120px;"  value="${view.PHONE}" />
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.cellPhone"/></span>
								</th>
								<td>								
									<form:input path="cellPhone"  id='cellPhone'   style="width:150px;"  value="${view.CELL_PHONE }" />
								</td>  
							</tr>						
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.email"/></span>
								</th>
								<td>								
									<form:input path="email"  id='email'   style="width:200px;"  />
								</td> 
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.employee.retireDt"/></span>
								</th>
								<td>								
									<form:input class="easyui-datebox"  path="retireDt"  style="width:100px;"  id="retireDt"  editable="false"  />
								</td>  
							</tr>	
							<tr>
								<th colspan='4' style="text-align:center;"  id="tdButton">										
									<a href="#" onclick="javascript:validate();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btInsert"><fmt:message key="ui.button.Edit"/></a>			
									<a href='<c:url value="/humanDivision/employeeInfo/list"/>' class="easyui-linkbutton"  iconCls="icon-application-view-detail"><fmt:message key="ui.label.toList"/></a>															
								</th>
							</tr>															
						</table>
					</form:form>
				</div>
			</td>
		</tr>
	</table>
</div>
 
</body>

</html>
