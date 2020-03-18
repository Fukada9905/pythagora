function Message(focus_control){
	
	this.focus_control = (focus_control === undefined) ? $("input:not([type='hidden']), select, option").first() : $(focus_control);
	
	this.DisplayNoChange = function(msg){
		var message = (msg === undefined) ? MSG_NO_CHANGE : msg;
		var focus = this.focus_control;
		jAlert(message,MSG_NO_CHANGE_TITLE,function(r){
			if(r===true){
				focus.focus();
			}
		});
	};
	
	this.DisplayNoData = function(msg){
		var message = (msg === undefined) ? MSG_NO_DATA : msg;
		var focus = this.focus_control;
		jAlert(message,MSG_NO_DATA_TITLE,function(r){
			if(r===true){
				focus.focus();
			}
		});
	};
	
	this.DisplayError = function(msg){
		var message = (msg === undefined) ? MSG_ERROR : msg;
		var focus = this.focus_control;
		jAlert(message,MSG_ERROR_TITLE,function(r){
			if(r===true){
				focus.focus();
			}
		});
	};
	
}