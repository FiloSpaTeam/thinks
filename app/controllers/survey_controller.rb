class SurveyController < ApplicationController
  before_action :set_sprint
  before_action :authenticate_thinker!


  def index
    @answers = current_thinker.answers

    redirect_to new_sprint_survey_path(@sprint) if @answers.empty?
  end

  def create
    @answers = params[:survey]

    @answers.each do |answer|
      current_thinker.answers << Answer.find(answer.last)
    end

    respond_to do |format|
      format.html { redirect_to sprint_survey_index_path }
    end
  end

  def new
    @surveys = Survey.all
    @survey  = Survey.new
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end

  def survey_params
    # allowed_params = Survey.all.map(&:id)

    params.require(:survey) # .permit(allowed_params)
  end
end