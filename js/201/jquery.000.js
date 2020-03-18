$(document).ready(function(){
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		var texts = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
		data = {"SNTCD":selects.join(",")};
		$('#selection_SNTCD_text').html(texts.join(" / "));
	}

	$(document).off("click","a").on('click',"a", function(event) {
		SetStorage();
		SetJigyoshoToStorage();
		var href = $(this).attr("data-href");
		if(href.substr(0,1) !== "#"){
			is_a = true;
			SetLogoutStatus();
			location.href= href;
		}
	});
	
});

function SetStorage(){
	var selects;
	if(JSON.parse(sessionStorage.getItem(LS_CENTER))){
		selects = JSON.parse(sessionStorage.getItem(LS_CENTER)).map(function(val){return "('" + val.JGSCD + "','" + val.SNTCD + "')";});
	}
	var params = {
			'201000_DATE_FROM':getVal('input[name=date_from]')
		,	'201000_DATE_TO':getVal('input[name=date_to]')
		,	'201000_CENTER':JSON.parse(sessionStorage.getItem(LS_CENTER))
	};
	SetParamatersToStorage(params)
}