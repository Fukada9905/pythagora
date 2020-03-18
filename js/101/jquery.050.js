var _first_tbody;
var _data = null;

$(document).ready(function(){


	_first_tbody = $('#data_table').html();

	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}

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


	$(".btn_print").click(function(){



		var process_divide = $(this).data("target-process-divide");
		var process_class = $(this).data("target-process-class");
		var window_name = process_class+"_"+process_divide+"_pdf";


		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
		});

		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? '' : checked.join(",");

		$("input[name='ids']").val(params);


		window.open("", window_name) ;
		window.document.output_form_pdf.action = "/class/pdf/output.php?method="+process_class+"&process_divide=" + process_divide ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
	});


});


function getMainData(){
	ResetTableSetting();
	$("#data_table").html(_first_tbody);

	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();

	$("input[name='params_date_divide']").val(getVal('input[name=date_divide]'));

	var params = {
		'DATE_DIVIDE':getVal('input[name=date_divide]')
	,	'DATE_FROM':getVal('input[name=date_from]')
	,	'DATE_TO':getVal('input[name=date_to]')
	,	'NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
	};


	ajax.setParams('101050','get_main_data',params);
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
	var exclusion = ['process_divide','user_id','NNSICD','JGSCD','UNSKSCD','work_id','prev_key','checked'];

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
