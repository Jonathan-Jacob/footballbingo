class MatchesController < ApplicationController
  def index
    policy_scope(Match)
    @data = Match.read_matches
  end
end
