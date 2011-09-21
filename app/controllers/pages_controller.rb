class PagesController < ApplicationController
  def download
    download_url = "https://github.com/maccman/spine/zipball/#{version}"
    redirect_to download_url
  end
end
