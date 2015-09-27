json.array!(@statuses) do |status|
  json.extract! status, :id, :translation_code, :description
  json.url status_url(status, format: :json)
end
