class ApiController < ApplicationController
  respond_to :html, :md
  
  def search
    @results = Search.api(params[:query])
  end
end
