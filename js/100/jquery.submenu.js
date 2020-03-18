$(document).ready(function(){

	var reset = [
		LS_NINUSHI,
		LS_CENTER,
		'101010_DATE_DIVIDE',
		'101010_DATE_FROM',
		'101010_DATE_TO',
		'101010_NINUSHI',
		'101040_DATE_DIVIDE',
		'101040_DATE_FROM',
		'101040_DATE_TO',
		'101040_NINUSHI',
		'101040_DATA',
		'103040_DATE_DIVIDE',
		'103040_DATE_FROM',
		'103040_DATE_TO',
		'103040_NINUSHI',
		'103040_DATA',
	];

	//clear
	reset.forEach(function(element){
		sessionStorage.removeItem(element);
	});
	ResetSessionParamaters(reset);

});
