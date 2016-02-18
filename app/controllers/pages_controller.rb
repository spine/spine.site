class PagesController < ApplicationController
  def download
    download_url = "https://github.com/spine/spine/archive/v.#{version}.zip"
    redirect_to download_url
  end
end
