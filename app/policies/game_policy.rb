class GamePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    create?
  end

  def create?
    record.group.users_groups.any? { |users_group| users_group.user == current_user }
  end

  def join_game?
    record.group.users_groups.any? { |users_group| users_group.user == current_user }
  end

  def show?
    true
    # record.bingo_cards.any? { |bingo_card| bingo_card.user == current_user }
  end
end
