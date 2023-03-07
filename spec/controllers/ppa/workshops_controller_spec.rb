require 'rails_helper'

RSpec.describe PPA::WorkshopsController, type: :controller do

  let!(:workshop) { create :ppa_workshop }

  describe '#index' do
    before { create :ppa_city }

    subject(:get_index) { get(:index) }

    context 'template' do
      render_views

      it { expect(response).to be_success }
      it { is_expected.to render_template('layouts/ppa/application') }
      it { is_expected.to render_template(:index) }
    end

    context 'start_at search' do
      let(:date) { '01/10/2018' }

      before do
        allow(PPA::Workshop).to receive(:starting_at)
        get :index, params: { start_at: date }
        controller.send :filtered_workshops
      end

      it 'pass it to .starting_at method' do
        expect(PPA::Workshop).to have_received(:starting_at).with(date)
      end
    end

    context 'city_id search' do
      context 'when city_id is present' do
        let(:city_id) { '99' }

        before do
          allow(PPA::Workshop).to receive(:in_city)
          get :index, params: { city_id: city_id }
          controller.send :filtered_workshops
        end

        it 'pass it to .in_city method' do
          expect(PPA::Workshop).to have_received(:in_city).with(city_id)
        end
      end

      context 'when city_id is blank' do
        before do
          allow(PPA::Workshop).to receive(:in_city)
          get :index
          controller.send :filtered_workshops
        end

        it 'dont call .in_city' do
          expect(PPA::Workshop).to_not have_received(:in_city)
        end
      end
    end
  end

  describe 'pagination' do
    before do
      allow(PPA::Workshop).to receive(:page).and_call_original
      controller.send :workshops
    end

    it 'calls kaminari methods' do
      expect(PPA::Workshop).to have_received(:page).at_least(:once)
    end
  end

  describe '#workshops' do
    let(:workshops) { [ workshop ] }

    it 'assign existing workshops' do
      expect(controller.send(:workshops)).to eq workshops
    end
  end

end
