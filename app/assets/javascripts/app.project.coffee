class App.Project
  constructor: ->
    m_active = true

    _init() if m_active
  _init: ->
    # initialize all you need to handle project in various pages

    # Comments
    $('.btn-approve').on "click", (event) ->
      event.preventDefault();

      $btn  = $(this);

      return if $btn.attr('href') == 'javascript:;';

      r = 0;
      r = prompt(I18n.t('specify_reason')) if $btn.data('approved') == false || $btn.data('approved') == '';

      _href = $btn.attr("href");
      $btn.attr('href', _href + "&reason[text]=" + r);

      window.location = $btn.attr('href') if r != null;

    # Recruitments
    $("#modal-recruitment-manifest").modal('show') if $("#modal-recruitment-manifest").data('seen') == 1

    # Tasks
    $('.btn-task-delete').on "click", (event) ->
      event.preventDefault();

      $btn  = $(this);

      r = prompt(I18n.t('specify_reason'));

      _href = $btn.attr("href");
      $btn.attr('href', _href + "&reason[text]=" + r);

      return false if r == null || r.trim() == '';

    # Teams
    $('.btn-lock').on "click", (event) ->
      event.preventDefault();
      r = prompt(I18n.t('if_are_you_sure_want_ban_this_member'));

      $btn  = $(this)
      _href = $btn.attr("href");
      $btn.attr('href', _href + "&banned_thinker[reason]=" + r)
      window.location = $(this).attr('href') if r != null

    # Settings contribution
    $("#project_contribution_type").on "change", ->
      $("#project_recruitment_text").prop 'disabled', $(this).val() != $(this).attr('data-reference-value')

$(document).on "turbolinks:load", ->
  project = new App.Project if $('meta[name="project"]').length
