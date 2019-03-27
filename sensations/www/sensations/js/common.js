$(function() {


	/* ----------------------
	| PREP & MISC
	---------------------- */

	var IE = navigator.appVersion.indexOf('MSIE') != -1;


	/* ----------------------
	| SEARCH FOCUS IN/OUT
	---------------------- */

	var search = $('#search input:first-child');
	search.focus(function() {
		if ($(this).attr('value') == 'search...') $(this).attr('value', '');
		try { origCol } catch(e) { origCol = $(this).css('color'); }
		$(this).css({color: '#333', fontWeight: 'normal'});
	});
	search.blur(function() {
		if ($(this).attr('value') == '') {
			$(this).attr('value', 'search...');
			$(this).css({color: origCol, fontWeight: 'bold'});
		}
	});


	/* ----------------------
	| CODE BLOCK LINE NUMBERS (if more than one line. If not, take opportunity to undo massive left padding would otherwise be)
	---------------------- */

    $('div.code').each(function() {
    	if ($(this).children('p').length > 1) {
	    	var span = document.createElement('span');
	    	with($(span)) {
	    		addClass('lineNum_bgThing');
	    		css('height', $(this).height()+parseInt($(this).css('paddingTop'))+parseInt($(this).css('paddingBottom')));
	    	}
	    	this.insertBefore(span, this.childNodes[0]);
	    } else
	    	$(this).css('padding-left', 20);
	});


	/* ----------------------
	| TAGS - if index, not specific post, show only most prevalent ones (>= 3) to start with. Show all on link click.
	---------------------- */

	if (!/-\d+$/.test(location.href)) {
		$('#tags li').filter(function() { return /\([1-2]\)$/.test($(this).text()); }).addClass('hidden').hide().end().parent().each(function() { $(this).children(':visible:last').css('border', 'none').addClass('noBorder'); });
		$('#tags .panelBottom a').click(function() {
			if ($('#tags li:hidden').length != 0) {
				$('#tags li:hidden').fadeIn();
				$(this).text('Show only prevalent tags');
			} else {
				$('#tags .hidden').fadeOut();
				$(this).text('Show all '+$('#tags li').length+' tags');
			}
		});
	}


	/* ----------------------
	| IE HACKS
	| 	- fudge ignored :last-child pseudo selectors
	---------------------- */

	if (IE) $('ul li:last-child').css('border', 'none');


	/* ----------------------
	| COMMENTS
	| 	- when 'post new reply' button clicked (or if 'newComment' found in URL), show form
	|	- when submitted, gather field name/value pairings, complain if any that have '*' in label are blank, then submit if OK
	---------------------- */

	$('.postButton').click(doCommentsForm);
	if (location.search.indexOf('newComment') != -1) doCommentsForm();
	function doCommentsForm() { $('#comments form').lightbox(); }

	$('#comments_form button').live('click', function() {

		var pairs = {};
		var badFields = [];

		$('#comments_form').find('input, textarea').each(function() {
			pairs[$(this).attr('name')] = $(this).val();
			if ($('label[for='+$(this).attr('id')+']').text().match(/\*$/) && !$(this).val()) badFields.push($(this).attr('name'));
		});

		if (badFields.length != 0) {
			hidelightbox(true, function() {
				lbdialog({
					content: '<p>The following fields were left blank:</p><p>'+badFields.join(', ')+'</p>',
					OKButton: {
						noLBClose: true,
						callback: function() { hidelightbox(true); $('#comments_form').lightbox(true); }
					}
				});
			});
		} else
			$.post(location.href, pairs, function(response) {
				if (response == 'ok')
					hidelightbox(true, function() {
						lbdialog({
							content: "Thanks - your comment was posted",
							OKButton: {
								callback: function() { location.reload(true); },
								noLBCLose: true
							}
						});
					});
				else
					alert(response);
			});

	});

});