var _first_tbody;
var _divide_combo;
var _new_count = 0;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	$(document).on("click",".btn_delete",function(){
		DoUpdate($(this).attr("data-target-id"));
	});
	getMainData();
});


function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	ajax.setParams('999910','get_main_data',{});
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
	}
}


function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = [];
	data.forEach(function (val, index, arr) {
		out.push('<tr data-target-id="'+val.user_id+'">\n');
		out.push('<td class="ta_center" style="width:100px;"><button type="button" class="btn btn_delete" data-target-id="'+val.user_id+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>解除</button></td>\n');
		out.push('<td>'+functions.clearnull(val.user_id)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.function_name)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.remote_ip)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.device)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.browser)+'</td>\n');
		out.push('<td>'+functions.clearnull(val.login_datetime)+'</td>\n');
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
	
}


function DoUpdate(user_id){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var ajax = new Ajax();
	ajax.setParams('999910','update_data',{"target_user_id":user_id});
	
	$.when(
		ajax.getData(true)
	).done(function(data){
		$(".refine").val("");
		getMainData();
	}).fail(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}