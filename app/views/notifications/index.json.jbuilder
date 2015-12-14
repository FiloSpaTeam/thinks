json.array!(@notifications) do |notification|
  json.extract! notification, :id, :project_id, :thinker_id
  json.url notification_url(notification, format: :json)
end
