class OtpController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_owner!, except: [:index]
  before_action :set_thinker, only: [:show, :enable, :disable]

  def show
  end

  def enable
  end

  def disable
  end

  private

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end
end
