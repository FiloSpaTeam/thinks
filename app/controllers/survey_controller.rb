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

class SurveyController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_sprint
  before_action :not_actual!
  before_action :set_project
  before_action :teammate!

  def index
    redirect_to new_sprint_survey_path(@sprint) if current_thinker
                                                   .answers
                                                   .where(sprint: @sprint)
                                                   .empty? &&
                                                   @sprint == @project.sprint.try(:previous)

    @answers_count   = AnswerThinker
                       .where(sprint: @sprint)
                       .group(:answer_id)
                       .count

    @answers_thinker = AnswerThinker
                       .where(sprint: @sprint)
                       .where(thinker: current_thinker)

    @surveys = Survey.all

    @breadcrumbs = {
      "project_sprints_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_sprints_path'),
      "sprint_path(#{@sprint.id})" => "N. #{@sprint.serial}",
      '' => I18n.t('breadcrumbs.survey')
    }
  end

  def create
    @answers = params[:survey]

    @answers.each do |answer|
      AnswerThinker.create(answer_id: answer.last, sprint_id: params[:sprint_id], thinker_id: current_thinker.id)
    end

    respond_to do |format|
      format.html { redirect_to sprint_survey_index_path }
    end
  end

  def new
    redirect_to sprint_survey_index_path(@sprint) if current_thinker
                                                     .answers
                                                     .where(sprint: @sprint)
                                                     .present? ||
                                                     @sprint != @project.sprint.try(:previous)

    @surveys = Survey.all
    @survey  = Survey.new

    @breadcrumbs = {
      "project_sprints_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_sprints_path'),
      "sprint_path(#{@sprint.id})" => "N. #{@sprint.serial}",
      '' => I18n.t('breadcrumbs.new_survey')
    }
  end

  private

  def set_project
    @project = @sprint.project
  end

  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end

  def not_actual!
    redirect_to project_sprints_path(@sprint.project) if @sprint.serial ==
                                                         @sprint.project.sprint
  end

  def teammate!
    unless @sprint.project.part_of_team?(current_thinker)
      flash[:error] = 'You cannot contribute to survey because you are not partecipating to the project'

      redirect_to project_sprints_path(@sprint.project)
    end
  end

  def survey_params
    # allowed_params = Survey.all.map(&:id)

    params.require(:survey) # .permit(allowed_params)
  end
end
