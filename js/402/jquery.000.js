var _first_tbody;
var _data;
var _sort_key;
var _sort_order;

var _is_detail_update = false;

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
	
	//車番確認ボタン
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
		var window_name = "402000_pdf";

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
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=402000" ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;

	});


	//CSV
	$(document).on("click",".btn_output_csv",function(){

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


		window.document.output_form_csv.action = "/class/csv/output.php?method=402000" ;
		window.document.output_form_csv.method = "POST" ;
		window.document.output_form_csv.submit() ;

	});

	
	//入力画面閉じるボタン
	$("#over_ray_tables .close_btn").click(function(){
		$("#over_ray_tables").stop().fadeOut("fast");
		if(_is_detail_update){
			getMainData();
		}
		_is_detail_update = false;

	});

	$(document).on("click",".btn_departure, .btn_arrival",function(){
		DoUpdate($(this));
	});


	//clear
	sessionStorage.removeItem(LS_NINUSHI);
	sessionStorage.removeItem(LS_SUB_PARTNER);
	sessionStorage.removeItem(LS_ROOTPT3);

	setConditionsVisible();

	$(document).on("change","input[name=get_divide]",setConditionsVisible);


	//var ps = new PerfectScrollbar(".other_table");

	
});

function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();

	var divide = getVal('input[name=get_divide]');

	$("#hidden_get_divide").text(divide);
	$("#csv_get_divide").val(divide);
	$("#pdf_get_divide").val(divide);


	var params = {
			'GET_DIVIDE':divide
		,	'DATE_DIVIDE':getVal('input[name=date_divide]')
		,	'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
		,	'PTNCD':JSON.parse(sessionStorage.getItem(LS_SUB_PARTNER))
		,	'ROOTPT3':JSON.parse(sessionStorage.getItem(LS_ROOTPT3))
	};

	ajax.setParams('402000','get_main_data',params);
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
		$(BTN_OUTPUT_CSV).css({display:'none'});
		$(BTN_OUTPUT_PDF).css({display:'none'});
		$(BTN_OUTPUT).css({display:'none'});
		$(".progress_area span.already_progress").text(0);
		$(".progress_area span.total_progress").text(0);
		
	}
	else {
		sort_btn.show();
		DoSetDisplay(target,data);
		DataTableSetting(1,$('article'));
		_data = data;
		$(BTN_OUTPUT_CSV).css({display:'inline-block'});
		$(BTN_OUTPUT_PDF).css({display:'inline-block'});
		$(BTN_OUTPUT).css({display:'inline-block'});
		
	}
}

function DoSetDisplay(target,data){
	
	var out = [];

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
		if(val.arrival_count !== "0"){
			out.push('<tr class="is_update">\n');
			checks = "<br>到着済";
			if(val.arrival_count !== val.detail_count){
				checks += "<br>("+val.arrival_count+"/"+val.detail_count+"台)";
			}
		}
		else if(val.departure_count !== "0"){
			out.push('<tr class="is_update">\n');
			checks = "<br>出発済";
			if(val.departure_count !== val.detail_count){
				checks += "<br>("+val.departure_count+"/"+val.detail_count+"台)";
			}
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
	
	ajax.setParams('402000','get_detail_data',params);
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

	}
}

function DoSetDetailDisplay(data){
	
	var out = [];
	var target = $("#over_ray_tables .table_wrap.other_table");
	data.forEach(function (val, index, arr) {

		out.push('<div class="shaban_input_wrap">');
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
		out.push('<th width="100">出発時間</th>');
		out.push('<th width="100">到着時間</th>');
		out.push('</tr>');
		out.push('</thead>');
		out.push('<tbody>');
		val.details.forEach(function(det,index2,arr2){
			out.push('<tr data-target-work_id="'+val.work_id+'" data-target-detail_no="'+det.detail_no+'">');
			out.push('<td class="ta_center numbers"></td>');
			out.push('<td>'+det.transporter_name+'</td>');
			out.push('<td>'+det.shaban+'</td>');
			out.push('<td>'+det.kizai+'</td>');
			out.push('<td>'+det.jomuin+'</td>');
			out.push('<td>'+det.tel+'</td>');
			out.push('<td>'+functions.nl2br(det.remarks)+'</td>');
			out.push('<td class="ta_center departure_btn">');
			if(det.departure_datetime){
				out.push(functions.nl2br(det.departure_datetime));
			}
			else{
				out.push('<button type="button" class="btn btn_departure" data-update_type="1" data-target-id="'+val.id+'" data-target-divide="'+val.target_divide+'" data-target-detail_no="'+det.detail_no+'">出発</button>');
			}
			out.push('</td>');
			out.push('<td class="ta_center arrival_btn">');
			if(det.arrival_datetime){
				out.push(functions.nl2br(det.arrival_datetime));
			}
			else{
				out.push('<button type="button" class="btn btn_arrival" data-update_type="2" data-target-id="'+val.id+'" data-target-divide="'+val.target_divide+'" data-target-detail_no="'+det.detail_no+'">到着</button>');
			}
			out.push('</td>');
			out.push('</tr>');
		});
		out.push('</tbody>');
		out.push('</table>');
		out.push('</div>');
		out.push('</div>');


	});
	
	target.html(out.join("\n"));
}

function DoUpdate(target){
	
	
	$(OBJ_PROGRESS).css({display:'flex'});

	var params = {
		"update_type":target.attr("data-update_type")
	,	"target_divide":target.attr("data-target-divide")
	,	"id":target.attr("data-target-id")
	,	"detail_no":target.attr("data-target-detail_no")
	};

	var ajax = new Ajax();
	ajax.setParams('402000','update_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		target.parents("td").html(functions.nl2br(data.datetime));
		_is_detail_update = true;
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});

}

function setConditionsVisible(){
	var condition_divide = getVal('input[name=get_divide]');

	if(condition_divide.match(/3/) === null){
		$(".only_master").hide();
	}
	else {
		$(".only_master").show();
	}

	if(condition_divide.match(/1|2|4/) === null){
		$(".not_master").hide();
	}
	else{
		$(".not_master").show();
	}

}