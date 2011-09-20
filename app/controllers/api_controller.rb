class ApiController < ApplicationController
  def search
    @query   = params[:query]
    @results = Search.api(@query)
  end
end
