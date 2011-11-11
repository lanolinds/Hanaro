//easyui datagrid column formmatter : function(value,rowData,rowIndex)
function numeric(val){val += '';x = val.split('.');x1 = x[0];	x2 = x.length > 1 ? '.' + x[1] : '';	var rgx = /(\d+)(\d{3})/;	while (rgx.test(x1)) {x1 = x1.replace(rgx, '$1' + ',' + '$2');}	return x1 + x2;}
//ajax callback failure handler : HTTP status 코드를 이용합니다. callback 실패를 처리하고 싶으면 반드시 HTTP status를 설정하십시오.
function handleAjaxError(err){
	var status = err.status;
	if(status===401){//http spec : 401 Unauthorized (Session timeout에 걸리면...)
		$.messager.alert("Session Timeout",$.messager.http401,"warning");
		//window.location.replace('<c:url value="/j_spring_security_logout" />');
	} 
	else if(status===403){//http sepc: 403 Forbidden (권한이 없을때...)
		$.messager.alert("Un Authorized Access",$.messager.http403,"warning");
	} 
	else if(status===404){//http spec: 404 Page Not Found (요청 페이지를 찾을 수 없을때...)
		$.messager.alert("Data Access Error",$.messager.http404,"error");
	}
	else if(status===500){//http spec: 500 Internal server error (서버 내부 에러...)
		$.messager.alert("Data Access Error",$.messager.http500,"error");
	}
	else{
		$.messager.alert("Unknown Error",$.messager.httpUnknown,"error");
	}
	
}
//input file 에서 선택된 파일의 파일명만 추출합니다.
function searchFileName(path){
	var arr=("file:///"+path.replace(/ /gi,"%20").replace(/\\/gi,"/")).split("/");
	return arr[arr.length-1];	
}


	


