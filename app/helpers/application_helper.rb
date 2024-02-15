# frozen_string_literal: true

module ApplicationHelper
  def set_page_title(page_title)
    content_for :title, page_title
  end

  def get_page_title
    [content_for(:title), 'GraceTunes'].compact.join(" | ")
  end

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
      "has-error"
    else
      ""
    end
  end

  def set_active_if_path(path)
    "header_link-active" if current_page?(path)
  end
end
