module TasksHelper
  def color_list_round_div(status)
    color_list = { 
      "backlog"     => "bg-backlog",
      "release"     => "bg-info",
      "sprint"      => "bg-danger",
      "in_progress" => "bg-warning",
      "done"        => "bg-success"
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

  def sd_class(sd)
    if sd >= 3
      "text-danger"
    elsif sd >= 1
      "text-warning"
    else
      "text-success"
    end
  end
end
