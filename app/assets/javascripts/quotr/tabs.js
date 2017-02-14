$(document).ready(function(){
	setTimeout(function(){
		$('.navtabs li').click(function(){
			$('.navtabs').find('li').removeClass('active');
			$(this).addClass('active');
		});
	},200);
});