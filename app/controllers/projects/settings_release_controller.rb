class Projects::SettingsReleaseController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project

  def index
  end

  def update
  end
end
