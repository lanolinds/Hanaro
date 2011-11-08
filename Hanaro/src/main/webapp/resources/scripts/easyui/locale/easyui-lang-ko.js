if ($.fn.pagination){
	$.fn.pagination.defaults.beforePageText = '페이지';
	$.fn.pagination.defaults.afterPageText = '/ {pages}';
	$.fn.pagination.defaults.displayMsg = '총 {total} 중 {from} 부터 {to} 까지 ';
}
if ($.fn.datagrid){
	$.fn.datagrid.defaults.loadMsg = '처리중...';
}
if ($.fn.treegrid && $.fn.datagrid){
	$.fn.treegrid.defaults.loadMsg = $.fn.datagrid.defaults.loadMsg;
}
if ($.messager){
	$.messager.defaults.ok = '확인';
	$.messager.defaults.cancel = '취소';
	$.messager.http401='세션이 만료되었습니다. 다시 로그인 하십시오.';
	$.messager.http403='요청을 처리하기위한 권한이 없습니다.';
	$.messager.http404='요청을 처리할 수 없습니다.';
	$.messager.http500='서버에서 데이터를 처리하던 중 에러가 발생하였습니다.';
	$.messager.httpUnknown='알 수 없는 에러';
	
}
if ($.fn.validatebox){
	$.fn.validatebox.defaults.missingMessage = '값을 입력하세요.';
	$.fn.validatebox.defaults.rules.email.message = '잘못된 메일 주소입니다.';
	$.fn.validatebox.defaults.rules.url.message = '잘못된 주소입니다.';
	$.fn.validatebox.defaults.rules.length.message = '{0} 에서 {1} 사이값을 입력하세요.';
	$.fn.validatebox.defaults.rules.remote.message = '값을 수정하세요.';
}
if ($.fn.numberbox){
	$.fn.numberbox.defaults.missingMessage = '값을 입력하세요.';
}
if ($.fn.combobox){
	$.fn.combobox.defaults.missingMessage = '값을 입력하세요.';
}
if ($.fn.combotree){
	$.fn.combotree.defaults.missingMessage = '값을 입력하세요.';
}
if ($.fn.combogrid){
	$.fn.combogrid.defaults.missingMessage = '값을 입력하세요.';
}
if ($.fn.calendar){
	$.fn.calendar.defaults.weeks = ['일','월','화','수','목','금','토'];
	$.fn.calendar.defaults.months = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
}
if ($.fn.datebox){
	$.fn.datebox.defaults.currentText = '오늘';
	$.fn.datebox.defaults.closeText = '닫기';
	$.fn.datebox.defaults.okText = '확인';
	$.fn.datebox.defaults.missingMessage = '날짜를 입력하세요.';
	// 제공되는 인터페이스로는 포맷을 줄 방법이 없음. 만들어 쓰자.(IP-HJW)
	$.fn.datebox.defaults.formatter=function(date){
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		
		return String(y)+"-"+String(m<10?("0"+String(m)):String(m))+"-"+String(d<10?("0"+String(d)):String(d));
	};
}
if ($.fn.datetimebox && $.fn.datebox){
	$.extend($.fn.datetimebox.defaults,{
		currentText: $.fn.datebox.defaults.currentText,
		closeText: $.fn.datebox.defaults.closeText,
		okText: $.fn.datebox.defaults.okText,
		missingMessage: $.fn.datebox.defaults.missingMessage
	});
}

