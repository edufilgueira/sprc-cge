module PPA
  module PastWorkshops::BaseBreadcrumbs
    extend ActiveSupport::Concern

    include PPA::BaseBreadcrumbs

    protected

    def index_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('past_workshops.index.title'), '' ],
      ]
    end

    private

    def home_breadcrumb
      [ breadcrumb_key('home.show.title'), url_for([:ppa, :root, only_path: true]) ]
    end

  end
end
