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

class Thinker < ActiveRecord::Base
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :two_factor_authenticatable,
         :two_factor_backupable,
         otp_backup_code_length: 16,
         otp_number_of_backup_codes: 5,
         otp_secret_encryption_key: ENV['THINK_SOFTWARE_OTP']

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_attachment :avatar, accept: [:jpg, :png]

  has_and_belongs_to_many :teams, class_name: 'Project'
  has_and_belongs_to_many :notifications
  has_and_belongs_to_many :skills

  validates_date :born_at,
                    :before => -> { 14.years.ago },
                    :before_message => 'must be at least 14 years old',
                    :allow_blank => true

  has_many :contributions
  has_many :projects
  has_many :working_tasks, -> { where("tasks.status_id = ?", Status.in_progress.first) }, class_name: 'Task', foreign_key: :worker_thinker_id
  has_many :tasks, -> { where(recruitment: false) }
  has_many :comments
  has_many :likes
  has_many :answers, class_name: 'AnswerThinker', foreign_key: :thinker_id
  has_many :assigned_roles
  has_many :banned_thinkers
  has_many :ratings, dependent: :destroy

  has_one :notifications_preference, class_name: 'NotificationsPreference', foreign_key: :thinker_id

  belongs_to :sex
  belongs_to :country, class_name: 'Country', foreign_key: :country_iso

  def ban(project)
    banned_thinkers.where(project: project).first
  end
end
