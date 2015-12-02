class Sprint < ActiveRecord::Base
  belongs_to :project

  before_create :default_values

  private

  def default_values
    self.obtained ||= 0
  end
end
