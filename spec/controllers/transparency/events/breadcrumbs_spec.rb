require 'rails_helper'

describe Transparency::EventsController do

  let(:event) { create(:event) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.events.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: event }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.events.index.title'), url: transparency_events_path },
        { title: event.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
