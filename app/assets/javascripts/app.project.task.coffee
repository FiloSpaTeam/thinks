class App.Project.Task
  constructor: ->
    $('.btn-task-delete').on "click", (event) ->
      event.preventDefault();

      $btn  = $(this);

      r = prompt(I18n.t('specify_reason'));

      _href = $btn.attr("href");
      $btn.attr('href', _href + "&reason[text]=" + r);

      return false if r == null || r.trim() == '';
