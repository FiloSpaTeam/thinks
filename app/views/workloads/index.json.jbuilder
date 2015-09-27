json.array!(@workloads) do |workload|
  json.extract! workload, :id, :value
  json.url workload_url(workload, format: :json)
end
