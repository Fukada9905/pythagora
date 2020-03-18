var _first_tbody;
var _divide_combo;
var _new_count = 0;

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();

	//パスワード表示ボタン
	$(document).on("change", ".passcheck",function(){
		var id = $(this).attr("data-target-id");
		if ( $(this).prop('checked') ) {
			$("input[name='user_password'][data-target-id='"+id+"']").attr('type','text');
		} else {
			$("input[name='user_password'][data-target-id='"+id+"']").attr('type','password');
		}
	});
	
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
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		var user_group_id = ($("select[name='divide_conditions']").val()) ? $("select[name='divide_conditions']").val() : null;
		$("#params_user_group_id").val(user_group_id);
		window.document.output_form.action = "/class/csv/output.php?method=999010" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	firstInit();
});


function firstInit(){
	var ajax = new Ajax();
	ajax.setParams('999010','get_divide_data',null);
	$.when(
		ajax.getData(true)
	).done(function(data){
		makeInlineCombo(data);
		getMainData();
		$(BTN_EXECUTE).show();
	});
	
	
}

function makeInlineCombo(data){
	
	var out = [];
	
	out.push('<select class="input_controls focus_controls" name="user_group_id" data-default-value="DEFAULT_VALUE"TAGS_BUFF>\n');
	data.forEach(function (val, index, arr) {
		out.push('<option value="'+val.user_group_id+'">'+val.user_group_name+'</option>\n');
	});
	out.push('</select>\n');
	
	_divide_combo = out.join("");
	
}

function getMainData(user_group_id){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	
	var params = {
		'user_group_id':user_group_id
	};
	
	ajax.setParams('999010','get_main_data',params);
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
		$(BTN_OUTPUT_CSV).show();
	}
	else{
		$(BTN_OUTPUT_CSV).hide();
	}
}


function DoSetDisplay(target,data){
	
	var out = [];
	var exclusion = [];
	data.forEach(function (val, index, arr) {
		if(val.del_flag === "1"){
			out.push('<tr class="is_update" data-target-id="'+val.user_id+'">\n');
		}
		else{
			out.push('<tr data-target-id="'+val.user_id+'">\n');
		}
		var common_tags = ' data-focus-group="master_input" data-target-id="'+val.user_id+'"';
		out.push('<td style="width:130px;">'+val.user_id+'</td>\n');
		//password
		out.push('<td>\n');
		out.push('<input type="password" name="user_password" data-default-value="'+val.user_password+'" value="'+val.user_password+'" maxlength="10" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
		out.push('<label><input type="checkbox" class="passcheck" data-target-id="'+val.user_id+'">パスワードを表示</label>\n');
		out.push('</td>\n');
		
		//name
		out.push('<td>\n');
		out.push('<input type="text" name="user_name" data-default-value="'+functions.clearnull(val.user_name)+'" value="'+functions.clearnull(val.user_name)+'" maxlength="50" class="input_controls focus_controls validate[required]" style="width:100%;"'+common_tags+'>\n');
		out.push('</td>\n');
		
		//kana
		out.push('<td>\n');
		out.push('<input type="text" name="user_name_kana" data-default-value="'+functions.clearnull(val.user_name_kana)+'" value="'+functions.clearnull(val.user_name_kana)+'" maxlength="50" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
		out.push('</td>\n');
		
		//group
		out.push('<td>\n');
		out.push(_divide_combo.replace('DEFAULT_VALUE',val.user_group_id).replace("TAGS_BUFF",common_tags));
		out.push('</td>\n');
		
		//management cd
		out.push('<td>\n');
		out.push('<input type="text" name="management_cd" data-default-value="'+functions.clearnull(val.management_cd)+'" value="'+functions.clearnull(val.management_cd)+'" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
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
	
	//USER ID
	out.push('<td>\n');
	out.push('<input type="text" name="user_id" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//password
	out.push('<td>\n');
	out.push('<input type="password" name="user_password" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[required,custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
	out.push('<label><input type="checkbox" class="passcheck" data-target-id="new-'+_new_count+'">パスワードを表示</label>\n');
	out.push('</td>\n');
	
	//name
	out.push('<td>\n');
	out.push('<input type="text" name="user_name" data-default-value="" value="" maxlength="50" class="input_controls focus_controls validate[required]" style="width:100%;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//kana
	out.push('<td>\n');
	out.push('<input type="text" name="user_name_kana" data-default-value="" value="" maxlength="50" class="input_controls focus_controls" style="width:100%;"'+common_tags+'>\n');
	out.push('</td>\n');
	
	//group
	out.push('<td>\n');
	out.push(_divide_combo.replace('DEFAULT_VALUE','').replace("TAGS_BUFF",common_tags));
	out.push('</td>\n');
	
	//management cd
	out.push('<td>\n');
	out.push('<input type="text" name="management_cd" data-default-value="" value="" maxlength="10" class="input_controls focus_controls validate[custom[onlyLetterNumber]]" style="width:100px;"'+common_tags+'>\n');
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
	
	$("input[name='user_id']:last").focus();
	
	_new_count++;
}

function DoUpdate(){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	
	$(".on_modify").each(function(){
		var target_id = $(this).attr("data-target-id");
		var user_id = $(this).hasClass("new_row") ? "'" + $(this).find("[name='user_id']").val() + "'" : "'" + target_id + "'";
		var user_password = "'" + $(this).find("[name='user_password']").val() + "'";
		var user_name = "'" + $(this).find("[name='user_name']").val() + "'";
		var user_name_kana = ($(this).find("[name='user_name_kana']").val()) ? "'" + $(this).find("[name='user_name_kana']").val() + "'" : "null";
		var user_group_id = "'" + $(this).find("[name='user_group_id']").val() + "'";
		var management_cd = ($(this).find("[name='management_cd']").val()) ? "'" + $(this).find("[name='management_cd']").val() + "'" : "null";
		var del_flag = $(this).find("[name='del_flag']").val();
		
		obj.push("("+user_id+","+user_password+","+user_name+","+user_name_kana+","+user_group_id+","+management_cd+","+del_flag+")");
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
		ajax.setParams('999010','update_data',update[0]["DATA"]);
		
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
		ajax.setParams('999010','update_data',null);
		
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