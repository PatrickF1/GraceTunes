module AuditsHelper
  AUDIT_ACTION_TO_BOOTSTRAP_CLASS = {
    Audit::UPDATE => "warning",
    Audit::CREATE => "success",
    Audit::DESTROY => "danger"
  }
  AUDIT_ACTION_TO_PLURAL_NOUN = {
    Audit::UPDATE => "updates",
    Audit::CREATE => "creations",
    Audit::DESTROY => "deletions"
  }
  private_constant :AUDIT_ACTION_TO_BOOTSTRAP_CLASS

  def get_action_opts(selected, include_any = false)
    options = Audit::VALID_ACTIONS.map { |action| [AUDIT_ACTION_TO_PLURAL_NOUN[action], action] }
    options.insert(0, ['All', '']) if include_any
    options_for_select(options, selected: selected)
  end

  def audit_action_past_tense(action)
    if action == Audit::DESTROY
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