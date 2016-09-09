json.all_matches do
  json.live_matches @live_matches, partial: 'matches/match', as: :match
  json.previous_matches @previous_matches, partial: 'matches/match', as: :match
end
