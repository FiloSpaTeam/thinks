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

class Thinkers::SkillsController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_owner!
  before_action :set_thinker

  def index

  end

  def create
    @skill = Skill.find(skill_params[:skill_ids])

    respond_to do |format|
      if @skill.nil?
        format.html { redirect_to thinker_skills_path(@thinker), alert: 'Skill does not exists.' }
        format.json { render json: {}, status: :unprocessable_entity }
      else
        @thinker.skills << @skill

        format.html { redirect_to thinker_skills_path(@thinker), notice: 'Skill added to list.' }
        format.json { render :index, status: :created }
      end
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    respond_to do |format|
      @thinker.skills.delete(@skill)

      format.html { redirect_to thinker_skills_path(@thinker), notice: 'Skill was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_thinker
    @thinker = Thinker.friendly.find(params[:thinker_id])
  end

  def skill_params
    allowed_params = [:skill_ids]

    params.require(:thinker).permit(allowed_params)
  end
end
