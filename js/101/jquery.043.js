
var first_tbody;
$(document).ready(function(){

	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){

		var texts = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id;});
		data = {"NNSICD":selects.join(",")};
		$('#selection_NNSICD_text').html(texts.join(" / "));
	}
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		
		if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
			var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
			var sntcd = selects.join(",");
			$("#param_sntcd").val(sntcd);
		}
		
		window.document.output_form.action = "/class/csv/output.php?method=101043" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	//PDF出力ボタン
	$(BTN_OUTPUT_PDF).click(function(){
		var window_name = "101043_pdf";
		$("#param_sntnm").val($("#selection_SNTCD_text").text());
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=101043";
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit();
	});
	
	first_tbody = $('#data_table').html();
	var data = {"SNTCD":null};
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}
	
	getMainData(data);
	
});

function getMainData(data){
	ResetTableSetting();
	$("#data_table").html(first_tbody);
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	ajax.setParams('101043','get_main_data',data);
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
		
		$(BTN_OUTPUT).hide();
	}
	else {
		var out = [];
		var foot = [];
		var exclusion = ['DATA_DIVIDE','NNSICD','NNSINM','PTNCD','JGSCD'];
		
		data.forEach(function (val, index, arr) {
			if(val.DATA_DIVIDE === "3"){
				foot.push('<tfoot>\n');
				foot.push('<tr>\n');
				for (var key in val) {
					if($.inArray(key, exclusion) === -1){
						if ( key.match(/KKTSR|WGT/)) {
							foot.push('<td class="ta_right">'+functions.numSeparate(val[key])+'</td>\n');
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
		
		DataTableSetting();
		
		$(BTN_OUTPUT).show();
	}
	
}


