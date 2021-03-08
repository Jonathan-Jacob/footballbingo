class BingoCardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.user == current_user
  end

  def create?
    record.user == current_user
  end
end
