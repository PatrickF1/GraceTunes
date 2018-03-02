module AuditsHelper
  AUDIT_ACTION_TO_BOOTSTRAP_CLASS = {
    "create" => "success",
    "destroy" => "danger",
    "update" => "warning"
  }
  private_constant :AUDIT_ACTION_TO_BOOTSTRAP_CLASS

  def audit_action_past_tense(action)
    if action == "destroy"
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
end