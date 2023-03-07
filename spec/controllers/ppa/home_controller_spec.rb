require 'rails_helper'

RSpec.describe PPA::HomeController, type: :controller do

  describe '#show' do
    let!(:ppa) { create(:ppa_plan) }
    let!(:ppa) { create(:ppa_workshop) }
    let!(:ppa_city) { create(:ppa_city) }
    let!(:ppa_region) { create(:ppa_region) }

    subject(:get_show) { get(:show) }

    context 'template' do
      render_views

      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:show) }
    end

    describe 'helper_methods' do
      it { expect(controller.regions).to eq PPA::Region.all }
      it { expect(controller.cities).to eq PPA::City.all }

      describe 'last_workshop' do
        let!(:workshops) { spy :ppa_workshop, finished_until: '' }
        let!(:current_workshops) { spy :ppa_workshop, first: '' }
        let(:date) { Date.yesterday.to_s }

        before do
          allow(controller).to receive_message_chain(:current_plan, :workshops) { workshops }
          allow(workshops).to receive(:finished_until).with(date) { current_workshops }
          allow(current_workshops).to receive(:first)

          controller.last_workshop
        end

        it { expect(workshops).to have_received(:finished_until).with(date) }
        it { expect(current_workshops).to have_received(:first) }

      end
    end
  end

end
