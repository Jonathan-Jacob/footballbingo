class MatchesController < ApplicationController
  def index
    policy_scope(Match)
    @data = Match.read_json
  end
end
