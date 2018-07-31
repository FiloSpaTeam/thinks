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

class ThinkersController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_thinker!
  before_action :check_owner!, except: [:index]

  before_action :set_thinker, only: [:show, :edit, :update, :dashboard, :privacy]
  before_action :set_validators_for_form_help, only: [:new, :edit]

  def index
    thinkers_scope = Thinker.all

    thinkers_scope = apply_filters(thinkers_scope, params[:filters]) if params[:filters].present?

    smart_listing_create :thinkers,
                         thinkers_scope,
                         partial: 'thinkers/list',
                         page_sizes: [9]
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if current_thinker == @thinker && @thinker.update(thinker_params)
        format.html { redirect_to @thinker, notice: 'Your data are updated.' }
        format.json { render :show, status: :ok, location: @thinker }
      else
        format.html { render :edit }
        format.json { render json: @thinker.errors, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    my_projects_scope = current_thinker.projects.order('title')
    my_projects_scope = ProjectsHelper.apply_filters(my_projects_scope, params[:filters_projects]) if params[:filters_projects].present?

    @my_projects = smart_listing_create :my_projects,
                                        my_projects_scope,
                                        partial: 'thinkers/dashboard/my_projects',
                                        default_sort: { created_at: 'desc' }
    @tasks_in_progress = current_thinker.working_tasks.order('updated_at DESC')

    @tasks_done = current_thinker.tasks.is_done.order('updated_at DESC')
    @tasks_created = current_thinker.tasks.order('created_at DESC')

    @d = Date.today
    @week_stats = current_thinker
                  .tasks
                  .is_done
                  .group(:created_at)
                  .where('updated_at >= ?', @d.beginning_of_week)
                  .where('updated_at <= ?', @d.end_of_week)
                  .count(:workload)

    @week_stats = @week_stats.transform_keys { |key| key.strftime('%B %d') }
  end

  private

  def set_validators_for_form_help
    bio_validators = Thinker.validators_on(:bio)[0]
    @chars_max_bio = bio_validators.options[:maximum]
  end

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thinker_params
    allowed_params = [:name, :email, :born_at, :sex_id, :avatar, :country_iso, :bio]

    params.require(:thinker).permit(allowed_params)
  end
end
