class App.Project.Comment
  constructor: ->
    $('.btn-approve').on "click", (event) ->
      event.preventDefault();

      $btn  = $(this);

      return if $btn.attr('href') == 'javascript:;';

      r = 0;
      r = prompt(I18n.t('specify_reason')) if $btn.data('approved') == false || $btn.data('approved') == '';

      _href = $btn.attr("href");
      $btn.attr('href', _href + "&reason[text]=" + r);

      window.location = $btn.attr('href') if r != null;
