require 'rails_helper'

RSpec.describe PPA::Themes::RegionalStrategies::RegionalInitiativesController, type: :controller do

  let(:region)     { create :ppa_region }
  let(:plan)       { create :ppa_plan }
  let(:biennium)   { [plan.start_year, (plan.start_year + 1) ].join('-')  }
  let(:theme)      { create :ppa_theme }
  let(:axis)       { theme.axis }
  let(:strategy)   { create :ppa_biennial_regional_strategy, region: region }
  let(:initiative) { create :ppa_biennial_regional_initiative }

  before do
    # too many associations, so we mock them
    allow_any_instance_of(PPA::Theme)
      .to receive_message_chain(:biennial_regional_strategies, :in_biennium_and_region, :find)
      .and_return(strategy)

    allow(strategy)
      .to receive_message_chain(:initiatives, :find)
      .and_return(initiative)
  end

  describe '#show' do
    before { send_show_request }

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:show) }
    end

    it_behaves_like 'region with biennium'
  end

  describe '#axis' do
    before { send_show_request }

    it { expect(controller.send(:axis)).to eq axis }
  end

  describe '#theme' do
    before { send_show_request }

    it { expect(controller.send(:theme)).to eq theme }
  end

  describe '#regional_strategy' do
    before { send_show_request }

    it { expect(controller.send(:regional_strategy)).to eq strategy }
  end

  describe '#regional_initiative' do
    before { send_show_request }

    it { expect(controller.send(:regional_initiative)).to eq initiative }
  end

  def send_show_request
    get :show,
      params: { biennium: biennium,
                region_code: region.code,
                theme_id: theme.id,
                regional_strategy_id: strategy.id,
                id: initiative.id }
  end

end
