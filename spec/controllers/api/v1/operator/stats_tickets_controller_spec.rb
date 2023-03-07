require 'rails_helper'

describe Api::V1::Operator::StatsTicketsController do

  let(:operator_cge) { create(:user, :operator_cge) }
  let(:stats_ticket) { create(:stats_ticket) }
  let(:permitted_params) do
    [
      :ticket_type,
      :month_start,
      :month_end,
      :year,
      :organ_id,
      :subnet_id
    ]
  end


  describe '#status' do
    before { sign_in(operator_cge) }

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

  describe '#create' do

    let(:valid_stats_ticket) { attributes_for(:stats_ticket) }
    let(:params) do
      { stats_ticket: valid_stats_ticket }
    end

    describe 'unauthorized' do
      before { post(:create, params: params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    describe 'authorized' do
      before { sign_in(operator_cge) }

      it 'permits params' do
        should permit(*permitted_params).
          for(:create, params: params ).on(:stats_ticket)
      end

      describe 'render' do
        before do
          service = double
          allow(UpdateStatsTicketWorker).to receive(:perform_async) { service }

          post(:create, xhr: true, params: params)
        end

        let(:data) { JSON.parse(response.body) }

        context 'valid params' do
          let(:last_stats_ticket) { Stats::Ticket.last }
          let(:expected) do
            {
              path: status_api_v1_operator_stats_ticket_path(last_stats_ticket),
              status: last_stats_ticket.status
            }
          end

          it { is_expected.to respond_with :created }
          it { expect(data).to eq expected.deep_stringify_keys }
          it { expect(UpdateStatsTicketWorker).to have_received(:perform_async).with(last_stats_ticket.ticket_type, last_stats_ticket.year, last_stats_ticket.month_start, last_stats_ticket.month_end, last_stats_ticket.organ_id, last_stats_ticket.subnet_id) }
        end
      end

      describe 'admin' do
        let(:admin) { create(:user, :admin) }

        it 'authorized' do
          sign_in(admin) && post(:create, xhr: true, params: params)

          is_expected.to respond_with :created
        end
      end
    end
  end
end
