class TeamsController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :set_thinker, only: [:destroy]
  before_action :set_contribution, only: [:index]

  def index
    @filterrific = initialize_filterrific(
      AssignedRole
      .where(project: @project)
      .order(:team_role_id)
      .order(:created_at),
      params[:filterrific],
      select_options: {}
    ) || return
    @members = @filterrific.find.page params[:page]
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def destroy
    thinker_role = params[:team_role_id]

    # if thinker is a member, remove him from team and change contribution to nothing
    # if thinker is a scrum_master or product_owner, create an election poll
    respond_to do |format|
      thinker_roles = @project.assigned_roles.where(thinker: @thinker)
      if thinker_roles.where('team_role_id IN (?,?)',
                             TeamRole.scrum_master.first,
                             TeamRole.product_owner.first)
                      .size
                      .nonzero?
        # it's time to create and election poll
        # if election poll is closed or suspended the position will not be removed

        ElectionPoll.first_or_create(project: @project, team_role_id: thinker_role)

        format.html { redirect_to project_teams_path(@project), notice: t('.election_poll_created') }
        format.json { head :no_content }
      elsif thinker_roles.where(team_role: TeamRole.team_member.first)
                         .size
                         .nonzero?
        puts 'MEMBER WANT LEAVE'
      else
        puts '??? YOU ARE NOT A TEAM MEMBER'
      end
    end
  end

  private

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end

  def set_contribution
    @contribution = Contribution
                    .where(thinker: current_thinker)
                    .where(project: @project)
                    .first_or_initialize
  end
end
