class Answer < ActiveRecord::Base
  belongs_to :survey

  has_and_belongs_to_many :shared_answers, class_name: 'AnswerThinker', foreign_key: :answer_id
end
