class App.Project.Settings
  constructor: ->
    $("#project_contribution_type").on "change", ->
      $("#project_recruitment_text").prop 'disabled', $(this).val() != $(this).attr('data-reference-value')
