$(document).ready(function(){

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

	if(JSON.parse(sessionStorage.getItem(LS_NINUSHI))){

		var texts = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.name;});
		var selects = JSON.parse(sessionStorage.getItem(LS_NINUSHI)).map(function(val){return val.id;});
		data = {"NNSICD":selects.join(",")};
		$('#selection_NNSICD_text').html(texts.join(" / "));
	}


});

function SetStorage(){
	var params = {
			'101010_DATE_DIVIDE':getVal('input[name=date_divide]')
		,	'101010_DATE_FROM':getVal('input[name=date_from]')
		,	'101010_DATE_TO':getVal('input[name=date_to]')
		,	'101010_NINUSHI':JSON.parse(sessionStorage.getItem(LS_NINUSHI))
	};
	for (var key in params) {
		sessionStorage.setItem(key,params[key]);
	}
	SetParamatersToStorage(params)
}