class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.users.include?(@user)
  end

  def create?
    true
  end

  def members?
    record.users.include?(user)
  end
end
