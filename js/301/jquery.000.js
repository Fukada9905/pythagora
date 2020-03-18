var _first_tbody;
var _data;
var _new_count = 1;
var _sort_key;
var _sort_order;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}
	
	
	$(BTN_CALC).click(function(){
		_sort_key = null;
		_sort_order = null;
		getMainData();
	});
	
	$(document).on('change',"input[name='all_checks']",function(){
		$('input.dl_checks').prop('checked',$(this).prop('checked'));
	});
	
	$(document).on('change',"input[name='all_det_checks']",function(){
		$('input.send_checks:not(:disabled)').prop('checked',$(this).prop('checked'));
		check_all_inputs();
	});
	
	$(".btn_denno_select").click(function(){
		openDennoForm();
	});
	
	
	$(document).on('click',".sort_btn",function(){
		_sort_key = $(this).attr('data-target-trigger');
		_sort_order = $(this).attr('data-sort-order');
		
		if(_data){
			
			if($(this).hasClass('on_sort')){
				_sort_order = (_sort_order) === "ASC" ? "DESC" : "ASC";
				$(this).attr('data-sort-order',_sort_order);
			}else{
				$(".sort_btn").removeClass('on_sort');
				$(this).addClass('on_sort');
			}
			
			if(_sort_order === "ASC"){
				$(this).find('i').removeClass('fa-caret-down').addClass('fa-caret-up');
			}
			else{
				$(this).find('i').removeClass('fa-caret-up').addClass('fa-caret-down');
			}
			
			_data.sort(function(a,b){
				if(_sort_order === "ASC"){
					if(a[_sort_key]<b[_sort_key]) return -1;
					if(a[_sort_key] > b[_sort_key]) return 1;
				}
				else{
					if(a[_sort_key]>b[_sort_key]) return -1;
					if(a[_sort_key] < b[_sort_key]) return 1;
				}
				return 0;
			});
			
			var target = $("#data_table tbody");
			target.parents('.sData').css({"overflow":"hidden"});
			DoSetDisplay(target,_data);
			setTimeout(function(){target.parents('.sData').css({"overflow":"auto"})},100);
			
		}
	});
	
	//報告ボタン
	$(document).on("click",".btn_report",function(){
		var target_id = $(this).attr("data-target-id");
		getDetailData(target_id);
		
	});
	
	//印刷
	$(document).on("click",".btn_print",function(){
		var window_name = "301000_pdf";
		var target_id = $(this).data("target-id");
		$("input[name='work_id']").val(target_id);
		
		window.open("", window_name) ;
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=301000" ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
	});
	
	
	//報告画面閉じるボタン
	$("#over_ray_tables .close_btn").click(function(){
		if($('#over_ray_tables').css('display') === 'block'){
			if($(".send_checks:checked").length > 0 || ($("#Reporter").val()) || $("tr.on_modify").length > 0){
				jConfirm('編集内容は保存されません。<br>前の画面にもどりますか？', '破棄確認',function(r) {
					if(r===true){
						$("#over_ray_tables").stop().fadeOut("fast");
					}
				});
			}
			else{
				$("#over_ray_tables").stop().fadeOut("fast");
			}
		}
	});
	
	
	$(document).on("input",".value_checks1",function(){
		var target_id = $(this).data("target-id");
		var change = false;
		$(".value_checks1[data-target-id='"+target_id+"']").each(function(){
			if($(this).val() !== $(this).data("default-value")){
				change = true;
			}
		});
		
		if(change){
			$(this).parents("tr").addClass("on_modify");
			
			if(!($("input[name='Comment_"+target_id+"']").val())){
				$("input.send_checks[value='"+target_id+"']").prop("checked",false).prop("disabled",true);
			}
			else{
				$("input.send_checks[value='"+target_id+"']").prop("checked",false).prop("disabled",false);
			}
			check_all_inputs();
		}
		else{
			$(this).parents("tr").removeClass("on_modify");
			$("input.send_checks[value='"+target_id+"']").prop("disabled",false);
		}
		
		
	});
	
	$(document).on("input",".value_checks2",function(){
		var is_on_mod = $(this).parents("tr").hasClass("on_modify");
		var target_id = $(this).data("target-id");
		
		if(is_on_mod){
			if(!($(this).val())){
				$("input.send_checks[value='"+target_id+"']").prop("checked",false).prop("disabled",true);
			}
			else{
				$("input.send_checks[value='"+target_id+"']").prop("disabled",false);
			}
		}
		else{
			$("input.send_checks[value='"+target_id+"']").prop("disabled",false);
		}
		
	});
	
	$(document).on("input",".value_checks3",function(){
		
		var target_id = $(this).data("target-id");
		var is_complete = true;
		$(".value_checks3[data-target-id='"+target_id+"']").each(function(){
			if(!($(this).val())) {
				is_complete = false;
				return false;
			}
		});
		
		if(!is_complete){
			$("input.send_checks[value='"+target_id+"']").prop("checked",false).prop("disabled",true);
		}
		else{
			$("input.send_checks[value='"+target_id+"']").prop("disabled",false);
		}
		
		
	});
	
	$(document).on("click",".btn_add",function(){
		add_detail_row();
		check_all_inputs();
	});
	
	$(document).on("click",".btn_delete",function(){
		$(this).parents("tr").remove();
		check_all_inputs();
	});
	
	
	$(document).on("change",".send_checks",function(){
		check_all_inputs();
	});
	
	$(document).on("click",".cancel_btn",function(){
		var target_id = $(this).attr("data-target-id");
		jConfirm('取消してよろしいですか？', '取消確認',function(r) {
			if(r===true){
				DoCancel(target_id);
			}
		});
	});
	
	$("#Reporter").on("input",function(){
		check_all_inputs();
		if(!($(this).val())){
			$(this).addClass("y_hatch");
		}
		else{
			$(this).removeClass("y_hatch");
		}
	});
	
	$(BTN_SEND).on("click",function(){
		var target_id = $(this).attr("data-work_id");
		jConfirm('この内容で送信してよろしいですか？', '送信確認',function(r) {
			if(r===true){
				DoUpdate(target_id);
			}
		});
	});
	
});

function check_all_inputs(){
	var all_checks = $(".send_checks").length === $(".send_checks:checked").length;
	var is_input_reporter = ($("#Reporter").val());
	$(BTN_SEND).prop("disabled",!(all_checks && is_input_reporter));
}

function add_detail_row(){
	var table = $("#data_table_det tbody");
	
	var out = [];
	
	out.push('<tr class="on_modify">\n');
	out.push('<td class="ta_center" colspan="2"><button type="button" name="btn_delete_1" class="btn btn_delete">削除</button></td>\n');
	out.push('<td><input type="text" name="SHNM_new_'+_new_count+'" value="" data-default-value="" data-focus-group="detail_input" data-target-id="new_'+_new_count+'" class="input_controls focus_controls value_checks3" maxlength="50" style="width:100%;"></td>\n');
	out.push('<td><input type="text" name="RTNO_new_'+_new_count+'" value="" data-default-value="" data-focus-group="detail_input" data-target-id="new_'+_new_count+'" class="input_controls focus_controls value_checks3" maxlength="20" style="width:100%;"></td>\n');
	out.push('<td></td>\n');
	out.push('<td></td>\n');
	out.push('<td></td>\n');
	out.push('<td>\n');
	out.push('<input type="text" name="JitsuCase_new_'+_new_count+'" value="0" data-default-value="0" data-focus-group="detail_input" data-target-id="new_'+_new_count+'" class="input_controls focus_controls number_input" maxlength="10"><br>\n');
	out.push('<input type="text" name="JitsuBara_new_'+_new_count+'" value="0" data-default-value="0" data-focus-group="detail_input" data-target-id="new_'+_new_count+'" class="input_controls focus_controls number_input" maxlength="10">\n');
	out.push('</td>\n');
	out.push('<td><input type="text" name="Comment_new_'+_new_count+'" value="" data-default-value="" data-focus-group="detail_input" data-target-id="new_'+_new_count+'" class="input_controls focus_controls value_checks3" style="width:100%;"></td>\n');
	out.push('<td class="ta_center"><input type="checkbox" name="send_checks" class="send_checks focus_controls" value="new_'+_new_count+'" data-focus-group="detail_input" data-is-addrow="1" disabled></td>\n');
	out.push('</tr>\n');
	
	table.append(out.join(""));
	
	$("input[name='SHNM_new_"+_new_count+"']").focus();
	
	_new_count++;
}



function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	var params = {
			'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
	};
	
	ajax.setParams('301000','get_main_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}

function setDisplay(data){
	
	var target = $('#data_table tbody');
	var sort_btn = $("#data_table thead th > div");
	
	if(!data.length){
		sort_btn.hide();
		target.find('td.no_data').addClass('shown');
		
		
	}
	else {
		sort_btn.show();
		DoSetDisplay(target,data);
		DataTableSetting(1,$('article'));
		_data = data;
		
	}
}

function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = ['user_id','JGSCD','JGSNM','SNTCD','NNSICD','Status','work_id','prev_key'];
	var count_already = 0;
	var count_total = 0;
	
	
	if(_sort_key){
		
		var target_col = $(".sort_btn[data-target-trigger='"+_sort_key+"']");
		
		$(".sort_btn").removeClass('on_sort');
		target_col.addClass('on_sort');
		target_col.attr('data-sort-order',_sort_order);
		
		
		if(_sort_order === "ASC"){
			target_col.find('i').removeClass('fa-caret-down').addClass('fa-caret-up');
		}
		else{
			target_col.find('i').removeClass('fa-caret-up').addClass('fa-caret-down');
		}
		
		
		
		data.sort(function(a,b){
			if(_sort_order === "ASC"){
				if(a[_sort_key]<b[_sort_key]) return -1;
				if(a[_sort_key] > b[_sort_key]) return 1;
			}
			else{
				if(a[_sort_key]>b[_sort_key]) return -1;
				if(a[_sort_key] < b[_sort_key]) return 1;
			}
			return 0;
		});
	}
	
	data.forEach(function (val, index, arr) {
		if(Number(val.Status)){
			out.push('<tr class="is_update">\n');
			count_already++;
		}
		else{
			out.push('<tr>\n');
		}
		
		for (var key in val) {
			if($.inArray(key, exclusion) === -1){
				if ( key.match(/KKTSR|WGT/)) {
					out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
				}
				else{
					out.push('<td>'+val[key]+'</td>\n');
				}
			}
		}
		if(val.Status === "1"){
			out.push('<td class="ta_center">報告済</td>\n');
			out.push('<td class="ta_center"><input type="button" class="btn cancel_btn" name="cancel_btn_'+val.work_id+'" value="取消" data-target-id="'+val.work_id+'"></td>\n');
		}
		else if(val.Status === "2"){
			out.push('<td colspan="2" class="ta_center">確認済</td>\n');
		}
		else if(val.Status === "3"){
			out.push('<td colspan="2" class="ta_center">承認済</td>\n');
		}
		else{
			out.push('<td class="ta_center"><button type="button" name="btn_print_'+val.work_id+'" class="btn btn_print" data-target-id="'+val.work_id+'"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>印刷</button></td>\n');
			out.push('<td class="ta_center"><button type="button" name="btn_report_'+val.work_id+'" class="btn btn_report" data-target-id="'+val.work_id+'"><i class="fa fa-edit" aria-hidden="true"></i>報告</button></td>\n');
		}
		
		out.push('</tr>\n');
		count_total++;
	});
	
	target.html(out.join(""));
	
	$(".progress_area span.already_progress").text(functions.numSeparate(String(count_already)));
	$(".progress_area span.total_progress").text(functions.numSeparate(String(count_total)));
}

function getDetailData(target_id){
	ResetTableSetting($('#over_ray_tables'),'data_table_det');
	$("#Reporter").val("").addClass("y_hatch");
	$("input[name='all_det_checks']").prop("checked",false);
	$(".btn_send").prop("disabled",true);
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var params = {
		'target_id':target_id
	};
	
	ajax.setParams('301000','get_detail_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDetailDisplay(data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}

function setDetailDisplay(data){
	
	var target = $("#data_table_det tbody");
	var sort_btn = $("#data_table_det thead th > div");
	
	if(!data.length){
		target.find('td.no_data').addClass('shown');
	}
	else {
		$("#over_ray_tables").show();
		DoSetDetailDisplay(target,data);
		SetDataTableHeight();
		DataTableSetting(1,$('#over_ray_tables'),'data_table_det');
		$("input[data-focus-group='detail_input']:first").focus();
		$("input[name='all_det_checks']").prop("checked",true);
	}
}

function DoSetDetailDisplay(target,data){
	
	var out = [];
	var exclusion = ['work_detail_id','work_id','prev_key','DET_ID','PYTStocktakingDate','SNTNM','NNSINM','JitsuCase','PYTstock1'];
	var head_content = ['PYTStocktakingDate','SNTNM','NNSINM'];
	var draw_header = false;
	var inputs1 = ['JitsuCase','JitsuBara'];
	var inputs2 = ['Comment'];
	data.forEach(function (val, index, arr) {
		if(!draw_header){
			head_content.forEach(function (val2, index2, arr2) {
				$('#'+val2).text(val[val2]);
			});
			$(".btn_send").attr("data-work_id",val.work_id);
			draw_header = true;
		}
		
		out.push('<tr>\n');
		for (var key in val) {
			
			if($.inArray(key, exclusion) === -1){
				if($.inArray(key,inputs1) !== -1){
					out.push('<td style="min-width: 132px;">');
					out.push('<input type="text" name="JitsuCase_'+val.work_detail_id+'" value="'+val.JitsuCase+'" data-default-value="'+val.JitsuCase+'" data-focus-group="detail_input" class="input_controls focus_controls number_input value_checks1" data-target-id="'+val.work_detail_id+'" maxlength="10"><br>\n');
					out.push('<input type="text" name="JitsuBara_'+val.work_detail_id+'" value="'+val.JitsuBara+'" data-default-value="'+val.JitsuBara+'" data-focus-group="detail_input" class="input_controls focus_controls number_input value_checks1" data-target-id="'+val.work_detail_id+'" maxlength="10">\n');
					out.push('</td>');
				}
				else if($.inArray(key,inputs2) !== -1){
					out.push('<td style="min-width: 300px;"><input type="text" name="'+key+'_'+val.work_detail_id+'" value="'+val[key]+'" data-default-value="'+val[key]+'" data-focus-group="detail_input" class="input_controls focus_controls value_checks2" data-target-id="'+val.work_detail_id+'" style="width:100%;"></td>\n')
				}
				else if ( key.match(/stock/)) {
					out.push('<td class="ta_right">'+functions.numSeparate(val.PYTstock1,true)+'<br><span style="display: inline-block; margin-top: 5px;">'+functions.numSeparate(val.PYTstock3,true)+'</span></td>\n');
				}
				else if ( key.match(/RTNO/)) {
					out.push('<td style="min-width:150px;">'+val[key]+'</td>\n');
				}
				else if ( key.match(/SHNM/)) {
					out.push('<td style="min-width:200px;">'+val[key]+'</td>\n');
				}
				else{
					out.push('<td>'+val[key]+'</td>\n');
				}
			}
		}
		out.push('<td class="ta_center"><input type="checkbox" name="send_checks" class="send_checks focus_controls" value="'+val.work_detail_id+'" data-focus-group="detail_input" checked></td>\n');
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
}

function DoUpdate(work_id){
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	
	$(".send_checks:checked").each(function(){
		var target_id = $(this).val();
		var JitsuCase = $("input[name='JitsuCase_"+target_id+"']").val();
		var JitsuBara = $("input[name='JitsuBara_"+target_id+"']").val();
		var Comment = !($("input[name='Comment_"+target_id+"']").val()) ? "null" : "'"+$("input[name='Comment_"+target_id+"']").val()+"'";
		var IsAdd = $(this).attr('data-is-addrow') === "1" ? 1 : 0;
		var shnm = !($("input[name='SHNM_"+target_id+"']").val()) ? "null" : "'"+$("input[name='SHNM_"+target_id+"']").val()+"'";
		var rtno = !($("input[name='RTNO_"+target_id+"']").val()) ? "null" : "'"+$("input[name='RTNO_"+target_id+"']").val()+"'";
		if(IsAdd === 1){
			target_id = work_id;
		}
		obj.push("("+target_id+","+JitsuCase+","+JitsuBara+","+Comment+","+IsAdd+","+shnm+","+rtno+")");
	});
	var start = 0;
	var max_length = 50;
	var update = [];
	
	
	while(start < obj.length){
		var updates = obj.slice(start,start+max_length);
		update.push(
			{
				"DATA":
				{
					'Update_data':updates.join(",")
				,	'Reporter':getVal('#Reporter')
				}
			}
		);
		start += max_length;
	}
	
	
	var ajax = new Ajax();
	if(update.length === 1){
		ajax.setParams('301000','update_data',update[0]["DATA"]);
		
		$.when(
			ajax.getData(true)
		).done(function(data){
			$("#over_ray_tables").stop().fadeOut("fast");
			getMainData();
		}).always(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	else{
		ajax.setParams('301000','update_data',null);
		
		$.when(
			ajax.getDataMultipul(update,true)
		).done(function(data){
			$("#over_ray_tables").stop().fadeOut("fast");
			getMainData();
		}).always(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}

}

function DoCancel(target_id){
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var ajax = new Ajax();
	var params = {"work_id":target_id};
	ajax.setParams('301000','cancel_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		getMainData();
	}).fail(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
}