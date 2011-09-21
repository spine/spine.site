class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
    def version
      Rails.config.version
    end
  
    helper_method :version
end
