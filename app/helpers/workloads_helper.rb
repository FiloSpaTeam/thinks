module WorkloadsHelper
  def workload_description(task)
    render 'workloads/description', task: task
  end
end
