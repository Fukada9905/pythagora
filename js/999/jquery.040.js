var _first_tbody;
var _divide_combo;
var _divide_combo_jgs;
var _new_count = 0;
var _divide_data = {name:'',address:''};

$(document).ready(function(){
	
	_first_tbody = $('#data_table').html();


	$(document).on("click",".btn_add i",function(){
		add_detail_row();

		var target_select = $('select.divide_controller[data-target-id=new-'+(_new_count-1)+']');

		target_select.each(function(){

			if($(this).attr("data-default-value")){
				var value = $(this).attr("data-default-value");
				$(this).val(value);
				var divide_tag = $(this).attr("data-target-divide");

				var name = $(this).children("option[value="+value+"]").attr("data-name");
				var address = $(this).children("option[value="+value+"]").attr("data-address");


				var inner_html = (divide_tag !== "UNSKSPTNCD") ? name + "<br>\n" + address : name;
				$(this).parents("tr").children("td."+divide_tag).html(inner_html);
			}

		});

	});

	$(document).on("change","select.divide_controller",function(){
		var divide_tag = $(this).attr("data-target-divide");
		var name = $(this).children("option[value="+$(this).val()+"]").attr("data-name");
		var address = $(this).children("option[value="+$(this).val()+"]").attr("data-address");


		var inner_html = (divide_tag !== "UNSKSPTNCD") ? name + "<br>\n" + address : name;
		$(this).parents("tr").children("td."+divide_tag).html(inner_html);
	});
	
	$("select.refine").change(function(){
		if(changeCheck()){
			jConfirm('編集内容は保存されません。<br>絞り込みを実施しますか？', '破棄確認',function(r) {
				if(r===true){
					getMainData();
				}
			});
		}
		else{
			getMainData();
		}
	});
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){

		var jgscd = ($("select[name='jgscd']").val()) ? $("select[name='jgscd']").val() : '';
		var tmcptncd= ($("select[name='tmcptncd']").val()) ? $("select[name='tmcptncd']").val() : '';
		var ckcptncd = ($("select[name='ckcptncd']").val()) ? $("select[name='ckcptncd']").val() : '';
		var unsksptncd = ($("select[name='unsksptncd']").val()) ? $("select[name='unsksptncd']").val() : '';

		$("#params_jgscd").val(jgscd);
		$("#params_tmcptncd").val(tmcptncd);
		$("#params_ckcptncd").val(ckcptncd);
		$("#params_unsksptncd").val(unsksptncd);

		window.document.output_form.action = "/class/csv/output.php?method=999040" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	firstInit();
});


function firstInit(){
	var ajax = new Ajax();
	ajax.setParams('999040','get_divide_data',null);
	$.when(
		ajax.getData(true)
	).done(function(data){
		if(data[0].length >0){
			_divide_data.name = data[0][0].PTNNM;
			_divide_data.address = data[0][0].PTNCDJUSYO;
		}
		makeInlineCombo(data[0]);
		makeInlineComboJgs(data[1]);
		getMainData();
		$(BTN_EXECUTE).show();
	});
	
	
}

function makeInlineCombo(data){

	var out = [];

	out.push('<select class="input_controls focus_controls divide_controller" style="width:80px;" name="DIVIDE_TAG_PTNCD" data-target-divide="DIVIDE_TAG_PTNCD" data-default-value="DEFAULT_VALUE"TAGS_BUFF>\n');
	data.forEach(function (val, index, arr) {
		out.push('<option value="'+val.PTNCD+'" data-name="'+val.PTNNM+'" data-address="'+val.PTNCDJUSYO+'">'+val.PTNCD+'</option>\n');
	});
	out.push('</select>\n');

	_divide_combo = out.join("");

}

function makeInlineComboJgs(data){

	var out = [];
	out.push('<select class="input_controls focus_controls" style="width:80px;" name="JGSCD" data-default-value="DEFAULT_VALUE"TAGS_BUFF>\n');
	data.forEach(function (val, index, arr) {
		out.push('<option value="'+val.JGSCD+'">'+val.JGSNM+'</option>\n');
	});
	out.push('</select>\n');

	_divide_combo_jgs = out.join("");

}

function getMainData(){
	ResetTableSetting($('article'));
	$("#data_table").html(_first_tbody);
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();


	var jgscd = ($("select[name='jgscd']").val()) ? $("select[name='jgscd']").val() : null;
	var tmcptncd= ($("select[name='tmcptncd']").val()) ? $("select[name='tmcptncd']").val() : null;
	var ckcptncd = ($("select[name='ckcptncd']").val()) ? $("select[name='ckcptncd']").val() : null;
	var unsksptncd = ($("select[name='unsksptncd']").val()) ? $("select[name='unsksptncd']").val() : null;

	
	var params = {
		'jgscd':jgscd
	,	'tmcptncd':tmcptncd
	,	'ckcptncd':ckcptncd
	,	'unsksptncd':unsksptncd
	};
	ajax.setParams('999040','get_main_data',params);
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
			out.push('<tr class="is_update" data-target-id="'+val.root_id+'">\n');
		}
		else{
			out.push('<tr data-target-id="'+val.root_id+'">\n');
		}
		var common_tags = ' data-focus-group="master_input" data-target-id="'+val.root_id+'"';
		//JGSCD
		out.push('<td>\n');
		out.push(_divide_combo_jgs.replace('DEFAULT_VALUE',val.JGSCD).replace("TAGS_BUFF",common_tags));
		out.push('</td>\n');
		
		//TMCPTNCD
		out.push('<td>\n');
		out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"TMC").replace('DEFAULT_VALUE',val.TMCPTNCD).replace("TAGS_BUFF",common_tags));
		out.push('</td>\n');
		
		//TMCINFO
		out.push('<td class="TMCPTNCD">\n');
		out.push(val.TMCPTNNM + '<br>\n' + val.TMCJUSYO);
		out.push('</td>\n');
		
		//CKCPTNCD
		out.push('<td>\n');
		out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"CKC").replace('DEFAULT_VALUE',val.CKCPTNCD).replace("TAGS_BUFF",common_tags));
		out.push('</td>\n');

		//CKCINFO
		out.push('<td class="CKCPTNCD">\n');
		out.push(val.CKCPTNNM + '<br>\n' + val.CKCJUSYO);
		out.push('</td>\n');

		//UNSKSTNCD
		out.push('<td>\n');
		out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"UNSKS").replace('DEFAULT_VALUE',val.UNSKSPTNCD).replace("TAGS_BUFF",common_tags));
		out.push('</td>\n');

		//UNSKSINFO
		out.push('<td class="UNSKSPTNCD">\n');
		out.push(val.UNSKSPTNNM);
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


	var jgscd = ($("select[name='jgscd']").val()) ? $("select[name='jgscd']").val() : '';
	var tmcptncd= ($("select[name='tmcptncd']").val()) ? $("select[name='tmcptncd']").val() : '';
	var ckcptncd = ($("select[name='ckcptncd']").val()) ? $("select[name='ckcptncd']").val() : '';
	var unsksptncd = ($("select[name='unsksptncd']").val()) ? $("select[name='unsksptncd']").val() :'';

	//JGSCD
	out.push('<td>\n');
	out.push(_divide_combo_jgs.replace('DEFAULT_VALUE',jgscd).replace("TAGS_BUFF",common_tags));
	out.push('</td>\n');

	//TMCPTNCD
	out.push('<td>\n');
	out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"TMC").replace('DEFAULT_VALUE',tmcptncd).replace("TAGS_BUFF",common_tags));
	out.push('</td>\n');

	//TMCINFO
	out.push('<td class="TMCPTNCD">\n');
	out.push(_divide_data.name + '<br/>\n' + _divide_data.address);
	out.push('</td>\n');

	//CKCPTNCD
	out.push('<td>\n');
	out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"CKC").replace('DEFAULT_VALUE',ckcptncd).replace("TAGS_BUFF",common_tags));
	out.push('</td>\n');

	//CKCINFO
	out.push('<td class="CKCPTNCD">\n');
	out.push(_divide_data.name + '<br/>\n' + _divide_data.address);
	out.push('</td>\n');


	//UNSKSPTNCD
	out.push('<td>\n');
	out.push(_divide_combo.replace(/DIVIDE_TAG_/g,"UNSKS").replace('DEFAULT_VALUE',unsksptncd).replace("TAGS_BUFF",common_tags));
	out.push('</td>\n');

	//UNSKSINFO
	out.push('<td class="UNSKSPTNCD">\n');
	out.push(_divide_data.name);
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
	
	$("input[name='JGSCD']:last").focus();
	
	_new_count++;
}

function DoUpdate(){
	
	$(OBJ_PROGRESS).css({display:'flex'});
	
	var obj = [];
	
	
	$(".on_modify").each(function(){
		var target_id = $(this).attr("data-target-id");
		var root_id = $(this).hasClass("new_row") ? null : target_id;
		var JGSCD = "'" + $(this).find("[name='JGSCD']").val() + "'";
		var TMCPTNCD = "'" + $(this).find("[name='TMCPTNCD']").val() + "'";
		var CKCPTNCD = "'" + $(this).find("[name='CKCPTNCD']").val() + "'";
		var UNSKSPTNCD = "'" + $(this).find("[name='UNSKSPTNCD']").val() + "'";
		var del_flag = $(this).find("[name='del_flag']").val();
		
		obj.push("("+root_id+","+JGSCD+","+TMCPTNCD+","+CKCPTNCD+","+UNSKSPTNCD+","+del_flag+")");
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
		ajax.setParams('999040','update_data',update[0]["DATA"]);
		
		$.when(
			ajax.getData(true)
		).done(function(data){
			getMainData();
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
	else{
		ajax.setParams('999040','update_data',null);
		
		$.when(
			ajax.getDataMultipul(update,true)
		).done(function(data){
			getMainData();
		}).fail(function(){
			$(OBJ_PROGRESS).css({display:'none'});
		});
	}
}