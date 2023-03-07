class HomeController < ApplicationController
  def index
  end

  def privacy_policy
  end

  def terms_of_use
  end

  def site_map
    render 'home/site_map/index'
  end
end
