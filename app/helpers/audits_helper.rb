module AuditsHelper
  AUDIT_ACTION_TO_BOOTSTRAP_CLASS = {
    AuditAction::UPDATE => "warning",
    AuditAction::CREATE => "success",
    AuditAction::DESTROY => "danger"
  }
  private_constant :AUDIT_ACTION_TO_BOOTSTRAP_CLASS

  def filter_empty_audited_changes(audited_changes)
    audited_changes.select { |field, value| value.kind_of?(Array) or !value.blank? }
  end

  def audit_action_past_tense(action)
    if action == AuditAction::DESTROY
      "deleted"
    else
      action + "d"
    end
  end

  def text_class_for_audit_action(audit_action)
    "text-" + AUDIT_ACTION_TO_BOOTSTRAP_CLASS[audit_action]
  end

  def audit_background_for_audit_action(audit_action)
    "bg-" + AUDIT_ACTION_TO_BOOTSTRAP_CLASS[audit_action]
  end

  def set_active_if_action(action)
    "active" if @audit_action_filter == action
  end
end