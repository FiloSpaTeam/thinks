class SurveyController < ApplicationController
  before_action :set_sprint
  before_action :authenticate_thinker!


  def index
    redirect_to new_sprint_survey_path(@sprint) if current_thinker.answers.where(sprint: @sprint).empty?

    @answers_count = AnswerThinker.where(sprint: @sprint).group(:answer_id).count
    @surveys       = Survey.all
  end

  def create
    @answers = params[:survey]

    @answers.each do |answer|
      AnswerThinker.create(answer_id: answer.last, sprint_id: params[:sprint_id], thinker_id: current_thinker.id)
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
