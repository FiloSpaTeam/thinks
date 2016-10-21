# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

class ApplicationController < ActionController::Base
  before_action :set_locale

  before_action :set_current_user, if: :thinker_signed_in?
  before_action :set_thinker_projects, if: :thinker_signed_in?
  before_action :set_thinker_tasks, if: :thinker_signed_in?
  before_action :set_thinker_following_projects, if: :thinker_signed_in?
  before_action :set_thinker_notifications, if: :thinker_signed_in?

  before_action :configure_permitted_parameters, if: :devise_controller?
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
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join

    flash.now[:error] = "<ul>#{messages}</ul>"
    flash[:error]     = "<ul>#{messages}</ul>"
  end

  protected

  # At the moment we need to redirect others, later will be there a public page
  def check_owner!
    redirect_to root_url unless current_thinker.slug == params[:id] ||
                                current_thinker.slug == params[:thinker_id]
  end

  def check_admin!
    redirect_to root_url unless current_thinker.try(:admin?)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :otp_attempt
  end

  def set_project
    @project = Project
               .includes(:tasks, :sprints, :cycle,
                         :assigned_roles, :contributions,
                         :releases, :goals)
               .friendly.find(params[:project_id])
  end

  def create_notification(model, project)
    @notification = Notification.new

    @notification.thinker = current_thinker
    @notification.project = project

    @notification.model    = model.class.name
    @notification.model_id = model.id

    @notification.controller = params[:controller]
    @notification.action     = params[:action]

    @notification.save
  end

  def destroy_notification(model, project)
    Notification
      .where(
        project: project,
        model: model.class.name,
        model_id: model.id,
        controller: params[:controller]
      )
      .delete_all
  end

  private

  def set_current_user
    @current_user = current_thinker
  end

  def set_thinker_projects
    @thinker_projects = current_thinker
                        .projects
                        .order('created_at DESC')
                        .first(5)
  end

  def set_thinker_following_projects
    @thinker_follow_projects = current_thinker
                               .contributions
                               .where('intensity > ?', Contribution
                                                       .intensities[:nothing])
  end

  def set_thinker_tasks
    @thinker_tasks = current_thinker
                     .working_tasks
                     .in_progress
                     .order('created_at DESC')
                     .first(10)
  end

  def set_thinker_notifications
    @thinker_notifications = Notification
                             .user(current_thinker)
                             .order('project_id DESC')
                             .order('created_at DESC')
                             .limit(10)
  end
end
