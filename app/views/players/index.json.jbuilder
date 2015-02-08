json.array!(@players) do |player|
  json.extract! player, :id, :team_id, :name, :slug, :status, :captain, :cell_number, :cell_provider
  json.url player_url(player, format: :json)
end
