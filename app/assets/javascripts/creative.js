(function($) {
    "use strict"; // Start of use strict
    // Collapse the navbar when page is scrolled
    if ($('body').hasClass('start')) {
        $(window).scroll(function() {
            if ($("#mainNav").offset().top > 100) {
                $("#mainNav").addClass("navbar-shrink");
            } else {
                $("#mainNav").removeClass("navbar-shrink");
            }
        });
    }
})(jQuery); // End of use strict
