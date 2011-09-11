class ApiController < ApplicationController
  respond_to :html, :md
  
  def search
    @query   = params[:query]
    @results = Search.api(@query)
  end
end
