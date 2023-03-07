require 'rails_helper'

describe Transparency::Tickets::StatsEvaluationsController do
  let(:stats_evaluation) { create(:stats_evaluation) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.tickets.stats_evaluations.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
