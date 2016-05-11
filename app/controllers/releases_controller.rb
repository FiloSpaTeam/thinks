class ReleasesController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_project, only: [:new, :index, :create]

  def index
    @filterrific = initialize_filterrific(
      Release,
      params[:filterrific],
      select_options: {}
    ) || return
    @releases = @filterrific
                .find.unscoped
                .where(project: @project)
                .order('end_at asc')
                .page(params[:page])
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end
end
