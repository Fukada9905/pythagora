$(document).ready(function(){
	
	if(JSON.parse(sessionStorage.getItem(LS_JIGYOSHO))){
		var texts_jigyosho = JSON.parse(sessionStorage.getItem(LS_JIGYOSHO)).map(function(val){return val.id + ':' + val.name;});
		$('#selection_JGSCD_text').html(texts_jigyosho.join(" / "));
	}
	if(JSON.parse(sessionStorage.getItem(LS_PARTNER))){
		var texts_partner = JSON.parse(sessionStorage.getItem(LS_PARTNER)).map(function(val){return val.id + ':' + val.name;});
		$('#selection_PTNCD_text').html(texts_partner.join(" / "));
		$(".btn_jigyosho").prop("disabled",true);
	}

	$(document).off("click","a").on('click',"a", function(event) {
		SetJigyoshoToStorage();
		var href = $(this).attr("data-href");
		if(href.substr(0,1) !== "#"){
			is_a = true;
			SetLogoutStatus();
			location.href= href;
		}
	});


	sessionStorage.setItem(LS_PROCESS_DIVIDE,3);
	
	
});

function SetJigyoshoToStorage(){
	
	if(JSON.parse(sessionStorage.getItem(LS_PARTNER))){
		sessionStorage.removeItem(LS_JIGYOSHO);
	}
	
	var params = {
		'400000_JGSCD':JSON.parse(sessionStorage.getItem(LS_JIGYOSHO))
	,	'400000_PTNCD':JSON.parse(sessionStorage.getItem(LS_PARTNER))
	};
	SetParamatersToStorage(params)
}