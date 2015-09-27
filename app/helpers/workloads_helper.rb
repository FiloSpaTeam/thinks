module WorkloadsHelper
  def workload_description workload
    return "?" if workload.nil?

    workload.description
  end
end
