class ThinkersController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_admin!, only: [:index]
  before_action :check_owner!, except: [:index]

  def index
    @thinkers = Thinker.all
  end

  def show
    @thinker = Thinker.friendly.find(params[:id])
  end

  private

  # At the moment we need to redirect others, later will be there a public page
  def check_owner!
    redirect_to root_url unless current_thinker.slug == params[:id]
  end

  def check_admin!
    redirect_to root_url unless current_thinker.try(:admin?)
  end
end
