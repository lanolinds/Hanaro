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
		#form input{width:250px;}
		#form select{width:250px;}
	</style>
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>	
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	
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
		$.messager.alert("24245","424","424");
	}
	
	
	
	
	
		$(document).ready(function(){			
			if('${param.status}'=='success'){
				$.messager.alert("<fmt:message key='ui.label.Result'/>","<fmt:message key='info.Success'/>");		
			}
			occurPartListCallbak("All");
			occurPlaceCombobox();

			 
			
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
				<div iconCls="icon-chart-bar-delete" class="easyui-panel" style="width:400px;height:720px;" title='<fmt:message key="menu.qualityIssueReg"/>'>
					<form:form action="addQualityIssueReg" method="POST"  modelAttribute="qualityIssueRegSheet"  id="form">
						<table>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.RegNo"/></span>
									</td><td>								
									<form:input class="easyui-validatebox" readonly="true"  path="regNo"  id="regNo" />
									<input type="hidden" name="procType" value="INSERT" >
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.Division"/></span>
									</td><td>								
									<form:select path="division"   id='division' class="easyui-validatebox" required='true' >
									   <form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${defectSource }"  />
									</form:select>
								</td>  
							</tr>	
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurSite"/></span>
									</td><td>								
									<form:select class="easyui-validatebox" path="occurSite"  id='occurSite' required='true'  />
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurDate"/></span>
									</td><td>								
									<form:input class="easyui-datebox"  path="occurDate"  required='true'  style="width:250px;"  />
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurAmPm"/></span>
									</td><td>								
									<form:select class="easyui-validatebox" path="occurAmPm"   required='true'  >
										<option value=""><fmt:message key="ui.element.Select"/></option>
										<option value="am">AM</option>
										<option value="pm">PM</option>
									</form:select>
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.OccurHour"/></span>
									</td><td>								
									<form:select class="easyui-validatebox"  path="occurHour"  required='true' >
									<option value=""><fmt:message key="ui.element.Select"/></option>									
											<c:forEach  begin="1" end="12" step="1" varStatus="hour">
												<option value="${hour.count }"> ${hour.count }<fmt:message key="ui.label.Hour"/></option>
											</c:forEach>
									</form:select>
								</td>  
							</tr>				
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPartNo"/></span>
									</td><td>								
									<form:input path="occurPartNo"  id='occurPartNo'   required='true'    style="width:250px;"  />
								</td>  
							</tr>
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPartNm"/></span>
									</td><td>								
									<input class="easyui-validatebox"  id="occurPartNm" readonly="true" id="occurPartNm"/>
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.Car"/></span>
									</td><td>								
									<form:input class="easyui-validatebox"  path="car"  id="car"  readonly ="true" />
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.Model"/></span>
									</td><td>								
									<input class="easyui-validatebox"  path="model"  id="model"  readonly ="true"  />
								</td>  
							</tr>
							
							
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.PartSupplier"/></span>
									</td><td>								
									<form:select class="easyui-validatebox"  path="partSupplier"  id="partSupplier"/>
								</td>  
							</tr>
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurPlace"/></span>
									</td><td>								
									<form:input  path="occurPlace"  id="occurPlace"    required="true" style="width:250px;"  />
								</td>  
							</tr>
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurLine"/></span>
									</td><td>								
									<form:select  path="occurLine"  id="occurLine"  />
								</td>  
							</tr>
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.OccurProc"/></span>
									</td><td>								
									<form:select  path="occurProc"  id="occurProc"/>
								</td>  
							</tr>			
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.LotNo"/></span>
									</td><td>								
									<form:input class="easyui-validatebox"  path="lotNo"  required="true" />
								</td>  
							</tr>
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectL"/></span>
									</td><td>								
									<form:select class="easyui-validatebox"  path="defectL"  id="defectL"    required="true"  >
										<form:option value=""><fmt:message key='ui.element.Select' /></form:option>
										<form:options items="${defectCode }"  />
									</form:select>
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectM"/></span>
									</td><td>								
									<form:select class="easyui-validatebox"  path="defectM" id="defectM"    required="true" />
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectS"/></span>
									</td><td>								
									<form:select class="easyui-validatebox"  path="defectS" id="defectS"    required="true" />
								</td>  
							</tr>											
							
							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.DefectAmount"/></span>
									</td><td>								
									<form:input class="easyui-numberspinner"  path="defectAmount"    required="true"   min="1"  max="9999999"  increment="1"  style="width:250px;" />
								</td>  
							</tr>										
																	
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.QualityIssue.Explanation"/></span>
									</td><td>								
									<form:input class="easyui-validatebox"  path="explanation"/>
								</td>  
							</tr>
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.File1"/></span>
									</td><td>								
									<form:input class="easyui-validatebox"  path="file1"/>
								</td>  
							</tr>							
							<tr>
								<td>
									<span  class="label-Leader-black" ><fmt:message key="ui.label.File2"/></span>
									</td><td>								
									<form:input class="easyui-validatebox"  path="file2"/>
								</td>  
							</tr>		
							<tr>
								<td colspan='2' align='center'  id="tdButton">										
									<a onclick="javascript:validate();" class="easyui-linkbutton"  iconCls="icon-disk"  id="btInsert"><fmt:message key="ui.button.Save"/></a>																		
									<a onclick="javascript:$('form')[0].reset();" class="easyui-linkbutton"  iconCls="icon-arrow-redo" id="btCancel"><fmt:message key="ui.button.Cancel"/></a>
								</td>
							</tr>															
						</table>
					</form:form>
				</div>
			</td>
			<td>
				<table class="easyui-datagrid" iconCls="icon-application-view-list" style="width:800px;height:720px;" 
				title='<fmt:message key="ui.label.RegList"/>' toolbar="#divSearch">
					<thead>
						        <tr>  
						            <th field="name1" width="50">Col 1</th>  
						            <th field="name2" width="50">Col 2</th>  
						            <th field="name3" width="50">Col 3</th>  
						            <th field="name4" width="50">Col 4</th>  
						            <th field="name5" width="50">Col 5</th>  
						            <th field="name6" width="50">Col 6</th>  
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
		<select  id='searchOccurSite' >
				<option value=''><fmt:message key="ui.element.All"/></option>
		</select>
		 <fmt:message key="ui.label.SearchDate"/>
		<input id="searchStdDt" class="easyui-datebox" style="width:90px;"  value="${today}" />~
		<input id="searchEndDt" class="easyui-datebox" style="width:90px;"  value="${today}" />
		<a class="easyui-linkbutton" iconCls="icon-search" onclick="javascript:searchList();"><fmt:message key="ui.button.Search"/></a>		
		  
     </div>
      <hr/>
     <div style="margin-bottom:5px" align="right"'>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"><fmt:message key="ui.button.Reg"/></a>  
         <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true"><fmt:message key="ui.button.Edit"/></a>           
         <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true"><fmt:message key="ui.button.Delete"/></a>
      </div>

 
 </div>  
</body>

</html>
