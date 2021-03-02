class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.users_groups.any? { |users_group| users_group.user == current_user }
  end

  def add_user?
    record.user == current_user?
  end

  def new?
    create?
  end

  def create?
    true
  end
end
