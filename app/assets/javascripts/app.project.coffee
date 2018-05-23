class App.Project
  constructor: ->
    this.m_active = true

    _init() if m_active

  _init: ->
    # initialize all you need to handle project in various pages

    this.m_comments = _initComments()
    this.m_settings = _initSettings()

  _initTask: ->
    return null unless $('.task').length
    return new App.Project.Task

  _initTeam: ->
    return null unless $('.team').length
    return new App.Project.Team

  _initComments: ->
    return null unless $('.comments').length
    return new App.Project.Comment

  _initSettings: ->
    return null unless $('.settings').length
    return new App.Project.Settings

$(document).on "turbolinks:load", ->
  project = new App.Project if $('meta[name="project"]').length
