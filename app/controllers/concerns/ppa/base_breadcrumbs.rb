require_dependency 'ppa/scoped_link_helper'

module PPA
  module BaseBreadcrumbs
    include ScopedLinkHelper

    private

    def home_breadcrumb
      [ breadcrumb_key('home.show.title'), url_for([:ppa, :root, only_path: true]) ]
    end

    def region_with_biennium_breadcrumb
      text = breadcrumb_key('region_with_biennium',
                            region: current_region.name,
                            biennium: current_biennium.to_s)

      [ text, ppa_scoped_path(:axes) ]
    end

    def breadcrumb_key(key, *args)
      t("ppa.breadcrumbs.#{key}", *args)
    end

  end
end
