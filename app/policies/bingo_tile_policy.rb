class BingoTilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.bingo_card.user == @user
  end

  def update?
    record.bingo_card.user == @user
  end
end
