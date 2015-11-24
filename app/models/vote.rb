class Vote < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :task
  belongs_to :workload

  after_save :save_vote_and_update_task_status

  private

  def save_vote_and_update_task_status
    if self.task.status == Status.backlog.first && self.task.workloads.length >= self.task.project.minimum_team_number
      self.task.update_attribute(:status, Status.release.first)
    end
  end
end
