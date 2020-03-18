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
	$(document).on("click",".btn_detail",function(){
		var target_id = $(this).attr("data-target-id");
		getDetailData(target_id);
	});
	
	
	
	//報告画面閉じるボタン
	$("#over_ray_tables .close_btn").click(function(){
		if($('#over_ray_tables').css('display') === 'block'){
			$("#over_ray_tables").stop().fadeOut("fast");
		}
	});
	
	
	$(BTN_SEND).on("click",function(){
		var target_id = $(this).attr("data-target-id");
		jConfirm('この内容で送信してよろしいですか？', '送信確認',function(r) {
			if(r===true){
				DoUpdate(target_id);
			}
		});
	});
	
	//clear
	sessionStorage.removeItem('204000_DENNO');
});


function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	var denno = JSON.parse(sessionStorage.getItem("204000_DENNO"));
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
	
	ajax.setParams('204000','get_main_data',params);
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
		if(val.HasComment !== ""){
			out.push('<tr class="on_modify">\n');
			count_already++;
		}
		else if(val.Status === "0"){
			out.push('<tr class="is_update">\n');
			count_already++;
		}
		else{
			out.push('<tr>\n');
		}
		
		for (var key in val) {
			if($.inArray(key, exclusion) === -1){
				if ( key.match(/HasComment/) && val[key] !== '') {
					out.push('<td class="c_red ta_center">'+val[key]+'</td>\n');
				}
				else{
					out.push('<td>'+val[key]+'</td>\n');
				}
			}
		}
		out.push('<td class="ta_center"><input type="button" class="btn btn_detail" name="detail_btn_'+val.work_id+'" value="詳細" data-target-id="'+val.work_id+'"></td>\\n');
		
		out.push('</tr>\n');
		count_total++;
	});
	
	target.html(out.join(""));
	
	/*
	$(".progress_area span.already_progress").text(functions.numSeparate(String(count_already)));
	$(".progress_area span.total_progress").text(functions.numSeparate(String(count_total)));
	
	if(count_already === count_total){
		$(BTN_OUTPUT).css({display:'none'});
	}
	else{
		$(BTN_OUTPUT).css({display:'inline-block'});
	}
	*/
}

function getDetailData(target_id){
	ResetTableSetting($('#over_ray_tables'),'data_table_det');
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var params = {
		'target_id':target_id
	};
	
	ajax.setParams('204000','get_detail_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDetailDisplay(data,target_id);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}

function setDetailDisplay(data,target_id){
	
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
	}
}

function DoSetDetailDisplay(target,data){
	
	var out = [];
	var exclusion = ['JGSCD_SK','SNTCD_NK','DENPYOYMD','SYUKAYMD','NOHINYMD','UNSKSNM','NNSINM','Reporter','IsModifyRow','Status','work_id'];
	var head_content = ['DENNO','JGSCD_SK','SNTCD_NK','DENPYOYMD','SYUKAYMD','NOHINYMD','UNSKSNM','NNSINM','Reporter'];
	var draw_header = false;
	
	data.forEach(function (val, index, arr) {
		if(!draw_header){
			head_content.forEach(function (val2, index2, arr2) {
				$('#'+val2).text(val[val2]);
			});
			$(".btn_send").attr("data-target-id",val.work_id);
			$(".btn_send").prop("disabled",!(val.Status === "1"));
			
			
			draw_header = true;
		}
		if(val['IsModifyRow'] === "1"){
			out.push('<tr class="on_modify">\n');
		}
		else{
			out.push('<tr>\n');
		}
		
		for (var key in val) {
			if($.inArray(key, exclusion) === -1){
				if ( key.match(/KKTSR/)) {
					if(val[key].match(/\r\n/)){
						var arrVal = val[key].split(/\r\n/);
						out.push('<td class="ta_right c_red">');
						arrVal.forEach(function(val3, index3){
							if(index3 === 0){
								out.push('<span style="text-decoration: line-through;">'+functions.numSeparate(val3)+'</span>');
								out.push('<br>');
							}
							else{
								out.push(functions.numSeparate(val3));
							}
							
						});
						out.push('</td>');
					}
					else{
						out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
					}
				}
				else{
					out.push('<td>'+val[key]+'</td>\n');
				}
			}
		}
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
}

function DoUpdate(target_id){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var ajax = new Ajax();
	var params = {"work_id":target_id};
	ajax.setParams('204000','update_data',params);
	
	$.when(
		ajax.getData(true)
	).done(function(data){
		$("#over_ray_tables").stop().fadeOut("fast");
		getMainData();
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
}

function DoCancel(target_id){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var ajax = new Ajax();
	var params = {"work_id":target_id};
	ajax.setParams('204000','cancel_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		getMainData();
	});
}


function openDennoForm(){
	
	var inputs = JSON.parse(sessionStorage.getItem("204000_DENNO"));
	
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
			sessionStorage.removeItem('204000_DENNO');
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
			sessionStorage.setItem('204000_DENNO',JSON.stringify(ls_denno));
		}};
	
	var clear_callback = function(){
		$('#selection_DENNO_text').html('指定なし');
		sessionStorage.removeItem('204000_DENNO');
	};
}

