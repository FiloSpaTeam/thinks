window.App ||= {}
App.Api ||= {}

App.init = ->
  # $('.attachinary-input').attachinary()
  $('[data-toggle="popover"]').popover()
  $('a, span, i, div').tooltip()

  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click ->
    if location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') and location.hostname == this.hostname
      target = $(this.hash)
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']')
      if target.length
        $('html, body').animate({
          scrollTop: (target.offset().top - 70)
        }, 1000, "easeInOutExpo")
        return false

  $(window).scroll ->
    if $('body').hasClass('start')
      if $("#mainNav").offset().top > 100
        $("#mainNav").addClass("navbar-shrink");
      else
        $("#mainNav").removeClass("navbar-shrink");

  if $(window).width() < 992
    if $('#modal-flash').attr('data-has-messages') == 'true'
      $("#modal-flash").modal('show')

  $('input.has-error').each ->
    $(this).closest('div').addClass('has-error')

  $('body').on 'change', '.smart-listing-controls input', (e) ->
    e.preventDefault()

    $this = $(this)

    $('#filters_last').val($this.attr('name'))
    $this.closest('form').submit()

  $(document).ajaxError (e, xhr, settings) ->
    location.reload() if xhr.status == 401

$(document).on "turbolinks:load", ->
  App.init()
