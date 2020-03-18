$(document).ready(function(){

	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){

		var texts = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id;});
		data = {"NNSICD":selects.join(",")};
		$('#selection_NNSICD_text').html(texts.join(" / "));
	}
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		window.document.output_form.action = "/class/csv/output.php?method=101015" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	//PDF出力ボタン
	$(BTN_OUTPUT_PDF).click(function(){
		var window_name = "101015_pdf";
		
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=101015" ;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
	});
	
	getMainData();
	
});

function getMainData(){
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	ajax.setParams('101015','get_main_data',{});
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	})
	
}

function setDisplay(data){
	
	var target = $('#data_table tbody');
	
	if(!data.length){
		target.find('td.no_data').addClass('shown');
	}
	else {
		target.empty();
		var out = [];
		var foot = [];
		var exclusion = ['DATA_DIVIDE','NHNSKCD','NNSICD'];
		var tmp_dateymd = '';
		data.forEach(function (val, index, arr) {
			if(val.DATA_DIVIDE === "3"){
				foot.push('<tfoot>\n');
				foot.push('<tr>\n');
				for (var key in val) {
					if($.inArray(key, exclusion) === -1){
						if ( key.match(/KKTSR|WGT/)) {
							foot.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
						}
						else if(key.match(/DATEYMD/)){
							foot.push('<td></td>\n');
						}
						else{
							foot.push('<td>'+val[key]+'</td>\n');
						}
					}
				}
				foot.push('</tr>\n');
				foot.push('</tfoot>\n');
			}
			else{
				if(val.DATA_DIVIDE === "2"){
					out.push('<tr class="totals">\n');
				}
				else{
					out.push('<tr>\n');
				}
				
				for (var key in val) {
					if($.inArray(key, exclusion) === -1){
						if ( key.match(/KKTSR|WGT/)) {
							out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
						}
						/*
						else if(key.match(/DATEYMD/)){
							if(val[key] === tmp_dateymd){
								out.push('<td></td>\n');
							}
							else{
								out.push('<td>'+val[key]+'</td>\n');
							}
							tmp_dateymd = val[key];
						}
						*/
						else{
							out.push('<td>'+val[key]+'</td>\n');
						}
					}
				}
				out.push('</tr>\n');
			}
			
		});
		
		target.html(out.join(""));
		target.after(foot.join(""));
		
		DataTableSetting(1);
		
		$(BTN_OUTPUT).show();
	}
	
}


