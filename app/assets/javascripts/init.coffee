window.App ||= {}

App.init = ->
  $(document).ajaxError (e, xhr, settings) ->
    location.reload() if xhr.status == 401

  $('input.has-error').each ->
    $(this).closest('div').addClass('has-error')

  # $('.attachinary-input').attachinary()
  $('[data-toggle="popover"]').popover()
  $('a, span, i, div').tooltip()

  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click ->
    if location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') and location.hostname == this.hostname
      target = $(this.hash)
      target = if target.length then target else $('[name=' + this.hash.slice(1) + ']')
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

  $('body').on 'change', '.smart-listing-controls input', (e) ->
    e.preventDefault()

    $this = $(this)

    $('#filters_last').val($this.attr('name'))
    $this.closest('form').submit()

  $('.has-counter').keyup ->
    counter      = $(this)
                   .parent()
                   .find('.counter')
    max_length   = counter.data('maximum-length')
    diff         = max_length - $(this).val().length
    counter.text(diff)

    if diff < 0
      counter.addClass('text-danger')
    else
      counter.removeClass('text-danger')

  $('.modal.open-by-default').modal('show')

  refers_to = $('button.submit').attr('data-refers-to')
  if refers_to?
    $('.submit').click ->
      refer = $(@).attr('data-refers-to')
      $(refer).submit()

  $.notify {
    message: $('.alert').data('message')
  }, {
    type: $('.alert').data('type')
  } if $('.alert').length > 0

$(document).on "turbolinks:load", ->
  App.init()
