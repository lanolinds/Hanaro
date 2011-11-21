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
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:800px" title='<fmt:message key="menu.custForm"/>'>
					<form:form action="updateCustInfo" method="POST"  modelAttribute="custInfo"  id="form" name="frm" >
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custType"  /></span>
									<input type="hidden" name="setType" value="UPDATE" >
								</th>
								<td>						
									<form:select path="custType" id="custType" class="easyui-validatebox" required='true' >
										<form:option value=""><fmt:message key="ui.element.Select"/></form:option>
											<c:forEach var="custType" items="${custTypeList}">
											<option value="${custType.key}" ${custType.key eq view.CUST_TYPE ?'selected':''}>${custType.value }</option>
											</c:forEach>
									</form:select>	
								</td>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custCd"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox" readonly="true"  path="custCd"  id="custCd" value="${view.CUST_CD }" />		
								</td>
							</tr>
							<tr>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.custNm"  /></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"   path="custNm"  style="width:100%;"  id="custNm" value="${view.CUST_NM }" />		
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.chief"  /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox" path="chief"  style="width:100%;"  id="chief" value="${view.CHIEF }" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.chiefPhone" /></span>
								</th>
								<td>								
									<form:input class="easyui-validatebox"   path="mobileChief"  style="width:100%;"   id="mobileChief" value="${view.MOBILE_CHIEF }"  />		
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.officePhone"/></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"  path="phoneOffice"  style="width:100%;"   id="phoneOffice"  value="${view.PHONE_OFFICE }"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.officeFax"/></span>
								</th>
								<td>						
									<form:input class="easyui-validatebox"  path="phoneFax"  style="width:100%;"   id="phoneFax"  value="${view.PHONE_FAX }"  />
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.address"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="address"   style="width:100%;"  id="address" value="${view.ADDRESS }"   />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.email"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="email" style="width:100%;"  id="email"  value="${view.EMAIL }"  />	
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.homepage"/></span>
								</th>
								<td>				
									<form:input class="easyui-validatebox"  path="homepage" style="width:100%;"  id="homepage"  value="${view.HOMEPAGE }"  />	
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.stdDt"/></span>
								</th>
								<td>						
									<form:input class="easyui-datebox"  path="stdDt"  style="width:100px;"  id="stdDt"  editable="false" value="${view.STD_DT }" />
								</td>  
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.cust.endDt"/></span>
								</th>
								<td>								
									<form:input class="easyui-datebox"  path="endDt"  style="width:100px;"  id="endDt"  editable="false" value="${view.END_DT }" />
								</td>  
							</tr>	
							<tr>
								<th colspan='4' style="text-align:center;"  id="tdButton">										
									<a href="#" onclick="javascript:validate();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btInsert"><fmt:message key="ui.button.Save"/></a>
									<a href='<c:url value="/custDivision/custInfo/list"/>' class="easyui-linkbutton"  iconCls="icon-application-view-detail"><fmt:message key="ui.label.toList"/></a>
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
