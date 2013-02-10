class PagesController < ApplicationController
  def download
    download_url = "https://github.com/spine/spine/zipball/v#{version}"
    redirect_to download_url
  end
end
