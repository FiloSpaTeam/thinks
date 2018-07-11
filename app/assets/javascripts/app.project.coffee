class App.Project
  constructor: ->
    this.m_active = true

    this._init() if this.m_active

  _init: ->
    # initialize all you need to handle project in various pages

    this.m_tasks    = new App.Project.Task
    this.m_comments = new App.Project.Comment if this.m_tasks != null
    # this.m_team     = new App.Project.Team
    # this.m_settings = new App.Project.Settings

$(document).on "turbolinks:load", ->
  project = new App.Project if $('meta[name="project"]').length
