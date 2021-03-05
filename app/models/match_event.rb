class MatchEvent < ApplicationRecord
  belongs_to :match
  has_many :bingo_tiles

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
          m = MatchEvent.new(match: match,  agent: agent, action: action, amount: amount, status: 'unchecked')
          m.describe_event
          p m.description
          m.save
        end
      end
    end
    %w[goals fouls yellow].each do |action|
      [4, 5].each do |amount|
        m = MatchEvent.new(match: match,  agent: 'all', action: action, amount: amount, status: 'unchecked')
        m.describe_event
        p m.description
        m.save
      end
    end
    # if match.data.present?

    # else

    # end
  end

  def describe_event
    self.description = ''
    if amount == 1
      case action
        when 'goals' then self.description << 'goal'
        when 'fouls' then self.description << 'foul'
        when 'yellow' then self.description << 'yellow card'
        when 'yellow_red' then self.description << 'second yellow card'
        when 'red' then self.description << 'red card'
        when 'penalties_scored' then self.description << 'penalty goal'
        when 'penalties_saved' then self.description << 'penalty saved'
        when 'woodwork' then self.description << 'woodwork hit'
        when 'own_goals' then self.description << 'own goal'
        when 'joker_goals' then self.description << 'joker goal'
      end
    else
      case action
        when 'goals' then self.description << amount.to_s << ' goals'
        when 'fouls' then self.description << amount.to_s << ' fouls'
        when 'yellow' then self.description << amount.to_s << ' yellow cards'
      end
    end
    case agent
      when 'home' then self.description << (%w[fouls penalties_saved].include?(action) ? ' by' : ' for') << ' ' << match.team_1
      when 'away' then self.description << (%w[fouls penalties_saved].include?(action) ? ' by' : ' for') << ' ' << match.team_2
    end
  end
end
