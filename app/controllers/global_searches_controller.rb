class GlobalSearchesController < ApplicationController

  layout false

  helper_method [:results]

  def index
    @results = GlobalSearcher.call(params[:search_group], params[:search_term])
  end

  private

  def results
    @results
  end
end
