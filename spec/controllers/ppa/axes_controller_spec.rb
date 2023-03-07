require 'rails_helper'

RSpec.describe PPA::AxesController, type: :controller do

  let(:region)   { create :ppa_region }
  let(:plan)     { create :ppa_plan }
  let(:biennium) { [plan.start_year, (plan.start_year + 1) ]  }

  describe '#index' do
    before { get(:index, params: { region_code: region.code, biennium: biennium.join('-') }) }

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:index) }
    end

    it_behaves_like 'region with biennium'
  end

  describe '#axes' do
    before do
      allow(PPA::Search::ThemesGroupedByAxis).to receive(:new).and_return(double(records: []))
      controller.send :axes
    end

    it 'delegate to PPA::Search::ThemesGroupedByAxis' do
      expect(PPA::Search::ThemesGroupedByAxis).to have_received(:new)
    end
  end

end
