class Vote < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :task
  belongs_to :workload

  after_save :save_vote_and_update_task_status

  private

  def save_vote_and_update_task_status
    logger.debug self.task.workloads.length

    if self.task.status == Status.backlog.first
      self.task.update_attribute(:status, Status.release.first) if self.task.workloads.length >= self.task.project.minimum_team_number
    end
  end
end
