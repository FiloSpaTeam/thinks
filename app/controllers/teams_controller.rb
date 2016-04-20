class TeamsController < ApplicationController
  before_action :authenticate_thinker!
  before_action :set_project
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
    @members      = @filterrific.find.page params[:page]
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  private

  def set_contribution
    @contribution = Contribution
                    .where(thinker: current_thinker)
                    .where(project: @project)
                    .first_or_initialize
  end
end
