var user_id = "#user_id";
var password = "#password";
var auto_login = "#auto_login";

$(document).ready(function(){

	if ($('#login_area').is(':visible')) {
		$(user_id).focus();
	}
	
	$('.btn_login').click(function(){
		DoLogin();
	});
	
	$(password).bind("keydown", function(e) {
		if (e.which === 13)
		{
			e.preventDefault();
			DoLogin();
		}
	});
	
	
	//clear storage
	sessionStorage.clear();
	
});

function DoLogin(){
	
	if(!$("#login_form").validationEngine('validate')){
		return;
	}

	var caution_area = ".caution_area";
	
	$(OBJ_PROGRESS).css({display:'flex'});
	$(caution_area).hide();
	
	var ajax = new Ajax();
	var data = {
				user_id : getVal(user_id)
			  , user_password : getVal(password)
			  , auto_login : getVal(auto_login)
	};
	ajax.setParams('index','login',data);
	
	$.when(
		ajax.getData(null,null,null,500)
	).then(
		function(data){
			var error_area = $(".caution_area p");
			switch(data.status){
				case STATUS_NG_USER:
					error_area.text("ユーザーが存在しません");
					$(caution_area).show();
					$(OBJ_PROGRESS).css({display:'none'});
					break;
				case STATUS_NG_PASS:
					error_area.text("パスワードが違います");
					$(caution_area).show();
					$(OBJ_PROGRESS).css({display:'none'});
					break;
				case STATUS_OTHER_LOGIN:
					var message = new Message(user_id);
					message.DisplayError("他の端末にて同一ユーザーIDが使用されています。<br>他の端末での処理を終了させ、再度実行してください。");
					$(OBJ_PROGRESS).css({display:'none'});
					
					break;
				case STATUS_OK:
					SetDisplay(data.data[0]);
					break;
			}
		},
		function(jqXHR){console.log(jqXHR)}
	).fail(function(error){
		$(OBJ_PROGRESS).css({display:'none'});
	});
}

function SetDisplay(user_data){
	var ajax = new Ajax();
	var data = {};
	ajax.setParams('index','get_menu',data);
	
	$.when(
		ajax.getData()
	).then(
		function(data){
			setMainManu(data.main_menu);
			setSubManu(data.sub_menu);

			$('header p.login_name span').html(user_data.user_name + " でログイン中");
			$("#login_area").fadeOut(100);
		},
		function(jqXHR){console.log(jqXHR)}
	).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	});
}

function setMainManu(data){
	var output = [];
	data.forEach(function(val,index,arr){
		
		var params = (val.params) ? '?' + val.params : '';
		var url = URL + val.function_id + '/' + params;
		output.push('<li>');
		output.push('\t<a data-href="'+url+'" class="hover_txt">');
		output.push('\t\t<div class="img_wrap">');
		output.push('\t\t\t<img src="'+IMG_DIR+'icon/'+val.icon_name+'" alt="'+val.menu_name+'" class="hover_txt">');
		output.push('\t\t</div>');
		output.push('\t\t'+val.menu_name);
		output.push('\t</a>');
		output.push('</li>');
		
	});
	$('#top_navigation ul').html(output.join('\n'));
}

function setSubManu(data){
	var output = [];
	output.push('<p class="menu_title">管理メニュー</p>');
	output.push('<ul class="clearfix">');
	data.forEach(function(val,index,arr){
		
		var params = (val.params) ? '?' + val.params : '';
		var url = URL + val.function_id + '/' + params;
		output.push('<li>');
		output.push('\t<a data-href="'+url+'"');
		output.push('\t\t<i class="fa fa-angle-right" aria-hidden="true"></i>');
		output.push('\t\t'+val.menu_name);
		output.push('\t</a>');
		output.push('</li>');
		
	});
	output.push('</ul>');
	$('#sub_menus').html(output.join('\n'));
}