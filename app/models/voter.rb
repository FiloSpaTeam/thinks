class Voter < ActiveRecord::Base
  belongs_to :election_poll
  belongs_to :thinker
  belongs_to :elect, class_name: 'Thinker', foreign_key: 'elect_id'
end
