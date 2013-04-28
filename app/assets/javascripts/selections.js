$(function() {
	var save_selections = function () {
		var ids = $('.selections li').map(function () {return parseInt(this.id.replace(/proposal_/, ''))}).get();
		$.ajax({
			url: '/selections',
		  	type: "POST",
			data:  JSON.stringify({proposal_ids: ids}),
			contentType: "application/json",
            processData: false
		});
	}, sortableIn;

	if ($('.proposals').length) {
		$('.proposals.nominated li').draggable({
            cursor: "url(https://mail.google.com/mail/images/2/closedhand.cur), move",
	    	appendTo: "body",
	    	revert: "invalid",
	    	helper: "clone"
		});

		$('.selections').droppable({
			activeClass: "ui-state-default",
      		hoverClass: "ui-state-hover",
      		accept: function (element) {
      			return element.is(":not(.ui-sortable-helper)") && $('.selections li').length < 10 && $("#" + element[0].id,'.selections').length == 0
      		},
      		drop: function( event, ui ) {
        		$( this ).find( ".placeholder" ).remove();
        		$( ui.draggable).clone().appendTo( this );
        		save_selections();
      		}
	    }).sortable({
	      items: "li:not(.placeholder)",
	      // axis: "y",
	      sort: function() {
	        $(this).removeClass( "ui-state-default" );
	      },
		  receive: function() { sortableIn = 1; },
		  over: function() { sortableIn = 1; },
		  out: function(e, ui) { sortableIn = 0; },
		  beforeStop: function(e, ui) {
   			if (sortableIn == 0) {
      			ui.item.remove();
				save_selections();
   			}
		  },
	      update: function(){
			 save_selections();
	      }
	    });
	}
})
