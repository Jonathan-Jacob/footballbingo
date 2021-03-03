class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.user_groups.any? { |user_group| user_group.user == @user }
  end

  def create?
    true
  end
end
