json.extract! live_event, :id, :name, :event_id, :created_at, :updated_at
json.url live_event_url(live_event, format: :json)