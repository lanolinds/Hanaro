<%@ page contentType="text/html; charset=UTF-8" %>

	<link rel="shortcut icon" href='<c:url value="/resources/images/favi.ico"/>' />
 	<link rel="icon" href='<c:url value="/resources/images/favi.ico"/>' type="image/x-icon" />

<!-- 메뉴그룹 level 1 -->
<table style="width:100%; white-space: nowrap;">
	<tr>
		<td style="text-align:left;">
			<div style="white-space: nowrap;"><!-- 좌측상단 메인 메뉴 -->
				<a href="#" class="easyui-menubutton" menu="#qualityDivision" iconCls="icon-candlestickchart"><fmt:message key="menu.qualityDivision"/></a>
			    <a href="#" class="easyui-menubutton" menu="#humanMgmt" iconCls="icon-candlestickchart"><fmt:message key="menu.employeeDivision"/></a>
			    <a href="#" class="easyui-menubutton" menu="#custMgmt" iconCls="icon-candlestickchart"><fmt:message key="menu.custDivision"/></a>
			</div>
		</td>
		<td style="text-align:right;">
			<div style="white-space: nowrap;"><!-- 우측 상단. 제어판 기능. (홈버튼,언어선택, 개인설정, 로그아웃) -->
				<a href="?locale=ko_KR" class="easyui-linkbutton" iconCls="icon-flag-kr" plain="true"></a>
				<a href="?locale=zh_CN" class="easyui-linkbutton" iconCls="icon-flag-cn" plain="true"></a>
				<a href="?locale=en_IN" class="easyui-linkbutton" iconCls="icon-flag-in" plain="true"></a>
				<a href="?locale=en_CZ" class="easyui-linkbutton" iconCls="icon-flag-cz" plain="true"></a>
				<a href="?locale=en_BR" class="easyui-linkbutton" iconCls="icon-flag-br" plain="true"></a>
			    <a href="#" class="easyui-splitbutton" menu="#userDetails" iconCls="icon-user-gray">${pageContext.request.userPrincipal.name}</a>  
			    <a href='<c:url value="/home"/>' class="easyui-linkbutton" iconCls="icon-house" plain="true"></a>
			    <a href='<c:url value="/j_spring_security_logout" />' class="easyui-linkbutton" iconCls="icon-door-out" plain="true"><fmt:message key="system.logout"/></a> 
			</div>
		</td> 
	</tr>  
</table>

<!--서브메뉴 level2 -->

<!-- 사용자 서브메뉴 -->
<div id="userDetails" style="width:150px;">  
    <div iconCls="icon-change-password"><fmt:message key="menu.changePassword"/></div>   
</div>

<!-- 품질부문 서브메뉴 -->
<div id="qualityDivision" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.qualityManagement"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/qualityDivision/qualityIssue/qualityIssueReg"/>'><fmt:message key="menu.qualityIssueReg"/></div>
			<div href='<c:url value="/qualityDivision/qualityIssue/list"/>'><fmt:message key="menu.qualityIssueList"/></div>
			<div href='<c:url value="/qualityDivision/qualityIssue/ncrManageList"/>'><fmt:message key="menu.qualityNcrManagement"/></div>
			<div ><fmt:message key="menu.qualityNcrStatus"/></div>			
			<div ><fmt:message key="menu.qualityClaimSearch"/></div>
	</div>
	</div>
</div>
<!-- 인사부문 서브메뉴 -->
<div id="humanMgmt" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.employeeMgmt"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/humanDivision/employeeInfo/createForm"/>'><fmt:message key="menu.employeeForm"/></div>
			<div href='<c:url value="/humanDivision/employeeInfo/list"/>'><fmt:message key="menu.employeeList"/></div>
	</div>
	</div>
</div>
<!-- 협력업체부문 서브메뉴 -->
<div id="custMgmt" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.custMgmt"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/custDivision/custInfo/createForm"/>'><fmt:message key="menu.custForm"/></div>
			<div href='<c:url value="/custDivision/custInfo/list"/>'><fmt:message key="menu.custList"/></div>
	</div>
	</div>
</div>
