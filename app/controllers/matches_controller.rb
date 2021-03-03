class MatchesController < ApplicationController
  def index
    policy_scope(UserGroup)
    @data = Match.read_matches
  end
end
