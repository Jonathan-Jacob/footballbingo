class Match < ApplicationRecord
  require 'json'
  require 'open-uri'

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

  def self.read_matches
    pages = 0
    json = {}
    api_url = "https://soccer.sportmonks.com/api/v2.0/fixtures/between/#{start_date}/#{end_date}?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,league,deleted=1"
    open(api_url) do |stream|
      json = JSON.parse(stream.read, symbolize_names: true)
      pages = json[:meta][:pagination][:total_pages]
    end
    if pages >= 2
      (2..pages).each do |page|
        open(api_url + "&page=#{page}") do |stream|
          json_page = JSON.parse(stream.read, symbolize_names: true)
          json[:data] += json_page[:data]
        end
      end
    end
    json
  end

  def self.read_events
    json = {}
    api_url = "https://soccer.sportmonks.com/api/v2.0/fixtures/between/2021-03-04/2021-03-04?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,events,lineup,bench,stats"
    # api_url = "https://soccer.sportmonks.com/api/v2.0/livescores?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,events,lineup,bench,stats"
    open(api_url) do |stream|
      json = JSON.parse(stream.read, symbolize_names: true)
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

  def self.store_data
    return if Match.count < 1

    raw_data = read_events
    raw_data[:data].each do |api_data|
      if (match = Match.find_by(api_id: api_data[:id]))
        match.init_data unless match.data.present?
        data_hash = JSON.parse(match.data, symbolize_names: true)
        home_id = api_data[:localteam_id]
        away_id = api_data[:visitorteam_id]
        woodwork_home = 0
        woodwork_away = 0
        penalties_scored_home = 0
        penalties_scored_away = 0
        penalties_saved_home = 0
        penalties_saved_away = 0
        own_goals_home = 0
        own_goals_away = 0
        joker_goals_home = 0
        joker_goals_away = 0
        (api_data[:lineup][:data] + api_data[:bench][:data]).each do |player_data|
          if player_data[:team_id] == home_id
            data_hash[:home_players][:"h#{player_data[:number]}"] = player_data[:player_name]
            data_hash[:goals][:home_players][:"h#{player_data[:number]}"] = player_data[:stats][:goals][:scored].nil? ? 0 : player_data[:stats][:goals][:scored]
            if player_data[:type] == 'bench' && data_hash[:goals][:home_players][:"h#{player_data[:number]}"].present?
              joker_goals_home += data_hash[:goals][:home_players][:"h#{player_data[:number]}"]
            end
            data_hash[:assists][:home_players][:"h#{player_data[:number]}"] = player_data[:stats][:goals][:assists].nil? ? 0 : player_data[:stats][:goals][:assists]
            data_hash[:fouls][:home_players][:"h#{player_data[:number]}"] = player_data[:stats][:fouls][:committed].nil? ? 0 : player_data[:stats][:fouls][:committed]
            data_hash[:fouled][:home_players][:"h#{player_data[:number]}"] = player_data[:stats][:fouls][:drawn].nil? ? 0 : player_data[:stats][:fouls][:drawn] 
            data_hash[:yellow][:home_players][:"h#{player_data[:number]}"] = player_data[:stats][:cards][:yellowcards].nil? ? 0 : player_data[:stats][:cards][:yellowcards]
            woodwork_home += player_data[:stats][:other][:hit_woodwork].nil? ? 0 : player_data[:stats][:other][:hit_woodwork]
            penalties_scored_home += player_data[:stats][:other][:pen_scored].nil? ? 0 : player_data[:stats][:other][:pen_scored]
            penalties_saved_home += player_data[:stats][:other][:pen_saved].nil? ? 0 : player_data[:stats][:other][:pen_saved]
            own_goals_home += player_data[:stats][:goals][:owngoals].nil? ? 0 : player_data[:stats][:goals][:owngoals]
          elsif player_data[:team_id] == away_id
            data_hash[:away_players][:"a#{player_data[:number]}"] = player_data[:player_name]
            data_hash[:goals][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:goals][:scored].nil? ? 0 : player_data[:stats][:goals][:scored]
            if player_data[:type] == 'bench' && data_hash[:goals][:home_players][:"h#{player_data[:number]}"].present?
              joker_goals_away += data_hash[:goals][:home_players][:"h#{player_data[:number]}"]
            end
            data_hash[:assists][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:goals][:assists].nil? ? 0 : player_data[:stats][:goals][:assists]
            data_hash[:fouls][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:fouls][:committed].nil? ? 0 : player_data[:stats][:fouls][:committed]
            data_hash[:fouled][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:fouls][:drawn].nil? ? 0 : player_data[:stats][:fouls][:drawn] 
            data_hash[:yellow][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:cards][:yellowcards].nil? ? 0 : player_data[:stats][:cards][:yellowcards]
            woodwork_away += player_data[:stats][:other][:hit_woodwork].nil? ? 0 : player_data[:stats][:other][:hit_woodwork]
            penalties_scored_away += player_data[:stats][:other][:pen_scored].nil? ? 0 : player_data[:stats][:other][:pen_scored]
            penalties_saved_away += player_data[:stats][:other][:pen_saved].nil? ? 0 : player_data[:stats][:other][:pen_saved]
            own_goals_away += player_data[:stats][:goals][:owngoals].nil? ? 0 : player_data[:stats][:goals][:owngoals]
          end
        end
        data_hash[:woodwork][:home] = woodwork_home
        data_hash[:woodwork][:away] = woodwork_away
        data_hash[:woodwork][:all] = woodwork_home + woodwork_away
        data_hash[:penalties_scored][:home] = penalties_scored_home
        data_hash[:penalties_scored][:away] = penalties_scored_away
        data_hash[:penalties_scored][:all] = penalties_scored_home + penalties_scored_away
        data_hash[:penalties_saved][:home] = penalties_saved_home
        data_hash[:penalties_saved][:away] = penalties_saved_away
        data_hash[:penalties_saved][:all] = penalties_saved_home + penalties_saved_away
        data_hash[:own_goals][:home] = own_goals_home
        data_hash[:own_goals][:away] = own_goals_away
        data_hash[:own_goals][:all] = own_goals_home + own_goals_away
        data_hash[:joker_goals][:home] = joker_goals_home
        data_hash[:joker_goals][:away] = joker_goals_away
        data_hash[:joker_goals][:all] = joker_goals_home + joker_goals_away
        api_data[:stats][:data].each do |stats_data|
          if stats_data[:team_id] == home_id
            data_hash[:goals][:home] = stats_data[:goals].nil? ? 0 : stats_data[:goals]
            data_hash[:fouls][:home] = stats_data[:fouls].nil? ? 0 : stats_data[:fouls]
            data_hash[:yellow][:home] = stats_data[:yellowcards].nil? ? 0 : stats_data[:yellowcards]
            data_hash[:yellow_red][:home] = stats_data[:yellowredcards].nil? ? 0 : stats_data[:yellowredcards]
            data_hash[:red][:home] = stats_data[:redcards].nil? ? 0 : stats_data[:redcards]
          elsif stats_data[:team_id] == away_id
            data_hash[:goals][:away] = stats_data[:goals].nil? ? 0 : stats_data[:goals]
            data_hash[:fouls][:away] = stats_data[:fouls].nil? ? 0 : stats_data[:fouls]
            data_hash[:yellow][:away] = stats_data[:yellowcards].nil? ? 0 : stats_data[:yellowcards]
            data_hash[:yellow_red][:away] = stats_data[:yellowredcards].nil? ? 0 : stats_data[:yellowredcards]
            data_hash[:red][:away] = stats_data[:redcards].nil? ? 0 : stats_data[:redcards]
          end
        end
        match.data = data_hash.to_json
        match.save
      end
    end
  end

  def init_data
    data_hash = {
      home_players: {},
      away_players: {},
      goals: {
        all: 0,
        home: 0,
        away: 0,
        home_players: {},
        away_players: {}
      },
      assists: {
        home_players: {},
        away_players: {}
      },
      fouls: {
        all: 0,
        home: 0,
        away: 0,
        home_players: {},
        away_players: {}
      },
      fouled: {
        home_players: {},
        away_players: {}
      },
      yellow: {
        all: 0,
        home: 0,
        away: 0,
        home_players: {},
        away_players: {}
      },
      yellow_red: {
        all: 0,
        home: 0,
        away: 0
      },
      red: {
        all: 0,
        home: 0,
        away: 0
      },
      penalties_scored: {
        all: 0,
        home: 0,
        away: 0
      },
      penalties_saved: {
        all: 0,
        home: 0,
        away: 0
      },
      woodwork: {
        all: 0,
        home: 0,
        away: 0
      },
      own_goals: {
        all: 0,
        home: 0,
        away: 0
      },
      joker_goals: {
        all: 0,
        home: 0,
        away: 0
      }
    }
    self.data = data_hash.to_json
  end
end
