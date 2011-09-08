class DocsController < ApplicationController
  respond_to :html, :md
  
  def search
    @results = Search.docs(params[:query])
  end
end
