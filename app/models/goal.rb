class Goal < ActiveRecord::Base
  belongs_to :project
  belongs_to :thinker

  has_many :tasks
end
