class AuditAction
  UPDATE = "update"
  CREATE = "create"
  DESTROY  = "destroy"

  ALL = [READER, CREATE, DESTROY].freeze

  def self.valid_action?(action)
    ALL.includes?(action.to_s)
  end
end