class DocsController < ApplicationController
  respond_to :html, :md
  
  def search
    @query   = params[:query]
    @results = Search.docs(@query)
  end
end
