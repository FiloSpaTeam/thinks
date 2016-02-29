class ThinkersController < ApplicationController
  before_action :authenticate_thinker!
  before_action :check_admin!, only: [:index]
  before_action :check_owner!, except: [:index]

  before_action :set_thinker, only: [:show, :edit, :update]

  def index
    @thinkers = Thinker.all
  end

  def show
  end

  def edit
  end

  def update
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

  def set_thinker
    @thinker = Thinker.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thinker_params
    allowed_params = [:name, :email, :born_at, :sex_id, :avatar, :country_iso]

    params.require(:thinker).permit(allowed_params)
  end
end
