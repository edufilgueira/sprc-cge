require 'rails_helper'

describe Transparency::HomeController do

  let!(:page) { create(:page) }

  describe '#index' do

    context 'authorized' do
      before { get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        it 'pages' do
          expect(controller.pages).to eq([page])
        end

        describe 'daes' do
          let!(:daes) do
            create_list(:integration_constructions_dae, 6, latitude: 1, longitude: 1)
          end

          let!(:another) do
            create(:integration_constructions_dae, latitude: nil, longitude: nil)
          end

          let(:expected) do
            Integration::Constructions::Dae.where(id: daes)
              .order(:data_fim_previsto)
          end

          before { get :index }

          it { expect(controller.daes).to match_array expected }
        end
      end
    end
  end
end
