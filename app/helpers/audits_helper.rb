module AuditsHelper

  def audit_action_past_tense(action)
    if action == "destroy"
      "deleted"
    else
      action + "d"
    end
  end

  def text_class_for_audit_action(audit_action)
    {
      create: 'text-success',
      destroy: 'text-danger',
      update: 'text-warning'
    }[audit_action.to_sym]
  end

  def audit_background_for_audit_action(audit_action)
    {
      create: 'bg-success',
      destroy: 'bg-danger',
      update: 'bg-warning',
    }[audit_action.to_sym]
  end
end