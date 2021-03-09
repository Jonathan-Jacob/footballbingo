class MatchEvent < ApplicationRecord
  belongs_to :match
  has_many :bingo_tiles, dependent: :destroy

  require 'json'

  def self.generate(match)
    %w[all home away].each do |agent|
      %w[goals fouls yellow yellow_red red penalties_scored penalties_saved woodwork own_goals joker_goals].each do |action|
        m = MatchEvent.new(match: match, agent: agent, action: action, amount: 1, status: 'unchecked')
        m.describe_event
        p m.description
        m.save
      end
      %w[goals fouls yellow].each do |action|
        [2, 3].each do |amount|
          m = MatchEvent.new(match: match, agent: agent, action: action, amount: amount, status: 'unchecked')
          m.describe_event
          p m.description
          m.save
        end
      end
    end
    %w[goals fouls yellow].each do |action|
      [4, 5].each do |amount|
        m = MatchEvent.new(match: match, agent: 'all', action: action, amount: amount, status: 'unchecked')
        m.describe_event
        p m.description
        m.save
      end
    end
    # if match.data.present?

    # else

    # end
  end

  def self.update(match)
    data_hash = JSON.parse(match.data, symbolize_names: true)
    revert_action = false;
    match.match_events.each do |match_event|
      if %w[all home away].include?(match_event.agent)
        if data_hash[match_event.action].present? && data_hash[match_event.action][match_event.agent].present? && data_hash[match_event.action][match_event.agent] >= match_event.amount
          match_event.status = "happened"
        elsif data_hash[match_event.action].present? && data_hash[match_event.action][match_event.agent].present? && data_hash[match_event.action][match_event.agent] < match_event.amount
          match_event.status = "not_happened"
        end
      else
        if match.event.agent.present? && match.event.agent[0] == "h"
          if data_hash[match_event.action].present? && data_hash[match_event.action][:home_players].present? && data_hash[match_event.action][:home_players][match_event.agent].present? && data_hash[match_event.action][:home_players][match_event.agent] >= match_event.amount
            match_event.status = "happened"
          elsif data_hash[match_event.action].present? && data_hash[match_event.action][:home_players].present? && data_hash[match_event.action][:home_players][match_event.agent].present? && data_hash[match_event.action][:home_players][match_event.agent] < match_event.amount
            match_event.status = "not_happened"
          end
        elsif match.event.agent.present? && match.event.agent[0] == "a"
          if data_hash[match_event.action].present? && data_hash[match_event.action][:away_players].present? && data_hash[match_event.action][:away_players][match_event.agent].present? && data_hash[match_event.action][:away_players][match_event.agent] >= match_event.amount
            match_event.status = "happened"
          elsif data_hash[match_event.action].present? && data_hash[match_event.action][:away_players].present? && data_hash[match_event.action][:away_players][match_event.agent].present? && data_hash[match_event.action][:away_players][match_event.agent] < match_event.amount
            match_event.status = "not_happened"
          end
        end
      end
      match_event.save
      match_event.bingo_tiles.each do |bingo_tile|
        revert_action = true if bingo_tile.update == "reverted"
      end
    end
    revert_action
  end

  def describe_event
    self.description = ''
    if amount == 1
      case action
      when 'goals' then description << 'goal'
      when 'fouls' then description << 'foul'
      when 'yellow' then description << 'yellow card'
      when 'yellow_red' then description << 'second yellow card'
      when 'red' then description << 'red card'
      when 'penalties_scored' then description << 'penalty goal'
      when 'penalties_saved' then description << 'penalty saved'
      when 'woodwork' then description << 'woodwork hit'
      when 'own_goals' then description << 'own goal'
      when 'joker_goals' then description << 'joker goal'
      end
    else
      case action
      when 'goals' then description << amount.to_s << ' goals'
      when 'fouls' then description << amount.to_s << ' fouls'
      when 'yellow' then description << amount.to_s << ' yellow cards'
      end
    end
    case agent
    when 'home' then description << (%w[fouls penalties_saved].include?(action) ? ' by' : ' for') << ' ' << match.team_1
    when 'away' then description << (%w[fouls penalties_saved].include?(action) ? ' by' : ' for') << ' ' << match.team_2
    end
  end
end
