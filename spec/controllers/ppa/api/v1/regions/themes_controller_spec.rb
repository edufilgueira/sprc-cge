require 'rails_helper'

RSpec.describe PPA::Api::V1::Regions::ThemesController, type: :controller do

  let!(:plan)     { create :ppa_plan }
  let!(:biennium) { plan.bienniums.first }
  let!(:region)   { create :ppa_region }

  let(:base_params) { { region_id: region.id } }

  context '#index' do
    let(:params) { {} }
    subject(:get_index) { get :index, params: base_params.merge(params) }
    subject(:json) do
      get_index
      JSON.parse response.body
    end

    context 'when there are no themes for the given region' do
      it 'responds with an empty array' do
        expect(json).to eq []
      end
    end

    context 'when there are themes for the given region' do
      let!(:themes_with_objectives) do
        create_list(:ppa_theme, 2) do |theme|
          objective = create :ppa_objective, themes: [theme]
          strategy  = create :ppa_strategy, objective: objective

          create :ppa_biennial_regional_strategy,
            biennium: biennium, strategy: strategy, region: region
        end
      end

      let!(:themes_without_objectives) do
        create_list(:ppa_theme, 1) do |theme|
          objective = create :ppa_objective, themes: [theme]
          strategy  = create :ppa_strategy, objective: objective

          # but without biennial regional strategies relating them to the biennium!
        end
      end

      it 'returns thems with objectives on current plan for the region' do
        expect(json).to match_array themes_with_objectives.map { |t| t.as_json(only: %i[id name]) }
      end
    end
  end

end
