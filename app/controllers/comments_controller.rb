# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

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

    @comment.really_destroy!

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
    reason = Reason.new(reason_params)

    @task = @comment.task
    respond_to do |format|
      if reason.text.empty?
        set_form_errors(reason)

        format.html { redirect_to @task, alert: 'You need to specify a reason!' }
      else
        if @task.worker == current_thinker && @comment.approve(reason)
          create_notification(@comment, @task.project)
          format.html { redirect_to @task, notice: 'Solution approved! Task done!' }
          format.json { render :show, status: :created, location: @task }
        else
          set_form_errors(@comment)

          format.html { redirect_to @task }
          format.json { render json: @task.comment, status: :unprocessable_entity }
        end
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
    @comment = Comment.with_deleted.find(params[:id])
  end

  def comment_params
    allowed_params = [:text]

    params.require(:comment).permit(allowed_params)
  end

  def reason_params
    allowed_params = [:text]

    params.require(:reason).permit(allowed_params)
  end
end
