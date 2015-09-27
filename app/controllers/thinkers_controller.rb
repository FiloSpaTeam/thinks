class ThinkersController < ApplicationController
  def index
    @thinkers = Thinker.all
  end

  def show
    @thinker = Thinker.find(params[:id])
  end
end
