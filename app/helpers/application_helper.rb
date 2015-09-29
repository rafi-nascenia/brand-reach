module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-error"
      when "alert"
        "alert-block"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def current_path(path)
    "current" if current_page?(path)
  end

end
