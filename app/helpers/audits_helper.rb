module AuditsHelper

  def audit_action_past_tense(action)
    if action == "destroy"
      "deleted"
    else
      action + "d"
    end
  end
end