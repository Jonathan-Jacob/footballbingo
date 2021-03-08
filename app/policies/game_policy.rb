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
    record.group.users.include?(@user)
  end

  def join_game?
    record.group.users.include?(@user)
  end

  def show?
    record.group.users.include?(@user)
  end
end
