var _first_tbody;
var _data;
var _new_counts = {};
var _sort_key;
var _sort_order;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	
	$(BTN_CALC).click(function(){
		_sort_key = null;
		_sort_order = null;
		getMainData();
	});
	
	$(document).on('change',"input[name='all_checks']",function(){
		$('input.dl_checks').prop('checked',$(this).prop('checked'));

		var check_length = $("#data_table input.dl_checks:checked").length;
		$(".progress_area span.already_progress").text(functions.numSeparate(String(check_length),true));
	});

	$(document).on('change',"input.dl_checks",function(){
		var check_length = $("#data_table input.dl_checks:checked").length;
		$(".progress_area span.already_progress").text(functions.numSeparate(String(check_length),true));
	});
	

	$(".btn_denno_select").click(function(){
		openDennoForm();
	});

	$(".btn_nohin_select").click(function(){
		openNouhinForm();
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

	$(document).on("click",".shaban_midashi_title",function(){

		var target = $(this).parents(".shaban_midashi_wrap").children(".shaban_midashi_conditions");

		if(target.hasClass("hidden")){
			$(this).find("i").stop().attr('class',$(this).find("i").attr('class').replace('down','up'));
		}
		else{
			$(this).find("i").stop().attr('class',$(this).find("i").attr('class').replace('up','down'));
		}
		target.stop().toggleClass("hidden");
	});
	
	//車番入力ボタン
	$(document).on("click",".btn_entry",function(){

		var check_length = $("#data_table input.dl_checks:checked").length;
		if(!check_length){
			jAlert('入力対象を選択してください','エラー');
			return;
		}
		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push("("+$(this).val()+")");
		});
		var params = checked.join(",");

		getDetailData(params);
		
	});
	
	//印刷
	$(document).on("click",".btn_output_pdf",function(){
		var window_name = "401000_pdf";

		var check_length = $("#data_table input.dl_checks:checked").length;
		if(!check_length){
			jAlert('出力対象を選択してください','エラー');
			return;
		}

		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push("("+$(this).val()+")");
		});
		$("input[name='work_id']").val(checked.join(","));


		window.open("", window_name) ;
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=401000" ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;

	});

	
	//入力画面閉じるボタン
	$("#over_ray_tables .close_btn").click(function(){
		if($('#over_ray_tables').css('display') === 'block'){
			if($("#Dispatcher").val() || $("tr.on_modify, tr.on_delete").length > 0){
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

	$(document).on("change",".value_checks",function(){
		var target = $(this).parents("tr").find(".value_checks");
		var change = false;
		target.each(function(){
			if($(this).val() !== $(this).attr("data-default-value")){
				change = true;
			}
		});
		
		if(change){
			$(this).parents("tr").addClass("on_modify");
		}
		else{
			$(this).parents("tr").removeClass("on_modify");
		}
		
		
	});

	
	$(document).on("click",".btn_add i",function(){
		var parents = $(this).parents(".shaban_input_wrap");
		var target_work_id = parents.attr("data-target-work_id");
		var tables = parents.find("table.list_table tbody");
		add_detail_row(target_work_id,tables);
	});
	
	$(document).on("click",".btn_delete",function(){
		var parents = $(this).parents("tr");

		if(parents.hasClass("is_new_row")){
			var target_work_id = parents.attr("data-target-work_id");
			var new_count = _new_counts[target_work_id].counts - 1;
			var new_detail_no = _new_counts[target_work_id].max -1;

			_new_counts[target_work_id] = {counts:new_count,max:new_detail_no};
			parents.remove();
		}
		else{
			if(parents.hasClass("on_delete")){
				$(this).html('<i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除')
			}
			else{
				$(this).html('削除取消')
			}
			parents.toggleClass("on_delete");
		}



	});

	
	$("#Dispatcher").on("input",function(){
		if(!($(this).val())){
			$(this).addClass("y_hatch");
			$(".btn_send").prop("disabled",true);
		}
		else{
			$(this).removeClass("y_hatch");
			$(".btn_send").prop("disabled",false);
		}
	});
	
	$(BTN_SEND).on("click",function(){

		if($("tr.on_modify, tr.on_delete").length === 0){
			jAlert('変更データがありません','お知らせ');
			return;
		}
		jConfirm('この内容で登録してよろしいですか？', '登録確認',function(r) {
			if(r===true){
				DoUpdate();
			}
		});
	});




	//clear
	sessionStorage.removeItem('401000_DENNO');
	sessionStorage.removeItem('401000_NOHIN');
	sessionStorage.removeItem(LS_NINUSHI);
	sessionStorage.removeItem(LS_CENTER);
	sessionStorage.removeItem(LS_SUB_PARTNER);
	sessionStorage.removeItem(LS_ROOTPT1);
	sessionStorage.removeItem(LS_ROOTPT2);
	sessionStorage.removeItem(LS_ROOTPT3);


	setConditionsVisible();

	$(document).on("change","input[name=get_divide]",setConditionsVisible);


	//var ps = new PerfectScrollbar(".other_table");

	
});


function add_detail_row(target_work_id,tables){

	var out = [];

	var new_count = (_new_counts[target_work_id].counts) ? _new_counts[target_work_id].counts + 1 : 1;
	var new_detail_no = (_new_counts[target_work_id].max) ? _new_counts[target_work_id].max + 1 : 1;

	if(new_count > 10){
		jAlert('追加可能なレコードは10件までです','お知らせ');
		return;
	}

	out.push('<tr class="on_modify is_new_row" data-target-work_id="'+target_work_id+'" data-target-detail_no="'+new_detail_no+'">');
	out.push('<td class="ta_center numbers"></td>');
	out.push('<td>');
	out.push('<input name="transporter_name" type="text" maxlength="30" value="" data-default-value="" data-focus-group="detail_input" class="max_input input_controls focus_controls">');
	out.push('</td>');
	out.push('<td>');
	out.push('<input name="shaban" type="text" maxlength="30" value="" data-default-value="" size="8" data-focus-group="detail_input" class="input_controls focus_controls">');
	out.push('</td>');
	out.push('<td>');
	out.push('<input name="kizai" type="text" maxlength="30" value="" data-default-value="" size="6" data-focus-group="detail_input" class="input_controls focus_controls">');
	out.push('</td>');
	out.push('<td>');
	out.push('<input name="jomuin" type="text" maxlength="30" value="" data-default-value="" size="6" data-focus-group="detail_input" class="input_controls focus_controls">');
	out.push('</td>');
	out.push('<td>');
	out.push('<input name="tel" type="text" maxlength="30" value="" data-default-value="" size="11" data-focus-group="detail_input" class="input_controls focus_controls">');
	out.push('</td>');
	out.push('<td>');
	out.push('<textarea name="remarks" data-max-rows="2" data-default-value="" data-focus-group="detail_input" class="max_input input_controls focus_controls">');
	out.push('</textarea>');
	out.push('</td>');
	out.push('<td class="delete_btn_col">');
	out.push('<button type="button" class="btn btn_delete" data-target-id="'+new_detail_no+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除</button>');
	out.push('</td>');
	out.push('</tr>');

	tables.append(out.join("\n"));
	_new_counts[target_work_id] = {counts:new_count, max:new_detail_no};


	tables.find("tr:last-of-type").find("[name=transporter_name]").focus();

}



function getMainData(){

	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();

	var denno = JSON.parse(sessionStorage.getItem("401000_DENNO"));
	var param_denno = null;
	if(denno){
		var texts = denno.filter(function(value){return value !== ""});
		var texts2 = texts.map(function(value){return "'"+value+"'"});
		param_denno = texts2.join(",");
	}

	var nohincd = JSON.parse(sessionStorage.getItem("401000_NOHIN"));
	var param_nohincd = null;
	if(nohincd){
		var texts3 = nohincd.filter(function(value){return value !== ""});
		var texts4 = texts3.map(function(value){return "'"+value+"'"});
		param_nohincd = texts4.join(",");
	}

	$("#hidden_get_divide").text(getVal('input[name=get_divide]'));
	$("#get_divide").val(getVal('input[name=get_divide]'));

	var params = {
		'GET_DIVIDE':getVal('input[name=get_divide]')
		,	'DATE_DIVIDE':getVal('input[name=date_divide]')
		,	'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
		,	'PTNCD':JSON.parse(sessionStorage.getItem(LS_SUB_PARTNER))
		,	'DENNO':param_denno
		,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
		,	'NOHINCD':param_nohincd
		,	'ROOTPT1':JSON.parse(sessionStorage.getItem(LS_ROOTPT1))
		,	'ROOTPT2':JSON.parse(sessionStorage.getItem(LS_ROOTPT2))
		,	'ROOTPT3':JSON.parse(sessionStorage.getItem(LS_ROOTPT3))
	};

	ajax.setParams('401000','get_main_data',params);
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
	var sort_btn = $("#data_table thead th div.sort_btn, #data_table thead th div.check_wrap");
	
	if(!data.length){
		sort_btn.hide();
		target.find('td.no_data').addClass('shown');
		$(BTN_OUTPUT_PDF).css({display:'none'});
		$(BTN_OUTPUT).css({display:'none'});
		$(".progress_area span.already_progress").text('');
		$(".progress_area span.total_progress").text('');
	}
	else {
		sort_btn.show();
		DoSetDisplay(target,data);
		DataTableSetting(1,$('article'));
		_data = data;
		$(BTN_OUTPUT_PDF).css({display:'inline-block'});
		$(BTN_OUTPUT).css({display:'inline-block'});
		
	}
}

function DoSetDisplay(target,data){
	
	var out = [];
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
		var checks = "";
		if(val.shaban_id){
			out.push('<tr class="is_update">\n');
			checks = "<br>入力済み";
		}
		else{
			out.push('<tr>\n');
		}


		//荷主
		out.push('<td>'+val['shipper_name']+'</td>\n');
		//運送業者
		out.push('<td>'+val['transporter_code']+'<br>'+val['transporter_name']+'</td>\n');
		//伝票番号
		out.push('<td>'+val['slip_number']+'</td>\n');
		//積地センター
		out.push('<td>'+val['warehouse_code']+'<br>'+val['warehouse_name']+'</td>\n');
		//納品先
		out.push('<td>'+val['delivery_code']+'<br>'+val['delivery_name']+'<br>'+val['delivery_address']+'</td>\n');
		//ケース
		out.push('<td class="ta_center">'+functions.numSeparate(val['package_count'],true)+'<br>'+functions.numSeparate(val['fraction'],true)+'</td>\n');
		//重量
		out.push('<td class="ta_center">'+functions.numSeparate(val['shipping_weight'],true)+'</td>\n');

		//チェック
		out.push('<td class="ta_center"><input type="checkbox" name="checks" class="dl_checks" value="'+val.work_id+'" checked>'+checks+'</td>\n');
		
		out.push('</tr>\n');
		count_total++;
	});
	
	target.html(out.join(""));
	
	$(".progress_area span.already_progress").text(functions.numSeparate(String(count_total)));
	$(".progress_area span.total_progress").text(functions.numSeparate(String(count_total)));
}

function getDetailData(target_id){

	ResetTableSetting($('#over_ray_tables'),'data_table_det');
	$("#Dispatcher").val("").addClass("y_hatch");
	$(".btn_send").prop("disabled",true);

	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var params = {
		'get_divide':$("#hidden_get_divide").text()
	,	'target_id':target_id
	};
	
	ajax.setParams('401000','get_detail_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDetailDisplay(data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});

}

function setDetailDisplay(data){


	if(!data.length){
		target.find('td.no_data').addClass('shown');
	}
	else {
		$("#over_ray_tables").show();
		SetDataTableHeight();
		DoSetDetailDisplay(data);
		$("input[data-focus-group='detail_input']:first").focus();

	}
}

function DoSetDetailDisplay(data){
	
	var out = [];
	var target = $("#over_ray_tables .table_wrap.other_table");
	data.forEach(function (val, index, arr) {

		out.push('<div class="shaban_input_wrap" data-target-work_id="'+val.work_id+'">');
		out.push('<div class="shaban_midashi_wrap">');
		out.push('<div class="shaban_midashi_title">');
		out.push('<h4>'+(index+1)+'件目 伝票番号／'+val.slip_number+'　'+val.shipper_name+'</h4>');
		out.push('<p class="mark"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>');
		out.push('</div>');
		out.push('<div class="shaban_midashi_conditions">');
		out.push('<dl class="input_area_inner">');
		out.push('<dt>出荷日</dt>');
		out.push('<dd><div class="selection_text">'+val.retrieval_date+'</div></dd>');
		out.push('<dt class="second_title">納品日</dt>');
		out.push('<dd><div class="selection_text">'+val.delivery_date+'</div></dd>');
		out.push('</dl>');
		out.push('<dl class="input_area_inner">');
		out.push('<dt>積地</dt>');
		out.push('<dd><div class="selection_text">'+val.warehouse+'</div></dd>');
		out.push('</dl>');
		out.push('<dl class="input_area_inner">');
		out.push('<dt>着地</dt>');
		out.push('<dd><div class="selection_text">'+val.delivery+'</div></dd>');
		out.push('</dl>');
		out.push('</div>');
		out.push('</div>');
		out.push('<div class="table_area">');
		out.push('<table class="list_table">');
		out.push('<thead>');
		out.push('<tr>');
		out.push('<th width="10">No</th>');
		out.push('<th width="250">運送会社</th>');
		out.push('<th width="100">車番</th>');
		out.push('<th width="90">機材</th>');
		out.push('<th width="90">乗務員</th>');
		out.push('<th width="130">携帯番号</th>');
		out.push('<th>備考</th>');
		out.push('<th>削除</th>');
		out.push('</tr>');
		out.push('</thead>');
		out.push('<tbody>');
		val.details.forEach(function(det,index2,arr2){
			out.push('<tr data-target-work_id="'+val.work_id+'" data-target-detail_no="'+det.detail_no+'">');
			out.push('<td class="ta_center numbers"></td>');
			out.push('<td>');
			out.push('<input name="transporter_name" type="text" maxlength="30" value="'+det.transporter_name+'" data-default-value="'+det.transporter_name+'" data-focus-group="detail_input" class="max_input input_controls focus_controls value_checks">');
			out.push('</td>');
			out.push('<td>');
			out.push('<input name="shaban" type="text" maxlength="30" value="'+det.shaban+'" data-default-value="'+det.shaban+'" size="8" data-focus-group="detail_input" class="input_controls focus_controls value_checks">');
			out.push('</td>');
			out.push('<td>');
			out.push('<input name="kizai" type="text" maxlength="30" value="'+det.kizai+'" data-default-value="'+det.kizai+'" size="6" data-focus-group="detail_input" class="input_controls focus_controls value_checks">');
			out.push('</td>');
			out.push('<td>');
			out.push('<input name="jomuin" type="text" maxlength="30" value="'+det.jomuin+'" data-default-value="'+det.jomuin+'" size="6" data-focus-group="detail_input" class="input_controls focus_controls value_checks">');
			out.push('</td>');
			out.push('<td>');
			out.push('<input name="tel" type="text" maxlength="30" value="'+det.tel+'" data-default-value="'+det.tel+'" size="11" data-focus-group="detail_input" class="input_controls focus_controls value_checks">');
			out.push('</td>');
			out.push('<td>');
			out.push('<textarea name="remarks" data-max-rows="2" data-default-value="'+det.remarks+'"  data-focus-group="detail_input" class="max_input input_controls focus_controls value_checks">');
			out.push(det.remarks);
			out.push('</textarea>');
			out.push('</td>');
			out.push('<td class="delete_btn_col">');
			out.push('<button type="button" class="btn btn_delete" data-target-id="'+det.detail_no+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除</button>');
			out.push('</td>');
			out.push('</tr>');
		});
		out.push('</tbody>');
		out.push('</table>');
		out.push('</div>');
		out.push('<div class="add_btn_wrap">');
		out.push('<p class="btn_add"><i class="fa fa-plus-circle hover_txt" aria-hidden="true"></i></p>');
		out.push('</div>');
		out.push('</div>');

		_new_counts[val.work_id] = {counts : val.details_count, max : val.max_detail_no};

	});
	
	target.html(out.join("\n"));
}

function DoUpdate(work_id){
	
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];

	$("tr.on_modify, tr.on_delete").each(function(){
		var work_id = $(this).attr("data-target-work_id");
		var detail_no = $(this).attr("data-target-detail_no");
		var is_delete = ($(this).hasClass("on_delete")) ? 1 : 0;
		var transporter_name = !($(this).find("[name='transporter_name']").val()) ? "null" : "'"+$(this).find("[name='transporter_name']").val()+"'";
		var shaban = !($(this).find("[name='shaban']").val()) ? "null" : "'"+$(this).find("[name='shaban']").val()+"'";
		var kizai = !($(this).find("[name='kizai']").val()) ? "null" : "'"+$(this).find("[name='kizai']").val()+"'";
		var jomuin = !($(this).find("[name='jomuin']").val()) ? "null" : "'"+$(this).find("[name='jomuin']").val()+"'";
		var tel = !($(this).find("[name='tel']").val()) ? "null" : "'"+$(this).find("[name='tel']").val()+"'";
		var remarks = !($(this).find("[name='remarks']").val()) ? "null" : "'"+$(this).find("[name='remarks']").val()+"'";


		obj.push("("+work_id+","+detail_no+","+is_delete+","+transporter_name+","+shaban+","+kizai+","+jomuin+","+tel+","+remarks+")");
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
					'get_divide':$("#hidden_get_divide").text()
				,	'Update_data':updates.join(",")
				,	'Dispatcher':getVal('#Dispatcher')
				}
			}
		);
		start += max_length;
	}
	
	
	var ajax = new Ajax();
	if(update.length === 1){
		ajax.setParams('401000','update_data',update[0]["DATA"]);
		
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
		ajax.setParams('401000','update_data',null);
		
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

function openDennoForm(){

	var inputs = JSON.parse(sessionStorage.getItem("401000_DENNO"));

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
			sessionStorage.removeItem('401000_DENNO');
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
			sessionStorage.setItem('401000_DENNO',JSON.stringify(ls_denno));
		}};

	var clear_callback = function(){
		$('#selection_DENNO_text').html('指定なし');
		sessionStorage.removeItem('401000_DENNO');
	};
}

function openNouhinForm(){

	var inputs = JSON.parse(sessionStorage.getItem("401000_NOHIN"));

	var over_ray = $("#over_ray");
	var inner = over_ray.find(".over_ray_inner");
	var title = '納品先指定';

	var html = [];
	html.push('<h3>'+title+'</h3>\n');
	html.push('<div class="over_ray_inner_inner">\n');
	html.push('<table class="list_table">\n');
	html.push('<thead>\n');
	html.push('<tr>\n');
	html.push('<th style="text-align: center; width: 20px;">NO</th>\n');
	html.push('<th>指定する納品先コードを入力</th>\n');
	html.push('</tr>\n');
	html.push('<tbody>\n');
	for(var i = 1;i<=10;i++){

		var val = (inputs) ? (inputs[i-1]) : '';
		html.push('<tr>');
		html.push('<td style="text-align: center; width: 20px;">'+i+'</td>');
		html.push('<td><input type="text" name="nohin_input_'+i+'" data-focus-group="nohin_input" class="input_controls focus_controls nohin_input" value="'+val+'" maxlength="10"></td>');
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

	$(".nohin_input:first").focus();

	var ok_callback = function(){
		var selected = [];
		$('input.nohin_input').each(function(){
			selected.push($(this).val());
		});


		if(!selected.length){
			$('#selection_NOHIN_text').html('指定なし');
			sessionStorage.removeItem('401000_NOHIN');
		}
		else{
			var texts = selected.filter(function(value){return value !== ""});
			$('#selection_NOHIN_text').html(texts.join(" / "));
			var ls_nohin = [];
			for(var i=0;i<10;i++){
				if(i<texts.length){
					ls_nohin.push(texts[i]);
				}
				else{
					ls_nohin.push('')
				}
			}
			sessionStorage.setItem('401000_NOHIN',JSON.stringify(ls_nohin));
		}};

	var clear_callback = function(){
		$('#selection_NOHIN_text').html('指定なし');
		sessionStorage.removeItem('401000_NOHIN');
	};
}

function setConditionsVisible(){
	var condition_divide = getVal('input[name=get_divide]');

	if(condition_divide === "3"){
		$(".not_master").hide();
		$(".only_master").show();
		$("input[name=date_from]").val(getNowDate());
		$("input[name=date_to]").val(getNowDate());
	}
	else{
		$(".not_master").show();
		$(".only_master").hide();
	}
}

function getNowDate() {

	var today = new Date();
	var format = 'YYYY/MM/DD';

	format = format.replace(/YYYY/, today.getFullYear());
	format = format.replace(/MM/, ('00' + (today.getMonth() + 1)).slice(-2));
	format = format.replace(/DD/, ('00' + today.getDate()).slice(-2));

	return format;
}