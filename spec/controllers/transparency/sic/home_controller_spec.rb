require 'rails_helper'

describe Transparency::Sic::HomeController do

  let(:stats_params) do
    {
      ticket_type: :sic,
      year: Date.today.year,
      month_start: 1,
      month_end: Date.today.month,
      data: { summary: { completed: { count: 1 }, average_time_answer: 1, resolubility: 1 } }
    }
  end

  let(:page) { create(:page) }
  let(:sic_stat) { create(:stats_ticket, stats_params) }

  before do
    page
    sic_stat
  end

  describe '#index' do
    context 'authorized' do
      before { get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end
    end
  end
end
