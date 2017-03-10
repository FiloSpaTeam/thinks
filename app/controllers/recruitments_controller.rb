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

# Copyright (c) 2017, Claudio Maradonna

class RecruitmentsController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_thinker!

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_show, only: [:show]

  before_action :check_ban!
  before_action :check_contribution_type!
  before_action :check_demand!, only: [:new]

  def index
    rtasks_scope = Task
                   .includes(:thinker, :updater, :status)
                   .where(project: @project)
                   .where(recruitment: true)

    @statuses = Status.where(translation_code: [:backlog, :done])

    smart_listing_create :recruitments,
                         rtasks_scope,
                         partial: 'recruitments/list',
                         default_sort: { status_id: 'desc' }

    @breadcrumbs = {
      "project_recruitments_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_recruitments_path')
    }

    @search = ''
    if params.key?(:filters) &&
       params[:filters].key?(:search_title_and_description)
      @search = params[:filters][:search_title_and_description].strip
    end
  end

  # GET /recruitments/1
  # GET /recruitments/1.json
  def show
    @comments         = Comment
                        .unscoped
                        .includes(:thinker, :reason)
                        .where(task: @task)
                        .with_deleted
                        .order(approved: :desc, created_at: :desc)
    @reason           = @comment_approved.try(:reason) || Reason.new
    @workload_voted   = @task.votes.where(thinker: current_thinker).first

    @project = @task.project
    @comment = Comment.new

    impressionist(@task, '', unique: [:impressionable_id, :user_id])

    @breadcrumbs = {
      "project_recruitments_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_recruitments_path'),
      "recruitment_path(#{@task.id})"                 => "\##{@task.serial} <span class='hidden-xs'>#{@task.title}</span>"
    }
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def approve
  end

  def reopen
  end

  private

  def set_task
    @task = Task
            .includes(:comments, :thinker, :project)
            .with_deleted
            .find(params[:id])
  end

  def set_validators_for_show
    comment_validators = Comment.validators_on(:text)[0]
    @chars_max_comment = comment_validators.options[:maximum]
  end

  def check_demand!
    if @project.recruitment_demand?(current_thinker)
      flash[:error] = 'You already made a recruitment demand!'

      redirect_to project_recruitments_path(@project)
    end
  end

  def check_contribution_type!
    if @project.open?
      flash[:error] = "You don't need recruitment, project is open. Enjoy!"

      redirect_to project_path(@project)
    end
  end
end