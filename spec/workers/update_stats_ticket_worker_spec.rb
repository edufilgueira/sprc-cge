require 'rails_helper'
require 'sidekiq/testing'

describe UpdateStatsTicketWorker do

  describe 'perform' do
    let(:ticket_type) { :sou }
    let(:current_stats) { Stats::Ticket.find_or_create_by(ticket_type: ticket_type, year: Date.today.year, month_start: 1, month_end: Date.today.month) }

    let(:service) { UpdateStatsTicketWorker.new }

    before { allow(UpdateStatsTicket).to receive(:call) }

    it 'create new stats' do
      expect { service.perform(ticket_type) }.to change(Stats::Ticket, :count).by(1)
    end

    it 'update existent stats' do
      current_stats
      expect { service.perform(ticket_type) }.to change(Stats::Ticket, :count).by(0)
    end

    it 'call service' do
      service.perform(ticket_type)
      expect(UpdateStatsTicket).to have_received(:call).with(current_stats.id)
    end

    context 'sectoral operator' do
      let(:current_stats) { create(:stats_ticket, :sectoral) }
      it 'call service' do
        service.perform(current_stats.ticket_type, current_stats.year, current_stats.month_start, current_stats.month_end, current_stats.organ_id, current_stats.subnet_id)
        expect(UpdateStatsTicket).to have_received(:call).with(current_stats.id)
      end
    end

    context 'optional args' do
      let(:year) { 1999 }
      let(:month_start) { 3 }
      let(:month_end) { 7 }
      let(:current_stats) { Stats::Ticket.find_or_create_by(ticket_type: ticket_type, year: year, month_start: month_start, month_end: month_end) }

      before { service.perform(ticket_type, year, month_start, month_end) }

      it { expect(UpdateStatsTicket).to have_received(:call).with(current_stats.id) }
    end
  end

  describe 'background job' do
    describe 'when UpdateStatsTicketWorker perform_async is called' do

      it 'date present' do
        expect do
          UpdateStatsTicketWorker.perform_async(1)
        end.to change(UpdateStatsTicketWorker.jobs, :size).by(1)
        expect(Sidekiq::Queues['low'].size).to_not be_blank
      end

      it 'date blank' do
        expect do
          UpdateStatsTicketWorker.perform_async(1)
        end.to change(UpdateStatsTicketWorker.jobs, :size).by(1)
        expect(Sidekiq::Queues['low'].size).to_not be_blank
      end
    end
  end
end
