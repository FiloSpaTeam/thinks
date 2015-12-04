class ThinkersController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_admin!

  def index
    @thinkers = Thinker.all
  end

  def show
    @thinker = Thinker.find(params[:id])
  end

  private

  def check_admin!
    if !current_thinker.try(:admin?)
      redirect_to root_url
    end
  end
end
