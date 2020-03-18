var target_top = 0;
var iah = 0;

var table_wrap_class = "div.table_wrap";

var startTime = new Date();
var lastTime = new Date();
var is_a = false;

$(document).ready(function(){

	//PAGE TOPボタンクリック
	var to_top = $('.to_top');
	to_top.click(function(){
		var speed = 1000;
		var href= $(this).attr("href");
		var target = $(href === "#" || href === "" ? 'html' : href);
		var position = target.offset().top;
		$("html, body").animate({scrollTop:position}, speed, "swing");
		return false;
	});
	
	//PAGE TOPボタン表示
	var offsetTop = 100;
	var floatMenu = function() {
		if ($(window).scrollTop() > offsetTop) {
			to_top.fadeIn();
		} else {
			to_top.fadeOut();
		}
	};
	$(window).scroll(floatMenu);
	$('body').bind('touchmove', floatMenu);
	
	
	//SPナビ開閉
	var sp_nav = $(".sp_nav");
	var responsive_wrap = $(".responsive_menu_wrap,.responsive_menu,.resoponsive_search_area");
	$(".sp_nav_btn").click(function () {
		responsive_wrap.stop().toggleClass("show");
		sp_nav.stop().toggleClass("is-opened");
		
	});
	$(".responsive_menu_wrap").click(function () {
		responsive_wrap.stop().toggleClass("show");
		sp_nav.stop().toggleClass("is-opened");
	});

	//テーブルの高さを設定
	var table_wrap = $(table_wrap_class);
	if(table_wrap.length){
		target_top = table_wrap.offset().top;
	}
	var input_area_wrapper = $('.input_area_wrapper');
	if(input_area_wrapper.length){
		iah = input_area_wrapper.outerHeight();
	}
	SetDataTableHeight(false,false);
	
	$(window).bind('beforeunload', function(event) {
		if(!is_a) SetLogoutStatus();
	});

	$(window).bind('pagehide', function(event) {
		if(!is_a) SetLogoutStatus();
	});

	$(document).on("click","a",function(){
		var href = $(this).attr("data-href");
		if(href.substr(0,1) !== "#"){
			is_a = true;
			SetLogoutStatus();
			location.href= href;
		}
	});
	
	$("section.input_area .input_area_title").click(function(){
		
		if($(this).parents("section.input_area").hasClass("hidden")) {
			$(this).find("i").stop().attr('class',$(this).find("i").attr('class').replace('down','up'));
			$("#over_btn > div").css({'margin-top': '-100px'});
			$(".submit_btns button.btn").css({'width':'80px','height':'80px'});
			SetDataTableHeight(true,true);
		}
		else{
			$(this).find("i").stop().attr('class',$(this).find("i").attr('class').replace('up','down'));
			$("#over_btn > div").css({'margin-top': '-85px'});
			$(".submit_btns button.btn").css({'width':'70px','height':'70px'});
			SetDataTableHeight(true,false);
		}
		$(this).parents("section.input_area").stop().toggleClass("hidden");
	});


	function timer_func(){
		if (!$('#login_area').is(':visible')) {
			location.href='/logout.php?AUTO_LOGOUT=true';
		}
	}
	var time_limit=20*60*1000; //制限時間
	var timer_id=setTimeout(timer_func, time_limit);

	$('body').on('keydown mousedown',function(){
		clearTimeout(timer_id);
		lastTime = new Date();
		var currentTime = new Date();
		if(currentTime - startTime > 60 * 1000){
			continueSession();
			startTime = new Date();
		}
		timer_id=setTimeout(timer_func, time_limit);
	});


	$(window).focus(function(){
		if(functions.isIOS()){
			var currentTime = new Date();
			if(currentTime - lastTime > 20 * 60 * 1000){
				if (!$('#login_area').is(':visible')) {
					location.href='/logout.php?AUTO_LOGOUT=true';
				}
			}
		}
	})

});


$(window).keyup(function(e){
	if(e.keyCode === 27){
		$(".sp_nav").stop().removeClass("is-opened");
		$(".responsive_menu_wrap,.responsive_menu,.resoponsive_search_area").stop().removeClass("show");
	}
});

$(window).resize(function(){SetDataTableHeight(false,false);});

function SetDataTableHeight(is_delay,is_hidden){
	if($(table_wrap_class).length){
		$(table_wrap_class).each(function(){
			var target = $(this);
			var wh = $(window).height();
			var fh = $("footer").height();
			var abh = 0;
			var data_area =target.find(".sData");
			
			
			var container_width = $(this).parent().width();
			target.css("width",container_width);
			data_area.css("width",container_width);
			
			var add_btn = $(this).next(".over_ray_footers, .over_ray_footers_multi, .master_add_btn");
			if(add_btn.length){
				abh = add_btn.outerHeight() + 20;
			}
			
			var sh;
			var table_wrap = $(this);
			if(!is_delay){
				
				sh = wh-table_wrap.offset().top-fh-abh-50;
				if(sh < 0){
					target.css("height","400px");
					if(data_area.length){
						data_area.css("height",(400-parseInt(data_area.css("margin-top"),10)-parseInt(data_area.css("margin-bottom"),10)) + "px");
					}
				}
				else{
					target.css("height",sh + "px");
					if(data_area.length){
						data_area.css("height",(sh-parseInt(data_area.css("margin-top"),10)-parseInt(data_area.css("margin-bottom"),10)) + "px");
					}
				}
				
				
			}
			else{
				if(is_hidden){
					sh = wh-target_top-fh-abh-50;
					if(sh < 0){
						target.css("height","400px");
						if(data_area.length){
							data_area.css("height",(400-parseInt(data_area.css("margin-top"),10)-parseInt(data_area.css("margin-bottom"),10)) + "px");
						}
					}
					else{
						target.css("height",sh + "px");
						if(data_area.length){
							data_area.css("height",(sh-parseInt(data_area.css("margin-top"),10)-parseInt(data_area.css("margin-bottom"),10)) + "px");
						}
					}
					
					
				}
				else{
					sh = wh-target_top-fh-abh-50+iah;
					if(sh < 0){
						target.animate({"height":"500px"},100,'easeInOutCubic');
						if(data_area.length){
							data_area.animate({"height":"500px"},100,'easeInOutCubic');
						}
					}
					else{
						target.animate({"height":sh + "px"},100,'easeInOutCubic');
						if(data_area.length){
							data_area.animate({"height":(sh-parseInt(data_area.css("margin-top"),10)-parseInt(data_area.css("margin-bottom"),10)) + "px"},100,'easeInOutCubic');
						}
					}
					
				}
			}
			
		});
	}
}

function continueSession(){
	var ajax = new Ajax();
	ajax.setParams('common','continue',{});
	ajax.sympleAsync();
}

function SetLogoutStatus(){
	var ajax = new Ajax();
	var data = {};
	ajax.setParams('common','set_logout',data);
	ajax.getDataSync();
}

function SetParamatersToStorage(data){
	var ajax = new Ajax();
	ajax.setParams('common','set_storage',data);
	ajax.getDataSync();
}

function ResetSessionParamaters(data){
	var ajax = new Ajax();
	ajax.setParams('common','reset_storage',data);
	ajax.getDataSync();
}