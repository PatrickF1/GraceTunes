Audit = Audited.audit_class

class Audit
  scope :today, -> do
    where("created_at >= ?", Time.zone.today.midnight).reorder(:created_at)
  end

  scope :history, -> { reorder("created_at DESC") }

  def create?
    action == "create"
  end

  def destroy?
    action == "destroy"
  end

  def update?
    action == "update"
  end
end