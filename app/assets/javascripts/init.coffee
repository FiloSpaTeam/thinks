window.App ||= {}

App.init = ->
  # $('.attachinary-input').attachinary()
  $('[data-toggle="popover"]').popover()

  $('input.has-error').each ->
    $(this).closest('div').addClass('has-error')

  $('body').on 'change', '.smart-listing-controls input', (e) ->
    e.preventDefault()

    $this = $(this)

    $('#filters_last').val($this.attr('name'))
    $this.closest('form').submit()

$(document).on "turbolinks:load", ->
  App.init()
