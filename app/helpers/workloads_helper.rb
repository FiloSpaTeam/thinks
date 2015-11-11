module WorkloadsHelper
  def workload_description task
    return t("not_defined_yet") if task.average.nil?

    render "workloads/description", task: task
  end

  def closest_workload task
    workloads = Workload.pluck(:value)

    workloads.min_by { |x| (x.to_f - task.average).abs }
  end
end
