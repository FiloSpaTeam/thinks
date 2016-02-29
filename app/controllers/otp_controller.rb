class OtpController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_owner!, except: [:index]

  def show
  end
end
