# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.btn-lock').on "click", (event) ->
    event.preventDefault();
    r = prompt(I18n.t('if_are_you_sure_want_ban_this_member'));

    $btn  = $(this)
    _href = $btn.attr("href");
    $btn.attr('href', _href + "&banned_thinker[reason]=" + r)
    window.location = $(this).attr('href') if r != null
