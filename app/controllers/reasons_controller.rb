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

        format.html { redirect_to @comment.task, alert: "Reason can't be empty!" }
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
