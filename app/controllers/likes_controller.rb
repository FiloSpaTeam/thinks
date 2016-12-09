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
