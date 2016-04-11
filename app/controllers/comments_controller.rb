class CommentsController < ApplicationController
  before_action :set_task, only: [:create]
  before_action :set_comment, only: [:approve, :edit, :update, :destroy]
  before_action :set_validators_for_form_help, only: [:edit]

  def create
    @comment         = Comment.new(comment_params)
    @comment.task    = @task
    @comment.thinker = current_thinker

    respond_to do |format|
      if @comment.save
        create_notification(@comment, @task.project)
        flash[:notice] = 'Comment was successfully created.'

        format.json { render :show, status: :created, location: @task }
        format.js { render js: "window.location = '#{task_path @task}'" }
      else
        set_form_errors(@comment)

        format.json { render json: @comment, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def index
  end

  def edit
  end

  def destroy
    task = @comment.task
    task_votes = task.votes.all
    task_votes.delete_all(thinker_id: current_thinker)

    @comment.destroy

    respond_to do |format|
      destroy_notification(@comment, task.project)
      format.html { redirect_to task, notice: 'Comment was successfully deleted.' }
      format.json { render :show, status: :ok, location: task }
    end
  end

  def update
    @task = @comment.task

    respond_to do |format|
      if current_thinker == @comment.thinker && @comment.update(comment_params)
        create_notification(@comment, @task.project)
        format.html { redirect_to @task, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @comment.approved = true
    @task             = @comment.task
    respond_to do |format|
      if @task.worker == current_thinker && @comment.approve
        create_notification(@comment, @task.project)
        format.html { redirect_to @task, notice: 'Solution approved! Task done!' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@comment)

        format.html { render :new }
        format.json { render json: @task.comment, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_validators_for_form_help
    # description_validators = Task.validators_on(:description)[0]
    # @chars_min_description = description_validators.options[:minimum]

    # title_validators = Task.validators_on(:title)[0]
    # @chars_max_title = title_validators.options[:maximum]

    comment_validators = Comment.validators_on(:text)[0]
    @chars_max_comment = comment_validators.options[:maximum]
  end

  def set_task
    @task = Task.with_deleted.find(params[:task_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    allowed_params = [:text]

    params.require(:comment).permit(allowed_params)
  end
end
