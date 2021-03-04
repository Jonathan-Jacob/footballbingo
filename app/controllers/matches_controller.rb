class MatchesController < ApplicationController
  def index
    policy_scope(Match)
    @data = Match.read_data
  end
end
