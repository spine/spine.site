module MarkdownTemplate
  class TemplateHandler
    def self.erb_handler
      @@erb_handler ||= ActionView::Template.registered_template_handler(:erb)
    end

    def self.call(template)
      compiled_source = erb_handler.call(template)
      "RDiscount.new(begin;#{compiled_source};end).to_html"
    end
  end

  Mime::Type.register "text/x-markdown", :md

  class ActionController::Responder
    def to_md
      controller.render :md => controller.action_name
    end
  end

  ActionController::Renderers.add :md do |md, options|
    html = RDiscount.new(md).to_html
    self.content_type ||= Mime::HTML
    self.response_body = html
  end

  ActionView::Template.register_template_handler :md, TemplateHandler
end