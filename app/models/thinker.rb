class Thinker < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects
  has_many :working_tasks, class_name: "Task", :foreign_key => :worker_thinker_id
  has_many :tasks

  has_many :comments
  has_many :likes
end
