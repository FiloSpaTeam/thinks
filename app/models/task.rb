class Task < ActiveRecord::Base
  has_many :tasks
  
  belongs_to :task
  belongs_to :project
  belongs_to :thinker
  belongs_to :worker, class_name: "Thinker", foreign_key: "worker_thinker_id"
  belongs_to :status
  belongs_to :workload

  before_create :generate_serial
  before_create :default_values

  before_save :set_progress

  validates :description, length: { in: 30..1600 }

  scope :status_progress, -> (status) { where status: status } 
  scope :in_progress, -> () { where status: Status.in_progress }

  def progress
    statuses = Status.all

    actual_index = statuses.index(self.status)

    return false if self.workload == Workload.infinity.first

    self.status = statuses.fetch(actual_index + 1)
  end

  private
  
    def generate_serial
      tasks_count = Task.where({project_id: self.project.id}).count
      tasks_count += 1
      
      self.serial = tasks_count
    end

    def default_values
      self.workload ||= Workload.find_by(:value => nil)
      self.status ||= Status.find_by(:translation_code => :backlog)
    end

    def set_progress
      if !self.workload.nil? && self.status == Status.backlog.first
        self.status = Status.release.first
      end
    end
end
