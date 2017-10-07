$(function($) {
    "use strict"; // Start of use strict
    // Collapse the navbar when page is scrolled

    $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html, body').animate({
                    scrollTop: (target.offset().top - 70)
                }, 1000, "easeInOutExpo");
                return false;
            }
        }
    });


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
