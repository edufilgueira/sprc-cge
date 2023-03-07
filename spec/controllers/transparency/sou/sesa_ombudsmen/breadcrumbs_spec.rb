require 'rails_helper'

describe Transparency::Sou::SesaOmbudsmenController do

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: root_path },
        { title: I18n.t('transparency.sou.home.index.title'), url: transparency_sou_path },
        { title: I18n.t('transparency.sou.sesa_ombudsmen.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
