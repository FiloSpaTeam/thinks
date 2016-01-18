class LikesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])

    @task       = @comment.task
    @other_like = @task.likes.where(thinker: current_thinker)

    @vote = @task.votes.where(thinker: current_thinker)

    @like         = Like.new
    @like.comment = @comment
    @like.thinker = current_thinker

    respond_to do |format|
      if @other_like.delete_all && @vote.delete_all && @like.save
        format.html { redirect_to @task, notice: 'You like it!' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@like)

        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end
end
