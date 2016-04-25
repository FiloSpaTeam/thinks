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
      flash[:alert] = 'You are not the founder!'
      redirect_to project_path(@project)
    end
  end

  def scrum_master?(project)
    return false if project
                    .assigned_roles
                    .where(thinker: current_thinker)
                    .where('team_role_id IN (?,?)',
                            TeamRole.scrum_master.first,
                            TeamRole.product_owner.first)
                    .first
                    .nil?
    true
  end
end
