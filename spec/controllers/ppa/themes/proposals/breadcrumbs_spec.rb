require 'rails_helper'

describe PPA::Themes::ProposalsController, type: :controller do
  let(:region)   { create :ppa_region }
  let(:theme)    { create :ppa_theme }
  let!(:axis)    { theme.axis }
  let(:biennium) { '2010-2011' }

  context 'index' do
    before { get :index, params: { biennium: biennium, region_code: region.code , theme_id: theme.id} }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.breadcrumbs.home.show.title'), url: ppa_root_path },
        {
          title: I18n.t('ppa.breadcrumbs.region_with_biennium', biennium: biennium, region: region.name),
          url: ppa_scoped_axes_path(biennium, region.code)
        },
        { title: axis.name, url: ppa_scoped_axes_path(biennium, region.code) },
        { title: theme.name, url: ppa_scoped_theme_proposals_path(biennium, region.code, theme) }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
