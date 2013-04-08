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

    var counter = $('#counter');
    if (counter.length) {
        var timerId =
            countdown(
                new Date(counter.data('countdown-end')),
                function(ts) {
                    counter.html(ts.toHTML("strong"));
                },
                countdown.DAYS|countdown.HOURS|countdown.MINUTES|countdown.SECONDS);
    }
})
