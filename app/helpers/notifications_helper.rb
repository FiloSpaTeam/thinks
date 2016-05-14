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
    if notification.action == 'create'
      icon('plus-circle', :class => "fa-lg fa-fw")
    elsif notification.action == 'update'
      icon('refresh', :class => "fa-lg fa-fw")
    elsif notification.action == 'destroy'
      icon('remove', :class => "fa-lg fa-fw")
    else
      icon('bolt', :class => "fa-lg fa-fw")
    end
  end

  def title_for(notification)
    model = Object.const_get(notification.model)
    if model.try(:with_deleted)
      model = model.try(:with_deleted).find_by_id notification.model_id
    else
      model = model.find_by_id notification.model_id
    end

    if notification.controller == 'tasks'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        task: model.title
    elsif notification.controller == 'operations'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        task: model.task.title
    elsif notification.controller == 'goals'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        goal: model.title
    elsif notification.controller == 'sprints'
      t ".#{ notification.controller }.#{ notification.action }",
        serial: model.serial,
        total: model.obtained
    elsif notification.controller == 'comments'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        task: model.task.title
    elsif notification.controller == 'projects'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name
    elsif notification.controller == 'assigned_roles'
      assigned_role_klass = notification.model.constantize
      assigned_role = assigned_role_klass.find(notification.model_id)

      t ".#{ notification.controller }.#{ notification.action }",
        thinker: assigned_role.thinker.name,
        team_role: t("team_roles.#{assigned_role.team_role.t_name}")
    elsif notification.controller == 'elections'
      election_poll_klass = notification.model.constantize
      election_poll = election_poll_klass.find(notification.model_id)

      t ".#{ notification.controller }.#{ notification.action }",
        status: election_poll.status
    end
  end

  def notification_icon(notifications)
    if notifications.empty?
      icon('comments', class: 'fa-lg notification-icon')
    else
      icon('commenting', class: 'fa-lg fa-inverse notification-icon')
    end
  end
end
