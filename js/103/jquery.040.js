var _first_tbody;
var _data = null;

$(document).ready(function(){

	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){

		var texts = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id;});
		data = {"NNSICD":selects.join(",")};
		$('#selection_NNSICD_text').html(texts.join(" / "));
	}

	_first_tbody = $('#data_table').html();

	$('input[name=date_divide]').change(function(){
		if(_data === null){
			$("span#dateymd_title").text(($(this).parents("label").text()));
		}
		else{
			$("#data_table_def span#dateymd_title").text(($(this).parents("label").text()));
			_first_tbody = $('#data_table_def').html();
		}

	});

	$(BTN_CALC).click(function(){
		getMainData();
	});

	$(document).on('change',"input[name='all_checks']",function(){
		$('input.dl_checks').prop('checked',$(this).prop('checked'));
	});


	$(document).on('click',".sort_btn",function(){
		var sort_target = $(this).data('target-trigger');
		var sort_order = $(this).data('sort-order');

		if(_data){

			if($(this).hasClass('on_sort')){
				sort_order = (sort_order) === "ASC" ? "DESC" : "ASC";
				$(this).data('sort-order',sort_order);
			}else{
				$(".sort_btn").removeClass('on_sort');
				$(this).addClass('on_sort');
			}

			if(sort_order === "ASC"){
				$(this).find('i').removeClass('fa-caret-down').addClass('fa-caret-up');
			}
			else{
				$(this).find('i').removeClass('fa-caret-up').addClass('fa-caret-down');
			}

			_data.sort(function(a,b){
				if(sort_order === "ASC"){
					if(a[sort_target]<b[sort_target]) return -1;
					if(a[sort_target] > b[sort_target]) return 1;
				}
				else{
					if(a[sort_target]>b[sort_target]) return -1;
					if(a[sort_target] < b[sort_target]) return 1;
				}
				return 0;
			});

			var target = $("#data_table tbody");
			target.parents('.sData').css({"overflow":"hidden"});
			DoSetDisplay(target,_data);
			setTimeout(function(){target.parents('.sData').css({"overflow":"auto"})},100);

		}

	});

	//画面1
	$(".btn_output_page1").click(function(){

		_data.forEach(function(element){
			element.checked = 0;
		});

		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
			var index = parseInt($(this).attr('data-row-index'));
			_data[index].checked = 1;
		});

		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? '' : checked.join(",");

		$("input[name='ids']").val(params);

		SetStorage(params);
		window.location.href = "/103010/";
	});

	//画面2
	$(".btn_output_page2").click(function(){

		_data.forEach(function(element){
			element.checked = 0;
		});

		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
			var index = parseInt($(this).attr('data-row-index'));
			_data[index].checked = 1;
		});

		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? '' : checked.join(",");

		$("input[name='ids']").val(params);

		SetStorage(params);
		window.location.href = "/103030/";
	});


	var data = JSON.parse(sessionStorage.getItem('103040_DATA'));
	if(data !== null){

		$("#data_table thead th > div").show();
		DoSetDisplay($('#data_table tbody'),data);
		DataTableSetting(1);
		_data = data;
		$(BTN_OUTPUT).css({display:'inline-block'});
	}


});

function SetStorage(selection){
	sessionStorage.setItem('103040_DATA',JSON.stringify(_data));

	var params = {
			'103040_SELECTION':selection
	};
	for (var key in params) {
		sessionStorage.setItem(key,params[key]);
	}
	SetParamatersToStorage(params)
}


function getMainData(){
	ResetTableSetting();
	$("#data_table").html(_first_tbody);

	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();



	var params = {
		'PROCESS_DIVIDE':$('#process_divide_text').text()
	,	'DATE_DIVIDE':getVal('input[name=date_divide]')
	,	'DATE_FROM':getVal('input[name=date_from]')
	,	'DATE_TO':getVal('input[name=date_to]')
	,	'NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	};


	ajax.setParams('103040','get_main_data',params);
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});

	var params2 = {
			'103040_DATE_DIVIDE':getVal('input[name=date_divide]')
		,	'103040_DATE_FROM':getVal('input[name=date_from]')
		,	'103040_DATE_TO':getVal('input[name=date_to]')
		,	'103040_NINUSHI':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	};
	for (var key in params2) {
		sessionStorage.setItem(key,params2[key]);
	}
	SetParamatersToStorage(params2)

}

function setDisplay(data){

	var target = $('#data_table tbody');
	var sort_btn = $("#data_table thead th > div");

	if(!data.length){
		_data = null;
		sort_btn.hide();
		target.find('td.no_data').addClass('shown');
		$(BTN_OUTPUT).css({display:'none'});
	}
	else {
		sort_btn.show();
		DoSetDisplay(target,data);
		DataTableSetting(1);
		_data = data;
		$(BTN_OUTPUT).css({display:'inline-block'});

	}
}

function DoSetDisplay(target,data){

	var out = [];
	var exclusion = ['process_divide','user_id','NNSICD','JGSCD','PTNCD','work_id','prev_key','checked'];

	data.forEach(function (val, index, arr) {

		out.push('<tr>\n');
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
		var checked = (val.checked.toString() === '1') ? ' checked' : '';
		out.push('<td class="ta_center"><input type="checkbox" name="checks" class="dl_checks" value="'+val.work_id+'"'+checked+' data-row-index="'+index+'"></td>\n');
		out.push('</tr>\n');
	});

	target.html(out.join(""));
}