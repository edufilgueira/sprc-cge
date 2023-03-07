require 'rails_helper'

describe Transparency::Tickets::StatsTicketsController do

  let(:stats_ticket) { create(:stats_ticket) }

  describe '#index' do

    context 'public' do

      context 'template' do
        before { get(:index) }
        render_views

        it { is_expected.to respond_with(:success) }
      end

      context 'helper method' do

        it 'filter default' do
          get(:index)

          expect(controller.filters[:month_start]).to eq(Date.today.beginning_of_year.month)
          expect(controller.filters[:month_end]).to eq(Date.today.month)
          expect(controller.filters[:year]).to eq(Date.today.year)
        end

        it 'filter params' do
          get(:index , params: {  month_start: 1, month_end: 2, year: 2017 })

          expect(controller.filters[:month_start]).to eq('1')
          expect(controller.filters[:month_end]).to eq('2')
          expect(controller.filters[:year]).to eq('2017')
        end
      end
    end

    describe 'helpers' do

      it 'title' do
        expect(controller.title).to eq(I18n.t('shared.reports.stats_tickets.index.title'))
      end

      context 'returns last stats_ticket by scope' do
        let(:month_start) { Date.today.month }
        let(:month_end) { Date.today.month }
        let(:year) {  Date.today.year }

        let!(:stats_ticket_sou) { create(:stats_ticket, ticket_type: :sou, month_start: month_start, month_end: month_end, year: year) }
        let!(:stats_ticket_sic) { create(:stats_ticket, ticket_type: :sic, month_start: month_start, month_end: month_end, year: year) }

        before { get(:index , params: { month_start: month_start, month_end: month_end, year: year }) }

        it { expect(controller.current_stats_ticket(:sou)).to eq(stats_ticket_sou) }
        it { expect(controller.current_stats_ticket(:sic)).to eq(stats_ticket_sic) }
      end

      context 'returns created stats_ticket by scope' do
        let(:last_stats_ticket_sou) { Stats::Ticket.find_by(ticket_type: :sou) }
        let(:last_stats_ticket_sic) { Stats::Ticket.find_by(ticket_type: :sic) }

        it { expect(controller.current_stats_ticket(:sou)).to eq(last_stats_ticket_sou) }
        it { expect(controller.current_stats_ticket(:sic)).to eq(last_stats_ticket_sic) }
      end

      it 'use filter' do
        stats_ticket = create(:stats_ticket, ticket_type: :sou, month_start: 4, month_end: 4, year: 2016)

        get(:index , params: { month_start: 4, month_end: 4, year: 2016 })

        expect(controller.current_stats_ticket(:sou)).to eq(stats_ticket)
      end

      describe 'stats_tabs' do

        it 'tabs for sic operator' do
          allow_any_instance_of(User).to receive(:sic_operator?).and_return(true)

          expected = [:sic, :sou]

          get(:index)

          expect(controller.stats_tabs).to eq(expected)
        end

        it 'tabs for sou operator' do
          allow_any_instance_of(User).to receive(:sou_operator?).and_return(true)

          # não muda na área de tansparencia
          expected = [:sic, :sou]

          get(:index)

          expect(controller.stats_tabs).to eq(expected)
        end

        it 'default' do
          allow_any_instance_of(User).to receive(:sic_operator?).and_return(false)
          allow_any_instance_of(User).to receive(:sou_operator?).and_return(false)

          expected = [:sic, :sou]

          get(:index)

          expect(controller.stats_tabs).to eq(expected)
        end
      end
    end
  end

  describe '#show' do

    let(:params) { { id: stats_ticket.id } }

    context 'public' do
      render_views
      before { get(:show, params: { id: stats_ticket })  }

      context 'render template' do
        it { is_expected.to render_template('transparency/tickets/stats_tickets/show') }
        it { is_expected.to render_template('transparency/tickets/stats_tickets/show') }
      end

      describe 'helper methods' do
        it 'stats_ticket' do
          expect(controller.stats_ticket).to eq(stats_ticket)
        end
      end
    end
  end

end
