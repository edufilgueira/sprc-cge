module PPA
  module Axes::BaseBreadcrumbs
    extend ActiveSupport::Concern

    include PPA::BaseBreadcrumbs

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        region_with_biennium_breadcrumb,
      ]
    end

    private

    def home_breadcrumb
      [ breadcrumb_key('home.show.title'), url_for([:ppa, :root, only_path: true]) ]
    end

  end
end
