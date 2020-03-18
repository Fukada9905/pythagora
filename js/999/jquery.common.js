$(document).ready(function(){
	//
	$(document).off("change input",".input_controls:not([type='checkbox'])").on("change input",".input_controls:not([type='checkbox'])",function(){
		var id = $(this).attr("data-target-id");
		var change = false;
		$(".input_controls[data-target-id='"+id+"']:not(tr)").each(function(){
			if($(this).attr("type") === "checkbox"){
				var def_check = ($(this).attr("data-default-value") === "1");
				if($(this).prop("checked") !== def_check){
					change = true;
					return false;
				}
			}
			else{
				if($(this).val() !== $(this).attr("data-default-value")){
					change = true;
					return false;
				}
			}
			
		});
		if(change){
			$(this).parents("tr").addClass("on_modify");
		}
		else{
			$(this).parents("tr").removeClass("on_modify");
		}
	});
	
	
	$(document).off("change","input[type='checkbox'].input_controls").on("change","input[type='checkbox'].input_controls",function(){
		var id = $(this).attr("data-target-id");
		var change = false;
		$(".input_controls[data-target-id='"+id+"']").each(function(){
			if($(this).attr("type") === "checkbox"){
				var def_check = ($(this).attr("data-default-value") === "1");
				
				
				if($(this).prop("checked") !== def_check){
					change = true;
					return false;
				}
			}
			else{
				if($(this).val() !== $(this).attr("data-default-value")){
					change = true;
					return false;
				}
			}
			
		});
		if(change){
			$(this).parents("tr").addClass("on_modify");
		}
		else{
			$(this).parents("tr").removeClass("on_modify");
		}
	});
	
	$(BTN_CLEAR).click(function(){
		if(changeCheck()){
			jConfirm('編集内容は保存されません。<br>クリアしますか？', '破棄確認',function(r) {
				if(r===true){
					getMainData();
					$(".refine").val("");
				}
			});
		}
		else{
			$(".refine").val("");
			getMainData();
		}
		
	});
	
	$(BTN_EXECUTE).click(function(){
		if(!changeCheck()){
			jAlert('変更内容はありません','お知らせ');
		}
		else{
			if($("#update_table").validationEngine('validate')){
				DoUpdate();
			}
			
		}
	})
});

function changeCheck(){
	return ($(".on_modify").length) || ($(".on_delete").length);
}
