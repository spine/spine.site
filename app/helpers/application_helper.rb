module ApplicationHelper
  def css_scope
    result = []
    result << params[:controller]
    result << params[:controller] + '-' + params[:action]
    result.map(&:dasherize).join(' ')
  end
  
  def error_messages(instance)
    return if !instance or instance.errors.blank?
    content_tag(:div, {:class => "errors"}) do
      content_tag(:ul, {}) do
        instance.errors.full_messages.collect do |msg|
          content_tag(:li, msg)
        end.join("").html_safe
      end        
    end
  end
  
  def flash_message
    flash.map do |key, value|
      content_tag(:div, value, :class => "flash #{key}") if value.present?
    end.join("").html_safe
  end
  
  def title(name)
    content_for(:title) { name }
  end
end
