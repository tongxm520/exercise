class CustomerPolicy < ApplicationPolicy
  def show?
    return true
  end

  def create?
    return true
  end

  def update?
    return true if customer.admin?
    return true if record.id == customer.id
  end

  def destroy?
    return true if customer.admin?
    return true if record.id == customer.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end


