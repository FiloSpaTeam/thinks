class Like < ActiveRecord::Base
  belongs_to :comment, counter_cache: true
  belongs_to :thinker

  scope :current_thinker, lambda { |thinker| 
    where ({ thinker: thinker })
  }
end
