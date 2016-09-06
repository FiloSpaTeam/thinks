# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.btn-approve').on "click", (event) ->
    event.preventDefault();
    r = prompt(I18n.t('specify_reason'));

    $btn  = $(this)
    _href = $btn.attr("href");
    $btn.attr('href', _href + "&reason[text]=" + r)
    window.location = $(this).attr('href') if r != null
