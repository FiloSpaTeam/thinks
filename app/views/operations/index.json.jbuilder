json.array!(@operations) do |operation|
  json.extract! operation, :id, :serial, :text, :done
  json.url operation_url(operation, format: :json)
end
