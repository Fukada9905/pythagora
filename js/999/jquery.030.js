var _first_tbody;
var _divide_combo;
var _new_count = 0;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();

	
	$(document).on("click",".btn_add i",function(){
		add_detail_row();
	});
	
	$("select[name='divide_conditions']").change(function(){
		var val = ($(this).val()) ? $(this).val() : null;
		if(changeCheck()){
			jConfirm('編集内容は保存されません。<br>絞り込みを実施しますか？', '破棄確認',function(r) {
				if(r===true){
					getMainData(val);
				}
			});
		}
		else{
			getMainData(val);
		}
	});
	
	
	$(document).on("click",".btn_delete",function(){
		if($(this).parents("tr").hasClass("on_delete")){
			$(this).parents("tr").removeClass("on_delete");
			$(this).html('<i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除')
		}
		else{
			$(this).parents("tr").addClass("on_delete");
			$(this).html('削除対象')
		}
		
	});
	
	$(document).on("click",".btn_delete2",function(){
		$(this).parents("tr").remove();
	});
	
	firstInit();
});


function firstInit(){
	var ajax = new Ajax();
	ajax.setParams('999030','get_divide_data',null);
	$.when(
		ajax.getData(true)
	).done(function(data){
		getMainData();
		$(BTN_EXECUTE).show();
	});
}

function getMainData(ptncd){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	var params = {
		'PTNCD':ptncd
	};
	
	ajax.setParams('999030','get_main_data',params);
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
		DataTableSetting(1,$('article'));
	}
}


function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = [];
	data.forEach(function (val, index, arr) {
		out.push('<tr data-target-id="'+val.sp_conditions_id+'">\n');
		var common_tags = ' data-focus-group="master_input" data-target-id="'+val.sp_conditions_id+'"';
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.PTNCD)+'</td>\n');
		out.push('<td style="min-width:60px;">'+functions.clearnull(val.NNSICD)+'</td>\n');
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.JGSCD)+'</td>\n');
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.SNTCD)+'</td>\n');
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.UNSKSCD)+'</td>\n');
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.SYUKAP)+'</td>\n');
		out.push('<td style="min-width:60px;">'+functions.clearnull(val.SEKKBN)+'</td>\n');
		out.push('<td style="min-width:110px;">'+functions.clearnull(val.NHNSKCD)+'</td>\n');
		
		
		//NKTISFRG
		out.push('<td class="ta_center">\n');
		var checked1 = (val.NKTISFRG === "1" ? "checked" : "");
		out.push('<label><input type="checkbox" name="NKTISFRG" class="input_controls focus_controls" data-default-value="'+val.NKTISFRG+'"'+common_tags+' '+checked1+'>対象</label>\n');
		out.push('</td>\n');
		
		//SKTISFRG
		out.push('<td class="ta_center">\n');
		var checked2 = (val.SKTISFRG === "1" ? "checked" : "");
		out.push('<label><input type="checkbox" name="SKTISFRG" class="input_controls focus_controls" data-default-value="'+val.SKTISFRG+'"'+common_tags+' '+checked2+'>対象</label>\n');
		out.push('</td>\n');
		
		//ZKTISFRG
		out.push('<td class="ta_center">\n');
		var checked3 = (val.ZKTISFRG === "1" ? "checked" : "");
		out.push('<label><input type="checkbox" name="ZKTISFRG" class="input_controls focus_controls" data-default-value="'+val.ZKTISFRG+'"'+common_tags+' '+checked3+'>対象</label>\n');
		out.push('</td>\n');
		
		
		//delete
		out.push('<td class="ta_center">\n');
		out.push('<button type="button" class="btn btn_delete" data-target-id="'+val.sp_conditions_id+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除</button>');
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
	
	//NNSICD
	out.push('<td>\n');
	out.push('<input type="text" name="NNSICD" data-default-value="" value="" maxlength="4" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:50px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//JGSCD
	out.push('<td>\n');
	out.push('<input type="text" name="JGSCD" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//SNTCD
	out.push('<td>\n');
	out.push('<input type="text" name="SNTCD" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//UNSKSCD
	out.push('<td>\n');
	out.push('<input type="text" name="UNSKSCD" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//SYUKAP
	out.push('<td>\n');
	out.push('<input type="text" name="SYUKAP" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//SEKKBN
	out.push('<td>\n');
	out.push('<input type="text" name="SEKKBN" data-default-value="" value="" maxlength="4" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:50px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//NHNSKCD
	out.push('<td>\n');
	out.push('<input type="text" name="NHNSKCD" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	
	//NKTISFRG
	out.push('<td class="ta_center">\n');
	out.push('<label><input type="checkbox" name="NKTISFRG" class="input_controls focus_controls" data-default-value=""'+common_tags+'>対象</label>\n');
	out.push('</td>\n');
	
	//SKTISFRG
	out.push('<td class="ta_center">\n');
	out.push('<label><input type="checkbox" name="SKTISFRG" class="input_controls focus_controls" data-default-value=""'+common_tags+'>対象</label>\n');
	out.push('</td>\n');
	
	//ZKTISFRG
	out.push('<td class="ta_center">\n');
	out.push('<label><input type="checkbox" name="ZKTISFRG" class="input_controls focus_controls" data-default-value=""'+common_tags+'>対象</label>\n');
	out.push('</td>\n');
	
	
	//delete
	out.push('<td class="ta_center">\n');
	out.push('<button type="button" class="btn btn_delete2" data-target-id="new-'+_new_count+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除</button>');
	out.push('</td>\n');
	
	out.push('</tr>\n');
	
	table.append(out.join(""));
	
	$("input[name='PTNCD']:last").focus();
	
	_new_count++;
}

function DoUpdate(){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	
	$(".on_modify,.on_delete").each(function(){
		var target_id = $(this).attr("data-target-id");
		var NKTISFRG = $(this).find("[name='NKTISFRG']").prop("checked") ? "1":"0";
		var SKTISFRG = $(this).find("[name='SKTISFRG']").prop("checked") ? "1":"0";
		var ZKTISFRG = $(this).find("[name='ZKTISFRG']").prop("checked") ? "1":"0";
		
		if($(this).hasClass("new_row")){
			var PTNCD = ($(this).find("[name='PTNCD']").val()) ? "'" + $(this).find("[name='PTNCD']").val() + "'" : "null";
			var NNSICD = ($(this).find("[name='NNSICD']").val()) ? "'" + $(this).find("[name='NNSICD']").val() + "'" : "null";
			var JGSCD = ($(this).find("[name='JGSCD']").val()) ? "'" + $(this).find("[name='JGSCD']").val() + "'" : "null";
			var SNTCD = ($(this).find("[name='SNTCD']").val()) ? "'" + $(this).find("[name='SNTCD']").val() + "'" : "null";
			var UNSKSCD = ($(this).find("[name='UNSKSCD']").val()) ? "'" + $(this).find("[name='UNSKSCD']").val() + "'" : "null";
			var SYUKAP = ($(this).find("[name='SYUKAP']").val()) ? "'" + $(this).find("[name='SYUKAP']").val() + "'" : "null";
			var SEKKBN = ($(this).find("[name='SEKKBN']").val()) ? "'" + $(this).find("[name='SEKKBN']").val() + "'" : "null";
			var NHNSKCD = ($(this).find("[name='NHNSKCD']").val()) ? "'" + $(this).find("[name='NHNSKCD']").val() + "'" : "null";
			
			obj.push("(null,"+PTNCD+","+NNSICD+","+JGSCD+","+SNTCD+","+UNSKSCD+","+SYUKAP+","+SEKKBN+","+NHNSKCD+","+NKTISFRG+","+SKTISFRG+","+ZKTISFRG+",1,0)");
		}
		else if($(this).hasClass("on_delete")){
			obj.push("("+target_id+",null,null,null,null,null,null,null,null,null,null,null,0,1)");
		}
		else{
			obj.push("("+target_id+",null,null,null,null,null,null,null,null,"+NKTISFRG+","+SKTISFRG+","+ZKTISFRG+",0,0)");
		}
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
		ajax.setParams('999030','update_data',update[0]["DATA"]);
		
		$.when(
			ajax.getData(true)
		).done(function(data){
			var val = ($("select[name='divide_conditions']").val()) ? $("select[name='divide_conditions']").val() : null;
			getMainData(val);
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	else{
		ajax.setParams('999030','update_data',null);
		
		$.when(
			ajax.getDataMultipul(update,true)
		).done(function(data){
			var val = ($("select[name='divide_conditions']").val()) ? $("select[name='divide_conditions']").val() : null;
			getMainData(val);
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	
	
}