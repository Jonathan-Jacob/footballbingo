# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'date'

puts "creating competitions..."

competition_seed_data = [
  #api_id, name, country
  [2, 'Champions League', 'UEFA'],
  [5, 'Europa League', 'UEFA'],
  [8, 'Premier League', 'ENG'],
  [9, 'Championship', 'ENG'],
  [72, 'Eredivisie', 'NED'],
  [82, 'Bundesliga', 'GER'],
  [85, '2. Bundesliga', 'GER'],
  [181, 'Tipico Bundesliga', 'AUT'],
  [262, 'Fortuna Liga', 'CZE'],
  [301, 'Ligue 1', 'FRA'],
  [325, 'Super League', 'GRE'],
  [384, 'Serie A', 'ITA'],
  [387, 'Serie B', 'ITA'],
  [462, 'Primeira Liga', 'POR'],
  [486, 'Premier League', 'RUS'],
  [564, 'La Liga', 'ESP'],
  [591, 'Super League', 'SUI'],
  [600, 'Süper Lig', 'TUR'],
  [732, 'World Cup', 'FIFA'],
  [1326, 'European Championship', 'UEFA']
]

competition_seed_data.each do |data|
  Competition.create(api_id: data[0], name: data[1], country: data[2]) unless Competition.find_by(api_id: data[0])
end

puts "done.\n\n"

puts "reading api..."

matches = Match.read_matches

puts "done.\n\n"

puts "updating/creating matches..."

if matches[:data].present?
  matches[:data].each do |match_json|
    if match = Match.find_by(api_id: match_json[:id])
      match.update(competition: Competition.find_by(api_id: match_json[:league_id]),
                   team_1: match_json[:localTeam][:data][:name],
                   team_2: match_json[:visitorTeam][:data][:name],
                   date_time: DateTime.strptime(match_json[:time][:starting_at][:date_time], '%Y-%m-%d %H:%M:%S'))
    else
      match = Match.create(competition: Competition.find_by(api_id: match_json[:league_id]),
                   team_1: match_json[:localTeam][:data][:name],
                   team_2: match_json[:visitorTeam][:data][:name],
                   api_id: match_json[:id],
                   date_time: DateTime.strptime(match_json[:time][:starting_at][:date_time], '%Y-%m-%d %H:%M:%S'))
    end
    match.update_status(match_json[:time][:status])
  end
end

puts "done."
