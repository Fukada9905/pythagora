$(document).ready(function(){
	
	$(".btn_print").click(function(){
		SetCenterToStorage();
		var process_divide = $(this).data("target-process-divide");
		var window_name = "101021_"+process_divide+"_pdf";
		
		$("input[name='params_target_date']").val(getVal("input[name='target_date']"));
		$("input[name='params_date_divide']").val(getVal('input[name=date_divide]'));
		
		window.open("", window_name) ;
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=101021&process_divide=" + process_divide ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
	});
});


function SetCenterToStorage(){
	var params = {
			'101021_SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
		,	'101021_NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	};
	SetParamatersToStorage(params)
}