var _first_tbody;
var _data;
var _pt_name_divide = 1;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	
	if(JSON.parse(sessionStorage.getItem(LS_PARTNER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_PARTNER)).map(function(val){return val.id + ':' + val.name;});
		$('#selection_PTNCD_text').html(texts.join(" / "));
	}
	
	
	$(BTN_CALC).click(function(){
		getMainData();
	});
	
	$(document).on('change',"input[name='all_checks']",function(){
		$('input.dl_checks').prop('checked',$(this).prop('checked'));
	});
	
	$(document).on('change',"input[name='date_divide']",function(){
		$("th.date_divide_col > span").text($(this).parents('label').text());
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
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
		});
		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? '' : checked.join(",");
		
		$("input[name='ids']").val(params);
		$("input[name='pt_name_divide']").val(_pt_name_divide);
		
		window.document.output_form.action = "/class/csv/output.php?method=101030" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	
});

function getMainData(){
	ResetTableSetting();
	$("#data_table").html(_first_tbody);
	$("th.date_divide_col > span").text($("input[name='date_divide']:checked").parents('label').text());
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	var ptn_cd = null;
	if(JSON.parse(sessionStorage.getItem(LS_PARTNER))){
		var selects = JSON.parse(sessionStorage.getItem(LS_PARTNER)).map(function(val){return "'" + val.id + "'";});
		ptn_cd = selects.join(",");
	}
	
	if($("input[name='pt_divide']").length > 0){
		_pt_name_divide = getVal("input[name=pt_divide]");
	}

	var nnsi_cd = null;
	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){
		var selects = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return "'" + val.id + "'";});
		nnsi_cd = selects.join(",");
	}
	
	var params = {
			'DATE_DIVIDE':getVal('input[name=date_divide]')
		,	'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'PTNCD':ptn_cd
		,	'PT_NAME_DIVIDE':_pt_name_divide
		,	'NNSICD':nnsi_cd
	};
	
	
	ajax.setParams('101030','get_main_data',params);
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
		DataTableSetting(1);
		_data = data;
		$(BTN_OUTPUT).css({display:'inline-block'});
		
	}
}

function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = ['user_id','process_divide','JGSCD','PTNCD','NNSICD','work_id','prev_key'];

	
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
		out.push('<td class="ta_center"><input type="checkbox" name="checks" class="dl_checks" value="'+val.work_id+'" checked></td>\n');
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
	
	
}


