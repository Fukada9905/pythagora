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
	
});


function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	
	var params = {
			'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
		,	'IsPartnerOnly':getVal('input[name=IsPartnerOnly]')
	};
	
	
	ajax.setParams('302000','get_main_data',params);
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
				else if ( key.match(/HasReturn/) && val[key] !== '') {
					out.push('<td class="c_blue ta_center">'+val[key]+'</td>\n');
				}
				else if(key.match(/IsConfirm/)){
					out.push('<td class="ta_center">'+val[key]+'</td>\n');
				}
				else{
					out.push('<td>'+val[key]+'</td>\n');
				}
			}
		}
		if(val.Status === "0"){
			out.push('<td class="ta_center">&nbsp;</td>\\n');
		}
		else{
			out.push('<td class="ta_center"><input type="button" class="btn btn_detail" name="detail_btn_'+val.work_id+'" value="確認処理" data-target-id="'+val.work_id+'"></td>\\n');
		}
		
		
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
	
	ajax.setParams('302000','get_detail_data',params);
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
	var exclusion = ['PYTStocktakingDate','JGSNM','SNTNM','NNSINM','Reporter','AuthorizerComment','ReviewComment','IsModifyRow','Status','work_id','work_detail_id'];
	var head_content = ['PYTStocktakingDate','JGSNM','SNTNM','NNSINM','Reporter','AuthorizerComment'];
	var draw_header = false;
	

	
	data.forEach(function (val, index, arr) {
		if(!draw_header){
			head_content.forEach(function (val2, index2, arr2) {
				if(val2 === "AuthorizerComment" && (val[val2])){
					$('#'+val2).html("<span>" + val[val2] + "</span>");
				}
				else{
					$('#'+val2).text(val[val2]);
				}
				
			});
			$(".btn_send").attr("data-target-id",val.work_id);
			
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
						out.push('<td class="ta_right">');
						arrVal.forEach(function(val3, index3){
							if(index3 === 0){
								out.push(functions.numSeparate(val3,true));
								out.push('<br>');
							}
							else{
								out.push(functions.numSeparate(val3,true));
							}
							
							
						});
						out.push('</td>');
					}
					else{
						out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
					}
				}
				else if ( key.match(/ReportComment/)) {
					
					out.push('<td style="min-width:300px;">\n');
					if(val[key]){
						out.push(val[key]+'<br>\n');
					}
					out.push('<input type="text" name="ReviewComment_'+val.work_detail_id+'" value="'+val.ReviewComment+'" data-default-value="'+val.ReviewComment+'" data-focus-group="detail_input" class="input_controls focus_controls ReviewComments" data-target-id="'+val.work_detail_id+'" style="width: 100%;">\n')
					out.push('</td>>\n');
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
	
	var obj = [];
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	$(".ReviewComments").each(function(){
		var target_id = $(this).attr('data-target-id');
		
		if($(this).val()){
			var Comment = "'" + $(this).val() + "'";
			obj.push("("+target_id+","+Comment+")");
		}
	});
	
	var params = {};
	
	if(obj.length){
		params = {"work_id":target_id,"Update_data":obj.join()};
	}
	else{
		params = {"work_id":target_id};
	}
	
	
	
	var ajax = new Ajax();
	
	ajax.setParams('302000','update_data',params);
	
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
	ajax.setParams('302000','cancel_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		getMainData();
	});
}


