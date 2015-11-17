class ReasonsController < ApplicationController
  before_action :set_comment, only: [:create]

  def create
    @reason = Reason.new(reason_params)
    @reason.thinker = current_thinker
    @reason.comment = @comment

    respond_to do |format|
      if @reason.save
        format.html { redirect_to @comment.task, notice: 'Reason added to documentation!' }
        format.json { render :show, status: :created, location: @comment.task }
      else
        set_form_errors(@reason)
        set_validators_for_form_help

        format.html { render :new }
        format.json { render json: @reason.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def reason_params
    allowed_params = [:text]

    params.require(:reason).permit(allowed_params)
  end
end
