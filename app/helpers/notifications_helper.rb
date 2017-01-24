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

module NotificationsHelper
  def url_for_notifications(notification)
    if notification.controller == 'comments'
      comment_klass = notification.model.constantize
      comment = comment_klass.find(notification.model_id)

      return url_for(:controller => 'tasks', :action => 'show', :id => comment.task.id)
    elsif notification.controller == 'operations'
      operation_klass = notification.model.constantize
      operation = operation_klass.find(notification.model_id)

      return url_for(:controller => 'operations', :action => 'index', :task_id => operation.task.id)
    elsif notification.controller == 'assigned_roles' or notification.controller == 'elections'
      assigned_role_klass = notification.model.constantize
      assigned_role = assigned_role_klass.find(notification.model_id)

      return url_for(:controller => 'teams', :action => 'index', :project_id => assigned_role.project.id)
    end

    url_for(:controller => notification.controller, :action => 'show', :id => notification.model_id)
  end

  def icon_for(notification)
    case notification.action
    when 'create'
      icon('plus-circle', class: 'fa-lg fa-fw')
    when 'update'
      icon('refresh', class: 'fa-lg fa-fw')
    when 'destroy'
      icon('remove', class: 'fa-lg fa-fw')
    else
      icon('bolt', class: 'fa-lg fa-fw')
    end
  end

  def title_for(notification)
    model = Object.const_get(notification.model)
    if model.try(:with_deleted)
      model = model.try(:with_deleted).find_by_id notification.model_id
    else
      model = model.find_by_id notification.model_id
    end

    t "notifications.list.#{notification.controller}.#{notification.action}",
      case notification.controller
      when 'tasks'
        {
          thinker: notification.thinker.name,
          task: model.title
        }
      when 'goals'
        {
          thinker: notification.thinker.name,
          goal: model.title
        }
      when 'operations', 'comments'
        {
          thinker: notification.thinker.name,
          task: model.task.title
        }
      when 'sprints'
        {
          serial: model.serial,
          total: model.obtained
        }
      when 'projects'
        {
          thinker: notification.thinker.name
        }
      when 'releases'
        {
          thinker: notification.thinker.name,
          release: model.version
        }
      when 'assigned_roles'
        assigned_role_klass = notification.model.constantize
        assigned_role = assigned_role_klass.find(notification.model_id)

        {
          thinker: assigned_role.thinker.name,
          team_role: t("team_roles.#{assigned_role.team_role.t_name}")
        }
      when 'elections'
        election_poll_klass = notification.model.constantize
        election_poll = election_poll_klass.find(notification.model_id)

        {
          status: election_poll.status
        }
      end
  end

  def notification_icon(notifications, dimension = 'fa-lg')
    if notifications.empty?
      icon('comments', class: "#{dimension} notification-icon dark-grey")
    else
      icon('commenting', class: "#{dimension} notification-icon dark-grey")
    end
  end
end
