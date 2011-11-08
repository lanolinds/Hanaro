<!-- 제작일 : 2011. 10. 31.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>품질문제 처리</title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
	.simple-table th {background-color: #FAFAFA;font-weight:normal; text-align: left; white-space:nowrap;width: 100px; }
	.simple-table td {border:1px dotted silver;}
	a.icon-page-attach {text-decoration: none;padding-left:16px;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		//등록대기 리스트 랜더링.
		$("#issueList").datagrid({onSelect:function(i,data){
			var regNo=data.regNo;
			$.getJSON("acceptIssues/issueDetailCallback",{no:regNo},function(data){
				bindIssueDetails(data);
			});	
		}}).datagrid("selectRow",0);
		
		//불량현상 콤보트리 랜더링.
		$("#defects").combotree({onBeforeSelect:function(node){
			if(!$("#defects").combotree("tree").tree("isLeaf",node.target)){
				return false;
			}
		},onSelect:function(node){
			var names=[];
			var codes=[];
			var p = $("#defects").combotree("tree").tree("getParent",node.target);
			var gp = $("#defects").combotree("tree").tree("getParent",p.target);
			names.push(gp.text);
			names.push(p.text);
			names.push(node.text);
			codes.push(gp.id);
			codes.push(p.id);
			codes.push(node.id);
			$("#finalDefects").data("codes", codes).text(names.join(" > "));
			$("#defects").combotree("tree").tree("expandTo",node.target);
		}});
		
		//처리방법에 따라 추가 입력 활성화.
		$(":radio[name='method']").change(function(){
			var method =$(this).val();
			if(method=="rework"){
				$("#workCost").fadeIn();
			}
			else{
				$("#workCost").fadeOut();
			}
			
		});
		
	});
	
	function bindIssueDetails(data){
		$("#regNo").text(data.regNo);
		$("#origin").text(data.origin);
		$("#when").text(data.when);
		$("#place").text(data.place);
		$("#line").text(data.line);
		$("#proc").text(data.proc);
		$("#item").text(data.item+"    ("+data.car+"/"+data.model+")");
		$("#name").text(data.name);
		$("#lot").text(data.lot);
		$("#causePartner").text(data.causePartner);
		$("#count").text(data.count);
		$("#unitPrice").text(data.price);
		$("#reasons").text(data.defects);
		$("#comment").text(data.comment);
		var link1 = data.ref1?"<a class='icon-page-attach' href='acceptIssues/downloadFile?seq=1&no="+data.regNo+"&name="+data.ref1+"'>"+data.ref1+"</a>":"&nbsp;";
		var link2 = data.ref2?"<a class='icon-page-attach' href='acceptIssues/downloadFile?seq=2&no="+data.regNo+"&name="+data.ref1+"'>"+data.ref2+"</a>":"&nbsp;";
		$("#attached").empty().append(link1+"&nbsp;"+link2);
		
		if(!$("#defects").combotree("tree").tree("getSelected"))
		{
			$("#defects").combotree("setValue",data.code);
		}
		
		
	}
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
	<table id="issueList" title="품질 문제 등록 리스트" iconCls="icon-text-list-bullets" 
	style="width:300px;height:260px;" idField="regNo" singleSelect="true" striped="true" rownumbers="true" fitColumns="true">
	<thead>
	<tr>
	<th field="regNo" width="200">등록번호</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="issue" items="${issues }">
	<tr><td>${issue}</td></tr>
	</c:forEach>
	</tbody>
	</table>
</td>
<td>
<div id="issueDetails" class="easyui-panel" title="등록정보" iconCls="icon-document-info" style="width:800px;height:260px;padding:2px;">

<table class="simple-table" style="width:100%;height:100%;">
<tr>
<th>등록번호</th>
<td style="width:200px;"><span id="regNo">&nbsp;</span></td>
<th>출처</th>
<td><span id="origin">&nbsp;</span></td>
</tr>
<tr>
<th>발생일시</th>
<td><span id="when">&nbsp;</span></td>
<th>발생처</th>
<td><span id="place">&nbsp;</span></td>
</tr>
<tr>
<th>조립라인</th>
<td><span id="line">&nbsp;</span></td>
<th>공정</th>
<td><span id="proc">&nbsp;</span></td>
</tr>
<tr>
<th>품번(차종/기종)</th>
<td><span id="item">&nbsp;</span></td>
<th>품명</th>
<td><span id="name">&nbsp;</span></td>
</tr>
<tr>
<th>로트</th>
<td><span id="lot">&nbsp;</span></td>
<th>예상귀책처</th>
<td><span id="causePartner">&nbsp;</span></td>
</tr>
<tr>
<th>수량</th>
<td><span id="count">&nbsp;</span></td>
<th>단가</th>
<td><span id="name">&nbsp;</span></td>
</tr>
<tr>
<th>현상</th>
<td colspan="3"><span id="reasons">&nbsp;</span></td>
</tr>
<tr>
<th>설명</th>
<td colspan="3"><span id="comment">&nbsp;</span></td>
</tr>
<tr>
<th>첨부</th>
<td colspan="3" ><span id="attached">&nbsp;</span></td>
</tr>
</table>	
</div>
</td>
</tr>
<tr>
<td colspan="2">
<div id="actionPanel" class="easyui-panel" style="width:1104px;height:auto;" title="최종처리내역" iconCls="icon-page-lightning">
<table class="simple-table" style="width:100%;">
<tr>
<th>최종현상</th>
<td>
<select id="defects"  url="acceptIssues/defectTreeCallback" multiple="true" style="width:300px;"></select>
<span id="finalDefects" style="margin-left: 2em;"></span>
</td>
</tr>
<tr>
<th>비고</th>
<td style="padding:0px 4px;">
<textarea id="finalComment" rows="3" cols="100" style="width:99%;"></textarea>
</td>
</tr>
<tr>
<th>처리방법</th>
<td>
<c:forEach var="method" items="${methods}">
<c:choose>
<c:when test="${method.key eq 'reuse'}">
	<input style="margin-left:1em;" name="method" type="radio" value="${method.key }" checked='checked' />${method.value}
</c:when>
<c:otherwise>
	<input style="margin-left:1em;" name="method" type="radio" value="${method.key }" />${method.value}
</c:otherwise>
</c:choose>
</c:forEach>
<span id="workCost" style="margin-left:2em;display:none;">
재작업요율
<select name="reworkRate"  class="easyui-combobox">
<option value=30>즉재작업</option>
<option value=40>부분해체</option>
<option value=50>완전해체</option>
</select>
</span>
<c:if test="${place eq 'DA' or place eq 'DB' }">
<span id="testCost"  style="margin-left:2em;">
시험(검사)비용
<select name="reworkRate"  class="easyui-combobox">
<option value=10000>일반신뢰성</option>
<option value=100000>동하중</option>
</select>
</span>
</c:if>
</td>
</tr>
</table>
</div>
</td>
</tr>
</table>
</div>
</body>
</html>