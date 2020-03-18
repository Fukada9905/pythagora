function getMasterData(process_type,is_onset,is_single_selection){
	var data = {};
	var after_process;
	
	var select_JGSCD = JSON.parse(sessionStorage.getItem(LS_JIGYOSHO));
	var select_PTNCD = JSON.parse(sessionStorage.getItem(LS_PARTNER));
	
	switch (process_type){
		case 'jigyosho':
			
			after_process = OpenJigyoshoMaster;
			break;
		case 'ninushi':
			after_process = OpenNinushiMaster;
			break;
		case 'center':
			after_process = OpenCenterMaster;
			if(select_PTNCD) {
				var ptncds = select_PTNCD.map(function(value){return value.id});
				data = {'PTNCD':ptncds.join(","),'PROCESS_DIVIDE':sessionStorage.getItem(LS_PROCESS_DIVIDE)}
			}else if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(","),'PROCESS_DIVIDE':sessionStorage.getItem(LS_PROCESS_DIVIDE)}
			}
			else{
				data = {'JGSCD':null,'PROCESS_DIVIDE':sessionStorage.getItem(LS_PROCESS_DIVIDE)};
			}
			break;
		case 'partner':
			after_process = OpenPartnerMaster;
			if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(",")}
			}
			else{
				data = {'JGSCD':null};
			}
			break;
		case 'sub_partner':
			after_process = OpenPartnerSubMaster;
			if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(",")}
			}
			else{
				data = {'JGSCD':null};
			}
			break;
		case 'root_partner1':
			after_process = OpenRootPartnerMaster1;
			if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(","),'PTNCD':null}
			}
			else if(select_PTNCD){
				var ptncds = select_PTNCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':null,'PTNCD':ptncds.join(",")};
			}
			else{

				data = {'JGSCD':null,'PTNCD':null};
			}
			break;
		case 'root_partner2':
			after_process = OpenRootPartnerMaster2;
			if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(","),'PTNCD':null}
			}
			else if(select_PTNCD){
				var ptncds = select_PTNCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':null,'PTNCD':ptncds.join(",")};
			}
			else{

				data = {'JGSCD':null,'PTNCD':null};
			}
			break;
		case 'root_partner3':
			after_process = OpenRootPartnerMaster3;
			if(select_JGSCD){
				var jgscds = select_JGSCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':jgscds.join(","),'PTNCD':null}
			}
			else if(select_PTNCD){
				var ptncds = select_PTNCD.map(function(value){return "'"+value.id+"'"});
				data = {'JGSCD':null,'PTNCD':ptncds.join(",")};
			}
			else{

				data = {'JGSCD':null,'PTNCD':null};
			}
			break;
	}
	
	var ajax = new Ajax();
	ajax.setParams('common','get_'+process_type,data);
	$.when(
		ajax.getData(true)
	).done(
		function(data){
			after_process(data,is_onset,is_single_selection);
		}
	);
	
}

function openSubForms(process_text,column_count,inner_html,is_selectable,is_all_selectable,ok_callback,clear_callback){
	
	var over_ray = $("#over_ray");
	var inner = over_ray.find(".over_ray_inner");
	var title = process_text + '指定';
	
	var html = [];
	html.push('<h3>'+title+'</h3>\n');
	html.push('<div class="over_ray_inner_inner">\n');
	html.push('<table class="list_table">\n');
	html.push('<thead>\n');
	html.push('<tr>\n');
	if(is_selectable && is_all_selectable){
		html.push('<th style="text-align: center; width: 20px;"><input type="checkbox" id="master_all_checks"></th>\n');
		html.push('<th colspan="'+(column_count - 1)+'">選択可能'+process_text+'</th>\n');
	}
	else{
		html.push('<th colspan="'+column_count+'">選択可能'+process_text+'</th>\n');
	}
	
	html.push('</tr>\n');
	html.push('<tbody>\n');
	html.push(inner_html);
	html.push('</tbody>\n');
	html.push('</table>\n');
	html.push('</div>\n');
	
	$(inner).html(html.join(""));
	
	if(is_selectable){
		var btns = [];
		btns.push("<div class=\"set_btns\">");
		btns.push("<button type=\"button\" class=\"btn btn_set_config_clear\">クリア</button>");
		btns.push("<button type=\"button\" class=\"btn btn_set_config\">確定</button>");
		btns.push("</div>");
		
		over_ray.find(".over_ray_inner_inner").after(btns.join(""));
		
		$(".btn_set_config").off("click").on("click",function(){
			ok_callback();
			over_ray.stop().fadeOut("fast");
		});
		$(".btn_set_config_clear").off("click").on("click",function(){
			clear_callback();
			over_ray.stop().fadeOut("fast");
		});
		if(is_all_selectable){
			$("#master_all_checks").off("change").on("change",function(){
				$("input.selections").prop("checked",$(this).prop("checked"));
			});
		}
	}
	
	over_ray.stop().fadeIn("fast");
}

function OpenJigyoshoMaster(data,is_onset_reload,is_single_selection){
	var inner_html = [];
	var column_count = 2;
	
	var is_selectable = true;
	var selectable = [];
	var arr_jigyosho = JSON.parse(sessionStorage.getItem(LS_JIGYOSHO));
	
	if(JSON.parse(sessionStorage.getItem(LS_JIGYOSHO))){
		selectable = JSON.parse(sessionStorage.getItem(LS_JIGYOSHO)).map(function(val){return val.id;});
	}
	
	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.JGSCD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="selections jigyosho_selections" value="'+val.JGSCD+'" data-label="'+val.JGSCD+':'+val.JGSNM+'"'+checked+'></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.JGSCD+':'+val.JGSNM+'</label></td>');
		inner_html.push('</tr>');
	});
	
	
	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}
	
	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;
	
	var ok_callback = function(){
		var checked = [];
		
		$('input.selections:checked').each(function(){
			checked.push({'id':$(this).data('label').split(':')[0],'name':$(this).data('label').split(':')[1]});
		});
		
		var data_length = $('input.selections').length;
		
		if(!checked.length || checked.length === data_length){
			$('#selection_JGSCD_text').html('指定なし');
			sessionStorage.removeItem(LS_JIGYOSHO);
			//$(".btn_partner").prop("disabled",false);
		}
		else{
			
			var texts = checked.map(function(value){return value.id + ':' + value.name;});
			$('#selection_JGSCD_text').html(texts.join(" / "));
			sessionStorage.setItem(LS_JIGYOSHO,JSON.stringify(checked));
			//$(".btn_partner").prop("disabled",true);
		}
		
		var changed = false;
		if((arr_jigyosho) || (checked.length)){
			
			if(!checked.length || !(arr_jigyosho)){
				changed = true;
			}
			else if(checked.length !== arr_jigyosho.length){
				changed = true;
			}
			else{
				for(var i=0;i<checked.length;i++){
					if(checked[i].name !== arr_jigyosho[i].name){
						changed = true;
						break;
					}
				}
			}
		}
		
		if(changed){
			sessionStorage.removeItem(LS_CENTER);
			$('#selection_SNTCD_text').html('指定なし');
		}
	};
	
	var clear_callback = function(){
		$('#selection_JGSCD_text').html('指定なし');
		sessionStorage.removeItem(LS_JIGYOSHO);
		sessionStorage.removeItem(LS_CENTER);
		$('#selection_SNTCD_text').html('指定なし');
		//$(".btn_partner").prop("disabled",false);
	};
	
	openSubForms('事業所',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);
	
	
	if(is_single_selection){
		
		$('input.jigyosho_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.jigyosho_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}

}

function OpenNinushiMaster(data,is_onset_reload,is_single_selection){
	var inner_html = [];
	var column_count = 2;
	var is_selectable = true;
	var selectable = [];
	
	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){
		selectable = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id;});
	}
	
	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.NNSICD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="ninushi_selections selections" value="'+val.NNSICD+'" data-label="'+val.NNSICD+':'+val.NNSINM+'"'+checked+'></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.NNSICD+':'+val.NNSINM+'</label></td>');
		inner_html.push('</tr>');
	});
	
	
	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}
	
	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;
	
	var ok_callback = function(){
		var checked = [];
		
		$('input.selections:checked').each(function(){
			checked.push({'id':$(this).data('label').split(':')[0],'name':$(this).data('label').split(':')[1]});
		});
		
		
		var data_length = $('input.selections').length;
		
		if(!checked.length || checked.length === data_length){
			$('#selection_NNSICD_text').html('指定なし');
			sessionStorage.removeItem(LS_NINUSHI);
		}
		else{
			var texts = checked.map(function(value){return value.id + ':' + value.name;});
			$('#selection_NNSICD_text').html(texts.join(" / "));
			sessionStorage.setItem(LS_NINUSHI,JSON.stringify(checked));
		}
	};
	
	var clear_callback = function(){
		$('#selection_NNSICD_text').html('指定なし');
		sessionStorage.removeItem(LS_NINUSHI);
		
	};
	
	openSubForms('荷主',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);
	
	if(is_single_selection){
		$('input.ninushi_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.ninushi_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}
	
}

function OpenCenterMaster(data,is_onset_reload,is_single_selection){
	
	var is_onset = (is_onset_reload === undefined || is_onset_reload === null) ? true : false;
	
	var inner_html = [];
	var column_count = 3;
	
	var is_selectable = true;
	var selectable = [];
	var arr_center = JSON.parse(sessionStorage.getItem(LS_CENTER));
	if(arr_center){
		selectable = arr_center.map(function(val){return val.JGSCD + "-" + val.SNTCD;});
	}
	
	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.JGSCD + "-" + val.SNTCD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="center_selections selections" value="'+val.JGSCD+"-"+val.SNTCD+'" data-jgscd="'+val.JGSCD+'" data-sntcd="'+val.SNTCD+'" data-label="'+val.SNTCD+':'+val.SNTNM+'('+val.JGSCD+':'+val.JGSNM+')"'+checked+'></td>');
		inner_html.push('<td style="width:100px;"><label class="check_label" for="checks'+index+'">'+val.JGSCD+':'+val.JGSNM+'</label></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.SNTCD+':'+val.SNTNM+'</label></td>');
		inner_html.push('</tr>');
	});
	
	
	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}
	
	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;
	
	var ok_callback = function(){
		var checked = [];
		
		$('input.selections:checked').each(function(){
			checked.push({'JGSCD':$(this).data('jgscd'),'SNTCD':$(this).data('sntcd'),'name':$(this).data('label')});
		});
		
		
		var changed = false;
		if((arr_center) || (checked.length)){
			if(!checked.length || !(arr_center)){
				changed = true;
			}
			else if(checked.length !== arr_center.length){
				changed = true;
			}
			else{
				for(var i=0;i<checked.length;i++){
					if(checked[i].name !== arr_center[i].name){
						changed = true;
						break;
					}
				}
			}
		}
		
		var data_length = $('input.selections').length;
		
		if(!checked.length || checked.length === data_length){
			$('#selection_SNTCD_text').html('指定なし');
			sessionStorage.removeItem(LS_CENTER);
		}
		else{
			var texts = checked.map(function(value){return value.name;});
			$('#selection_SNTCD_text').html(texts.join(" / "));
			sessionStorage.setItem(LS_CENTER,JSON.stringify(checked));
		}
		
		if(changed){
			var data = {"SNTCD":null};
			if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
				var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
				data = {"SNTCD":selects.join(",")};
			}
			if(is_onset){
				getMainData(data);
			}
		}
	};
	
	var clear_callback = function(){
		$('#selection_SNTCD_text').html('指定なし');
		sessionStorage.removeItem(LS_CENTER);
		
		if((arr_center)){
			var data = {"SNTCD":null};
			if(is_onset) {
				getMainData(data);
			}
		}
	};
	
	openSubForms('センター',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);
	
	if(is_single_selection){
		$('input.center_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.center_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}
	
}


function OpenPartnerSubMaster(data,is_onset_reload,is_single_selection){
	var inner_html = [];
	var column_count = 2;
	var is_selectable = true;
	var selectable = [];
	if(JSON.parse(sessionStorage.getItem(LS_SUB_PARTNER))){
		selectable = JSON.parse(sessionStorage.getItem(LS_SUB_PARTNER)).map(function(val){return val.id;});
	}

	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.PTNCD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="partner_selections selections" value="'+val.PTNCD+'" data-label="'+val.PTNCD+':'+val.PTNNM+'"'+checked+'></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.PTNCD+':'+val.PTNNM+'</label></td>');
		inner_html.push('</tr>');
	});


	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}

	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;

	var ok_callback = function(){
		var checked = [];

		$('input.selections:checked').each(function(){
			checked.push({'id':$(this).data('label').split(':')[0],'name':$(this).data('label').split(':')[1]});
		});

		var data_length = $('input.selections').length;

		if(!checked.length || checked.length === data_length){
			$('#selection_SUBPTNCD_text').html('指定なし');
			sessionStorage.removeItem(LS_SUB_PARTNER);
		}
		else{

			var texts = checked.map(function(value){return value.id + ':' + value.name;});
			$('#selection_SUBPTNCD_text').html(texts.join(" / "));
			sessionStorage.setItem(LS_SUB_PARTNER,JSON.stringify(checked));
		}
	};

	var clear_callback = function(){
		$('#selection_SUBPTNCD_text').html('指定なし');
		sessionStorage.removeItem(LS_SUB_PARTNER);
	};

	openSubForms('パートナー',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);

	if(is_single_selection){
		$('input.partner_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.partner_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}
}

function OpenPartnerMaster(data,is_onset_reload,is_single_selection){
	var inner_html = [];
	var column_count = 2;
	var is_selectable = true;
	var selectable = [];
	if(JSON.parse(sessionStorage.getItem(LS_PARTNER))){
		selectable = JSON.parse(sessionStorage.getItem(LS_PARTNER)).map(function(val){return val.id;});
	}
	
	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.PTNCD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="partner_selections selections" value="'+val.PTNCD+'" data-label="'+val.PTNCD+':'+val.PTNNM+'"'+checked+'></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.PTNCD+':'+val.PTNNM+'</label></td>');
		inner_html.push('</tr>');
	});
	
	
	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}
	
	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;
	
	var ok_callback = function(){
		var checked = [];
		
		$('input.selections:checked').each(function(){
			checked.push({'id':$(this).data('label').split(':')[0],'name':$(this).data('label').split(':')[1]});
		});
		
		var data_length = $('input.selections').length;
		
		if(!checked.length || checked.length === data_length){
			$('#selection_PTNCD_text').html('指定なし');
			sessionStorage.removeItem(LS_PARTNER);
			$(".btn_jigyosho").prop("disabled",false);
		}
		else{
			
			var texts = checked.map(function(value){return value.id + ':' + value.name;});
			$('#selection_PTNCD_text').html(texts.join(" / "));
			sessionStorage.setItem(LS_PARTNER,JSON.stringify(checked));
			$(".btn_jigyosho").prop("disabled",true);
		}
	};
	
	var clear_callback = function(){
		$('#selection_PTNCD_text').html('指定なし');
		sessionStorage.removeItem(LS_PARTNER);
		$(".btn_jigyosho").prop("disabled",false);
	};
	
	openSubForms('パートナー',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);
	
	if(is_single_selection){
		$('input.partner_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.partner_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}
	
}

function OpenRootPartnerMaster1(data,is_onset_reload,is_single_selection){
	OpenRootPartnerMaster(1,data,is_onset_reload,is_single_selection);
}
function OpenRootPartnerMaster2(data,is_onset_reload,is_single_selection){
	OpenRootPartnerMaster(2,data,is_onset_reload,is_single_selection);
}
function OpenRootPartnerMaster3(data,is_onset_reload,is_single_selection){
	OpenRootPartnerMaster(3,data,is_onset_reload,is_single_selection);
}

function OpenRootPartnerMaster(root_master_type, data,is_onset_reload,is_single_selection){

	var SESSION_STORAGE;
	var TEXT_ID;

	switch (root_master_type) {
		case 1:
			SESSION_STORAGE = LS_ROOTPT1;
			TEXT_ID = "#selection_ROOTPT1_text";
			break;
		case 2:
			SESSION_STORAGE = LS_ROOTPT2;
			TEXT_ID = "#selection_ROOTPT2_text";
			break;
		case 3:
			SESSION_STORAGE = LS_ROOTPT3;
			TEXT_ID = "#selection_ROOTPT3_text";
			break;
	}


	var inner_html = [];
	var column_count = 2;
	var is_selectable = true;
	var selectable = [];
	if(JSON.parse(sessionStorage.getItem(SESSION_STORAGE))){
		selectable = JSON.parse(sessionStorage.getItem(SESSION_STORAGE)).map(function(val){return val.id;});
	}

	data.forEach(function(val,index,arr) {
		var checked = "";
		if(selectable){
			checked = selectable.indexOf(val.PTNCD) >= 0 ? " checked" : "";
		}
		inner_html.push('<tr>');
		inner_html.push('<td style="text-align: center; width: 20px;"><input type="checkbox" id="checks'+index+'" class="partner_selections selections" value="'+val.PTNCD+'" data-label="'+val.PTNCD+':'+val.PTNNM+'"'+checked+'></td>');
		inner_html.push('<td><label class="check_label" for="checks'+index+'">'+val.PTNCD+':'+val.PTNNM+'</label></td>');
		inner_html.push('</tr>');
	});


	if(!inner_html.length){
		inner_html.push('<tr>');
		inner_html.push('<td colspan="'+column_count+'">対象データがありません</td>');
		inner_html.push('</tr>');
		is_selectable = false;
	}

	var is_all_selectable = (is_single_selection || !is_selectable) ? false : true;

	var ok_callback = function(){
		var checked = [];

		$('input.selections:checked').each(function(){
			checked.push({'id':$(this).data('label').split(':')[0],'name':$(this).data('label').split(':')[1]});
		});

		var data_length = $('input.selections').length;

		if(!checked.length || checked.length === data_length){
			$(TEXT_ID).html('指定なし');
			sessionStorage.removeItem(SESSION_STORAGE);
		}
		else{

			var texts = checked.map(function(value){return value.id + ':' + value.name;});
			$(TEXT_ID).html(texts.join(" / "));
			sessionStorage.setItem(SESSION_STORAGE,JSON.stringify(checked));
		}
	};

	var clear_callback = function(){
		$(TEXT_ID).html('指定なし');
		sessionStorage.removeItem(SESSION_STORAGE);
	};

	openSubForms('パートナー',column_count,inner_html.join(""),is_selectable,is_all_selectable,ok_callback,clear_callback);

	if(is_single_selection){
		$('input.partner_selections').off('click').on('click',function(){
			if ($(this).prop('checked')){
				// 一旦全てをクリアして再チェックする
				$('.partner_selections').prop('checked', false);
				$(this).prop('checked', true);
			}
		})
	}

}