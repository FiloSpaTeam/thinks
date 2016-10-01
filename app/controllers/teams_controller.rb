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

class TeamsController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :set_thinker, only: [:destroy, :ban, :unban]
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
    @members        = @filterrific.find.page params[:page]
    @election_polls = @project.election_polls
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
        # it's time to create an election poll
        # if election poll is closed or suspended the position will not be removed

        ElectionPoll
          .where(project: @project)
          .where(team_role_id: thinker_role)
          .where(status: ElectionPoll.statuses[:active])
          .first_or_create

        format.html { redirect_to project_teams_path(@project), notice: t('.election_poll_created') }
        format.json { head :no_content }
      elsif thinker_roles.where(team_role: TeamRole.team_member.first)
                         .size
                         .nonzero?

        assigned_role = AssignedRole
                        .where(thinker: current_thinker)
                        .where(project: @project)
                        .where(team_role: TeamRole.team_member.first)
                        .first
        assigned_role.delete_with_contribution

        format.html { redirect_to project_teams_path(@project), notice: t('.you_are_no_longer_part_of_the_team') }
        format.json { head :no_content }
      else
        format.html { redirect_to project_teams_path(@project), alert: t('.you_are_not_part_of_the_team') }
        format.json { head :no_content }

        puts '??? YOU ARE NOT A TEAM MEMBER'
      end
    end
  end

  def ban
    banned_thinker = BannedThinker.new(ban_params)

    respond_to do |format|
      format.json { head :no_content }
      if banned_thinker.reason.empty?
        format.html { redirect_to project_teams_path(@project), alert: t('.reason_empty') }
      else
        banned_thinker.thinker = @thinker
        banned_thinker.project = @project

        banned_thinker.save

        format.html { redirect_to project_teams_path(@project), notice: t('.thinker_banned') }
      end
    end
  end

  def unban
    banned_thinker = BannedThinker
                     .where(project: @project)
                     .where(thinker: @thinker)

    respond_to do |format|
      format.json { head :no_content }
      if banned_thinker.empty?
        format.html { redirect_to project_teams_path(@project), alert: t('.thinker_already_unbanned') }
      else
        banned_thinker.destroy_all

        format.html { redirect_to project_teams_path(@project), notice: t('.thinker_unbanned') }
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

  def ban_params
    allowed_params = [:reason]

    params.require(:banned_thinker).permit(allowed_params)
  end
end
