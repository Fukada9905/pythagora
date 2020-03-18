$(document).ready(function(){
	
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}
	
	getMainData();
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		window.document.output_form.action = "/class/csv/output.php?method=201010" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	//PDF出力ボタン
	$(BTN_OUTPUT_PDF).click(function(){
		var window_name = "201010_pdf";
		$("#param_sntnm").val($("#selection_SNTCD_text").text());
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=201010";
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit();
	});
	
	
	$(document).on(".btn");
});

function getMainData(){
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	ajax.setParams('201010','get_main_data',{});
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
		$(BTN_OUTPUT).css({display:'none'});
	}
	else {
		target.empty();
		var out = [];
		var foot = [];
		var exclusion = ['DATA_DIVIDE','NNSICD'];
		var tmp_dateymd = '';
		data.forEach(function (val, index, arr) {
			if(val.DATA_DIVIDE === "3"){
				foot.push('<tfoot>\n');
				foot.push('<tr>\n');
				for (var key in val) {
					if($.inArray(key, exclusion) === -1){
						if ( key.match(/KKTSR|PL/)) {
							foot.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
						}
						else if(key.match(/NOHINYMD/)){
							foot.push('<td>総計</td>\n');
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
						if ( key.match(/KKTSR|PL/)) {
							out.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
						}
						else if(key.match(/NOHINYMD/)){
							if(val[key] === tmp_dateymd){
								out.push('<td></td>\n');
							}
							else{
								out.push('<td>'+val[key]+'</td>\n');
							}
							tmp_dateymd = val[key];
						}
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
		$(BTN_OUTPUT).css({display:'inline-block'});
		
		DataTableSetting(1);
	}
	
}


