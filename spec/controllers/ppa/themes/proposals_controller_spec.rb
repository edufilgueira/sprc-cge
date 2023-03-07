require 'rails_helper'

RSpec.describe PPA::Themes::ProposalsController, type: :controller do

  let(:region)   { create :ppa_region }
  let(:plan)     { create :ppa_plan }
  let(:biennium) { [plan.start_year, (plan.start_year + 1) ].join('-')  }
  let(:axis)     { theme.axis }
  let(:theme)    { create :ppa_theme }
  let(:strategy) { create :ppa_biennial_regional_strategy }


  describe '#index' do
    before { get(:index, params: { theme_id: theme.id, region_code: region.code, biennium: biennium }) }

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:index) }
    end

    it_behaves_like 'region with biennium'
  end

end
