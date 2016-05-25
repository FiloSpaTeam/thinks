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

class OtpController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_owner!, except: [:index]
  before_action :set_thinker, only: [:show, :enable, :disable, :codes]

  def show
  end

  def codes
    if current_thinker.valid_password?(otp_params[:password])
      flash[:otp_enabled] = true
    else
      flash[:error] = 'Invalid password'
    end

    redirect_to otp_path @thinker
  end

  def enable
    current_thinker.otp_required_for_login = true
    current_thinker.otp_secret = Thinker.generate_otp_secret
    current_thinker.save!

    flash[:otp_enabled] = true

    redirect_to otp_path @thinker
  end

  def disable
    current_thinker.otp_required_for_login = false
    current_thinker.save!

    redirect_to otp_path @thinker
  end

  private

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end

  def otp_params
    allowed_params = [:password]

    params.require(:otp).permit(allowed_params)
  end
end
