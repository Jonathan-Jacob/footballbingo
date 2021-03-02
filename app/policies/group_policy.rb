class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
    # record.user_groups.any? { |user_group| user_group.user == current_user }
  end

  def create?
    true
  end
end
