module TasksHelper
  def color_list_group_header(status)
    color_list = { 
      "backlog"     => "list-group-header-backlog",
      "release"     => "list-group-header-info",
      "sprint"      => "list-group-header-danger",
      "in_progress" => "list-group-header-warning",
      "done"        => "list-group-header-success"
    }
  
    return color_list[status]
  end

  def color_list_group_item(status_task)
    if status_task.worker == current_thinker
      return "active"
    elsif !["backlog", "done"].include?(status_task.status.translation_code)
      if status_task.worker.nil?
        return "list-group-item-danger"
      else
        return "list-group-item-info"
      end
    end
  end
end
