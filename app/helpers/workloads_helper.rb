module WorkloadsHelper
  def workload_description task
    return t("not_defined_yet") if task.average.nil?

    " 
        #{task.average}
        #{task.variance}
    "
  end
end
