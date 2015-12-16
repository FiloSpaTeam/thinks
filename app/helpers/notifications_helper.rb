module NotificationsHelper
  def icon_for(notification)
    if notification.action == 'create'
      icon('plus-circle', :class => "fa-lg")
    elsif notification.action == 'update'
      icon('refresh', :class => "fa-lg")
    end
  end

  def title_for(notification)
    model = Object.const_get(notification.model)
    model = model.find(notification.model_id)

    if notification.controller == 'tasks'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        task: model.title
    elsif notification.controller == 'goals'
      t ".#{ notification.controller }.#{ notification.action }",
        thinker: notification.thinker.name,
        goal: model.title
    elsif notification.controller == 'sprints'
      t ".#{ notification.controller }.#{ notification.action }",
        serial: model.serial,
        total: model.obtained
    end
  end
end
