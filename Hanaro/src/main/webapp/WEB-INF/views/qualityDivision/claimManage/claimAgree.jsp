<!-- 제작일 : 2012. 4. 16.-->
<!-- 제작자 : IP-HDS-->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false"  contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title><fmt:message key="ui.label.claimAction"/></title>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/gray/easyui.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/scripts/easyui/themes/icon.css"/>'/>
	<link rel="stylesheet" href='<c:url value="/resources/styles/app.default.css"/>'/>
	<style type="text/css">
		th {background-color: #FAFAFA;height:23px; font-weight:normal; text-align: left; white-space:nowrap;width: 120px; }
		td {border:1px dotted silver;width:150px;}
		#noLine td {border:0px;}
		input{border:0px;width:150px;}
		select{width:150px;}	
		.LS{color:red;}
		.RW{color:blue;}
		.SW{color:#089B00;}
		.EX{color:#DEA300;}		
	</style>
		
	<script type="text/javascript" src='<c:url value="/resources/scripts/jquery/jquery.latest.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/jquery.easyui.min.js"/>'></script>
	<script type="text/javascript" src='<c:url value="/resources/scripts/easyui/locale/easyui-lang-${pageContext.response.locale.language}.js"/>'></script>
	<script type="text/javascript">
		function agree(){
			$("input[name='procType']").val("");
			$("#frmx").submit();
			opener.searchRegList();
			opener.searchAgreeList();
			self.close();
		}
		function changeClaim(){
			var claim = 0;
			claim = Number($("#claimR").text())/100.0*Number($("select[name='claimRate']").val());
			$("input[name='claim']").val(Number(claim).toFixed(0));
		}
		function agreeCancel(){
			$("input[name='procType']").val("DELETE");
			$("#frmx").submit();
			opener.searchRegList();
			opener.searchAgreeList();			
			self.close();
		}
	</script>
</head>

<body class="easyui-layout" style="min-width: 800px;">
<div region="north" title='<fmt:message key="system.title"/>'  border="false" 
	iconCls="icon-draw-ring" style="height:26px; background-color:#ffffff; overflow: hidden;">
	
</div>
<div region="center" style="padding:15px;">
<table>
	<tr>
		<td colspan="6" style="text-align:left;background-color:#FBF3AF;">
			<span style="font-weight:bold;">
				<c:if test="${claimInfo[0].DATA47=='AGREE'}">
					<font color="blue"><fmt:message key="info.commitClaim"/></font>
				</c:if>
				<c:if test="${claimInfo[0].DATA47=='WAIT'}">
					<font color="blue"><fmt:message key="info.waitClaim"/></font>
				</c:if>				
			</span>
		</td>		
	</tr>
	<tr>
		<th colspan="2" rowspan="2" class="${claimInfo[0].DATA1}" style="width:300px;text-align:center;">
			<span style="font-weight:bold;font-size: 2.3em;">${claimInfo[0].DATA23}</span>
		</th>
		<th colspan="4" style="background-color: #ECECEC;"><b><fmt:message key="ui.label.basicInfo"/></b></th>
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.claimNo'/></span></th>
		<td>${claimInfo[0].DATA2}&nbsp;</td>
		<th><span  class="label-Leader-black" >INVOICE NO</span></th>
		<td>${claimInfo[0].DATA3}&nbsp;</td>		
	</tr>
	<tr>
		<th colspan="2" rowspan="9">
		<div style="width:295px;height:225px;overflow:auto;vertical-align: top;">			
			<table id="noLine">
				<c:if test="${claimInfo[0].DATA37!=''}">
					<c:if test="${claimInfo[0].DATA38.split('/')[0]=='image'}">
						<tr>
							<td><img src="getClaimImg?claimNo=${claimInfo[0].DATA2}&fileType=${claimInfo[0].DATA38}&fileSeq=1" style="width:270px;height:200px;"/></td>
						</tr>
					</c:if>
					<c:if test="${claimInfo[0].DATA38.split('/')[0]!='image'}">
						<tr>
							<td style="width:270px;height:20px;">
							<a href="getClaimFile?claimNo=${claimInfo[0].DATA2}&fileName=${claimInfo[0].DATA37}&fileSeq=1" class="files icon-attach" style="padding:2px 12px;cursor:pointer;">&nbsp;${claimInfo[0].DATA37}</a>
							</td>
						</tr>
					</c:if>											
				</c:if>
				<c:if test="${claimInfo[0].DATA39!=''}">
					<c:if test="${claimInfo[0].DATA40.split('/')[0]=='image'}">
						<tr>
							<td><img src="getClaimImg?claimNo=${claimInfo[0].DATA2}&fileType=${claimInfo[0].DATA40}&fileSeq=2" style="width:270px;height:200px;"/></td>
						</tr>
					</c:if>
					<c:if test="${claimInfo[0].DATA40.split('/')[0]!='image'}">
						<tr>
							<td style="width:270px;height:20px;">
							<a href="getClaimFile?claimNo=${claimInfo[0].DATA2}&fileName=${claimInfo[0].DATA39}&fileSeq=2" class="files icon-attach" style="padding:2px 12px;cursor:pointer;">&nbsp;${claimInfo[0].DATA39}</a>
							</td>
						</tr>
					</c:if>											
				</c:if>
				<c:if test="${claimInfo[0].DATA41!=''}">
					<c:if test="${claimInfo[0].DATA42.split('/')[0]=='image'}">
						<tr>
							<td><img src="getClaimImg?claimNo=${claimInfo[0].DATA2}&fileType=${claimInfo[0].DATA42}&fileSeq=3" style="width:270px;height:200px;"/></td>
						</tr>
					</c:if>
					<c:if test="${claimInfo[0].DATA42.split('/')[0]!='image'}">
						<tr>
							<td style="width:270px;height:20px;">
							<a href="getClaimFile?claimNo=${claimInfo[0].DATA2}&fileName=${claimInfo[0].DATA41}&fileSeq=3" class="files icon-attach" style="padding:2px 12px;cursor:pointer;">&nbsp;${claimInfo[0].DATA41}</a>
							</td>
						</tr>
					</c:if>											
				</c:if>		
				<c:if test="${claimInfo[0].DATA43!=''}">
					<c:if test="${claimInfo[0].DATA44.split('/')[0]=='image'}">
						<tr>
							<td><img src="getClaimImg?claimNo=${claimInfo[0].DATA2}&fileType=${claimInfo[0].DATA44}&fileSeq=4" style="width:270px;height:200px;"/></td>
						</tr>
					</c:if>
					<c:if test="${claimInfo[0].DATA44.split('/')[0]!='image'}">
						<tr>
							<td style="width:270px;height:20px;">
							<a href="getClaimFile?claimNo=${claimInfo[0].DATA2}&fileName=${claimInfo[0].DATA43}&fileSeq=4" class="files icon-attach" style="padding:2px 12px;cursor:pointer;">&nbsp;${claimInfo[0].DATA43}</a>
							</td>
						</tr>
					</c:if>											
				</c:if>
				<c:if test="${claimInfo[0].DATA45!=''}">
					<c:if test="${claimInfo[0].DATA46.split('/')[0]=='image'}">
						<tr>
							<td><img src="getClaimImg?claimNo=${claimInfo[0].DATA2}&fileType=${claimInfo[0].DATA46}&fileSeq=5" style="width:270px;height:200px;"/></td>
						</tr>
					</c:if>
					<c:if test="${claimInfo[0].DATA46.split('/')[0]!='image'}">
						<tr>
							<td style="width:270px;height:20px;">
							<a href="getClaimFile?claimNo=${claimInfo[0].DATA2}&fileName=${claimInfo[0].DATA45}&fileSeq=5" class="files icon-attach" style="padding:2px 12px;cursor:pointer;">&nbsp;${claimInfo[0].DATA45}</a>
							</td>
						</tr>
					</c:if>											
				</c:if>																	
			</table>
		</div>
		</th>
		<th>
			<span  class="label-Leader-black" >
			<c:choose>
				<c:when test="${claimInfo[0].DATA1=='LS'}"><fmt:message key='ui.label.OccurDate'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='RW'}"><fmt:message key='ui.label.reworkDt'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='SW'}"><fmt:message key='ui.label.selectDt'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='EX'}"><fmt:message key='ui.label.changeDt'/></c:when>
			</c:choose>
			</span>
		</th>
		<td>${claimInfo[0].DATA11}</td>
		<th>
			<span  class="label-Leader-black" >
			<c:choose>
				<c:when test="${claimInfo[0].DATA1=='LS'}"><fmt:message key='ui.label.stopTime'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='RW'}"><fmt:message key='ui.label.reworkTime'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='SW'}"><fmt:message key='ui.label.selectTime'/></c:when>
				<c:when test="${claimInfo[0].DATA1=='EX'}"><fmt:message key='ui.label.changeTime'/></c:when>
			</c:choose>
			</span>
		</th>
		<td>${claimInfo[0].DATA16}</td>		
	</tr>
	<tr>		
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Car'/></span></th>
		<td>${claimInfo[0].DATA13}&nbsp;</td>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.Model'/></span></th>
		<td>${claimInfo[0].DATA24}&nbsp;</td>		
	</tr>	
	<tr>		
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.refTeam'/></span></th>
		<td>${claimInfo[0].DATA25}&nbsp;</td>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.workerCount'/></span></th>
		<td>${claimInfo[0].DATA15}&nbsp;</td>		
	</tr>
	<tr>		
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.writeDt'/></span></th>
		<td>${claimInfo[0].DATA18}&nbsp;</td>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.writer'/></span></th>
		<td>${claimInfo[0].DATA26}&nbsp;</td>		
	</tr>		
	<tr>
		<th colspan="4" style="background-color: #ECECEC;"><b><fmt:message key="ui.label.addInfo"/></b></th>	
	</tr>
	<c:choose>
		<c:when test="${claimInfo[0].DATA1=='LS'}">
			<tr>		
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.productPartNo'/></span></th>
				<td>${claimInfo[0].DATA31}&nbsp;</td>
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.productPartNm'/></span></th>
				<td>${claimInfo[0].DATA32}&nbsp;</td>
			</tr>		
			<tr>		
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.startTime'/></span></th>
				<td>${claimInfo[0].DATA33}&nbsp;</td>
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.endTime'/></span></th>
				<td>${claimInfo[0].DATA34}&nbsp;</td>		
			</tr>			
			<tr>		
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.restTimeStart'/></span></th>
				<td>${claimInfo[0].DATA35}&nbsp;</td>
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
				<td>${claimInfo[0].DATA36}&nbsp;</td>		
			</tr>
			<tr>		
				<th><span  class="label-Leader-red" ><fmt:message key='ui.label.type'/></span></th>
				<td colspan="3">${claimInfo[0].DATA30}&nbsp;</td>
			</tr>									
		</c:when>
		<c:when test="${claimInfo[0].DATA1=='RW'}">
			<tr>		
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.productPartNo'/></span></th>
				<td>${claimInfo[0].DATA31}&nbsp;</td>
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.productPartNm'/></span></th>
				<td>${claimInfo[0].DATA32}&nbsp;</td>
			</tr>
			<tr>		
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.productCount'/></span></th>
				<td>${claimInfo[0].DATA33}&nbsp;</td>
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.QualityIssue.OccurLine'/></span></th>
				<td>${claimInfo[0].DATA30}&nbsp;</td>
			</tr>
			<tr>		
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workCost'/></span></th>
				<td>${claimInfo[0].DATA34}&nbsp;</td>
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workType'/></span></th>
				<td>${claimInfo[0].DATA36}&nbsp;</td>
			</tr>									
			<tr>		
				<th><span  class="label-Leader-blue" ><fmt:message key='ui.label.workContent'/></span></th>
				<td colspan="3">${claimInfo[0].DATA35}&nbsp;</td>
			</tr>																											
		</c:when>
		<c:when test="${claimInfo[0].DATA1=='SW'}">
			<tr>		
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.productPartNo'/></span></th>
				<td>${claimInfo[0].DATA31}&nbsp;</td>
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.productPartNm'/></span></th>
				<td>${claimInfo[0].DATA32}&nbsp;</td>		
			</tr>
			<tr>		
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.selectCount'/></span></th>
				<td>${claimInfo[0].DATA30}&nbsp;</td>
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.workCost'/></span></th>
				<td>${claimInfo[0].DATA33}&nbsp;</td>		
			</tr>
			<tr>		
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.selectType'/></span></th>
				<td>${claimInfo[0].DATA35}&nbsp;</td>
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.workType'/></span></th>
				<td>${claimInfo[0].DATA36}&nbsp;</td>		
			</tr>	
			<tr>		
				<th><span  class="label-Leader-green" ><fmt:message key='ui.label.workContent'/></span></th>
				<td colspan="3">${claimInfo[0].DATA34}&nbsp;</td>
			</tr>																					
		</c:when>
		<c:when test="${claimInfo[0].DATA1=='EX'}">
			<tr>		
				<th><span  class="label-Leader-orange" ><fmt:message key='ui.label.startTime'/></span></th>
				<td>${claimInfo[0].DATA31}&nbsp;</td>
				<th><span  class="label-Leader-orange" ><fmt:message key='ui.label.endTime'/></span></th>
				<td>${claimInfo[0].DATA32}&nbsp;</td>		
			</tr>			
			<tr>		
				<th><span  class="label-Leader-orange" ><fmt:message key='ui.label.restTimeStart'/></span></th>
				<td>${claimInfo[0].DATA33}&nbsp;</td>
				<th><span  class="label-Leader-orange" ><fmt:message key='ui.label.restTimeEnd'/></span></th>
				<td>${claimInfo[0].DATA34}&nbsp;</td>		
			</tr>
			<tr>		
				<th><span  class="label-Leader-orange" ><fmt:message key='ui.label.QualityIssue.OccurLine'/></span></th>
				<td colspan="3">${claimInfo[0].DATA30}&nbsp;</td>
			</tr>			
		</c:when>
	</c:choose>	
</table>
<form action="prodRealClaimAgree" method="post" id="frmx" >
<table>
	<tr>
		<th colspan="5" style="background-color: #ECECEC;color:blue"><b><fmt:message key="ui.label.claimAction"/></b></th>
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonOrgan'/></span></th>
		<td style="width:300px;">${claimInfo[0].DATA28}&nbsp;
			<input type="hidden" name = "claimNo" value="${claimInfo[0].DATA2}"/>
			<input type="hidden" name = "procType" value=""/>
		</td>
		<th style="width:140px;">&nbsp;</th>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.shareRate'/></span></th>
		<td>
			<select name="claimRate" onchange="javascript:changeClaim();">
				<c:forEach begin="0" end="100" step="10" varStatus="x">
				 	<c:if test="${claimInfo[0].DATA48==x.index}"><option value="${x.index}" selected>${x.index}%</option></c:if>
				 	<c:if test="${claimInfo[0].DATA48!=x.index}"><option value="${x.index}">${x.index}%</option></c:if>
				</c:forEach>
			</select>
		</td>		
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartNo'/></span></th>
		<td style="width:300px;">${claimInfo[0].DATA9}&nbsp;</td>
		<th style="width:140px;">&nbsp;</th>
		<th><span  class="label-Leader-black" >LOT NO</span></th>
		<td>${claimInfo[0].DATA21}&nbsp;</td>
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.qualityIssue.reasonPartName'/></span></th>
		<td style="width:300px;">${claimInfo[0].DATA10}&nbsp;</td>
		<th style="width:140px;">&nbsp;</th>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimCost'/></span></th>
		<td id="claimR">${claimInfo[0].DATA4}&nbsp;</td>
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.claimContent'/></span></th>
		<td colspan="4">${claimInfo[0].DATA12}&nbsp;</td>
	</tr>
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.analyConten'/></span></th>
		<td colspan="4">
		<textarea rows="3" cols="102" name="analyCon">${claimInfo[0].DATA49}&nbsp;</textarea>
		</td>
	</tr>	
	<tr>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.ing'/></span></th>
		<td>
		<select name="stateIng">
			<option value="AGREE" <c:if test="${claimInfo[0].DATA47=='AGREE'}">selected</c:if>><fmt:message key="ui.label.approver"/></option>
			<c:if test="${claimInfo[0].DATA47!='AGREE'}">
			<option value="WAIT" <c:if test="${claimInfo[0].DATA47=='WAIT'}">selected</c:if>><fmt:message key="ui.label.wait"/></option>
			</c:if>
		</select>
		</td>
		<th style="width:140px;">&nbsp;</th>
		<th><span  class="label-Leader-black" ><fmt:message key='ui.label.totalCLaim'/></span></th>
		<td><input type="text" style="color:red;" value="${claimInfo[0].DATA50}" name="claim" readonly/></td>		
	</tr>						
</table>
<br>
<br>
<c:if test="${cLocale=='KR'}">
<div style="width:870px;text-align:center;">
	<c:if test="${own=='own'}">
	<a  href="#" class="easyui-linkbutton" iconCls="icon-disk" onclick="javascript:agree();"><fmt:message key="ui.button.Save"/></a>
	<c:if test="${claimInfo[0].DATA47=='AGREE' || claimInfo[0].DATA47=='WAIT' }">
	<a  href="#" class="easyui-linkbutton" iconCls="icon-arrow-redo" onclick="javascript:agreeCancel();"><fmt:message key="ui.label.cancelAction"/></a>
	</c:if>
	</c:if>
	<a  href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:self.close();"><fmt:message key="ui.button.close"/></a>
</div>
</c:if>
</form>


</div>
</body>

</html>
