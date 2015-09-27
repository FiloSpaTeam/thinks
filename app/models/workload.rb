class Workload < ActiveRecord::Base
  default_scope { order(:value) }

  scope :infinity, -> () { where value: 9999 }
end
