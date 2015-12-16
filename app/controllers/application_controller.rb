class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_thinker_projects, :if => :thinker_signed_in?
  before_action :set_thinker_tasks, :if => :thinker_signed_in?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :set_form_errors

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def set_form_errors(object)
    return "" if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
    flash.now[:error] = "<ul>#{messages}</ul>"

    return ""
  end

  protected

  def set_project
    @project = Project.friendly.find(params[:project_id])

    load_project_session
  end

  def create_notification(model)
    @notification = Notification.new

    @notification.thinker = current_thinker
    @notification.project = @project

    @notification.model    = model.class.name
    @notification.model_id = model.id

    @notification.controller = params[:controller]
    @notification.action     = params[:action]

    @notification.save
  end

  private

  def load_project_session
    if session[:project_id] != @project.id
      session[:project_id] = @project.id
    end
  end

  def set_thinker_projects
    @thinker_projects = current_thinker.projects.order("created_at DESC").first(5)
  end

  def set_thinker_tasks
    @thinker_tasks = current_thinker.working_tasks.in_progress.order("created_at DESC").first(10)
  end
end
