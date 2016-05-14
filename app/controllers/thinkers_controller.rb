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
  before_action :authenticate_thinker!
  before_action :check_admin!, only: [:index]
  before_action :check_owner!, except: [:index]

  before_action :set_thinker, only: [:show, :edit, :update]

  def index
    @thinkers = Thinker.all
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

  private

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thinker_params
    allowed_params = [:name, :email, :born_at, :sex_id, :avatar, :country_iso]

    params.require(:thinker).permit(allowed_params)
  end
end
