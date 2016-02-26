class Thinker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_attachment :avatar, accept: [:jpg, :png, :gif]

  has_and_belongs_to_many :teams, class_name: 'Project'
  has_and_belongs_to_many :notifications

  has_many :projects
  has_many :working_tasks, class_name: 'Task', foreign_key: :worker_thinker_id
  has_many :tasks
  has_many :comments
  has_many :likes
  has_many :answers, class_name: 'AnswerThinker', foreign_key: :thinker_id

  belongs_to :sex
  belongs_to :country, class_name: 'Country', foreign_key: :country_iso
end
