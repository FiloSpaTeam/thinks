class Vote < ActiveRecord::Base
  belongs_to :thinker
  belongs_to :task
  belongs_to :workload

  after_save :save_vote_and_update_task

  private

  def save_vote_and_update_task
    # update average workload and standard_deviation
    average = task.average

    # search for the closest workload
    task.workload           = Workload.closest(average)
    task.standard_deviation = task.standard_deviation

    task.save
  end
end
