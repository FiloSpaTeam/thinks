class BannedThinker < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :project
end
