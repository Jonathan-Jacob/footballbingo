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
  [2, 'Champions League', 'eu'],
  [5, 'Europa League', 'eu'],
  [8, 'Premier League', 'en'],
  [9, 'Championship', 'en'],
  [72, 'Eredivisie', 'nl'],
  [82, 'Bundesliga', 'de'],
  [85, '2. Bundesliga', 'de'],
  [109, 'DFB-Pokal', 'de'],
  [181, 'Bundesliga', 'at'],
  [301, 'Ligue 1', 'fr'],
  [384, 'Serie A', 'it'],
  [387, 'Serie B', 'it'],
  [462, 'Primeira Liga', 'pt'],
  [486, 'Premier League', 'ru'],
  [564, 'La Liga', 'es'],
  [591, 'Super League', 'ch'],
  [600, 'Süper Lig', 'tr'],
  [732, 'World Cup', 'un'],
  [779, 'MLS', 'us'],
  [1326, 'Euro Championship', 'eu']
]
competition_seed_data.each do |data|
  Competition.create(api_id: data[0], name: data[1], country: data[2])
end
puts "done.\n\n"

puts "reading api, updating/creating matches..."
matches = Match.update_matches
puts "done."
