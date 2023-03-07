module PPA
  module Proposals::BaseBreadcrumbs
    extend ActiveSupport::Concern

    include PPA::BaseBreadcrumbs

    protected

    def new_create_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('proposals.new.title'), '' ]
      ]
    end

    def show_edit_update_breadcrumbs
      [
        home_breadcrumb,
        [ breadcrumb_key('proposals.index.title'), ppa_root_path ],
        [ breadcrumb_key('proposals.show.title'), '' ]
      ]
    end


  end
end
