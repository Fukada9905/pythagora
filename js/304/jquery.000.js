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
	
	
	$(BTN_CALC).click(function(){
		getMainData();
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
	
	//印刷
	$(document).on("click",".btn_print",function(){
		var window_name = "304000_pdf";
		var target_id = $(this).data("target-id");
		$("input[name='work_id']").val(target_id);
		
		window.open("", window_name) ;
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=304000";
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
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
		,	'HasComment':$(".comment_checks").prop("checked") ? 1 : 0
	};
	
	ajax.setParams('304000','get_main_data',params);
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
	data.forEach(function (val, index, arr) {
		if(val.HasComment !== ""){
			out.push('<tr class="on_modify">\n');
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
		out.push('<td class="ta_center"><button type="button" name="btn_print_'+val.work_id+'" class="btn btn_print" data-target-id="'+val.work_id+'"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>棚卸業務報告書</button></td>\n');
		
		out.push('</tr>\n');
		count_total++;
	});
	
	target.html(out.join(""));
}



