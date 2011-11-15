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
	
	 
	//품번에 대한 공급업체를 조회하는 것
	function supplierByPartCode(partCode){
		$.get("supplierOptionByPartCodeCallbak",{partCode:partCode,t: new Date().getTime()},function(map){
			var options="<option value=''>"+"<fmt:message key='ui.element.Select'/>"+"</option>";				
			for(var key in map){
				options+='<option value='+key+'>'+map[key]+'</option>';
			}
			$("#partSupplier").empty().append(options);
		});
		
		
	}	
	
	
	
	//발생품번선택 자동완성(All: 모든품번, 1001 : 완성품, 1002 : 부품)
	function occurPartListCallbak(partType){
		
	    $('#occurPartNo').combogrid({
	    	panelWidth:443,
	        url : 'codePartListForIssueRegCallbak?partType='+partType,
	        columns:[[  
	                  {field:'partNo',title:'<fmt:message key="ui.label.PartNo"/>',width:100},  
	                  {field:'partName',title:'<fmt:message key="ui.label.PartName"/>',width:200},  
	                  {field:'car',title:'<fmt:message key="ui.label.Car"/>',width:60},  
	                  {field:'model',title:'<fmt:message key="ui.label.Model"/>',width:60}  
	              ]],
	        idField:'partNo',  
	        textField:'partNo',
	        mode:'remote',
	        onSelect:function(rowIndex, rowData){	        	
	        	$("#occurPartNm").val(rowData.partName);
	        	$("#car").val(rowData.car);
	        	$("#model").val(rowData.model);
	        	supplierByPartCode(rowData.partNo);
	        }
	     });
	}
	
	//발생처 자동완성
 	function occurPlaceCombobox(){		
	    $('#occurPlace').combobox({
	    	url : "codeCustOptionCallbak?searchType=QISALL",	        
	    	valueField:'custCode',  
	    	textField:'custName',
	        mode:'remote',	        
	        onSelect:function(record){
	        	occurLineProc(record.custCode,"");
	        }
	     });		
	}
	
	//라인코드 / 공정코드 가져오기
	function occurLineProc(custCode,lineCode){
		$.get("codeLineProcOptionCallbak",{custCode:custCode,lineCode:lineCode,t:new Date().getTime()},function(list){
			var options="<option value=''>"+"<fmt:message key='ui.element.Select'/>"+"</option>";
			for(var key in list){
				options += "<option value="+key+">"+list[key]+"</option>";
			}
			if(lineCode==""){
				$("#occurLine").empty().append(options);
				$("#occurProc").empty();
			}else {
				$("#occurProc").empty().append(options);
			}
		});
	}
	
	//불량현상 코드 가져오기
	function defectCode(searchLevel,code){
		$.get("codeDefectCallbak",{searchLevel:searchLevel,code:code,t:new Date().getTime()},function(list){
			var options="<option value=''>"+"<fmt:message key='ui.element.Select'/>"+"</option>";
			for( var key in list){
				options+="<option value="+key+">"+list[key]+"</option>";
			}
			if(searchLevel == 1){
				$("#defectM").empty().append(options);
				$("#defectS").empty();
			}else{
				$("#defectS").empty().append(options);
			}
		});
	}
	
	
	//품질문제 등록 리스트 조회하기
	function searchList(){
		var params = {};
		params.division = $("#searchDivision").val();
		params.occurSite = $("#searchOccurSite").val(); 
		params.stdDt = $("#searchStdDt").datebox("getValue");
		params.endDt=$("#searchEndDt").datebox("getValue");
		$("#resultDataGrid").datagrid("load",params);
		
	}
	
	//품질문제등록 리스트 삭제하기
	function deleteList(){
		var record = $("#resultDataGrid").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		$.messager.confirm("<fmt:message key='info.confirm' />","<fmt:message key='warn.wannaDelete' />",function(r){  
		    if (r){  
				$("input[name='procType']").val("DELETE");
				var form = document.frm;		
				form.regNo.value = record.DATA0;		
				form.occurHour.value=1;
				form.submit();		  
		    }  
		});	
	}
	
	//품질문제등록 내용을 폼에 넣는다.
	function insertForm(){
		var record = $("#resultDataGrid").datagrid("getSelected");
		if(record ==null){
			$.messager.alert("<fmt:message key='warn.infoWarn' />","<fmt:message key='warn.notSelectedItem' />");
			return;
		}
		
		$("#regNo").val(record.DATA0);
		$("input[name='procType']").val("UPDATE");
		$("#division").val(record.DATA20);
		$("#occurSite").empty().append("<option value='"+record.DATA21+"'>"+record.DATA2+"</option>");
		$("#occurDate").datebox('setValue',record.DATA22);		
		$("#occurAmPm").val(record.DATA23);
		$("#occurHour").val(record.DATA24);
		$("#occurPartNo").combogrid("setValue",record.DATA9);
		$("#partSupplier").val(record.DATA25);
		$("#occurPlace").combobox("setValue",record.DATA27);
		$("#occurLine").empty();
		if(record.DATA5 !=null && record.DATA5 !="")
			$("#occurLine").append("<option value'"+record.DATA5+"'>"+record.DATA5+"</option>");
		if(record.DATA28 !=null && record.DATA28 !="")
			$("#occurProc").append("<option value'"+record.DATA28+"'>"+record.DATA6+"</option>");
		$("#lotNo").val(record.DATA11);
		$("#defectL").val(record.DATA29);
		$("#defectM").empty().append("<option value='"+record.DATA30+"'>"+record.DATA14+"</option>");
		$("#defectS").empty().append("<option value='"+record.DATA31+"'>"+record.DATA15+"</option>");
		$("#defectAmount").numberspinner("setValue",record.DATA12);
		$("#explanation").val(record.DATA16);
		$("b",$("#files1").parent()).empty();
		$("b",$("#files2").parent()).empty();
				
		if(record.DATA18 !="")
			$("b",$("#files1").parent()).append("<a  href='getQualityIssueFile?regNo="+record.DATA0+"&fileName="+encodeURIComponent(record.DATA18)+"&fileSeq=1' >"+record.DATA18+"</a>");
		if(record.DATA19 !="")
			$("b",$("#files2").parent()).append("<a  href='getQualityIssueFile?regNo="+record.DATA0+"&fileName="+encodeURIComponent(record.DATA19)+"&fileSeq=2' >"+record.DATA19+"</a>");
		
		
	}
	

	function fileDownImg1(value,rowData){
		var regNo = rowData.DATA0;				
		var format = "";		
		if(value !="")
			format = "<a  href='getQualityIssueFile?regNo="+regNo+"&fileName="+encodeURIComponent(value)+"&fileSeq=1'  class='icon-disk' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>";
		
		return format;
		
	}
	
	function fileDownImg2(value,rowData){
		var regNo = rowData.DATA0;				
		var format = "";		
		if(value !="")
			format = "<a  href='getQualityIssueFile?regNo="+regNo+"&fileName="+encodeURIComponent(value)+"&fileSeq=2'  class='icon-disk' style='padding:2px 12px;cursor:pointer;'>&nbsp;</a>";
		
		return format;
		
	}
	
	
	function resetForm(){
		$('form')[0].reset();
		$('#procType').val('INSERT');
		$('b',$('#files1').parent()).empty();
		$('b',$('#files2').parent()).empty();
	}
	
	
	
	
		$(document).ready(function(){			
			if('${param.status}'=='success'){
				$.messager.alert("<fmt:message key='ui.label.Result'/>","<fmt:message key='info.Success'/>");			
			}
			
			occurPlaceCombobox();
			
			//초기에 사용할수 있는 품번은 없는것으로 한다.
			occurPartListCallbak("NONE");
		
			
			
			$("#occurLine").change(function(){
				occurLineProc($('#occurPlace').combobox("getValue"),$(this).val());
			});
			
			//처리구분 선택시 출처 옵션 변경
			$("#division").change(function(){
				$.get("codeDefectSourceCallback",{parentCode:$(this).val(),t: new Date().getTime()},function(map){
					var options="<option value=''>"+"<fmt:message key='ui.element.Select'/>"+"</option>";				
					for(var key in map){
						options+='<option value='+key+'>'+map[key]+'</option>';
					}
					$("#occurSite").empty().append(options);
				});
			});
			
			//출처 선택시 사용가능한 품번을 선택한다.
			$("#occurSite").change(function(){
				
				var partType = "";
				switch($(this).val())
				{
					case 'CD' : partType = "1001"; break;
					case 'CB' : partType = "1001"; break;
					case 'CC' : partType = "1002"; break;
					default : partType = "ALL"; break;
				}
				occurPartListCallbak(partType);
			});
			
			//조회용 처리구분 선택시 조회용출처옵션 변경
			$("#searchDivision").change(function(){
				$.get("codeDefectSourceCallback",{parentCode:$(this).val(),t: new Date().getTime()},function(map){
					var options="<option value=''>"+"<fmt:message key='ui.element.All'/>"+"</option>";				
					for(var key in map){
						options+='<option value='+key+'>'+map[key]+'</option>';
					}
					$("#searchOccurSite").empty().append(options);
				});
			});
			
			//불량현상 선택시 하위 옵션변경
			$("#defectL").change(function(){
				defectCode(1,$(this).val());
			});
			$("#defectM").change(function(){
				defectCode(2,$(this).val());
			});			
					
		});
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
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:400px;height:725px;" title='<fmt:message key="menu.qualityIssueReg"/>'>
					<form:form action="addQualityIssueReg" method="POST"  modelAttribute="qualityIssueRegSheet"  id="form" name="frm"  enctype="multipart/form-data">
						<table class="groupTable"  >
							<tr>
								<th>
									<span  class="label-Leader-black"  ><fmt:message key="ui.label.RegNo"/></span>
									</th><td>								
									<form:input class="easyui-validatebox" readonly="true"  path="regNo"  id="regNo" />
									<input type="hidden" name="procType" value="INSERT" >
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.Division"/></span>
									</th><td>								
									<form:select path="division"   id="division"  class="easyui-validatebox" required='true' >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${defectSource }"  />
									</form:select>
								</td>  
							</tr>	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurSite"/></span>
									</th><td>								
									<form:select class="easyui-validatebox" path="occurSite"  id='occurSite' required='true'  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurDate"/></span>
									</th><td>								
									<form:input class="easyui-datebox"  path="occurDate"  required='true'  style="width:250px;"  id="occurDate"  editable="false"  />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurAmPm"/></span>
									</th><td>								
									<form:select class="easyui-validatebox" path="occurAmPm"   required='true'   id="occurAmPm">
										<option value=""><fmt:message key="ui.element.Select"/></option>
										<option value="am">AM</option>
										<option value="pm">PM</option>
									</form:select>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurHour"/></span>
									</th><td>								
									<form:select class="easyui-validatebox"  path="occurHour"  required='true'  id="occurHour">
									<option value=""><fmt:message key="ui.element.Select"/></option>									
											<c:forEach  begin="1" end="12" step="1" varStatus="hour">
												<option value="${hour.count }"> ${hour.count }<fmt:message key="ui.label.Hour"/></option>
											</c:forEach>
									</form:select>
								</td>  
							</tr>				
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPartNo"/></span>
									</th><td>								
									<form:input path="occurPartNo"  id='occurPartNo'   required='true'    style="width:250px;"  />
								</td>  
							</tr>
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPartNm"/></span>
									</th><td>								
									<input class="easyui-validatebox"  id="occurPartNm" readonly="true" id="occurPartNm"/>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.Car"/></span>
									</th><td>								
									<form:input class="easyui-validatebox"  path="car"  id="car"  readonly ="true" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.Model"/></span>
									</th><td>								
									<input class="easyui-validatebox"  path="model"  id="model"  readonly ="true"  />
								</td>  
							</tr>
							
							
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.PartSupplier"/></span>
									</th><td>								
									<form:select class="easyui-validatebox"  path="partSupplier"  id="partSupplier"/>
								</td>  
							</tr>
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPlace"/></span>
									</th><td>								
									<form:input  path="occurPlace"  id="occurPlace"    required="true" style="width:250px;"  />
								</td>  
							</tr>
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurLine"/></span>
									</th><td>								
									<form:select  path="occurLine"  id="occurLine"  />
								</td>  
							</tr>
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurProc"/></span>
									</th><td>								
									<form:select  path="occurProc"  id="occurProc"/>
								</td>  
							</tr>			
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.LotNo"/></span>
									</th><td>								
									<form:input class="easyui-validatebox"  path="lotNo"  required="true"  id="lotNo"  />
								</td>  
							</tr>
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectL"/></span>
									</th><td>								
									<form:select class="easyui-validatebox"  path="defectL"  id="defectL"    required="true"  >
										<form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${defectCode }"  />
									</form:select>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectM"/></span>
									</th><td>								
									<form:select class="easyui-validatebox"  path="defectM" id="defectM"    required="true" />
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectS"/></span>
									</th><td>								
									<form:select class="easyui-validatebox"  path="defectS" id="defectS"    required="true" />
								</td>  
							</tr>											
							
							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectAmount"/></span>
									</th><td>								
									<form:input class="easyui-numberspinner" id="defectAmount"  path="defectAmount"    required="true"   min="1"  max="9999999"  increment="1"  style="width:250px;" />
								</td>  
							</tr>										
																	
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.Explanation"/></span>
									</th><td>								
									<form:input class="easyui-validatebox"  id="explanation" path="explanation"/>
								</td>  
							</tr>
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.File1"/></span>
									</th><td>								
									<input type = "file"  id="files1"  name = "files1"  /><br><b></b>
								</td>  
							</tr>							
							<tr>
								<th>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.File2"/></span>
									</th><td>								
									<input  type = "file"  id="files2"  name = "files2"   /><br><b></b>
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
				title='<fmt:message key="ui.label.RegList"/>' toolbar="#divSearch" pagination="true"  id="resultDataGrid" pageSize="30"   singleSelect="true" striped="true"   url="getQualityIssueRegList" >
					<thead frozen="true">
						        <tr>  
						            <th field="DATA0" width="110" sortable="true" align="center"><fmt:message key="ui.label.RegNo" /></th>  
						            <th field="DATA1" width="50" sortable="true" align="center"><fmt:message key="ui.label.OccurDate" /></th>  
						            <th field="DATA2" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurSite" /></th>
						        </tr>
				    </thead>
					<thead>
						        <tr>  				      
						            <th field="DATA3" width="90" sortable="true" align="center"><fmt:message key="ui.label.RegPlace" /></th>  
						            <th field="DATA4" width="90" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurPlace" /></th>
						            <th field="DATA5" width="60" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurLine" /></th>  
						            <th field="DATA6" width="60" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurProc" /></th>  
						            <th field="DATA7" width="40" sortable="true" align="center"><fmt:message key="ui.label.Car" /></th>  
						            <th field="DATA8" width="40" sortable="true" align="center"><fmt:message key="ui.label.Model" /></th>  
						            <th field="DATA9" width="120" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurPartNo" /></th>
						            <th field="DATA10" width="100" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.OccurPartNm" /></th>  
						            <th field="DATA11" width="60" sortable="true" align="center"><fmt:message key="ui.label.LotNo" /></th>  
						            <th field="DATA12" width="70" sortable="true" align="right"  formatter="numeric" ><fmt:message key="ui.label.QualityIssue.DefectAmount" /></th>  
						            <th field="DATA13" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.DefectL" /></th>  
						            <th field="DATA14" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.DefectM" /></th>
						            <th field="DATA15" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.DefectS" /></th>  
						            <th field="DATA16" width="70" sortable="true" align="center"><fmt:message key="ui.label.QualityIssue.Explanation" /></th>  
						            <th field="DATA17" width="80" sortable="true" align="center"><fmt:message key="ui.label.RegDate" /></th>  
						            <th field="DATA18" width="60" sortable="true" align="center"  formatter="fileDownImg1" ><fmt:message key="ui.label.File1"  /></th>  
						            <th field="DATA19" width="60" sortable="true" align="center"  formatter="fileDownImg2" ><fmt:message key="ui.label.File2"  /></th>
						            
						            <c:forEach begin="20"  end="33"  step="1"  varStatus="dataKey">
						            	<th field="DATA"+"${dataKey.count}"  hidden="true"></th>	
						            </c:forEach>
      						  </tr> 
					</thead>
					
				</table>
			</td>
		</tr>
	</table>
</div>

 <div id="divSearch" style="padding:5px;height:auto">
       <div>        
         <fmt:message key="ui.label.QualityIssue.Division"/>
		<select  id='searchDivision' >
		<option value=""><fmt:message key="ui.element.All"/></option>									
				<c:forEach items="${defectSource }"  var="item" >
					<option value="${item.key }"> ${item.value }</option>
				</c:forEach>
		</select>
		 <fmt:message key="ui.label.QualityIssue.OccurSite"/>         
		<select  id='searchOccurSite' style="width:100px;">
				<option value=''><fmt:message key="ui.element.All"/></option>
		</select>
		 <fmt:message key="ui.label.SearchDate"/>
		<input id="searchStdDt" class="easyui-datebox" style="width:90px;"  value="${today}"  />~
		<input id="searchEndDt" class="easyui-datebox" style="width:90px;"  value="${today}"  />
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
