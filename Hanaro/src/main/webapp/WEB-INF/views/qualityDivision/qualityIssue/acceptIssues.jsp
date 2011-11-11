<!-- 제작일 : 2011. 10. 31.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<<jsp:useBean id="today" class="java.util.Date"></jsp:useBean>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>품질문제 처리</title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
	.simple-table  th {background-color: #FAFAFA;height:24px; font-weight:normal; text-align: left; white-space:nowrap;width: 100px; }
	.simple-table  td {border:1px dotted silver;}
	a.icon-page-attach {text-decoration: none;padding-left:16px;}
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	
	$(document).ready(function(){
		
		//클래임 리스트 랜더링.
		$("#claimList").datagrid({queryParams:{approvalNo:"${approval.approvalNo}"}});
		
		//다이얼로드 랜더링.
		$("#claimPartnerDlg").dialog({buttons:[{text:"저장",iconCls:"icon-disk",handler:function(){
			validateClaimForm();
		}},{text:"취소",iconCls:"icon-cancel",handler:function(){
			$("#claimPartnerDlg").dialog("close");
		}}]});
		
		//불량현상 콤보트리 랜더링.
		$("#defects").combotree({onBeforeSelect:function(node){
			if(!$("#defects").combotree("tree").tree("isLeaf",node.target)){
				return false;
			}
		},onSelect:function(node){
			var names=[];
			var p = $("#defects").combotree("tree").tree("getParent",node.target);
			var gp = $("#defects").combotree("tree").tree("getParent",p.target);
			names.push(gp.text);
			names.push(p.text);
			names.push(node.text);
			$("form[name='approvalForm'] input[name='reason1']").val(gp.id);
			$("form[name='approvalForm'] input[name='reason2']").val(p.id);
			$("#finalDefects").text(names.join(" > "));
			$("#defects").combotree("tree").tree("expandTo",node.target);
		}});
		
		//4m 콤보트리 랜더링.
		$("#claim4m").combotree({onBeforeSelect:function(node){
			if(!$("#claim4m").combotree("tree").tree("isLeaf",node.target)){
				return false;
			}
		},onSelect:function(node){
			var names=[];
			var p = $("#claim4m").combotree("tree").tree("getParent",node.target);
			var gp = $("#claim4m").combotree("tree").tree("getParent",p.target);
			names.push(gp.text);
			names.push(p.text);
			names.push(node.text);
			$("form[name='claimForm'] input[name='reason1']").val(gp.id);
			$("form[name='claimForm'] input[name='reason2']").val(p.id);
			$("#claim4mLabels").text(names.join(" > "));
			$("#claim4m").combotree("tree").tree("expandTo",node.target);
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
	
	function addNewClaimPartner(){
		openClaimDlg();
	}
	
	function editClaim(){
		
		var selected =$("#claimList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		openClaimDlg(selected);
	}
	
	function openClaimDlg(data){
		var $form = $("form[name='claimForm']");
		$form[0].reset();
		if(data){
			$(" input[name='action']",$form).val("edit");
			$("#claimPartner").combobox("setValue",data.code).combobox("disable"); //업체바인딩.
			$("input[name='claimRate']",$form).numberspinner("setValue",data.rate);//요율바인딩.
			$("input[name='claimItem']",$form).val(data.item); //원인품번 바인딩.
			$("input[name='claimLot']",$form).val(data.lot); //로트 바인딩.
			$("#claim4m").combotree("setValue",data.reason3);//4m바인딩.
			$("textarea[name='claimRemark']",$form).val(data.remark);//귀책 원인 바인딩.
			if(data.pic1){
				$("#pic1Link",$form).attr("href","acceptIssues/downloadClaimRef?id="+data.pic1).show();
			}
			else{
				$("#pic1Link",$form).hide();
			}
			if(data.pic2){
				$("#pic2Link",$form).attr("href","acceptIssues/downloadClaimRef?id="+data.pic2).show();
			}
			else{
				$("#pic2Link",$form).hide();
			}
			if(data.ref){
				$("#refLink",$form).attr("href","acceptIssues/downloadClaimRef?id="+data.ref).show();
			}
			else{
				$("#refLink",$form).hide();
			}
			if(data.ncr){
				$(":radio[value='Y']",$form).attr("checked",true);
			}
			$("#ncrNo").text(data.ncr);
			$("#reqDate").datebox("setValue",data.reqDate);//ncr 요청일 바인딩.
			$("textarea[name='request']",$form).val(data.request);//귀책 원인 바인딩.	
		}
		else{
			$(" input[name='action']",$form).val("add");
			$("#claim4mLabels").text("");
			$("#ncrNo").text("");
			$("#claimPartner").combobox("enable").combobox("clear"); 
			$("#reqDate").datebox("setValue",""); 
			$("#claim4m").combotree("clear");//4m바인딩.
		}
		$("#claimPartnerDlg").dialog("open");
	}
	
	function getClaimRateSum(action){
		var rows =$("#claimList").datagrid("getRows");
		var exceptIndex = -1;
		if(action=="edit"){
			 exceptIndex = $("#claimList").datagrid("getRowIndex",$("#claimList").datagrid("getSelected"));
		}
		var rateSum = 0;
		$.each(rows,function(i,row){
			if(exceptIndex !==i)
				rateSum += Number(row.rate);
		});
		return rateSum;
	}
	
	function deleteClaim(){
		var selected =$("#claimList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		$("form[name='claimForm'] input[name='action']").val("delete");
		$("#claimPartner").combobox("setValue",selected.code); //업체바인딩.
		$("form[name='claimForm']").submit();
	}
	
	function validateApprovalForm(){
		$("form[name='approvalForm']").submit();
	}
	
	function validateClaimForm(){
		
		var action = $("form[name='claimForm'] input[name='action']").val();
		
		
		if(action=="add"){  // 신규 추가일 경우 귀책처 누락 없게...
			var partner =  $("#claimPartner").combobox("getValue");
			if(partner==""){
				$.messager.alert("Warnning",'귀책처를 선택하세요',"warning");
				return false;
			}
		}
		
		
		//ncr을 발행하면 필히 회신일을 입력 받는다.
		var ncr = $("form[name='claimForm'] :radio:checked").val();
		var date = $("#reqDate").datebox("getValue");
		if(ncr=="Y" && date.length==0){
			$.messager.alert("Warnning",'NCR 대책 회신일을 입력하세요',"warning");
			return false;
		}
		
		//요율의 합은 100을 넘지 않게
		var rate = Number($("form[name='claimForm'] input[name='claimRate']").numberspinner("getValue"));//요율바인딩.
		var rateSum = getClaimRateSum(action)+rate;
		if(rateSum>100){
			$.messager.alert("Warnning",'요율은 100%를 넘을 수 없습니다.',"warning");
			return false;
		}
		
		$("#claimPartner").combobox("enable");	
		$("form[name='claimForm']").submit();
	}
	
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

<div id="issueDetails" class="easyui-panel" title="등록정보" iconCls="icon-document-info" style="width:1000px;height:auto;padding:2px;">

<table class="simple-table" style="width:100%;">
<tr>
<th>등록번호</th>
<td style="width:200px;"><span id="regNo">${issue.regNo }</span></td>
<th>출처</th>
<td><span id="origin">${issue.origin}</span></td>
</tr>
<tr>
<th>발생일시</th>
<td><span id="when">${issue.when}</span></td>
<th>발생처</th>
<td><span id="place">${issue.place}</span></td>
</tr>
<tr>
<th>조립라인</th>
<td><span id="line">${issue.line}</span></td>
<th>공정</th>
<td><span id="proc">${issue.proc }</span></td>
</tr>
<tr>
<th>품번(차종/기종)</th>
<td><span id="item">${issue.item }&nbsp;&nbsp;(${issue.car }/${issue.model})</span></td>
<th>품명</th>
<td><span id="name">${issue.name }</span></td>
</tr>
<tr>
<th>로트</th>
<td><span id="lot">${issue.lot}</span></td>
<th>예상귀책처</th>
<td><span id="causePartner">${issue.causePartner}</span></td>
</tr>
<tr>
<th>수량</th>
<td><span id="count">${issue.count}</span></td>
<th>단가</th>
<td><span id="price">${issue.price}</span></td>
</tr>
<tr>
<th>현상</th>
<td colspan="3"><span id="reasons">${issue.defects}</span></td>
</tr>
<tr>
<th>설명</th>
<td colspan="3"><span id="comment">${issue.comment}</span></td>
</tr>
<tr>
<th>첨부</th>
<td colspan="3" >
<span id="attached">
<c:if test="${issue.ref1 != null and issue.ref1 ne '' }">
<a class='icon-page-attach' href='acceptIssues/downloadFile?seq=1&no=${issue.regNo}&name=${issue.ref1 }'>${issue.ref1 }</a>
</c:if>
<c:if test="${issue.ref2 != null and issue.ref2 ne '' }">
<a class='icon-page-attach' href='acceptIssues/downloadFile?seq=2&no=${issue.regNo}&name=${issue.ref2 }'>${issue.ref2 }</a>
</c:if>
</span>
</td>
</tr>
</table>	
</div>
<br/>
<div id="actionPanel" class="easyui-panel" style="width:1000px;height:auto;" title="최종처리내역" iconCls="icon-page-lightning">
<form name="approvalForm" action="approval" method="post">
<input type="hidden" name="regNo" value="${issue.regNo}"></input>
<table class="simple-table" style="width:100%;">
<tr>
<th>처리번호</th>
<td style="padding:4px;"><input type="text"  name="approvalNo"  readonly="readonly" value="${approval.approvalNo }" style="border: none;" /></td>
</tr>
<tr>
<th>최종현상</th>
<td style="padding:4px;">
<input name="reason1"  type='hidden'/>
<input name="reason2"  type='hidden'/>
<input id="defects" name="reason3"  url="acceptIssues/defectTreeCallback" style="width:300px;margin-left:1em;" value='${approval.defect3}'/>
<span id="finalDefects" style="margin-left: 2em;"></span>
</td>
</tr>
<tr>
<th>비고</th>
<td style="padding:4px;">
<textarea id="finalComment" name="approvalRemark" rows="3" cols="100" style="width:99%;">${approval.remark }</textarea>
</td>
</tr>
<tr>
<th>처리방법</th>
<td style="padding 4px;">
<c:forEach var="method" items="${methods}">
<c:choose>
<c:when test="${method.key eq approval.method}">
	<input name="method" type="radio" value="${method.key }" checked='checked' />${method.value}
</c:when>
<c:otherwise>
	<input name="method" type="radio" value="${method.key }" />${method.value}
</c:otherwise>
</c:choose>
</c:forEach>
<span id="workCost" style="margin-left:2em; display:${approval.method eq 'rework'?'inline':'none' };">
재작업요율
<select name="workCost"   class="easyui-combobox" >
<option value=30 ${approval.workCost == 30 ?'selected':''}>즉재작업</option>
<option value=40 ${approval.workCost == 40 ?'selected':''}>부분해체</option>
<option value=50 ${approval.workCost == 50 ?'selected':''}>완전해체</option>
</select>
</span>
<c:if test="${issue.originCode eq 'DA' or issue.originCode eq 'DB' }">
<span id="testCost"  style="margin-left:2em;">
시험(검사)비용 
<select name="testCost"  class="easyui-combobox">
<option value=10000 ${approval.testCost == 10000 ?'selected':''}>일반신뢰성</option>
<option value=100000 ${approval.testCost == 100000 ?'selected':''}>동하중</option>
</select>
</span>
</c:if>
</td>
</tr>
<tr>
<td colspan="2" style="text-align:right;border:none;">
<a href="#" iconCls="icon-accept" class="easyui-linkbutton"  onclick="javascript:validateApprovalForm()">적용</a>
</td>
</tr>
</table>
</form>
</div>
<br/>
<table id="claimList" title="귀책처 리스트" iconCls="icon-table-money" rownumbers="true" fitColumns="true"
url="acceptIssues/claimListGridCallback" showFooter="true" toolbar="#claimToolbar" style="width:1000px;height:200px;" singleSelect="true" >
<thead>
<tr>
<th field="code" width="50">코드</th>
<th field="name" width="150">귀책처</th>
<th field="item" width="150">원인품번</th>
<th field="car" width="50" align="center">차종</th>
<th field="model" width="50" align="center">기종</th>
<th field="lot" width="100"  align="center">로트</th>
<th field="reason1" width="100" hidden="true">4M1차</th>
<th field="reason2" width="100" hidden="true">4M2차</th>
<th field="reason3" width="100" hidden="true">4M3차</th>
<th field="rate" width="50" align="right;">분담율</th>
<th field="claim" width="100" align="right;">금액</th>
<th field="remark" width="150" hidden="true" >원인</th>
<th field="pic1" width="100" hidden="true">사진1</th>
<th field="pic2" width="100" hidden="true">사진2</th>
<th field="ref" width="100" hidden="true">참조</th>
<th field="ncr" width="100" align="center;" hidden="true">NCR</th>
<th field="reqDate" width="100" align="center;" hidden="true">대책회신일</th>
<th field="request" width="150" hidden="true">요청사항</th>
</tr>
</thead>
</table>

</div>
<div id="claimToolbar" style="text-align:right;">
<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:addNewClaimPartner();">추가</a>
<a href="#" class="easyui-linkbutton" iconCls="icon-page-edit" plain="true" onclick="javascript:editClaim();">수정</a>
<a href="#" class="easyui-linkbutton" iconCls="icon-bin-closed" plain="true" onclick="javascript:deleteClaim();">삭제</a>
</div>

<div id="claimPartnerDlg" closed="true" title="귀책처 변경" iconCls="icon-page-edit" style="width:610px;height:440px;" modal="true">
<form name="claimForm" action="updateClaim" method="post" enctype="multipart/form-data">
<input type="hidden" name="action"></input>
<input type="hidden" name="regNo" value="${issue.regNo}"></input>
<input type="hidden" name="approvalNo" value="${approval.approvalNo }"></input>
<table class="simple-table" style="margin-top:6px; width:100%;">
<tr>
<th>업체</th>
<td style="width:300px;">
<select name="claimPartner" id="claimPartner" class="easyui-combobox" style="width:200px;">
<option value='' selected="selected">선택</option>
<c:forEach var="partner" items="${partners}">
<option value="${partner.custCode}">${partner.custName }</option>
</c:forEach>
</select>
</td>
<th>요율</th>
<td>
<input name="claimRate"  min="10" max="100" increment="5" value="10" class="easyui-numberspinner" style="width:200px;text-align:right;"></input>
</td>
</tr>
<tr>
<th>원인품번</th>
<td>
<input name="claimItem" id="claimItem"  style="width:200px;" ></input>
</td>
<th>로트</th>
<td>
<input name="claimLot"  style="width:200px;" ></input>
</td>
</tr>
<tr>
<th>4M분석</th>
<td colspan="3">
<input name="reason1"  type="hidden"></input>
<input name="reason2"  type="hidden"></input>
<input name="claim4m" id="claim4m"  url="acceptIssues/4mTreeCallback" style="width:200px;"/>
<span id="claim4mLabels" style="margin-left:2em;"></span>
</td>
</tr>
<tr>
<th>설명</th>
<td colspan="3">
<textarea name="claimRemark" style="width:99%;" rows="3"></textarea>
</td>
</tr>
<tr>
<th>사진1</th>
<td colspan="3">
<input type="file" name="pic1"></input> 
<a href="#" id="pic1Link"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;">다운로드</a>
</td>
</tr>
<tr>
<th>사진2</th>
<td colspan="3">
<input type="file" name="pic2"></input>
<a href="#" id="pic2Link"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;">다운로드</a>
</td>
</tr>
<tr>
<th>참조</th>
<td colspan="3">
<input type="file" name="ref"></input>
<a href="#" id="refLink"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;">다운로드</a>
</td>
</tr>
<tr>
<th>NCR</th>
<td>
<input type="radio" name="ncr" value="N" checked="checked"/>미발행
<input type="radio" name="ncr" value="Y" />발행<span id="ncrNo" style="margin-left:1em;color:blue;"></span>
</td>
<th>회신일</th>
<td>
<input name = "reqDate" id="reqDate"  type="text"  class="easyui-datebox" style="width:100px;" editable="false"></input>
</td>
</tr>
<tr>
<th>요청사항</th>
<td colspan="3">
<textarea name="request"  rows="3" style="width:99%;"></textarea>
</td>
</tr>
</table>
</form>
</div>
</body>
</html>