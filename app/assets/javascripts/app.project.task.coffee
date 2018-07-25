class App.Project.Task
  constructor: ->
    $('#task_father_id').change ->
      $('#task_goal_id').prop('disabled', $(this).val() != '')
      $('#task_goal_id').val($('option:selected', this).attr('data-goal')) if $('option:selected', this).attr('data-goal')

    $('form.smart-listing-controls[data-smart-listing="tasks"]')
