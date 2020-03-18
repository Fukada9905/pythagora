var _first_tbody;
var _divide_combo;
var _new_count = 0;

$(document).ready(function(){
	_first_tbody = $('#data_table').html();

	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){

		$("#target_date_from").val($("[name=date_from]").val());
		$("#target_date_to").val($("[name=date_to]").val());

		window.document.output_form.action = "/class/csv/output.php?method=999920" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});

	$(".btn_calc").click(function(){
		getMainData();
	});

});


function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var params = {
		target_date_from:$("[name=date_from]").val(),
		target_date_to:$("[name=date_to]").val()
	};
	
	ajax.setParams('999920','get_main_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(data);
	}).always(function(){
		$(".focus_controls[data-focus-group='master_input']:first").focus();
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}

function setDisplay(data){
	
	var target = $('#data_table tbody');
	var sort_btn = $("#data_table thead th > div");
	
	if(data.length){
		DoSetDisplay(target,data);
		target.find("select.input_controls").each(function(){
			$(this).val($(this).attr("data-default-value"));
		});
		DataTableSetting(1,$('article'));
		$(BTN_OUTPUT).show();
	}
	else{
		$(BTN_OUTPUT).hide();
	}
}


function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = [];
	data.forEach(function (val, index, arr) {
		out.push('<tr data-target-id="'+val.user_id+'">\n');
		out.push('<td>'+functions.clearnull(val.login_date)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.user_id)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.user_name)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.device)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.browser)+'</td>\n');
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
	
}