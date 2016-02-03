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

  def edit
    @thinker = Thinker.friendly.find(params[:id])
  end

  def update
    @thinker = Thinker.friendly.find(params[:id])

    respond_to do |format|
      if current_thinker == @thinker && @thinker.update(thinker_params)
        format.html { redirect_to @thinker, notice: 'Your data are updated.' }
        format.json { render :show, status: :ok, location: @thinker }
      else
        format.html { render :edit }
        format.json { render json: @thinker.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # At the moment we need to redirect others, later will be there a public page
  def check_owner!
    redirect_to root_url unless current_thinker.slug == params[:id]
  end

  def check_admin!
    redirect_to root_url unless current_thinker.try(:admin?)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thinker_params
    allowed_params = [:name, :email, :born_at, :sex_id, :avatar, :avatar_cache]

    params.require(:thinker).permit(allowed_params)
  end
end
