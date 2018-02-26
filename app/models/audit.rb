Audit = Audited.audit_class

class Audit
  scope :today, -> do
    where("created_at >= ?", Time.zone.today.midnight).reorder(:created_at)
  end

  scope :history, -> { reorder("created_at DESC") }
end