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

class NotificationsController < ApplicationController
  include NotificationsHelper

  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_thinker!

  # GET /notifications
  # GET /notifications.json
  def index
    @filterrific = initialize_filterrific(
      Notification
        .user(current_thinker)
        .order('project_id DESC')
        .order('created_at DESC'),
      params[:filterrific],
      select_options: {
        sorted_by_title: Task.options_for_sorted_by(:title),
        sorted_by_workload: Task.options_for_sorted_by(:workload)
      }
    ) || return
    @notifications = @filterrific.find.page params[:page]

    @notifications = @notifications.group_by { |n| [n.controller, n.action, n.model, n.model_id] }

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /notifications/1/read
  # PATCH/PUT /notifications/1/read.json
  def read
    @notification = Notification.find(params[:notification_id])

    mark_as_read_similar_notifications(@notification)

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification read.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /notifications/1/read_all
  # PATCH/PUT /notifications/1/read_all.json
  def read_all
    project = Project.with_deleted.friendly.find(params[:project_id])
    @notifications = Notification.where(project: project)

    current_thinker.notifications << @notifications
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'All notifications read.' }
      format.json { head :no_content }
    end
  end

  def check
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def follow
    notification = Notification.find(params[:notification_id])

    mark_as_read_similar_notifications(notification)

    respond_to do |format|
      format.html { redirect_to url_for_notifications(notification), notice: 'Notification mark as read.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  def mark_as_read_similar_notifications(notification)
    similar_notifications = Notification
                            .user(current_thinker)
                            .where(project: notification.project)
                            .where(controller: notification.controller)
                            .where(action: notification.action)
                            .where(model: notification.model)
                            .where(model_id: notification.model_id)

    current_thinker.notifications << notification
    similar_notifications.each do |s_notification|
      current_thinker.notifications << s_notification
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def notification_params
    params.require(:notification).permit(:project_id, :thinker_id)
  end
end
