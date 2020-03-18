function Ajax(){
	this.params = {};
	this.setParams = function(class_name, process, data){
		this.params = {
				CLASS_NAME : class_name
			,	PROCESS_DIVIDE : process
			,	DATA : data
		};
	};
	this.doGetData = function(data){
		var defer = $.Deferred();
		var self = this;
		$.ajax({
			url         : AJAX_HOST,
			type        : 'POST',
			data        : data,
			success     : defer.resolve,
			timeout     : 180000
		}).fail(function(xhr){
			defer.reject(xhr.statusText);
		});
		return defer.promise();
	};
	this.getData = function(is_allow_no_data,is_shown_no_data_msg,focus,wait){
		
		var is_shown_message = functions.IsNull(is_allow_no_data) ? true : is_allow_no_data;
		var wait_time = (wait === undefined) ? 0 : wait;
		var self = this;
		var message = new Message(focus);
		var defer = $.Deferred();
		$on_process = true;
		setTimeout(function(){
			self.doGetData(self.params)
				.done(function(data){
					var res = JSON.parse(data);
					switch(res.status){
						case STATUS_NO_DATA:
							if(!is_allow_no_data){
								if(is_shown_message){
									message.DisplayNoData();
								}
								defer.reject(res.message);
							}
							else{
								defer.resolve(res.data);
							}
							break;
						case STATUS_ERROR:
							message.DisplayError(res.message);
							defer.reject(res.message);
							break;
						case "":
						case undefined:
							message.DisplayError(MSG_ERROR_NETWORK);
							defer.reject("Internal Server Error");
							break;
						default:
							defer.resolve(res.data);
							break;
					}
				})
				.fail(function(status_text){
					switch(status_text){
						case "timeout":
							message.DisplayError("タイムアウトが発生しました。\nしばらくたってから再度試してください。");
							break;
						default:
							message.DisplayError();
							break;
					}
					defer.reject(status_text);
				})
				.always(function(){
					$on_process = false;
				})
		},wait_time);

		return defer.promise();
	};
	this.getDataMultipul = function(objects,is_allow_no_data,is_shown_message){
		var defer = $.Deferred();
		$on_process = true;
		var self = this;
		var message = new Message();
		
		for(var i = 0; i < objects.length; i++){
			objects[i]['CLASS_NAME'] = self.params.CLASS_NAME;
			objects[i]['PROCESS_DIVIDE'] = self.params.PROCESS_DIVIDE;
		}
		
		$.when.apply($,objects.map(function(req) {
			return self.doGetData(req);
		})).done(function() {
			var returns = [];
			var rejects = '';
			for(var i=0;i<arguments.length;i++) {
				var res = JSON.parse(arguments[i][0]);
				switch(res.status){
					case STATUS_NO_DATA:
						if(!is_allow_no_data){
							rejects = res.message;
						}
						else{
							returns.push(res.data);
						}
						break;
					case STATUS_ERROR:
						rejects = res.message;
						break;
					case "":
					case undefined:
						rejects = "Internal Server Error";
						break;
					default:
						returns.push(res.data);
						break;
				}
				if(rejects){
					defer.reject(rejects);
					break;
				}
			}
			if(!rejects){
				defer.resolve(returns);
			}
		}).fail(function(status_text) {
			switch(status_text){
				case "timeout":
					message.DisplayError("タイムアウトが発生しました。\nしばらくたってから再度試してください。");
					break;
				default:
					message.DisplayError();
					break;
			}
			defer.reject(status_text);
		});
		
		return defer.promise();
	};

	this.sympleAsync = function(){
		var self = this;
		$.ajax({
			url         : AJAX_HOST,
			type        : 'POST',
			data        : self.params,
			timeout     : 180000
		}).done(function(data){
		}).fail(function(xhr){
		});
	};
	
	
	this.getDataSync = function(){
		var self = this;
		if(functions.isIe() || functions.isSafari()){
			$.ajax({
				url: AJAX_HOST,
				type: 'POST',
				data: self.params,
				timeout:3000,
				async:false
			}).done(function(data){

			}).fail(function(error){

			});
		}
		else{
			var fd = new FormData();
			fd.append("CLASS_NAME",self.params["CLASS_NAME"]);
			fd.append("PROCESS_DIVIDE",self.params["PROCESS_DIVIDE"]);
			var data_params = [];
			Object.keys(self.params["DATA"]).forEach(function(key){
				var value = self.params["DATA"][key];
				if(functions.isArray(value)){
					value.forEach(function(val,index){
						if(functions.isArray(val)){
							val.forEach(function(val2,index2){
								data_params.push({key:"DATA["+key+"]["+index+"]["+index2+"]",val:val2});
							});
						}
						else if(functions.isObject(val)){
							Object.keys(val).forEach(function(row_key){
								data_params.push({key:"DATA["+key+"]["+index+"]["+row_key+"]",val:val[row_key]});
							});
						}
						else{
							data_params.push({key:"DATA["+key+"]["+index+"]",val:val});
						}
					});
				}
				else if(functions.isObject(value)){
					Object.keys(value).forEach(function(row_key){
						var val = value[row_key];

						if(functions.isArray(val)){
							val.forEach(function(val2,index2){
								data_params.push({key:"DATA["+key+"]["+row_key+"]["+index2+"]",val:val2});
							});
						}
						else if(functions.isObject(val)){
							Object.keys(val).forEach(function(row_key2){
								data_params.push({key:"DATA["+key+"]["+row_key+"]["+row_key2+"]",val:val[row_key2]});
							});
						}
						else{
							data_params.push({key:"DATA["+key+"]["+row_key+"]",val:val});
						}
					});
				}
				else{
					data_params.push({key:"DATA["+key+"]",val:value});
				}
			});
			data_params.forEach(function(row){
				fd.append(row.key,row.val);
			});
			navigator.sendBeacon(AJAX_HOST, fd);
		}
	};
}
