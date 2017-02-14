$(document).ready(function() {    
  //show mobile menu
  $('#showMobileMenu').click(function(){
    $('.wrapper').addClass('menu-active');
  });
  $('.close-menu').click(function(){
    $('.wrapper').removeClass('menu-active');
  }); 
});