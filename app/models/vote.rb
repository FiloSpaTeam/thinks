class Vote < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :task
  belongs_to :workload
end
