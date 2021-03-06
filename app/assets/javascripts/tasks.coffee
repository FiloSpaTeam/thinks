# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.btn-task-delete').on "click", (event) ->
    event.preventDefault();

    $btn  = $(this);

    r = prompt(I18n.t('specify_reason'));

    _href = $btn.attr("href");
    $btn.attr('href', _href + "&reason[text]=" + r);

    return false if r == null || r.trim() == '';
