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
    current_thinker.otp_secret = Thinker.generate_otp_secret(24)
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
