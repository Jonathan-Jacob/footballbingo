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
    record.group.user_groups.any? { |user_group| user_group.user == @user }
  end

  def join_game?
    record.group.user_groups.any? { |user_group| user_group.user == @user }
  end

  def show?
    record.group.user_groups.any? { |user_group| user_group.user == @user }
  end
end
