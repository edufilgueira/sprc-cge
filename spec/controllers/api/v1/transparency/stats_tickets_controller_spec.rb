require 'rails_helper'

describe Api::V1::Transparency::StatsTicketsController do

  let(:stats_ticket) { create(:stats_ticket) }
  let(:permitted_params) do
    [
      :ticket_type,
      :month_start,
      :month_end,
      :year
    ]
  end

  describe '#status' do
    let(:params) { { id: stats_ticket.id } }

    describe 'render' do
      before { get :status, xhr: true, params: params }

      let(:data) { response.body }
      let(:expected) do
        Stats::Ticket.find(params[:id]).to_json(only: [:status])
      end

      it { expect(data).to eq expected }
    end

    describe 'template' do
      before { get :status, xhr: true, params: params }

      it { is_expected.to respond_with :success }
    end
  end
end
