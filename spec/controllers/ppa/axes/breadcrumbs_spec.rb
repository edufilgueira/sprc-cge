require 'rails_helper'

describe PPA::AxesController do
  let(:region)   { create :ppa_region }
  let(:biennium) { '2010-2011' }

  context 'index' do
    before { get :index, params: { biennium: biennium, region_code: region.code } }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.breadcrumbs.home.show.title'), url: ppa_root_path },
        {
          title: I18n.t('ppa.breadcrumbs.region_with_biennium', biennium: biennium, region: region.name),
          url: ppa_scoped_axes_path(biennium, region.code)
        }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
