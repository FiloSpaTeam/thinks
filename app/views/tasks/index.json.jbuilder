json.array!(@tasks) do |task|
  json.extract! task, :id, :serial, :description, :project_id, :task_id, :thinker_id, :worker_thinker_id, :status_id, :workload
  json.url task_url(task, format: :json)
end
