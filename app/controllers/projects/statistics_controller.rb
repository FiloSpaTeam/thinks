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

class Projects::StatisticsController < ApplicationController

  before_action :authenticate_thinker!
  before_action :set_project

  def show
    @filterrific = initialize_filterrific(
      Projects::Statistic,
      params[:filterrific],
      select_options: {}
    ) || return

    unless params[:filterrific].nil?
      @first_section = params[:filterrific][:with_first_section]
      @second_section = params[:filterrific][:with_second_section]
      @third_section = params[:filterrific][:with_third_section]
    end

    @local_thinker = Thinker.friendly.find(params[:id])
    @statistic     = @filterrific.find.where(slug: params[:project_id]).first
  end
end
