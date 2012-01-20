<%@ page contentType="text/html; charset=UTF-8" %>

	<link rel="shortcut icon" href='<c:url value="/resources/images/favi.ico"/>' />
 	<link rel="icon" href='<c:url value="/resources/images/favi.ico"/>' type="image/x-icon" />

<!-- 메뉴그룹 level 1 -->
<table style="width:100%; white-space: nowrap;">
	<tr>
		<td style="text-align:left;">
			<div style="white-space: nowrap;"><!-- 좌측상단 메인 메뉴 -->
				<a href="#" class="easyui-menubutton" menu="#basicDivision" iconCls="icon-database-edit"><fmt:message key="menu.basicDivision"/></a>
				<a href="#" class="easyui-menubutton" menu="#qualityDivision" iconCls="icon-candlestickchart"><fmt:message key="menu.qualityDivision"/></a>
				<a href="#" class="easyui-menubutton" menu="#productMgmt" iconCls="icon-brick"><fmt:message key="menu.productDivision"/></a>
				<a href="#" class="easyui-menubutton" menu="#materialMgmt" iconCls="icon-basket"><fmt:message key="menu.materialDivision"/></a>
			    <a href="#" class="easyui-menubutton" menu="#humanMgmt" iconCls="icon-group"><fmt:message key="menu.employeeDivision"/></a>
			    <a href="#" class="easyui-menubutton" menu="#custMgmt" iconCls="icon-lorry"><fmt:message key="menu.custDivision"/></a>
			</div>
		</td>
		<td style="text-align:right;">
			<div style="white-space: nowrap;"><!-- 우측 상단. 제어판 기능. (홈버튼,언어선택, 개인설정, 로그아웃) -->
				<a href="?locale=ko_KR" class="easyui-linkbutton" iconCls="icon-flag-kr" plain="true"></a>
				<a href="?locale=zh_CN" class="easyui-linkbutton" iconCls="icon-flag-cn" plain="true"></a>
				<a href="?locale=en_US" class="easyui-linkbutton" iconCls="icon-flag-en" plain="true"></a>				
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
    <div iconCls="icon-change-password" href='<c:url value="/changePassword"/>'><fmt:message key="menu.changePassword"/></div>   
</div>

<!-- 기준정보 서브메뉴 -->
<div id="basicDivision" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.items"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/basicDivision/items/itemLocalization"/>'><fmt:message key="menu.itemLocalization"/></div>
	</div>
	</div>	
	<div style="white-space: nowrap;"><fmt:message key="menu.line"/>
	<div style="width:150px;">			
			<div href='<c:url value="/basicDivision/line/lineProcConfigure"/>'><fmt:message key="menu.lineProcConfigure"/></div>
			<div href='<c:url value="/basicDivision/line/processMaster"/>'><fmt:message key="menu.processMaster"/></div>
	</div>	
	</div>
	<div class="menu-sep"></div>  
	<div style="white-space: nowrap;"><fmt:message key="menu.globalSupport"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/basicDivision/global/langSupport"/>'><fmt:message key="menu.multiLangSupport"/></div>
	</div>
	</div>
</div>

<!-- 품질부문 서브메뉴 -->
<div id="qualityDivision" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.qualityManagement"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/qualityDivision/qualityIssue/qualityIssueReg"/>'><fmt:message key="menu.qualityIssueReg"/></div>
			<div href='<c:url value="/qualityDivision/qualityIssue/list"/>'><fmt:message key="menu.qualityIssueList"/></div>
			<div href='<c:url value="/qualityDivision/qualityIssue/ncrManageList"/>'><fmt:message key="menu.qualityNcrManagement"/></div>
			<div href='<c:url value="/qualityDivision/qualityIssue/ncrStatus"/>' ><fmt:message key="menu.qualityNcrStatus"/></div>			
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

<!-- 생산부문 서브메뉴 -->
<div id="productMgmt" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.stockMgmt"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/productDivision/stock/inoutManagement"/>'><fmt:message key="menu.productInoutMgmt"/></div>									
	</div>
	</div>
</div>

<!-- 생산부문 서브메뉴 -->
<div id="materialMgmt" style="width:150px;">
	<div style="white-space: nowrap;"><fmt:message key="menu.stockMgmt"/>      	
	<div style="width:150px;">			
			<div href='<c:url value="/materialDivision/stock/inoutManagement"/>'><fmt:message key="menu.materInoutMgmt"/></div>			
	</div>
	</div>
</div>



