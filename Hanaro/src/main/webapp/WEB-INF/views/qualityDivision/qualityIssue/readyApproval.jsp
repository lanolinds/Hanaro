<!-- 제작일 : 2011. 10. 31.-->
<!-- 제작자 : IP-HJW-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<<jsp:useBean id="today" class="java.util.Date"></jsp:useBean>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
	<title><fmt:message key="menu.qualityIssueProduce"/></title>
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
		$("#claimList").datagrid({
			queryParams:{approvalNo:"${approval.approvalNo}"},
			onLoadSuccess:function(data){
				if(data.total>0){
					$("#claimList").datagrid("selectRow",0);
					editClaim();
				}
				
			}
		});
				
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
		$("#claim4m").combotree({
			onBeforeSelect:function(node){
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
		
		//재사용이면 귀책관련 정보 숨김.
		var action = ("${approval.method}"=="reuse")?"collapse":"expand";
		$("#claimList").datagrid("getPanel").panel(action);
		$("#editPanel").panel(action);
	});
	
	function addNewClaimPartner(){
		bindClaimForEdit();
		$("#claimPartner").combobox("showPanel");
	}
	
	function editClaim(){
		
		var selected =$("#claimList").datagrid("getSelected");
		if(!selected || selected.length===0){
			$.messager.alert("Warnning",'<fmt:message key="warn.notSelectedItem"/>',"warning");
			return false;
		}
		bindClaimForEdit(selected);
	}
	
	function bindClaimForEdit(data){
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
			//$("#claimPartner")
			if(data.pic1){
				$("input[name='pic1id']",$form).val(data.pic1); 
				$("#pic1Link",$form).attr("href","readyApproval/downloadTempClaimRef?id="+data.pic1).show();
			}
			else{
				$("#pic1Link",$form).hide();
			}
			if(data.pic2){
				$("input[name='pic2id']",$form).val(data.pic2);
				$("#pic2Link",$form).attr("href","acceptIssues/downloadClaimRef?id="+data.pic2).show();
			}
			else{
				$("#pic2Link",$form).hide();
			}
			if(data.ref){
				$("input[name='refid']",$form).val(data.ref);
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
			$(".icon-page-attach",$form).hide();
			$("#claim4mLabels").text("");
			$("#ncrNo").text("");
			$("#claimPartner").combobox("enable").combobox("clear"); 
			$("#reqDate").datebox("setValue",""); 
			$("#claim4m").combotree("clear");//4m바인딩.
		}
		
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
		else{
			$("form[name='claimForm'] input[name='action']").val("delete");
			$("#claimPartner").combobox("setValue",selected.code); //업체바인딩.
			$("form[name='claimForm']").submit();
		}
	}
	
	function validateApprovalForm(){
		//최종 납품처는 claim 계산에 반영된다.
		//납품처를 선택하지 않으면 claim이 부여되지 않을 수 있음을 경고한다.
		var finalCausePartner = $("#finalCausePartner").combobox("getValue");
		if(finalCausePartner==""){
			var title = '<fmt:message key="ui.label.editAction"/>';
			var message = '<fmt:message key="question.noCausePartnerExist"/>';
			$.messager.confirm(title,message,function(b){
				if(b)
				{
					$("form[name='approvalForm']").submit();	
				}
			});
		}
		else{
			$("form[name='approvalForm']").submit();
		}
		
	}
	
	function validateClaimForm(){
		
		var action = $("form[name='claimForm'] input[name='action']").val();
		
		
		if(action=="add"){  // 신규 추가일 경우 귀책처,귀책품번, 4m 분석을 반드시 입력받는다. 
			var partner =  $("#claimPartner").combobox("getValue");
			if(partner==""){
				$.messager.alert("Warnning",'<fmt:message key="warn.enterFaultPartner"/>',"warning");
				return false;
			}
			var claimItem = $.trim($("#claimItem").val());
			if(claimItem==""){
				$.messager.alert("Warnning",'<fmt:message key="warn.enterFaultItem"/>',"warning");
				return false;
			}
			var claim4m = $.trim($("#claim4mLabels").text());
			if(claim4m==""){
				$.messager.alert("Warnning",'<fmt:message key="warn.enter4m"/>',"warning");
				return false;
			}
		}
		
		
		//ncr을 발행하면 필히 회신일을 입력 받는다.
		//ncr은 발행만 됨. 발행된 ncr은 라디오 버튼 값을 n으로 수정하여도 적용하지 않음.
		var ncrNo = $.trim($("#ncrNo").text());
		var ncr = (ncrNo=="")?$("form[name='claimForm'] :radio:checked").val():ncrNo;
		var date = $("#reqDate").datebox("getValue");
		if(ncr=="Y" && date.length==0){
			$.messager.alert("Warnning",'<fmt:message key="ui.label.qualityIssue.measureReplyDate"/>'+'<fmt:message key="warn.enterSomething"/>',"warning");
			return false;
		}
		
		//요율의 합은 100을 넘지 않게
		var rate = Number($("form[name='claimForm'] input[name='claimRate']").numberspinner("getValue"));//요율바인딩.
		var rateSum = getClaimRateSum(action)+rate;
		if(rateSum>100){
			$.messager.alert("Warnning",'<fmt:message key="warn.percentError"/>',"warning");
			return false;
		}
		
		$("#claimPartner").combobox("enable");
		$("form[name='claimForm'] :radio:checked").val(ncr);
		$("form[name='claimForm']").submit();
	}
	
	
	function persistApproval(){
		//처리 방법이 재사용이 아니면 귀책처는 반드시 하나 있어야 한다.
		var method = "${approval.method}";
		var claimCount = $($("#claimList").datagrid("getRows")).size();
		if(method!="reuse" && claimCount==0){
			$.messager.alert("Warnning",'<fmt:message key="warn.emptyClaimPartner"/>',"warning");
			return false;
		}
		$("form[name='persistForm']").submit();
	}
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">

<div id="issueDetails" class="easyui-panel" title='<fmt:message key="ui.label.regInfo"/>' iconCls="icon-document-info" style="width:1000px;height:auto;padding:2px;">

<table class="simple-table" style="width:100%;">
<tr>
<th><fmt:message key="ui.label.RegNo"/></th>
<td style="width:200px;"><span id="regNo">${issue.regNo }</span></td>
<th><fmt:message key="ui.label.QualityIssue.OccurSite"/></th>
<td><span id="origin">${issue.origin}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.OccurDate"/></th>
<td><span id="when">${issue.when}</span></td>
<th><fmt:message key="ui.label.QualityIssue.OccurPlace"/></th>
<td><span id="place">${issue.place}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.QualityIssue.OccurLine"/></th>
<td><span id="line">${issue.line}</span></td>
<th><fmt:message key="ui.label.QualityIssue.OccurProc"/></th>
<td><span id="proc">${issue.proc }</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.PartNo"/>(<fmt:message key="ui.label.CarModel"/>)</th>
<td><span id="item">${issue.item }&nbsp;&nbsp;(${issue.car }/${issue.model})</span></td>
<th><fmt:message key="ui.label.PartName"/></th>
<td><span id="name">${issue.name }</span></td>
</tr>
<tr>
<th>LOT</th>
<td><span id="lot">${issue.lot}</span></td>
<th><fmt:message key="ui.label.qualityIssue.tempSupplier"/></th>
<td><span id="causePartner">${issue.causePartner}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.count"/></th>
<td><span id="count">${issue.count}</span></td>
<th><fmt:message key="ui.label.unitPrice"/></th>
<td><span id="price">${issue.price}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.phenomenon"/></th>
<td colspan="3"><span id="reasons">${issue.defects}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.description"/></th>
<td colspan="3"><span id="comment">${issue.comment}</span></td>
</tr>
<tr>
<th><fmt:message key="ui.label.File"/></th>
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
<div id="actionPanel" class="easyui-panel" style="width:1000px;height:auto;" title='<fmt:message key="ui.label.finalActionDescription"/>' iconCls="icon-page-lightning">
<form name="approvalForm" action="reapproval" method="post">
<input type="hidden" name="regNo" value="${issue.regNo}"></input>
<table class="simple-table" style="width:100%;">
<tr>
<th><fmt:message key="ui.label.actionNo"/></th>
<td style="padding:4px;"><input type="text"  name="approvalNo"  readonly="readonly" value="${approval.approvalNo }" style="border: none;" /></td>
</tr>
<tr>
<th><fmt:message key="ui.label.qualityIssue.fixedSupplier"/></th>
<td style="padding:4px;">
<select name="finalCausePartner" id="finalCausePartner" class="easyui-combobox" style="width:200px;">
<option value="" ${approval.causePartner eq '' or approval.causePartner eq null ?'selected':''}><fmt:message key="ui.label.noExist"/></option>
<c:forEach var="supplier" items="${suppliers}">
<option value="${supplier.key}" ${supplier.key eq approval.causePartner ?'selected':''}>${supplier.value }</option>
</c:forEach>
</select>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.fixedPhenomenon"/></th>
<td style="padding:4px;">
<input name="reason1"  type='hidden'/>
<input name="reason2"  type='hidden'/>
<input id="defects" name="reason3"  url="readyApproval/defectTreeCallback" style="width:300px;margin-left:1em;" value='${approval.defect3}'/>
<span id="finalDefects" style="margin-left: 2em;"></span>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.remark"/></th>
<td style="padding:4px;">
<textarea id="finalComment" name="approvalRemark" rows="3" cols="100" style="width:99%;">${approval.remark }</textarea>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.actionType"/></th>
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
<fmt:message key="ui.label.qualityIssue.reworkRate"/>
<select name="workCost"   class="easyui-combobox" >
<option value=30 ${approval.workCost == 30 ?'selected':''}><fmt:message key="ui.label.qualityIssue.recompose"/></option>
<option value=40 ${approval.workCost == 40 ?'selected':''}><fmt:message key="ui.label.qualityIssue.partialDecompose"/></option>
<option value=50 ${approval.workCost == 50 ?'selected':''}><fmt:message key="ui.label.qualityIssue.fullDecompose"/></option>
</select>
</span>
<c:if test="${issue.originCode eq 'DA' or issue.originCode eq 'DB' }">
<span id="testCost"  style="margin-left:2em;">
<fmt:message key="ui.label.qualityIssue.testCost"/>
<select name="testCost"  class="easyui-combobox">
<option value=10000 ${approval.testCost == 10000 ?'selected':''}><fmt:message key="ui.label.qualityIssue.reliableTestCost"/></option>
<option value=100000 ${approval.testCost == 100000 ?'selected':''}><fmt:message key="ui.label.qualityIssue.loadTestCost"/></option>
</select>
</span>
</c:if>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.qualityIssue.fixedClaim"/></th>
<td >
<span id="totalClaim" style="width:800px;display:inline-table;"><fmt:formatNumber minFractionDigits="2" value="${approval.claim }"/></span>
<a href="#" iconCls="icon-accept" class="easyui-linkbutton" onclick="javascript:validateApprovalForm()"><fmt:message key="ui.label.apply"/></a>
</td>
</tr>
</table>
</form>
</div>

<br/>

<div id="editPanel"  title='<fmt:message key="ui.label.qualityIssue.reasonOrgan"/>' iconCls="icon-page-edit" style="width:1000px" class="easyui-panel">
<form name="claimForm" action="updateTempClaim" method="post" enctype="multipart/form-data">
<input type="hidden" name="action"></input>
<input type="hidden" name="regNo" value="${issue.regNo}"></input>
<input type="hidden" name="approvalNo" value="${approval.approvalNo }"></input>
<table class="simple-table" style="margin-top:6px; width:100%;">
<tr>
<th><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th>
<td style="width:300px;">
<select name="claimPartner" id="claimPartner" class="easyui-combobox" style="width:200px;">
<option value='' selected="selected"><fmt:message key="ui.element.Select"/></option>
<c:forEach var="partner" items="${partners}">
<option value="${partner.custCode}">${partner.custName }</option>
</c:forEach>
</select>
</td>
<th><fmt:message key="ui.label.shareRate"/></th>
<td>
<input name="claimRate"  min="10" max="100" increment="5" value="10" class="easyui-numberspinner" style="width:200px;text-align:right;"></input>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.qualityIssue.reasonPartNo"/></th>
<td>
<input name="claimItem" id="claimItem"  style="width:200px;" ></input>
</td>
<th>LOT</th>
<td>
<input name="claimLot"  style="width:200px;" ></input>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.qualityIssue.4mAnalysis"/></th>
<td colspan="3">
<input name="reason1"  type="hidden"></input>
<input name="reason2"  type="hidden"></input>
<input name="claim4m" id="claim4m"  url="readyApproval/4mTreeCallback" style="width:200px;"/>
<span id="claim4mLabels" style="margin-left:2em;"></span>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.description"/></th>
<td colspan="3">
<textarea name="claimRemark" style="width:99%;" rows="3"></textarea>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.picture"/>1</th>
<td colspan="3">
<input type="file" name="pic1"></input><input type="hidden" name="pic1id"></input>  
<a href="#" id="pic1Link"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;"><fmt:message key="ui.label.download"/></a>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.picture"/>2</th>
<td colspan="3">
<input type="file" name="pic2"></input><input type="hidden" name="pic2id"></input>  
<a href="#" id="pic2Link"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;"><fmt:message key="ui.label.download"/></a>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.reference"/></th>
<td colspan="3">
<input type="file" name="ref"></input><input type="hidden" name="refid"></input>  
<a href="#" id="refLink"  class='icon-page-attach' style="margin-left:1em;padding-left16px;display:none;"><fmt:message key="ui.label.download"/></a>
</td>
</tr>
<tr>
<td colspan="4" style="background-color:#9BD200; color:white; padding:4px;">
<p><span class="icon-information" style="padding: 1px 2px 1px 16px;">&nbsp;</span><fmt:message key="info.ncrCausion"/></p>
</td>
</tr>
<tr>
<th>NCR</th>
<td>
<input type="radio" name="ncr" value="N" checked="checked"/><fmt:message key="ui.label.unpublished"/>
<input type="radio" name="ncr" value="Y" /><fmt:message key="ui.label.publish"/><span id="ncrNo" style="margin-left:1em;color:blue;"></span>
</td>
<th><fmt:message key="ui.label.replyDate"/></th>
<td>
<input name = "reqDate" id="reqDate"  type="text"  class="easyui-datebox" style="width:100px;" editable="false"></input>
</td>
</tr>
<tr>
<th><fmt:message key="ui.label.requestContents"/></th>
<td colspan="3">
<textarea name="request"  rows="3" style="width:99%;"></textarea>
</td>
</tr>
<tr style="border:none;">
<td colspan="4" align="right">
<a href='#' class="easyui-linkbutton"  iconCls="icon-accept" onclick="validateClaimForm()"><fmt:message key="ui.label.apply"/></a>
</td>
</tr>
</table>
</form>
</div>
<br/>
<table id="claimList" title='<fmt:message key="ui.label.faultList"/>' iconCls="icon-table-money" rownumbers="true" fitColumns="true"
url="readyApproval/claimListGridCallback" showFooter="true" toolbar="#claimToolbar" style="width:1000px;height:200px;" singleSelect="true" >
<thead>
<tr>
<th field="code" width="50" hidden="true"><fmt:message key="ui.label.code"/></th>
<th field="name" width="150"><fmt:message key="ui.label.qualityIssue.reasonOrgan"/></th>
<th field="item" width="150"><fmt:message key="ui.label.qualityIssue.reasonPartNo"/></th>
<th field="car" width="50" hidden="true"><fmt:message key="ui.label.Car"/></th>
<th field="model" width="50" hidden="true"><fmt:message key="ui.label.Model"/></th>
<th field="lot" width="100"  align="center">LOT</th>
<th field="reason1" width="100" hidden="true"><fmt:message key="ui.label.qualityIssue.4m1"/></th>
<th field="reason2" width="100" hidden="true"><fmt:message key="ui.label.qualityIssue.4m2"/></th>
<th field="reason3" width="100" hidden="true"><fmt:message key="ui.label.qualityIssue.analysisName"/></th>
<th field="rate" width="50" align="right;"><fmt:message key="ui.label.shareRate"/></th>
<th field="remark" width="150" hidden="true" ><fmt:message key="ui.label.reason"/></th>
<th field="pic1" width="100" hidden="true"><fmt:message key="ui.label.picture"/>1</th>
<th field="pic2" width="100" hidden="true"><fmt:message key="ui.label.picture"/>2</th>
<th field="ref" width="100" hidden="true"><fmt:message key="ui.label.reference"/></th>
<th field="ncr" width="100" align="center;" >NCR</th>
<th field="reqDate" width="100" align="center;" hidden="true"><fmt:message key="ui.label.qualityIssue.measureReplyDate"/></th>
<th field="request" width="150" hidden="true"><fmt:message key="ui.label.requestContents"/></th>
<th field="claim" width="100" align="right;"><fmt:message key="ui.label.money"/></th>
</tr>
</thead>
</table>
</br>
<div style="width:1000px;text-align:right; padding:6px 0px;">
<form name="persistForm" action = "persistApproval" method="post">
<input type="hidden" name="approvalNo" value="${approval.approvalNo }"></input>
<input type="hidden" name="regNo" value="${issue.regNo }"></input>
<a href='#' class="easyui-linkbutton"  iconCls="icon-disk" onclick="persistApproval()"><fmt:message key="ui.label.qualityIssue.done"/></a>
<a href='<c:url value="/qualityDivision/qualityIssue/list"/>' class="easyui-linkbutton"  iconCls="icon-application-view-detail"><fmt:message key="ui.label.toList"/></a>
</form>
</div>
</div>

<div id="claimToolbar" style="text-align:right;">
<a href="#editPanel" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:addNewClaimPartner();"><fmt:message key="ui.button.Add"/></a>
<a href="#editPanel" class="easyui-linkbutton" iconCls="icon-pencil" plain="true" onclick="javascript:editClaim();"><fmt:message key="ui.button.Edit"/></a>
<a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="javascript:deleteClaim();"><fmt:message key="ui.button.Delete"/></a>
</div>
</body>
</html>