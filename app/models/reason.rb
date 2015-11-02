class Reason < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :comment
end
