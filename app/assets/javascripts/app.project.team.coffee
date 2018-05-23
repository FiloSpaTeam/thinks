class App.Project.Team
  constructor: ->
    $("#modal-recruitment-manifest").modal('show') if $("#modal-recruitment-manifest").data('seen') == 1

    $('.btn-lock').on "click", (event) ->
      event.preventDefault();
      r = prompt(I18n.t('if_are_you_sure_want_ban_this_member'));

      $btn  = $(this)
      _href = $btn.attr("href");
      $btn.attr('href', _href + "&banned_thinker[reason]=" + r)
      window.location = $(this).attr('href') if r != null
