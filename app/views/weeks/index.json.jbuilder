json.array!(@weeks) do |week|
  json.extract! week, :id, :game_id, :number, :days, :count, :status, :thread_url
  json.url week_url(week, format: :json)
end
