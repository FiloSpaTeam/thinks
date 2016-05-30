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

class PasswordController < ApplicationController

  before_action :authenticate_thinker!
  before_action :check_owner!

  def edit
    @thinker = current_thinker
  end

  def update
    @thinker = Thinker.find(current_thinker.id)

    respond_to do |format|
      if @thinker.update_with_password(thinker_params)
        # Sign in the user by passing validation in case their password changed
        sign_in @thinker, bypass: true

        format.html { redirect_to @thinker, notice: 'Your password is updated.' }
        format.json { render :show, status: :ok, location: @thinker }
      else
        set_form_errors(@thinker)

        format.html { render :edit }
        format.json { render json: @thinkers.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def thinker_params
    # NOTE: Using `strong_parameters` gem
    params.require(:thinker).permit(:password, :password_confirmation, :current_password)
  end
end
