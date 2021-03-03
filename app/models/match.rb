class Match < ApplicationRecord
  require 'json'
  require 'open-uri'

  has_many :games
  has_many :match_events

  validates :team_1, presence: true
  validates :team_2, presence: true

  def teams
    "#{team_1} vs #{team_2}"
  end

  def self.read_matches
    data = []
    api_url = "https://soccer.sportmonks.com/api/v2.0/fixtures/between/#{start_date}/#{end_date}?#{ENV["SPORTMONKS_URL"]}api_token=CYKQiMHdrgenG9Uwe91lnRk3lMI0LOiowonRns3ryM6xygFyxmfa0p4E3jA2&include=localTeam,visitorTeam,league"
    open(api_url) do |stream|
      json = JSON.parse(stream.read)
      json['data'].each_with_index do |fixture, index|
        data[index] = ""
        data[index] << fixture['league']['data']['name']
        data[index] << ": " << fixture['localTeam']['data']['name']
        data[index] << " vs " << fixture['visitorTeam']['data']['name']
        data[index] << " at " << fixture['time']['starting_at']['date_time']
      end
    end
    data
  end

  def self.start_date
    (Date.today - 1).to_s
  end

  def self.end_date
    (Date.today + 8).to_s
  end

end
