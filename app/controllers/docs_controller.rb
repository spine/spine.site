class DocsController < ApplicationController  
  def search
    @query   = params[:query]
    @results = Search.docs(@query)
  end
end
