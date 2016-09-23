# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

class Comment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :task, -> { with_deleted }
  belongs_to :thinker

  has_one :reason

  has_many :likes, dependent: :destroy

  has_many :notifications, -> { where(model: :Notification) }, foreign_key: :model_id, dependent: :destroy

  validates :text, length: { maximum: 2000 }, presence: true
  validates :thinker, presence: true
  validates :task, presence: true

  default_scope { order('approved').order('likes_count DESC').order('updated_at DESC') }

  scope :approved, lambda {
    where(approved: true)
  }

  def current_thinker?(current_thinker)
    thinker == current_thinker
  end

  def approve(p_reason)
    ActiveRecord::Base.transaction do
      task = self.task

      task.status = Status.done.first
      task.end_at = DateTime.now
      task.save

      unless approved
        task.comments.approved.update_all(approved: false)

        self.approved = true
        save

        p_reason.comment = self
        p_reason.save
      end
    end
  end
end
