require 'rails_helper'

RSpec.describe PPA::Themes::RegionalStrategiesController, type: :controller do

  let(:region)   { create :ppa_region }
  let(:plan)     { create :ppa_plan }
  let(:biennium) { [plan.start_year, (plan.start_year + 1) ].join('-')  }
  let(:theme)    { create :ppa_theme }
  let(:axis)     { theme.axis }
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

  describe '#show' do
    before { get(:show, params: { theme_id: theme.id, region_code: region.code, biennium: biennium, id: strategy.id }) }

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:show) }
    end

    context 'helper methods' do
      it 'set a regional_strategy' do
        expect(controller.send(:regional_strategy)).to eq strategy
      end
    end

    it_behaves_like 'region with biennium'
  end

  describe '#axis' do
    before { get(:index, params: { theme_id: theme.id, region_code: region.code, biennium: biennium }) }

    it 'retrieves a PPA::Axis' do
      expect(controller.send(:axis)).to eq axis
    end
  end

  describe '#theme' do
    before { get(:index, params: { theme_id: theme.id, region_code: region.code, biennium: biennium }) }

    it 'retrieves a PPA::Theme' do
      expect(controller.send(:theme)).to eq theme
    end
  end

  describe '#proposals' do
    before do
      allow(PPA::Proposal).to receive(:in_biennium_and_region)
      get(:index, params: { theme_id: theme.id, region_code: region.code, biennium: biennium })
      controller.send :proposals
    end

    it 'call .in_biennium_and_region in PPA::Proposal' do
      expect(PPA::Proposal).to have_received(:in_biennium_and_region)
    end
  end

end
