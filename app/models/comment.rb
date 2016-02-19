class Comment < ActiveRecord::Base
  belongs_to :task
  belongs_to :thinker

  has_one :reason

  has_many :likes

  validates :text, length: { maximum: 240 }, presence: true
  validates :thinker, presence: true
  validates :task, presence: true

  default_scope { order('approved').order('likes_count DESC').order('updated_at DESC') }

  after_destroy lambda { |comment|
    Notification
      .where('model LIKE ?', comment.class.name)
      .where(model_id: comment.id)
      .destroy_all
  }

  scope :approved, lambda {
    where(approved: true)
  }

  def current_thinker?(current_thinker)
    thinker == current_thinker
  end
end
