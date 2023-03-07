require 'rails_helper'

describe Transparency::RealStatesController do

  let(:real_state) { create(:integration_real_states_real_state) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.real_states.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: real_state }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.real_states.index.title'), url: transparency_real_states_path },
        { title: real_state.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

