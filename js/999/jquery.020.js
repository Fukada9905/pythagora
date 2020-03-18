var _first_tbody;
var _divide_combo;
var _new_count = 0;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();
	
	$(document).on("click",".btn_add i",function(){
		add_detail_row();
	});
	
	getMainData();
	$(BTN_EXECUTE).show();
});




function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	
	ajax.setParams('999020','get_main_data',{});
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(data);
	}).always(function(){
		$(".focus_controls[data-focus-group='master_input']:first").focus();
		$(OBJ_PROGRESS).css({display:'none'});
	});
	
}

function setDisplay(data){
	
	var target = $('#data_table tbody');
	var sort_btn = $("#data_table thead th > div");
	
	if(data.length){
		DoSetDisplay(target,data);
		target.find("select.input_controls").each(function(){
			$(this).val($(this).attr("data-default-value"));
		});
		DataTableSetting(1,$('article'));
	}
}


function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = [];
	data.forEach(function (val, index, arr) {
		if(val.del_flag === "1"){
			out.push('<tr class="is_update" data-target-id="'+val.PTNCD+'">\n');
		}
		else{
			out.push('<tr data-target-id="'+val.PTNCD+'">\n');
		}
		
		var common_tags = ' data-focus-group="master_input" data-target-id="'+val.PTNCD+'"';
		out.push('<td style="width:100px;">'+val.PTNCD+'</td>\n');
		
		//PTNCDNM1
		out.push('<td style="width:250px;">\n');
		out.push('<input type="text" name="PTNCDNM1" data-default-value="'+functions.clearnull(val.PTNCDNM1)+'" value="'+functions.clearnull(val.PTNCDNM1)+'" maxlength="50" class="input_controls focus_controls validate[required]" style="width:100%;"'+common_tags+'>\n');
		out.push('</td>\n');
		
		//PTNCDNM2
		out.push('<td style="width:250px;">\n');
		out.push('<input type="text" name="PTNCDNM2" data-default-value="'+functions.clearnull(val.PTNCDNM2)+'" value="'+functions.clearnull(val.PTNCDNM2)+'" maxlength="50" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
		out.push('</td>\n');
		
		//PTNCDJUSYO
		out.push('<td style="min-width:300px;">\n');
		out.push('<input type="text" name="PTNCDJUSYO" data-default-value="'+functions.clearnull(val.PTNCDJUSYO)+'" value="'+functions.clearnull(val.PTNCDJUSYO)+'" maxlength="100" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
		out.push('</td>\n');
		
		//delete
		out.push('<td>\n');
		out.push('<select name="del_flag" class="input_controls focus_controls" data-default-value="'+val.del_flag+'"'+common_tags+'>');
		out.push('<option value="0">通常</option>');
		out.push('<option value="1">削除</option>');
		out.push('</select>');
		out.push('</td>\n');
		
		out.push('</tr>\n');
	});
	
	target.html(out.join(""));
	
}

function add_detail_row(){
	var table = $("#data_table tbody");
	
	var out = [];
	
	out.push('<tr class="on_modify new_row" data-target-id="new-'+_new_count+'">\n');
	
	var common_tags = ' data-focus-group="master_input" data-target-id="new-'+_new_count+'"';
	
	//PTNCD
	out.push('<td>\n');
	out.push('<input type="text" name="PTNCD" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	
	//PTNCDNM1
	out.push('<td>\n');
	out.push('<input type="text" name="PTNCDNM1" data-default-value="" value="" maxlength="50" class="input_controls focus_controls validate[required]" style="width:100%;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//PTNCDNM2
	out.push('<td>\n');
	out.push('<input type="text" name="PTNCDNM2" data-default-value="" value="" maxlength="50" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//PTNCDJUSYO
	out.push('<td>\n');
	out.push('<input type="text" name="PTNCDJUSYO" data-default-value="" value="" maxlength="100" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	
	//delete
	out.push('<td>\n');
	out.push('<select name="del_flag" class="input_controls focus_controls" data-default-value="0">');
	out.push('<option value="0" selected>通常</option>');
	out.push('<option value="1">削除</option>');
	out.push('</select>');
	out.push('</td>\n');
	
	out.push('</tr>\n');
	
	table.append(out.join(""));
	
	$("input[name='PTNCD']:last").focus();
	
	_new_count++;
}

function DoUpdate(){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	
	$(".on_modify").each(function(){
		var target_id = $(this).attr("data-target-id");
		var PTNCD = $(this).hasClass("new_row") ? "'" + $(this).find("[name='PTNCD']").val() + "'" : "'" + target_id + "'";
		var PTNCDNM1 = "'" + $(this).find("[name='PTNCDNM1']").val() + "'";
		var PTNCDNM2 = ($(this).find("[name='PTNCDNM2']").val()) ? "'" + $(this).find("[name='PTNCDNM2']").val() + "'" : "null";
		var PTNCDJUSYO = ($(this).find("[name='PTNCDJUSYO']").val()) ? "'" + $(this).find("[name='PTNCDJUSYO']").val() + "'" : "null";
		var del_flag = $(this).find("[name='del_flag']").val();
		
		obj.push("("+PTNCD+","+PTNCDNM1+","+PTNCDNM2+","+PTNCDJUSYO+","+del_flag+")");
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
					}
			}
		);
		start += max_length;
	}
	
	
	var ajax = new Ajax();
	if(update.length === 1){
		ajax.setParams('999020','update_data',update[0]["DATA"]);
		
		$.when(
			ajax.getData(true)
		).done(function(data){
			getMainData();
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	else{
		ajax.setParams('999020','update_data',null);
		
		$.when(
			ajax.getDataMultipul(update,true)
		).done(function(data){
			getMainData();
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	
	
}