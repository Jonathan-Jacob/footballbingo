class Match < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :bingo_cards, through: :games
  has_many :match_events, dependent: :destroy
  belongs_to :competition
  validates :team_1, presence: true
  validates :team_2, presence: true

  require 'json'
  require 'open-uri'
  require 'csv'

  def broadcasting
    bingo_cards.each do |bingo_card|
      BingoCardChannel.broadcast_to(
        bingo_card,
        bingo_card.bingo_tiles
      )
    end
  end

  def start_possible?
    status == "not_started" || date_time + 300 >= Time.now.utc
  end

  def teams
    "#{team_1} vs #{team_2} - kickoff #{normal_time}"
  end

  def normal_time
    date_time.strftime("%d.%B %Y - %H:%Mh")
  end
  
  def self.write_csv
    CSV.open('matches.csv', 'wb') do |csv|
      csv << ['competition_id', 'competition_name', 'date', 'team_1_id', 'team_2_id', 'team_1_name', 'team_2_name', 'color_1', 'color_2', 'goals', 'fouls', 'yellow', 'yellow_red', 'red', 'penalties_scored', 'penalties_saved', 'woodwork', 'own_goals', 'joker_goals']
      Match.all.each do |match|
        data_hash = match.data.present? ? JSON.parse(match.data, symbolize_names: true) : nil
        if data_hash.present? && data_hash[:home_id].present? && data_hash[:away_id].present?
          csv << [match.competition.api_id, match.competition.name, match.date_time, data_hash[:home_id], data_hash[:away_id], match.team_1, match.team_2, match.home_color, match.away_color, data_hash[:goals][:all], data_hash[:fouls][:all], data_hash[:yellow][:all], data_hash[:yellow_red][:all], data_hash[:red][:all], data_hash[:penalties_scored][:all], data_hash[:penalties_saved][:all], data_hash[:woodwork][:all], data_hash[:own_goals][:all], data_hash[:joker_goals][:all]]
        else
          csv << [match.competition.api_id, match.competition.name, match.date_time]
        end
      end
    end
  end

  def self.read_colors
    colors = {}
    open('config/colors.json') do |stream|
      colors = JSON.parse(stream.read)
    end
    colors
  end

  def self.update_matches
    Match.where("date_time < ?", start_date).destroy_all
    matches = read_matches
    colors = read_colors
    if matches[:data].present?
      matches[:data].each do |match_json|        
        if (match = Match.find_by(api_id: match_json[:id]))
          home_color = match_json[:colors].present? && match_json[:colors][:localteam].present? && match_json[:colors][:localteam][:color].present? ? match_json[:colors][:localteam][:color] : match.home_color
          away_color = match_json[:colors].present? && match_json[:colors][:visitorteam].present? && match_json[:colors][:visitorteam][:color].present? ? match_json[:colors][:visitorteam][:color] : match.away_color
          match.update(competition: Competition.find_by(api_id: match_json[:league_id]),
                       team_1: match_json[:localTeam][:data][:name],
                       team_2: match_json[:visitorTeam][:data][:name],
                       home_color: home_color,
                       away_color: away_color,
                       date_time: DateTime.strptime(match_json[:time][:starting_at][:date_time], '%Y-%m-%d %H:%M:%S'))
          match.update_status(match_json[:time][:status])
        else
<<<<<<< HEAD
          home_color = match_json[:colors].present? && match_json[:colors][:localteam].present? && match_json[:colors][:localteam][:color].present? ? match_json[:colors][:localteam][:color] : "#AAAAAA"
          away_color = match_json[:colors].present? && match_json[:colors][:visitorteam].present? && match_json[:colors][:visitorteam][:color].present? ? match_json[:colors][:visitorteam][:color] : "#AAAAAA"
          match = Match.create(competition: Competition.find_by(api_id: match_json[:league_id]),
                       team_1: match_json[:localTeam][:data][:name],
                       team_2: match_json[:visitorTeam][:data][:name],
                       api_id: match_json[:id],
                       home_color: home_color,
                       away_color: away_color,
                       date_time: DateTime.strptime(match_json[:time][:starting_at][:date_time], '%Y-%m-%d %H:%M:%S')) if Competition.find_by(api_id: match_json[:league_id])
=======
          if Competition.find_by(api_id: match_json[:league_id])
            home_color = match_json[:colors].present? && match_json[:colors][:localteam].present? && match_json[:colors][:localteam][:color].present? ? match_json[:colors][:localteam][:color] : colors[match_json[:localTeam][:data][:id].to_s].present? ? colors[match_json[:localTeam][:data][:id].to_s] : "#AAAAAA"
            away_color = match_json[:colors].present? && match_json[:colors][:visitorteam].present? && match_json[:colors][:visitorteam][:color].present? ? match_json[:colors][:visitorteam][:color] : colors[match_json[:visitorTeam][:data][:id].to_s].present? ? colors[match_json[:visitorTeam][:data][:id].to_s] : "#AAAAAA"
            match = Match.create(competition: Competition.find_by(api_id: match_json[:league_id]),
                        team_1: match_json[:localTeam][:data][:name],
                        team_2: match_json[:visitorTeam][:data][:name],
                        api_id: match_json[:id],
                        home_color: home_color,
                        away_color: away_color,
                        date_time: DateTime.strptime(match_json[:time][:starting_at][:date_time], '%Y-%m-%d %H:%M:%S'))
            match.update_status(match_json[:time][:status])
          end
>>>>>>> 907f525cf50dc6cbb57a4a5795386335b9ea210a
        end
      end
    end
  end

  def self.update_livescores
    return if Match.count < 1

    live_matches = []
    raw_data = read_events
    raw_data[:data].each do |api_data|
      if (match = Match.find_by(api_id: api_data[:id]))
        match.init_data unless match.data.present?
        data_hash = JSON.parse(match.data, symbolize_names: true)
        home_id = api_data[:localteam_id]
        away_id = api_data[:visitorteam_id]
        data_hash[:home_id] = home_id
        data_hash[:away_id] = away_id
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
        goals_home = 0
        goals_away = 0
        fouls_home = 0
        fouls_away = 0
        yellow_home = 0
        yellow_away = 0
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
            goals_home += player_data[:stats][:goals][:scored].nil? ? 0 : player_data[:stats][:goals][:scored]
            fouls_home += player_data[:stats][:fouls][:committed].nil? ? 0 : player_data[:stats][:fouls][:committed]
            yellow_home += player_data[:stats][:cards][:yellowcards].nil? ? 0 : player_data[:stats][:cards][:yellowcards]
          elsif player_data[:team_id] == away_id
            data_hash[:away_players][:"a#{player_data[:number]}"] = player_data[:player_name]
            data_hash[:goals][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:goals][:scored].nil? ? 0 : player_data[:stats][:goals][:scored]
            if player_data[:type] == 'bench' && data_hash[:goals][:home_players][:"h#{player_data[:number]}"].present?
              joker_goals_away += data_hash[:goals][:away_players][:"a#{player_data[:number]}"]
            end
            data_hash[:assists][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:goals][:assists].nil? ? 0 : player_data[:stats][:goals][:assists]
            data_hash[:fouls][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:fouls][:committed].nil? ? 0 : player_data[:stats][:fouls][:committed]
            data_hash[:fouled][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:fouls][:drawn].nil? ? 0 : player_data[:stats][:fouls][:drawn]
            data_hash[:yellow][:away_players][:"a#{player_data[:number]}"] = player_data[:stats][:cards][:yellowcards].nil? ? 0 : player_data[:stats][:cards][:yellowcards]
            woodwork_away += player_data[:stats][:other][:hit_woodwork].nil? ? 0 : player_data[:stats][:other][:hit_woodwork]
            penalties_scored_away += player_data[:stats][:other][:pen_scored].nil? ? 0 : player_data[:stats][:other][:pen_scored]
            penalties_saved_away += player_data[:stats][:other][:pen_saved].nil? ? 0 : player_data[:stats][:other][:pen_saved]
            own_goals_away += player_data[:stats][:goals][:owngoals].nil? ? 0 : player_data[:stats][:goals][:owngoals]
            goals_away += player_data[:stats][:goals][:scored].nil? ? 0 : player_data[:stats][:goals][:scored]
            fouls_away += player_data[:stats][:fouls][:committed].nil? ? 0 : player_data[:stats][:fouls][:committed]
            yellow_away += player_data[:stats][:cards][:yellowcards].nil? ? 0 : player_data[:stats][:cards][:yellowcards]
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
        data_hash[:goals][:home] = goals_home + own_goals_away
        data_hash[:goals][:away] = goals_away + own_goals_home
        data_hash[:goals][:all] = goals_home + goals_away + own_goals_away + own_goals_home
        data_hash[:fouls][:home] = fouls_home
        data_hash[:fouls][:away] = fouls_away
        data_hash[:fouls][:all] = fouls_home + fouls_away
        data_hash[:fouls][:home] = fouls_home
        data_hash[:fouls][:away] = fouls_away
        data_hash[:fouls][:all] = fouls_home + fouls_away
        data_hash[:yellow][:home] = yellow_home
        data_hash[:yellow][:away] = yellow_away
        data_hash[:yellow][:all] = yellow_home + yellow_away
        api_data[:stats][:data].each do |stats_data|
          if stats_data[:team_id] == home_id
            data_hash[:yellow_red][:home] = stats_data[:yellowredcards].nil? ? 0 : stats_data[:yellowredcards]
            data_hash[:red][:home] = stats_data[:redcards].nil? ? 0 : stats_data[:redcards]
          elsif stats_data[:team_id] == away_id
            data_hash[:yellow_red][:away] = stats_data[:yellowredcards].nil? ? 0 : stats_data[:yellowredcards]
            data_hash[:red][:away] = stats_data[:redcards].nil? ? 0 : stats_data[:redcards]
          end
        end
        data_hash[:yellow_red][:all] = data_hash[:yellow_red][:home] + data_hash[:yellow_red][:away]
        data_hash[:red][:all] = data_hash[:red][:home] + data_hash[:red][:away]
        match.data = data_hash.to_json
        match.save
        match.update_status(api_data[:time][:status])
        live_matches.push(match)
      end
    end
    live_matches
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
    api_url = "https://soccer.sportmonks.com/api/v2.0/livescores?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,events,lineup,bench,stats"
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
    not_started = %w[NS DELAYED]
    ongoing = %w[LIVE HT ET PEN_LIVE BREAK INT ABAN SUSP]
    finished = %w[FT AET FT_PEN CANCL AWARDED WO POSTP Deleted]
    if not_started.include?(status)
      self.status = "not_started"
    elsif ongoing.include?(status)
      self.status = "ongoing"
    elsif finished.include?(status)
      self.status = "finished"
    end
    save
  end

  def init_data
    data_hash = {
      home_id: "",
      away_id: "",
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
