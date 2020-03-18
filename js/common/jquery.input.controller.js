var arrPartner = [];
var arrWarehouse = [];

$(document).ready(function(){

	var calendar = $('.calendar_ui');
	
	//Jquery UI
	calendar.datepicker({
		buttonText: "<i class='fa fa-calendar-o' aria-hidden='true'></i>",
		showOn:"button"
	});
	
	calendar.bind("keydown", function(e) {
		var c = e.which ? e.which : e.keyCode;
		if (c === 119) {
			$(this).datepicker("show");
		}
	});
	calendar.blur(function(){
		setDateFormatOnBlur($(this));
	});
	
	
	$(document).on('input', 'input.number_input',function(e) {
		var halfVal = $(this).val().replace(/[！-～]/g,
			function (tmpStr) {
				return String.fromCharCode(tmpStr.charCodeAt(0) - 0xFEE0);
			}
		);
		var maxlength = !($(this).attr("maxlength")) ? 999 : Number($(this).attr("maxlength"));
		$(this).val(halfVal.replace(/[^0-9]/g, '').substr(0,maxlength));
	});
	$(document).on('blur', 'input.number_input',function(e) {
		if(!$(this).val()){
			$(this).val('0');
		}
	});
	
	
	//マスタサブデータ
	$('.btn_function').click(function(){
		var is_noset = ($(this).data("is-noset")) ? false : null;
		var is_single_selections = ($(this).data("is-single-selection")) ? true : false;
		
		getMasterData($(this).data('open-target'),is_noset,is_single_selections);
	});

	//コントロールのキーボード遷移
	$(document).on("keydown", OBJ_FOCUS_CONTROLS,function(e) {
		var c = e.which ? e.which : e.keyCode;
		var group_name = $(this).data("focus-group");
		var groups = OBJ_FOCUS_CONTROLS + "[data-focus-group='"+group_name+"']:not(:disabled)";
		var index = $(groups).index(this);
		var length = $(groups).length;
		
		
		switch (c){
			case 13:	//ENTER
			case 9:		//TAB
				if(e.shiftKey){
					if($(this).attr("type") === "button" && c===13){
						//通常のクリック処理
					}
					else if(index === 0){
						$(groups+":last").focus();
						e.preventDefault();
					}
					else{
						$(groups+":lt(" + index + "):last").focus();
						e.preventDefault();
					}
				}
				else{
					if($(this).attr("type") === "button" && c===13){
						//通常のクリック処理
					}
					else if(event.target.type.toLowerCase() === "textarea" && c === 13){
						//高さ制限がある場合は、改行させない
						if($(this).attr("data-max-rows")){
							var textHeight = $(this).val().split("\n").length;
							if(textHeight === parseInt($(this).attr("data-max-rows"))){
								e.preventDefault();
							}
						}
					}
					else if(index === length - 1){
						if($(groups).length > 0){
							$(groups+":first").focus();
							e.preventDefault();
						}
						else{
							$(groups+":first").focus();
							e.preventDefault();
						}
					}
					else{
						$(groups + ":gt(" + index + "):first").focus();
						e.preventDefault();
					}
				}
				break;
			case 27:	//ESC
				$(this).val('');
				break;
			case 37:	//←
				break;
			case 38:	//↑
				break;
			case 39:	//→
				break;
			case 40:	//↓
				break;
		}

	});
	
	//入力エリアは全選択
	$(document).on("focus",OBJ_FOCUS_CONTROLS,function(){
		$(this).select();
	});

	//FROM TOコントロールの大小自動設定
	$(OBJ_INPUT_FROMTO).bind("blur", function(e) {
		if($(this).val() === "" || $(this).parents("dd").children("div.formError").length){
			return false;
		}
		var from_target_name = $(this).data("from-target");
		var from_target = $("input[name="+from_target_name+"]");
		var to_target_name = $(this).data("to-target");
		var to_target = $("input[name="+to_target_name+"]");

		var this_val;
		var target_val;


		if (from_target_name) {
			
			if(!isNaN($(this).val()) && !isNaN(from_target.val())){
				this_val = Number($(this).val());
				target_val = Number(from_target.val());
			}
			else{
				this_val = $(this).val();
				target_val = from_target.val();
			}
			if(this_val < target_val && target_val !== ""){
				from_target.val($(this).val());
				//TODO 名称付きコントロールは名称を設定
				//setCdName(from_target);
			}
		}

		if (to_target) {

			if(!isNaN($(this).val()) && !isNaN(to_target.val())){
				this_val = Number($(this).val());
				target_val = Number(to_target.val());
			}
			else{
				this_val = $(this).val();
				target_val = to_target.val();
			}


			if(this_val > target_val && target_val !== ""){
				to_target.val($(this).val());
				//TODO 名称付きコントロールは名称を設定
				//setCdName(to_target);
			}
		}
	});

	
	//閉じるボタン
	$(".close_btn").click(function(){
		OverRayClose();
	});
	
	//事業所・パートナー必須メニュー
	$("a.must_conditions").click(function(e){
		/*
		if($(".btn_partner").length && $(".btn_jigyosho").length &&
			!(sessionStorage.getItem(LS_JIGYOSHO)) && !(sessionStorage.getItem(LS_PARTNER))){
			var message = new Message();
			message.DisplayError("「事業所」または「業者」を選択してください");
			e.preventDefault();
			e.stopPropagation();
		}
		*/
	});
	
	
	//初期設定
	clearForms();
	
});


$(window).resize(function(){
	$( ".calendar_ui" ).datepicker("hide");
});

$(window).keyup(function(e){
	if(e.keyCode === 27){
		//OverRayClose();
	}
});

function clearForms(){
	
	
	var elem_name = '.input_controls';
	var elem= $(elem_name);
	
	
	$(elem).each(function(index, element){
		var attr = $(element).data('default-value');
		if(typeof attr !== 'undefined' && attr !== false){
			if($(element).attr('type') === 'checkbox' || $(element).attr('type') === 'radio'){
				if(attr === "checked"){
					$(element).prop("checked",true);
				}
				else{
					$(element).prop("checked",false);
				}
			}
			else{
				$(element).val(attr);
			}
		}
	});
	
	$(elem_name + ":first").focus();
	
}

function getVal(elementName){
	var val;
	switch ($(elementName).attr('type')){
		case "checkbox":
			var valList = $(elementName + ':checked').map(function(index,element){
				return ($(this).attr("data-has-escape") === "true") ? "'"+$(this).val()+"'" : $(this).val();
			});
			val = valList.get().join();
			break;
		case "radio":
			val = $(elementName + ':checked').val();
			break;
		default :
			if($(elementName).length){
				val = $(elementName).val().trim();
			}
			else{
				val = null;
				
			}
			break;
	}
	return val;
}

function setDateFormatOnBlur(object){

	var value = object.val().replace(/\//g,'');
	var length = value.length;

	if(!$.isNumeric(value) || length > 8 || length < 3){
		object.val("");
		return;
	}


	var year = '';
	var month = '';
	var day = '';

	object.val(value.replace("/",""));
	object.val(value.replace("-",""));

	var returns = '';

	if (length === 8
		&& (value.substr(0,4) <= 9999
			&& value.substr(0,4) >= 1
			&& value.substr(4,2) <= 12
			&& value.substr(4,2) >= 1
			&& value.substr(6) <= 31
			&& value.substr(6) >= 1))
	{
		year = value.substr(0,4);
		month = value.substr(4,2);
		day = value.substr(6);
		returns = makeDate(year, month, day, value);
		
	}
	else if (length === 7)
	{
		if (value.substr(0,4) <= 9999
			&& value.substr(0,4) >= 1
			&& value.substr(4,2) <= 12
			&& value.substr(4,2) >= 1
			&& value.substr(6) <= 9
			&& value.substr(6) >= 1)
		{
			year = value.substr(0,4);
			month = value.substr(4,2);
			day = '0' + value.substr(6);
			returns = makeDate(year, month, day, value);
			
		}
		else if (value.substr(0,4) <= 9999
			&& value.substr(0,4) >= 1
			&& value.substr(4,1) <= 9
			&& value.substr(4,1) >= 1
			&& value.substr(5) <= 31
			&& value.substr(5) >= 1)
		{
			year = value.substr(0,4);
			month = '0' + value.substr(4,1);
			day = value.substr(5);
			returns = makeDate(year, month, day, value);
		}
	}
	else if (length === 6)
	{
		if (value.substr(0,2) <= 99
			&& value.substr(2,2) <= 12
			&& value.substr(2,2) >= 1
			&& value.substr(4) <= 31
			&& value.substr(4) >= 1)
		{
			year = '20' + value.substr(0,2);
			month = value.substr(2,2);
			day = value.substr(4);
			returns = makeDate(year, month, day, value);
		}
		else if (value.substr(0,4) <= 9999
			&& value.substr(0,4) >= 1
			&& value.substr(4,1) <= 9
			&& value.substr(4,1) >= 1
			&& value.substr(5) <= 9
			&& value.substr(5) >= 1)
		{
			year = value.substr(0,4);
			month = '0' + value.substr(4,1);
			day = '0' + value.substr(5);
			returns = makeDate(year, month, day, value);
		}
	}
	else if (length === 5)
	{
		if (value.substr(0,2) <= 99
			&& value.substr(2,2) <= 12
			&& value.substr(2,2) >= 1
			&& value.substr(4) <= 9
			&& value.substr(4) >= 1)
		{
			year = '20' + value.substr(0,2);
			month = value.substr(2,2);
			day = '0' + value.substr(4);
			returns = makeDate(year, month, day, value);
		}
		else if (value.substr(0,2) <= 99
			&& value.substr(2,1) <= 9
			&& value.substr(2,1) >= 1
			&& value.substr(3) <= 31
			&& value.substr(3) >= 1)
		{
			year = '20' + value.substr(0,2);
			month = '0' + value.substr(2,1);
			day = value.substr(3);
			returns = makeDate(year, month, day, value);
		}
	}
	else if (length === 4
		&& (value.substr(0,2) <= 99
			&& value.substr(2,1) <= 9
			&& value.substr(2,1) >= 1
			&& value.substr(3) <= 9
			&& value.substr(3) >= 1))
	{
		year = '20' + value.substr(0,2);
		month = '0' + value.substr(2,1);
		day = '0' + value.substr(3);
		returns = makeDate(year, month, day, value);
	}
	else if (length === 3
		&& (value.substr(0,1) <= 9
			&& value.substr(1,1) <= 9
			&& value.substr(1,1) >= 1
			&& value.substr(2) <= 9
			&& value.substr(2) >= 1))
	{
		year = '200' + value.substr(0,1);
		month = '0' + value.substr(1,1);
		day = '0' + value.substr(2);
		returns = makeDate(year, month, day, value);
	}
	object.val(returns);

}

function makeDate (pYear, pMonth, pDay, pYMD){
	var ymdRet = pYMD;
	if ((pMonth === 4 || pMonth === 6 || pMonth === 9 || pMonth === 11))
	{
		if (pDay <= 30)
		{
			ymdRet = pYear + '/' + pMonth + '/' + pDay;
		}
	}
	else if (pMonth === 2)
	{
		if ((pYear % 4 === 0 && pYear % 100 !== 0 || pYear % 400 === 0))
		{
			if (pDay <= 29)
			{
				ymdRet = pYear + '/' + pMonth + '/' + pDay;
			}
		}
		else if (pDay <= 28)
		{
			ymdRet = pYear + '/' + pMonth + '/' + pDay;
		}
	}
	else
	{
		ymdRet = pYear + '/' + pMonth + '/' + pDay;
	}
	return ymdRet;
}

function OverRayClose(){
	if($('#over_ray').css('display') == 'block'){
		$("#over_ray").stop().fadeOut("fast");
	}
}


function DataTableSetting(header_rows,target_table_wrap, target_table_id){
	
	if(target_table_wrap === undefined){
		target_table_wrap = $("body")
	}
	if(target_table_id === undefined){
		target_table_id = "data_table";
	}
	var head_row = (header_rows === undefined) ? 2 : header_rows;

	
	var target = target_table_wrap.find(".table_wrap");
	target.clone().insertBefore(target);
	target_table_wrap.find(".table_wrap:first").removeClass("table_wrap").addClass("table_wrap_def");
	target_table_wrap.find(".table_wrap_def #"+target_table_id).attr("id",target_table_id+"_def");
	target_table_wrap.find("#"+target_table_id+"_def tbody").empty();
	target.css({"overflow":"hidden"});
	
	new superTable(target_table_id, {
		cssSkin : "sDefault",
		headerRows : head_row,
		fixedCols : 0
	});
	
	var data_area = target_table_wrap.find(".sData");
	
	var ps = new PerfectScrollbar(data_area.get(0));
	SetDataTableHeight(false,false);
	
	/*var container_width = target.parent().width();
	target.css("width",container_width);
	data_area.css("width",container_width);
	*/
	
}

function ResetTableSetting(target_table_wrap, target_table_id){
	
	if(target_table_wrap === undefined){
		target_table_wrap = $("body")
	}
	if(target_table_id === undefined){
		target_table_id = "data_table";
	}

	
	if(target_table_wrap.find(".table_wrap_def").length){
		target_table_wrap.find(".table_wrap").remove();
		target_table_wrap.find(".table_wrap_def").removeClass("table_wrap_def").addClass("table_wrap");
		target_table_wrap.find(".table_wrap #"+target_table_id+"_def").attr("id",target_table_id);
	}
	
}




