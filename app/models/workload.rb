class Workload < ActiveRecord::Base
  has_many :tasks, through: :votes

  default_scope { order(:value) }

  scope :infinity, lambda { where value: 9999 }
end
