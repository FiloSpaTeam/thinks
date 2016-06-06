class Projects::StatisticsController < ApplicationController

  before_action :authenticate_thinker!
  before_action :set_project

  def show
    @thinker = Thinker.friendly.find(params[:id])
  end

end
