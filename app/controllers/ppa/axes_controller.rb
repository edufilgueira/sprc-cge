class PPA::AxesController < PPAController
  include PPA::Axes::BaseBreadcrumbs
  include PPA::RegionWithBiennium

  def index
  end

  helper_method :axes

  private

  def axes
    PPA::Search::ThemesGroupedByAxis.new(params[:search]).records
  end

end
