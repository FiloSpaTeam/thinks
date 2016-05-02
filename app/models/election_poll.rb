class ElectionPoll < ActiveRecord::Base
  belongs_to :project
  belongs_to :team_role

  has_many :voters

  enum status: [:active, :done, :closed]
end
