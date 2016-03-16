class Contribution < ActiveRecord::Base
  belongs_to :project
  belongs_to :thinker

  enum intensity: [:nothing, :watching, :partecipate]
end
