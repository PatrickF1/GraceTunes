# frozen_string_literal: true

class AuditAction
  UPDATE = "update"
  CREATE = "create"
  DESTROY  = "destroy"

  ALL = [UPDATE, CREATE, DESTROY].freeze

  def self.valid_action?(action)
    ALL.include?(action.to_s)
  end
end
