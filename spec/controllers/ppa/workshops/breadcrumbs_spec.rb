require 'rails_helper'

describe PPA::WorkshopsController do
  let(:workshop) { create :ppa_workshop }

  context 'index' do
    before { get :index }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.breadcrumbs.home.show.title'), url: ppa_root_path },
        { title: I18n.t('ppa.breadcrumbs.workshops.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end
