module ProjectsHelper
  def creator?(id) 
    thinker_signed_in? && id == current_thinker.id 
  end

  def progress_bar_color(percentage)
    case percentage
    when -Float::INFINITY..25
      "progress-bar-danger"
    when 25..50
      "progress-bar-warning"
    when 100
      "progress-bar-success"
    end
  end
end
