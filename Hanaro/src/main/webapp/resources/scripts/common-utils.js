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

//입력된 파일명의 확장자에 따른 아이콘을 반환한다.
function fileExtensionIcon(fileName){
	if(fileName=="" || fileName ==null){
		return "icon-attach";
	}
	var extension = "";
	var extensionCheck = fileName.split('.')[fileName.split('.').length-1];
	
	switch(extensionCheck.toLowerCase()){
		case '3gp' :extension='3gp';break;
		case '7zb' :extension='7zb';break;
		case 'ace' :extension='ace';break;
		case 'aib' :extension='aib';break;
		case 'aif' :extension='aif';break;
		case 'aiff' :extension='aiff';break;
		case 'amr' :extension='amr';break;
		case 'asf' :extension='asf';break;
		case 'asx' :extension='asx';break;
		case 'bat' :extension='bat';break;
		case 'bin' :extension='bin';break;
		case 'bmp' :extension='bmp';break;
		case 'bup' :extension='bup';break;
		case 'cab' :extension='cab';break;
		case 'cbr' :extension='cbr';break;
		case 'cda' :extension='cda';break;
		case 'cdl' :extension='cdl';break;
		case 'cdr' :extension='cdr';break;
		case 'chm' :extension='chm';break;
		case 'dat' :extension='dat';break;
		case 'divx' :extension='divx';break;
		case 'dll' :extension='dll';break;
		case 'dmg' :extension='dmg';break;
		case 'doc' :extension='doc';break;
		case 'dss' :extension='dss';break;
		case 'dvf' :extension='dvf';break;
		case 'dwg' :extension='dwg';break;
		case 'eml' :extension='eml';break;
		case 'eps' :extension='eps';break;
		case 'exe' :extension='exe';break;
		case 'fla' :extension='fla';break;
		case 'flv' :extension='flv';break;
		case 'gif' :extension='gif';break;
		case 'gzb' :extension='gzb';break;
		case 'hqx' :extension='hqx';break;
		case 'htm' :extension='htm';break;
		case 'html' :extension='html';break;
		case 'ifo' :extension='ifo';break;
		case 'indd' :extension='indd';break;
		case 'iso' :extension='iso';break;
		case 'jar' :extension='jar';break;
		case 'jpeg' :extension='jpeg';break;
		case 'jpg' :extension='jpg';break;
		case 'lnk' :extension='lnk';break;
		case 'log' :extension='log';break;
		case 'm4a' :extension='m4a';break;
		case 'm4b' :extension='m4b';break;
		case 'm4p' :extension='m4p';break;
		case 'm4v' :extension='m4v';break;
		case 'mcd' :extension='mcd';break;
		case 'mdb' :extension='mdb';break;
		case 'mid' :extension='mid';break;
		case 'mov' :extension='mov';break;
		case 'mp2' :extension='mp2';break;
		case 'mp4' :extension='mp4';break;
		case 'mpeg' :extension='mpeg';break;
		case 'mpg' :extension='mpg';break;
		case 'msi' :extension='msi';break;
		case 'mswm' :extension='mswm';break;
		case 'ogg' :extension='ogg';break;
		case 'pdf' :extension='pdf';break;
		case 'png' :extension='png';break;
		case 'pps' :extension='pps';break;
		case 'psb' :extension='psb';break;
		case 'psd' :extension='psd';break;
		case 'pst' :extension='pst';break;
		case 'ptb' :extension='ptb';break;
		case 'pub' :extension='pub';break;
		case 'qbb' :extension='qbb';break;
		case 'qbw' :extension='qbw';break;
		case 'qxd' :extension='qxd';break;
		case 'ram' :extension='ram';break;
		case 'rar' :extension='rar';break;
		case 'rmb' :extension='rmb';break;
		case 'rmvb' :extension='rmvb';break;
		case 'rtf' :extension='rtf';break;
		case 'sea' :extension='sea';break;
		case 'ses' :extension='ses';break;
		case 'sit' :extension='sit';break;
		case 'sitx' :extension='sitx';break;
		case 'ssb' :extension='ssb';break;
		case 'swf' :extension='swf';break;
		case 'tgz' :extension='tgz';break;
		case 'thm' :extension='thm';break;
		case 'tif' :extension='tif';break;
		case 'tmp' :extension='tmp';break;
		case 'torr' :extension='torr';break;
		case 'ttf' :extension='ttf';break;
		case 'txt' :extension='txt';break;
		case 'vcd' :extension='vcd';break;
		case 'vob' :extension='vob';break;
		case 'wav' :extension='wav';break;
		case 'wma' :extension='wma';break;
		case 'wmv' :extension='wmv';break;
		case 'wps' :extension='wps';break;
		case 'xls' :extension='xls';break;
		case 'xpi' :extension='xpi';break;
		case 'zip' :extension='zip';break;
	}
	if(extension!="")
		return "icon-file-extension-"+extension;
	else
		return "icon-attach";
		
}


	


