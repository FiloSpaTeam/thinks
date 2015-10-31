module WorkloadsHelper
  def workload_description workload
    return t("not_defined_yet") if workload.nil?

    workload.description
  end
end
