$(function($) {
    "use strict"; // Start of use strict
    // Collapse the navbar when page is scrolled

    $(window).scroll(function() {
        if ($('body').hasClass('start')) {
            if ($("#mainNav").offset().top > 100) {
                $("#mainNav").addClass("navbar-shrink");
            } else {
                $("#mainNav").removeClass("navbar-shrink");
            }
        }
    });

    if ($(window).width() < 992) {
        if ($('#modal-flash').attr('data-has-messages') == 'true') {
            $("#modal-flash").modal('show');
        }
    }
}); // End of use strict
