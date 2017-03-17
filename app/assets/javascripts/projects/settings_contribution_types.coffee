# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#project_contribution_type").on "change", ->
    $("#project_recruitment_text").prop 'disabled', $(this).val() != $(this).attr('data-reference-value')


