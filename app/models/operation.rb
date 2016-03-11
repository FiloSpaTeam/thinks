class Operation < ActiveRecord::Base
  belongs_to :task

  before_create :generate_serial

  private

  def generate_serial
    operations_count = Operation.where(task_id: task.id).count + 1

    self.serial = operations_count
  end
end
