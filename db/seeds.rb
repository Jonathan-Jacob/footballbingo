# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'date'

puts "clearing database..."
Competition.destroy_all
puts "done.\n\n"

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
  [109, 'DFB-Pokal', 'GER'],
  [181, 'Tipico Bundesliga', 'AUT'],
  [301, 'Ligue 1', 'FRA'],
  [384, 'Serie A', 'ITA'],
  [387, 'Serie B', 'ITA'],
  [462, 'Primeira Liga', 'POR'],
  [486, 'Premier League', 'RUS'],
  [564, 'La Liga', 'ESP'],
  [591, 'Super League', 'SUI'],
  [600, 'Süper Lig', 'TUR'],
  [732, 'World Cup', 'FIFA'],
  [779, 'Major League Soccer', 'USA'],
  [1326, 'European Championship', 'UEFA']
]
competition_seed_data.each do |data|
  Competition.create(api_id: data[0], name: data[1], country: data[2])
end
puts "done.\n\n"

puts "reading api, updating/creating matches..."
matches = Match.update_matches
puts "done."
