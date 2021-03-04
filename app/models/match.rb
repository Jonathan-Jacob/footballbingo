class Match < ApplicationRecord
  has_many :games
  has_many :match_events
  belongs_to :competition
  validates :team_1, presence: true
  validates :team_2, presence: true

  require 'json'
  require 'open-uri'

  def teams
    "#{team_1} vs #{team_2}"
  end

  def self.read_json
    pages = 0
    json = ""
    api_url = "https://soccer.sportmonks.com/api/v2.0/fixtures/between/#{start_date}/#{end_date}?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,league,deleted=1"
    # binding.pry
    open(api_url) do |stream|
      json = JSON.parse(stream.read)
      pages = json['meta']['pagination']['total_pages']
    end
    if pages >= 2
      (2..pages).each do |page|
        open(api_url + "&page=#{page}") do |stream|
          json_page = JSON.parse(stream.read)
          json['data'] += json_page['data']
        end
      end
    end
    json
  end

  def self.start_date
    (Date.today - 1).to_s
  end

  def self.end_date
    (Date.today + 8).to_s
  end

  def update_status(status)
    not_started = %w[NS POSTP DELAYED TBA]
    ongoing = %w[LIVE HT ET PEN_LIVE BREAK INT ABAN SUSP]
    finished = %w[FT AET FT_PEN CANCL AWARDED WO Deleted]
    if not_started.include?(status)
      self.status = "not_started"
    elsif ongoing.include?(status)
      self.status = "ongoing"
    elsif finished.include?(status)
      self.status = "finished"
    end
    save
  end
end
