module AuditsHelper

  def audit_action_past_tense(action)
    if action == "destroy"
      "deleted"
    end
    action + "d"
  end
end