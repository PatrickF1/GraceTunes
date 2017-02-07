module ApplicationHelper
  def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def highlight_if_errors(resource, field_name)
    if resource.errors[field_name].present?
      return "has-error"
    else
      return ""
    end
  end

  def set_active_if_path(path)
    "header_link-active" if current_page?(path)
  end
end
