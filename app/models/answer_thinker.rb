class AnswerThinker < ActiveRecord::Base
  self.table_name = :answers_thinkers

  belongs_to :answer
  belongs_to :sprint
  belongs_to :thinker
end
