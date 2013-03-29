$(function() {
  $(".alert").alert();

  $(".edit_suggestion_link").on('click', function(e){
  	e.preventDefault();
  	var $target = $(e.target);
  	var $form = $target.parents('.suggestion').find('.edit_suggestion_form');
  	
  	if ($form.is(':visible')) {
  	  $form.slideUp();
  	} else {
  	  $form.slideDown();
  	}
  });
})
