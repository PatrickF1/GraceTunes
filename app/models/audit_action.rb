class AuditAction
  UPDATE = "update"
  CREATE = "create"
  DESTROY  = "destroy"

  ALL = [READER, CREATE, DESTROY].freeze
end