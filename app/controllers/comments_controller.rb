class CommentsController < ApplicationController
  before_action :set_task, only: [:create]

  def create
    @comment         = Comment.new(comment_params)
    @comment.task    = @task
    @comment.thinker = current_thinker

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @task, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@comment)

        format.html { render :new }
        format.json { render json: @task.comment, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_task
      @task = Task.find(params[:task_id])
    end

    def comment_params
      allowed_params = [:text]

      params.require(:comment).permit(allowed_params)
    end
end
