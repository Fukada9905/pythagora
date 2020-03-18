$(document).ready(function(){
	
	var active_tab_id = $(".tab_area div.active").data("target-view");
	$(".tab_container:not(#"+active_tab_id+")").css({"z-index":"-1"});
	
	//CSV出力ボタン
	$(BTN_OUTPUT_CSV).click(function(){
		
		var target_form = $(".tab_controller.active").attr("data-target-view");
		var target_date = $("#"+target_form).find("section.data_area.slick-active").attr("data-target-date");
		$("#params_target_date_csv").val(target_date);
		
		window.document.output_form.action = "/class/csv/output.php?method=103030" ;
		window.document.output_form.method = "POST" ;
		window.document.output_form.submit() ;
	});
	
	//PDF出力ボタン
	$(BTN_OUTPUT_PDF).click(function(){
		
		var target_form = $(".tab_controller.active").attr("data-target-view");
		var target_divide = (target_form === "target-view-houmen") ? 1 : 2;
		$("#params_target_divide").val(target_divide);
		var target_date = $("#"+target_form).find("section.data_area.slick-active").attr("data-target-date");
		$("#params_target_date").val(target_date);
		
		var window_name = "103030_"+target_divide+"_"+target_date.replace(/\//g,'')+"pdf";
		
		window.document.output_form_pdf.action = "/class/pdf/output.php?method=103030&process_divide="+target_divide;
		window.document.output_form_pdf.method = "POST" ;
		window.document.output_form_pdf.target = window_name ;
		window.document.output_form_pdf.submit() ;
	});
	
	$(BTN_OUTPUT).show();
	
	var slider_houmen = $('#view_houmen_wrap');
	slider_houmen.slick({
		dots: true,
		infinite: false,
		speed: 300,
		slidesToShow: 1,
		slidesToScroll: 1,
		initialSlide: Number($("#date_length").text())
	});
	
	var slider_souko = $('#view_shukkasouko_wrap');
	slider_souko.slick({
		dots: true,
		infinite: false,
		speed: 300,
		slidesToShow: 1,
		slidesToScroll: 1,
		initialSlide: Number($("#date_length").text())
	});
	

	$(".tab_area div.tab_controller").click(function(){
		if(!$(this).hasClass("active")){
			$(".tab_area div.tab_controller").removeClass("active");
			$(this).addClass("active");
			
			$(".tab_container:not('#"+$(this).data("target-view")+"')").css({"z-index":"-1"});
			$("#"+$(this).data("target-view")).css({"z-index":"1"});
		}
	});
	
	slider_houmen.on("afterChange",function(slick, currentSlide){
		var new_index = $(this).slick('slickCurrentSlide');
		var obj = $("#view_houmen_wrap .data_area[data-slick-index='"+new_index+"']");
		var target_date = obj.data("target-date");
		var is_load = obj.data("is-load");
		if(!is_load){
			getMainData(1,target_date);
		}
		
	});
	
	slider_souko.on("afterChange",function(slick, currentSlide){
		var new_index = $(this).slick('slickCurrentSlide');
		var obj = $("#view_shukkasouko_wrap .data_area[data-slick-index='"+new_index+"']");
		var target_date = obj.data("target-date");
		var is_load = obj.data("is-load");
		if(!is_load){
			
			getMainData(2,target_date);
		}
	});
	
	
	getFirstData();
	
});


function getFirstData(){
	var last_date = $(".data_area:last-of-type").data("target-date");
	
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	var ajax2 = new Ajax();
	
	ajax.setParams('103030','get_main_data',{"target_divide":1,"target_date":last_date});
	ajax2.setParams('103030','get_main_data',{"target_divide":2,"target_date":last_date});
	
	$.when(
		ajax.getData(true)
	,	ajax2.getData(true)
	).then(function(data1,data2){
		setDisplay(1,last_date,data1);
		setDisplay(2,last_date,data2);

	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	})
}

function getMainData(target_divide,target_date){
	$(OBJ_PROGRESS).css({display:'flex'});
	var ajax = new Ajax();
	
	ajax.setParams('103030','get_main_data',{"target_divide":target_divide,"target_date":target_date});
	$.when(
		ajax.getData(true)
	).done(function(data){
		setDisplay(target_divide,target_date,data);
	}).always(function(){
		$(OBJ_PROGRESS).css({display:'none'});
	})
	
}


function setDisplay(target_divide,target_date,data){
	
	
	var target;
	var target_wrap;
	var table_id;
	var exclusion = ['JGSCD','JGSNM','SNTCD','NNSICD','UNSKSCD','NHNSKCD','DATA_DIVIDE'];
	
	if(target_divide === 1){
		target_wrap = "#view_houmen_wrap .data_area[data-target-date='"+target_date+"']";
		table_id = "houmen_data_table_"+target_date.replace(/\//g,"_");
		target = $(target_wrap).find("#"+table_id + " tbody");
		
	}
	else{
		target_wrap = "#view_shukkasouko_wrap .data_area[data-target-date='"+target_date+"']";
		table_id = "shukkasouko_data_table_"+target_date.replace(/\//g,"_");
		target = $(target_wrap).find("#"+table_id + " tbody");
		
	}
	
	if(!data.length){
		target.find('td.no_data').addClass('shown');
		$(target_wrap).data("is-load",1);
		SetDataTableHeight(false,false);
	}
	else {
		target.empty();
		var out = [];
		var foot = [];
		
		data.forEach(function (val, index, arr) {
			if(val.DATA_DIVIDE === "4"){
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
				if(val.DATA_DIVIDE === "3"){
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
		$(target_wrap).data("is-load",1);
		DataTableSetting(1,$(target_wrap),table_id);
	}
	
}






