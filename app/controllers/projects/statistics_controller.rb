class Projects::StatisticsController < ApplicationController

  before_action :authenticate_thinker!
  before_action :set_project

  def show
    @filterrific = initialize_filterrific(
      Projects::Statistic,
      params[:filterrific],
      select_options: {}
    ) || return

    @local_thinker = Thinker.friendly.find(params[:id])
    @statistic = @filterrific.find

    if !params[:filterrific].nil?
      @first_section = params[:filterrific][:with_first_section]
      @second_section = params[:filterrific][:with_second_section]
      @third_section = params[:filterrific][:with_third_section]
    end
  end
end
