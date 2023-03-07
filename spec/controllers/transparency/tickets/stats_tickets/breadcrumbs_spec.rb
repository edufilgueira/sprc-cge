require 'rails_helper'

describe Transparency::Tickets::StatsTicketsController do

  let(:stats_ticket) { create(:stats_ticket) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.tickets.stats_tickets.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: stats_ticket }) }

    it 'breadcrumbs' do

      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.tickets.stats_tickets.index.title'), url: transparency_tickets_stats_tickets_path },
        { title: I18n.t('transparency.tickets.stats_tickets.show.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

