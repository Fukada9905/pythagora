var _first_tbody;
var _data;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}
	
	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){
		var texts_partner = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id + ':' + val.name;});
		$('#selection_NNSICD_text').html(texts_partner.join(" / "));
	}
	
	
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
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		var checked = [];
		$("#data_table input.dl_checks:checked").each(function(){
			checked.push($(this).val());
		});
		var params = $("#data_table input.dl_checks:checked").length === $("#data_table input.dl_checks").length ? '' : checked.join(",");
		
		$("input[name='ids']").val(params);
		window.document.output_form_csv.action = "/class/csv/output.php?method=305000" ;
		window.document.output_form_csv.method = "POST" ;
		window.document.output_form_csv.submit() ;
	});
	
	
});

function getMainData(){
	ResetTableSetting();
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	
	var params = {
			'DATE_FROM':getVal('input[name=date_from]')
		,	'DATE_TO':getVal('input[name=date_to]')
		,	'SNTCD':JSON.parse(sessionStorage.getItem(LS_CENTER))
		,	'NNSICD':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	};
	
	
	ajax.setParams('305000','get_main_data',params);
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
	var exclusion = ['user_id','JGSCD','JGSNM','SNTCD','NNSICD','work_id','prev_key','STATUS'];
	
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

function DoPrint(){

}
