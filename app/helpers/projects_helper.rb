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

  def set_project
    @project = Project.friendly.find(params[:project_id] || params[:id]) 
  end

  def thinker!
    if @project.thinker != current_thinker
      flash[:alert] = 'You are not the Scrum Master!'
      redirect_to project_path(@project)
    end
  end
end
