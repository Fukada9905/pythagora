var _first_tbody;
var _data;
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
	$(BTN_EXECUTE).click(function(){
		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
		});
		if(!(checked.length)){
			var message = new Message();
			message.DisplayError("報告対象を一つ以上選択してください");
			return;
		}
		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? null : checked.join(",");
		getDetailData(params);
		
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
	
	$(document).on("change",".send_checks",function(){
		check_all_inputs();
	});
	
	$(document).on("click",".cancel_btn",function(){
		var target_id = $(this).data("target-id");
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
		jConfirm('この内容で送信してよろしいですか？', '送信確認',function(r) {
			if(r===true){
				DoUpdate();
			}
		});
	});
	
	//clear
	sessionStorage.removeItem('203000_DENNO');
});

function check_all_inputs(){
	var all_checks = $(".send_checks").length === $(".send_checks:checked").length;
	var is_input_reporter = ($("#Reporter").val());
	$(BTN_SEND).prop("disabled",!(all_checks && is_input_reporter));
}



function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	var denno = JSON.parse(sessionStorage.getItem("203000_DENNO"));
	var param_denno = null;
	if(denno){
		var texts = denno.filter(function(value){return value !== ""});
		var texts2 = texts.map(function(value){return "'"+value+"'"});
		param_denno = texts2.join(",");
	}
	
	var params = {
			'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'DENNO':param_denno
		,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
	};
	
	ajax.setParams('203000','get_main_data',params);
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
		$(BTN_OUTPUT).css({display:'none'});
		
		
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
	var exclusion = ['user_id','JGSCD_SK','JGSCD_NK','JGSNM_NK','SNTCD_NK','NNSICD','Status','work_id','prev_key'];
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
		if(val.Status === "1" || val.Status === "2"){
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
			out.push('<td class="ta_center"><input type="button" class="btn cancel_btn" name="cancel_btn_'+val.work_id+'" value="取消" data-target-id="'+val.work_id+'"></td>\n');
		}
		else if(val.Status === "2"){
			out.push('<td class="ta_center">入荷入力済</td>\n');
		}
		else{
			out.push('<td class="ta_center"><input type="checkbox" name="checks" class="dl_checks" value="'+val.work_id+'" checked></td>\n');
		}
		
		out.push('</tr>\n');
		count_total++;
	});
	
	target.html(out.join(""));
	
	$(".progress_area span.already_progress").text(functions.numSeparate(String(count_already)));
	$(".progress_area span.total_progress").text(functions.numSeparate(String(count_total)));
	
	if(count_already === count_total){
		$(BTN_OUTPUT).css({display:'none'});
	}
	else{
		$(BTN_OUTPUT).css({display:'inline-block'});
	}
}

function getDetailData(target_ids){
	ResetTableSetting($('#over_ray_tables'),'data_table_det');
	$("#Reporter").val("").addClass("y_hatch");
	$("input[name='all_det_checks']").prop("checked",false);
	$(".btn_send").prop("disabled",true);
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var params = {
		'ids':target_ids
	};
	
	ajax.setParams('203000','get_detail_data',params);
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
	var exclusion = ['work_detail_id','work_id','prev_key','Status','ID','DENGNO','NIBKNRDENGNO','JGSCD_SK','SNTCD_SK','LOTK','LOTS','FCKBNKK'];
	var inputs1 = ['JitsuCase','JitsuBara'];
	var inputs2 = ['Comment'];
	data.forEach(function (val, index, arr) {
		
		out.push('<tr>\n');
		for (var key in val) {
			if($.inArray(key, exclusion) === -1){
				if($.inArray(key,inputs1) !== -1){
					out.push('<td><input type="text" name="'+key+'_'+val.work_detail_id+'" value="'+val[key]+'" data-default-value="'+val[key]+'" data-focus-group="detail_input" class="input_controls focus_controls number_input value_checks1" data-target-id="'+val.work_detail_id+'" maxlength="10"></td>\n')
				}
				else if($.inArray(key,inputs2) !== -1){
					out.push('<td><input type="text" name="'+key+'_'+val.work_detail_id+'" value="'+val[key]+'" data-default-value="'+val[key]+'" data-focus-group="detail_input" class="input_controls focus_controls value_checks2" data-target-id="'+val.work_detail_id+'"></td>\n')
				}
				else if ( key.match(/KKTSR|WGT/)) {
					out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
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

function DoUpdate(){
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	$(".send_checks:checked").each(function(){
		var target_id = $(this).val();
		var JitsuCase = $("input[name='JitsuCase_"+target_id+"']").val();
		var JitsuBara = $("input[name='JitsuBara_"+target_id+"']").val();
		var Comment = !($("input[name='Comment_"+target_id+"']").val()) ? "null" : "'"+$("input[name='Comment_"+target_id+"']").val()+"'";
		obj.push("("+target_id+","+JitsuCase+","+JitsuBara+","+Comment+")");
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
		ajax.setParams('203000','update_data',update[0]["DATA"]);
		
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
		ajax.setParams('203000','update_data',null);
		
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
	ajax.setParams('203000','cancel_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		getMainData();
	});
}


function openDennoForm(){
	
	var inputs = JSON.parse(sessionStorage.getItem("203000_DENNO"));
	
	var over_ray = $("#over_ray");
	var inner = over_ray.find(".over_ray_inner");
	var title = '伝票番号指定';
	
	var html = [];
	html.push('<h3>'+title+'</h3>\n');
	html.push('<div class="over_ray_inner_inner">\n');
	html.push('<table class="list_table">\n');
	html.push('<thead>\n');
	html.push('<tr>\n');
	html.push('<th style="text-align: center; width: 20px;">NO</th>\n');
	html.push('<th>指定する伝票番号を入力</th>\n');
	html.push('</tr>\n');
	html.push('<tbody>\n');
	for(var i = 1;i<=10;i++){
		
		var val = (inputs) ? (inputs[i-1]) : '';
		html.push('<tr>');
		html.push('<td style="text-align: center; width: 20px;">'+i+'</td>');
		html.push('<td><input type="text" name="denno_input_'+i+'" data-focus-group="denno_input" class="input_controls focus_controls dennno_input" value="'+val+'" maxlength="10"></td>');
		html.push('</tr>');
	}
	html.push('</tbody>\n');
	html.push('</table>\n');
	html.push('</div>\n');
	
	$(inner).html(html.join(""));
	
	var btns = [];
	btns.push("<div class=\"set_btns\">");
	btns.push("<button type=\"button\" class=\"btn btn_set_config_clear\">クリア</button>");
	btns.push("<button type=\"button\" class=\"btn btn_set_config\">確定</button>");
	btns.push("</div>");
	
	over_ray.find(".over_ray_inner_inner").after(btns.join(""));
	
	$(".btn_set_config").off("click").on("click",function(){
		ok_callback();
		over_ray.stop().fadeOut("fast");
	});
	$(".btn_set_config_clear").off("click").on("click",function(){
		clear_callback();
		over_ray.stop().fadeOut("fast");
	});
	
	
	over_ray.stop().fadeIn("fast");
	
	$(".dennno_input:first").focus();
	
	var ok_callback = function(){
		var selected = [];
		$('input.dennno_input').each(function(){
			selected.push($(this).val());
		});
		
		
		if(!selected.length){
			$('#selection_DENNO_text').html('指定なし');
			sessionStorage.removeItem('203000_DENNO');
		}
		else{
			var texts = selected.filter(function(value){return value !== ""});
			$('#selection_DENNO_text').html(texts.join(" / "));
			var ls_denno = [];
			for(var i=0;i<10;i++){
				if(i<texts.length){
					ls_denno.push(texts[i]);
				}
				else{
					ls_denno.push('')
				}
			}
			sessionStorage.setItem('203000_DENNO',JSON.stringify(ls_denno));
		}};
	
	var clear_callback = function(){
		$('#selection_DENNO_text').html('指定なし');
		sessionStorage.removeItem('203000_DENNO');
	};
}

