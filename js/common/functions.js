var functions = {
	IsNull:function(val){
		return (val === undefined || val === '' || val === null);
	},
	numSeparate:function(num,zero_view){
		if(zero_view){
			if(!(num) || isNaN(num)){return '0'}
		}
		else{
			if(!(num) || isNaN(num) || num == 0){return ''}
		}
		return String(num).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
	},
	nl2br:function(str) {
		str = str.replace(/\r\n/g, "<br />");
		str = str.replace(/(\n|\r)/g, "<br />");
		return str;
	},
	clearnull:function(val){
		if(val === "null" || val === undefined || val === null){
			return '';
		}else{
			return val;
		}
	},
	getBrowser:function(){
		var userAgent = window.navigator.userAgent.toLowerCase();
		if(userAgent.indexOf('msie') !== -1 ||
			userAgent.indexOf('trident') !== -1) {
			return "ie";
		} else if(userAgent.indexOf('edge') !== -1) {
			return "edge";
		} else if(userAgent.indexOf('chrome') !== -1) {
			return "chrome";
		} else if(userAgent.indexOf('safari') !== -1) {
			return "safari";
		} else if(userAgent.indexOf('firefox') !== -1) {
			return "firefox";
		} else if(userAgent.indexOf('opera') !== -1) {
			return "opera";
		} else {
			return "unknown";
		}
	},
	isIOS:function(){
		var userAgent = window.navigator.userAgent.toLowerCase();
		return userAgent.indexOf('iphone') !== -1 || userAgent.indexOf('ipad') !== -1;
	},
	isIe:function(){
		return (this.getBrowser() === "ie");
	},
	isSafari:function(){
		return (this.getBrowser() === "safari");
	},
	isArray:function(item){
		return Object.prototype.toString.call(item) === '[object Array]';
	},
	isObject:function(item){
		return typeof item === 'object' && item !== null && !this.isArray(item);
	}
};



