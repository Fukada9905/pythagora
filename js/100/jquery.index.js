$(document).ready(function(){

	var reset = [
		'101010_DATE_DIVIDE',
		'101010_DATE_FROM',
		'101010_DATE_TO',
		'101010_NINUSHI',
		'101040_DATE_DIVIDE',
		'101040_DATE_FROM',
		'101040_DATE_TO',
		'101040_NINUSHI',
		'101040_DATA'
	];

	//clear
	reset.forEach(function(element){
		sessionStorage.removeItem(element);
	});
	ResetSessionParamaters(reset);



});
