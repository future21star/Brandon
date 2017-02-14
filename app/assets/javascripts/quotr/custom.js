$(document).ready(function() {		
	// taking window height
	setTimeout(function(){
		adjustFooter();
		$(window).resize(function() {
			adjustFooter();
		});
	},400);
});
//adjusting footer on big screens
function adjustFooter() {
	var winHeight = $(window).height(),
	body_h = $('body').height();
	if (winHeight > body_h) {
		$('footer').addClass('navbar-fixed-bottom');
	}
}



