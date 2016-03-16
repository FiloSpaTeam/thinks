class Thinker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :two_factor_authenticatable,
         :two_factor_backupable,
         otp_backup_code_length: 16,
         otp_number_of_backup_codes: 5,
         :otp_secret_encryption_key => ENV['THINK_SOFTWARE_OTP']

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_attachment :avatar, accept: [:jpg, :png]

  has_and_belongs_to_many :teams, class_name: 'Project'
  has_and_belongs_to_many :notifications

  has_many :contributions
  has_many :projects
  has_many :working_tasks, class_name: 'Task', foreign_key: :worker_thinker_id
  has_many :tasks
  has_many :comments
  has_many :likes
  has_many :answers, class_name: 'AnswerThinker', foreign_key: :thinker_id

  belongs_to :sex
  belongs_to :country, class_name: 'Country', foreign_key: :country_iso
end
