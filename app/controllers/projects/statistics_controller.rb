class Projects::StatisticsController < ApplicationController

  before_action :authenticate_thinker!
  before_action :set_project

  def show
    @filterrific = initialize_filterrific(
      Projects::Statistic,
      params[:filterrific],
      select_options: {}
    ) || return

    @thinker   = Thinker.friendly.find(params[:id])
    @statistic = @filterrific.find
  end
end
