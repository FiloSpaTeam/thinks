class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :thinker

  has_one :reason

  has_many :likes

  validates :text, length: { maximum: 240 }, presence: true

  default_scope { order("likes_count DESC").order("updated_at DESC") }

  scope :approved, lambda {
    where(approved: true)
  }

  def current_thinker?(current_thinker)
    self.thinker == current_thinker
  end
end
