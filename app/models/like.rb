class Like < ActiveRecord::Base
  belongs_to :comment
  belongs_to :thinker

  scope :current_thinker, lambda { |thinker| 
    where ({ thinker: thinker })
  }
end
