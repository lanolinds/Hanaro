<!-- 제작일 : 2012. 6. 1.-->
<!-- 제작자 : IP-HDS--> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="menu.localItemManager"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
	.table{border-collapse: collapse;}
	.head{background:#EAEBEB;padding:5px;width:80px;}
	.cnt1{border:1px dotted silver;background-color:#F5F5F5;}
	.table input{border:0px;}
	.table select{border:0px;width:150px;}
	.blank{width:10px;border:0px;}
	</style>	
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
	function searchList(){		
		var params = {};		
		params.carType = $("#selCar").val();
		params.machineType = $("#selModel").val();
		params.partType = $("input[name='partType']:checked").val();
		params.partCode = $("#txtPartNo").val();
		params.custCode = "";
		params.supplierCode = "";
		$("#resultDataGrid").datagrid("load",params);
	}
	function save(){
		if($("#form").form("validate")){
			var partCode = $("input[name='partNo1']").val()+"-"+$("input[name='partNo2']").val()
			$.getJSON("getPartMasterInfo",{partNo:partCode,t:new Date().getTime()},function(list){
				if(Number(list.length)==0 || $("input[name='prodType']").val()!="INSERT"){
					$("#form").submit();	
				}else{
					$.messager.alert("이미 등록된 품번입니다");
				}
			});
		}else{
			return false;
		}		
	}
	function noUse(){
		$("input[name='prodType']").val("NOTUSE");
		save();
	}
	
	function use(){
		$("input[name='prodType']").val("USE");
		save();
	}	
	function selectAssyCode(custCode){
		$.getJSON("getLineCodeOption",{custCode:custCode,t:new Date().getTime()},function(list){
			var txtContent = "";
			$.each(list,function(i,cell){
				txtContent+="<option value='"+cell.line_code+"'>"+cell.line_code+"</option>";
			});
			$("select[name='selLineCodeList']").empty().append(txtContent);
		});
	}
	
	function fnonChange(newValue, oldValue){
		$("input[name='partNo1']").val(newValue);
		
	}
	
	function changePartType(value){
		if(value=="1002"){
			$("select[name='selAssyCustRegList']").attr("disabled","disabled");
			$("select[name='selLineCodeList']").attr("disabled","disabled");
			$("input[name='txtAssyCost']").attr("disabled","disabled");
			$("select[name='selAssyCostTypeList']").attr("disabled","disabled");
			$("#selAssyCustRegList").validatebox({required:false});
			$("#selLineCodeList").validatebox({required:false});
			$("#txtAssyCost").validatebox({required:false});
			$("#selAssyCostTypeList").validatebox({required:false});		
		}else{
			$("select[name='selAssyCustRegList']").removeAttr("disabled");
			$("select[name='selLineCodeList']").removeAttr("disabled");
			$("input[name='txtAssyCost']").removeAttr("disabled");
			$("select[name='selAssyCostTypeList']").removeAttr("disabled");
			$("#selAssyCustRegList").validatebox({required:true});
			$("#selLineCodeList").validatebox({required:true});
			$("#txtAssyCost").validatebox({required:true});
			$("#selAssyCostTypeList").validatebox({required:true});			
		}
	}
	function resetAll(){
		changePartType("");
		$("#useText").empty();
		$("form")[0].reset();
	}
	
	
	function fnOnClickRow(rowIndex, rowData){
		var partCode = rowData.part_no;
		$.getJSON("getPartMasterInfo",{partNo:partCode,t:new Date().getTime()},function(list){
			$.each(list,function(i,cell){
				$("select[name='selCateList']").val(cell.part_type);
				$("input[name='partNo1']").val(cell.part_no.split('-')[0]);
				$("input[name='partNo2']").val(cell.part_no.split('-')[1]);
				$("select[name='selProductTypeList']").val(cell.class_cd);
				$("input[name='partNm']").val(cell.part_name);
				$("#selCarTypeList").combobox("setValue",cell.car_type);
			    $("select[name='selUnitList']").val(cell.unit);
			    $("#selMachineTypeList").combobox("setValue",cell.machine_type);
			    $("#selColorList").combobox("setValue",cell.p_color);
			    $("input[name='alcCode']").val(cell.alc_code);
			    $("select[name='selCustRegList']").val(cell.cust_code);
			    $("input[name='txtProdCost']").val(cell.prod_cost);
			    $("select[name='selCustCostTypeList']").val(cell.cost_type.substring(0,1));
			    $("select[name='selSupplierRegList']").val(cell.supplier);
			    $("input[name='txtSupplyCost']").val(cell.s_price);
			    $("select[name='selSupplyCostTypeList']").val(cell.cost_type.substring(1,2));
			    
			    $("select[name='selAssyCustRegList']").val(cell.work_line);
			    $("select[name='selLineCodeList']").val(cell.line_code);
			    $("input[name='txtAssyCost']").val(cell.work_cost);
			    $("select[name='selAssyCostTypeList']").val(cell.cost_type.substring(2,3));
			    $("#selRawMaterList").combobox("setValue",cell.p_quality);
			    $("input[name='txtWeight']").val(cell.p_weight);
			    $("input[name='txtBoxQty']").val(cell.box_qty);
			    $("input[name='txtPackQty']").val(cell.pkg_qty);
			    $("#selVesselList").combobox("setValue",cell.vessel_nm);
			    $("input[name='txtSaftyDay']").val(cell.ss_day);
			    $("textarea[name='remark']").val(cell.remark);
			    $("input[name='prodType']").val("UPDATE");
			    changePartType(cell.part_type);
			    
			    if(cell.deleted =="Y"){
			    	$("#useText").css("color","red").empty().append("<fmt:message key='ui.label.disable'/>");
			    	
			    }else{
			    	$("#useText").css("color","blue").empty().append("<fmt:message key='ui.label.enable'/>");
			    }
			    
			});
		});		
	}
	
	$(document).ready(function(){
		selectAssyCode("");
		$("select[name='selMachineTypeList']").combobox({onChange:fnonChange});
		$("#resultDataGrid").datagrid({onClickRow:fnOnClickRow});  
	});
	</script>
</head>

<body class="easyui-layout" style="min-width: 1024px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:80px; background-color:#fafafa; overflow: hidden;">
<%@ include file="/WEB-INF/views/menu.jsp" %>
</div>
<div region="center" style="padding:10px;">
	<div iconCls="icon-text-large-cap" class="easyui-panel" style="width:1150px;height:720px;" title='<fmt:message key="menu.localItemManager"/>'>
	<table>
		<tr>
			<td colspan="2" style="background-color:#E4EBEF;height:50px;padding:0px 15px;">
				<input type="radio" value="1001" name="partType" checked/><fmt:message key="ui.label.product"/>
				<input type="radio" value="1002" name="partType" /><fmt:message key="ui.label.material"/>
				<span style="width:20px;">&nbsp;</span>
				<span  class="label-Leader-blue"><fmt:message key="ui.label.Model"/></span>
				<select id="selModel">
				<option value=""><fmt:message key="ui.element.All"/></option>
					<c:forEach items="${modelList}" var="item">
						<option value="${item.machine_type}">${item.machine_type}</option>
					</c:forEach>
				</select>				
				<span  class="label-Leader-blue"><fmt:message key="ui.label.Car"/></span>
				<select id="selCar">
				<option value=""><fmt:message key="ui.element.All"/></option>
					<c:forEach items="${carList}" var="item">
						<option value="${item.car_type}">${item.car_type}</option>
					</c:forEach>
				</select>				
				<span  class="label-Leader-blue"><fmt:message key="ui.label.customer"/></span>
				<select id="selCust" style="width:150px;">
				<option value=""><fmt:message key="ui.element.All"/></option>
					<c:forEach items="${custList}" var="item">
						<option value="${item.cust_cd}">${item.cust_nm}</option>
					</c:forEach>
				</select>				
				<span  class="label-Leader-blue"><fmt:message key="ui.label.partner"/></span>
				<select id="selSupplier" style="width:120px;">
				<option value=""><fmt:message key="ui.element.All"/></option>
					<c:forEach items="${supplierList}" var="item">
						<option value="${item.cust_cd}">${item.cust_nm}</option>
					</c:forEach>
				</select>
				<span  class="label-Leader-blue"><fmt:message key="ui.label.PartNo"/></span>
				<input type="text" id="txtPartNo" size="30"/>				
				<a  href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();" ><fmt:message key="ui.button.Search"/></a>			
				
			</td>
		</tr>
		<tr>
			<td style="height:610px;width:330px;">
				<table iconCls="icon-application-view-list" style="width:325px;height:610px;margin:0px;" 
				 fit="true" pagination="false"  id="resultDataGrid" singleSelect="true" striped="true"  url="getLocalPartList" >
				<thead>
		        <tr>						        	  
		            <th field="part_no" width="144" sortable="true" align="left"><fmt:message key="ui.label.PartNo" /></th>
		            <th field="car_type" width="70" sortable="true" align="center"><fmt:message key="ui.label.Car" /></th>						      
		            <th field="machine_type" width="70" sortable="true" align="center"><fmt:message key="ui.label.Model" /></th>
  				</tr>
  				</thead> 			
				</table>				
			</td>
			<td style="height:610px;width:820px;padding:10px;vertical-align:text-top;">
				<b>상세현황</b>
				<hr/>
				<form action="localItemManager" method="POST" id="form" name="frm">
				<table class="table">
					<tr>
						<th class="head" style="background-color:#2E4569;color:white;"><fmt:message key="ui.label.cagegory"/></th>
						<td class="cnt1">							
							<select name="selCateList" required="true" class="easyui-validatebox" onchange="javascript:changePartType(this.value)">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${partType}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>
							<input type="hidden" name="prodType" value="INSERT"/>
						</td>
						<td class="blank">&nbsp;</td>
						<th class="head"><fmt:message key="ui.label.PartNo"/></th>
						<td class="cnt1" style="border-right: 0px;"><input type="text" name="partNo1" size="6" readonly style="background-color:#FBEAD9;" /><span style="width:15px;text-align:center;" ><b>-</b></span></td>
						<td colspan="2" class="cnt1" style="border-left: 0px;"><input style="width:360px;" type="text" name="partNo2" size="20" class="easyui-validatebox" required="true" /></td>
					</tr>
					<tr>
						<th class="head"><fmt:message key="ui.label.category"/></th>
						<td class="cnt1">
							<select name="selProductTypeList" required="true" class="easyui-validatebox">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${productType}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>
						</td>
						<td class="blank">&nbsp;</td>
						<th class="head"><fmt:message key="ui.label.PartName"/></th>
						<td colspan="3" class="cnt1" style="border-right: 0px;"><input size="82" type="text" name="partNm"/></td>					
					</tr>
					<tr>
						<th class="head"><fmt:message key="ui.label.Car"/></th>
						<td class="cnt1">
							<select name="selCarTypeList" id="selCarTypeList" class="easyui-combobox" style="width:150px;" required = "true">							
								<c:forEach items="${carList}" var="item">
									<option value="${item.car_type}">${item.car_type}</option>
								</c:forEach>
							</select>
						</td>
						<td class="blank">&nbsp;</td>
						<th class="head"><fmt:message key="ui.label.unit"/></th>
						<td class="cnt1">
							<select name="selUnitList" required="true" class="easyui-validatebox" style="width:80px;">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${unitList}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>
						</td>
						<th class="head"><fmt:message key="ui.label.RegDate"/></th>
						<td class="cnt1"><input size="48" type="text" name="regDate" readonly style="background-color:#FBEAD9;" ></td>							
					</tr>	
					<tr>
						<th class="head"><fmt:message key="ui.label.Model"/></th>
						<td class="cnt1">
							<select name="selMachineTypeList" id="selMachineTypeList" style="width:150px;" required = "true" >
								<option value=""></option>							
								<c:forEach items="${modelList}" var="item">
									<option value="${item.machine_type}">${item.machine_type}</option>
								</c:forEach>
							</select>
						</td>				
						<td class="blank">&nbsp;</td>
						<th class="head"><fmt:message key="ui.label.color"/></th>
						<td class="cnt1">
							<select name="selColorList" id="selColorList" class="easyui-combobox" style="width:80px;" required = "true">							
								<c:forEach items="${colorList}" var="item">
									<option value="${item.p_color}">${item.p_color}</option>
								</c:forEach>
							</select>
						</td>
						<th class="head">ALC CODE</th>
						<td class="cnt1"><input size="48" type="text" name="alcCode"></td>							
					</tr>		
				</table>
				<br/>
				<table>
					<tr>
						<th class="head"><fmt:message key="ui.label.customer"/></th>
						<td class="cnt1" >
						<select name="selCustRegList" style="width:330px;" class="easyui-validatebox" required="true">
						<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${custRegList}" var="item">
									<option value="${item.cust_cd}">${item.cust_nm}</option>
								</c:forEach>
						</select>
						</td>
						<th class="head"><fmt:message key="ui.label.prodCost"/></th>
						<td class="cnt1">
							<input type="text" name="txtProdCost" class="easyui-numberbox" precision="2" value="0.00"style="width:80px;" required="true" />			
						</td>
						<th class="head"><fmt:message key="ui.label.costType"/></th>
						<td class="cnt1">
							<select name="selCustCostTypeList" style="width:80px;" class="easyui-validatebox" required="true">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${costTypeList}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>			
						</td>						
					</tr>
					
					<tr>
						<th class="head"><fmt:message key="ui.label.supplyPlace"/></th>
						<td class="cnt1" >
						<select name="selSupplierRegList" style="width:330px;" class="easyui-validatebox" required="true">
						<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${supplierRegList}" var="item">
									<option value="${item.cust_cd}">${item.cust_nm}</option>
								</c:forEach>
						</select>
						</td>
						<th class="head"><fmt:message key="ui.label.supplierCost"/></th>
						<td class="cnt1">
							<input type="text" name="txtSupplyCost" class="easyui-numberbox" precision="2" value="0.00" style="width:80px;" required="true" />			
						</td>
						<th class="head"><fmt:message key="ui.label.costType"/></th>
						<td class="cnt1">
							<select name="selSupplyCostTypeList" style="width:80px;" class="easyui-validatebox" required="true">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${costTypeList}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>			
						</td>						
					</tr>
					<tr>
						<th class="head"><fmt:message key="ui.label.assyCust"/></th>
						<td class="cnt1" >
						<select name="selAssyCustRegList" id="selAssyCustRegList" style="width:330px;" class="easyui-validatebox" required="true" onchange="javascript:selectAssyCode(this.value);">
						<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${assyCustRegList}" var="item">
									<option value="${item.cust_cd}">${item.cust_nm}</option>
								</c:forEach>
						</select>
						</td>
						<th class="head"><fmt:message key="ui.label.assyCost"/></th>
						<td class="cnt1">
							<input type="text" name="txtAssyCost"  id="txtAssyCost" class="easyui-numberbox" precision="2" value="0.00" style="width:80px;" required="true" />			
						</td>
						<th class="head"><fmt:message key="ui.label.costType"/></th>
						<td class="cnt1">
							<select name="selAssyCostTypeList" id="selAssyCostTypeList" style="width:80px;" class="easyui-validatebox" required="true">
							<option value=""><fmt:message key="ui.element.Select"/></option>
								<c:forEach items="${costTypeList}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>			
						</td>						
					</tr>	
					<tr>
						<th class="head"><fmt:message key="ui.label.lineCode"/></th>
						<td class="cnt1" colspan="5">
							<select name="selLineCodeList" id="selLineCodeList" style="width:330px;">
							</select>									
						</td>
					</tr>									
				</table>
				<br/>
				<table>
					<tr>
						<th class="head"><fmt:message key="ui.label.materQuality"/></th>
						<td class="cnt1">
							<select name="selRawMaterList" id="selRawMaterList" class="easyui-combobox" style="width:150px;" required = "true">							
								<c:forEach items="${materQuality}" var="item">
									<option value="${item.p_quality}">${item.p_quality}</option>
								</c:forEach>
							</select>
						</td>						
						<th class="head"><fmt:message key="ui.label.weight"/></th>
						<td class="cnt1">
							<input type="text" style="width:80px;" name="txtWeight" class="easyui-numberbox" precision="2" value="0.00" required="true" />
						</td>
						<th class="head"><fmt:message key="ui.label.boxQty"/></th>
						<td class="cnt1">
							<input type="text" style="width:80px;" name="txtBoxQty" class="easyui-numberbox"  value="0" required="true"/>
						</td>						
						<th class="head"><fmt:message key="ui.label.pkgQty"/></th>
						<td class="cnt1">
							<input type="text" style="width:80px;" name="txtPackQty" class="easyui-numberbox" value="0" required="true"/>
						</td>
					</tr>
					<tr>
						<th class="head"><fmt:message key="ui.label.vessel"/></th>
						<td class="cnt1">
							<select name="selVesselList" id="selVesselList" class="easyui-combobox" style="width:150px;" required = "true">							
								<c:forEach items="${vessel}" var="item">
									<option value="${item.vessel_nm}">${item.vessel_nm}</option>
								</c:forEach>
							</select>							
						</td>
						<th class="head"><fmt:message key="ui.label.saftyDay"/></th>
						<td class="cnt1" colspan="5">
							<input type="text" style="width:80px;" name="txtSaftyDay" class="easyui-numberbox" precision="2" value="0.00" required="true"/>							
						</td>						
					</tr>
					<tr>
						<th class="head"><fmt:message key="ui.label.remark"/></th>
						<td class="cnt1" colspan="3">
							<textarea name="remark" cols="44" rows="4"></textarea>
						</td>
						<td class="cnt1" colspan="4" id="useText" style="font-size:300%;font-weight:bold;text-align: center;">
						</td>
					</tr>
					<tr>
						<td colspan="8" style="height:50px;" align="center">
							<a  href="#" class="easyui-linkbutton" iconCls="icon-disk" onclick="javascript:save();" ><fmt:message key="ui.button.Save"/></a>
							<a  href="#" class="easyui-linkbutton" iconCls="icon-update" onclick="javascript:use();" ><fmt:message key="ui.label.enable"/></a>
							<a  href="#" class="easyui-linkbutton" iconCls="icon-delete" onclick="javascript:noUse();" ><fmt:message key="ui.label.disable"/></a>
							<a  href="#" class="easyui-linkbutton" iconCls="icon-arrow-redo" onclick="javascript:resetAll();" ><fmt:message key="ui.button.Cancel"/></a>
						</td>
					</tr>
				</table>
				
				</form>
			</td>
		</tr>
	</table>
	</div>
</div>
</body>

</html>
