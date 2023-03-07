require 'rails_helper'

RSpec.describe Transparency::Sou::ExecutiveOmbudsmenController, type: :controller do

  describe 'index' do

    before { get(:index) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
    end
  end

  it_behaves_like 'controllers/base/index' do
    let(:resources) { create_list(:executive_ombudsman, 1) }

    let(:executive_ombudsman) { resources.first }

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
  end

  describe 'executive ombudsmen' do
    before do
      create(:executive_ombudsman, :arce)
      create(:executive_ombudsman)
      create(:sesa_ombudsman)

      get :index, params: { search: '' }
    end

    let(:expected) { ExecutiveOmbudsman.order(:title) }

    it { expect(controller.executive_ombudsmen).to match_array(expected) }

    it 'returns array ordered by title' do
      expect(controller.executive_ombudsmen.pluck(:title)).to eq(expected.pluck(:title))
    end
  end
end
