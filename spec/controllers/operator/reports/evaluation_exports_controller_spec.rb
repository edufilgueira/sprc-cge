require 'rails_helper'

describe Operator::Reports::EvaluationExportsController do

  let(:user) { create(:user, :operator_cge) }
  let!(:ticket) { create(:ticket, :confirmed) }

  let(:resources) { create_list(:evaluation_export, 2, user: user) }

  let(:permitted_params) do
    [
      :title,
      filters: [
        :ticket_type,
        :organ,
        :subnet,
        confirmed_at: [
          :start,
          :end
        ]
      ]
    ]
  end

  let(:valid_params) do
    {
      evaluation_export: attributes_for(:evaluation_export)
    }
  end

  it_behaves_like 'controllers/operator/base/index' do
    it_behaves_like 'controllers/operator/base/index/xhr'
    it_behaves_like 'controllers/operator/base/index/paginated'
    it_behaves_like 'controllers/operator/base/index/search'
  end

  it_behaves_like 'controllers/operator/base/new'

  it_behaves_like 'controllers/operator/base/create' do

    context 'authorized' do
      before { sign_in(user) }

      it 'invokes service' do
        service = double
        allow(Reports::Tickets::EvaluationsService).to receive(:delay) { service }
        allow(service).to receive(:call)

        post(:create, params: valid_params)

        evaluation_export = EvaluationExport.last
        expect(service).to have_received(:call).with(evaluation_export.id)
      end

      context 'when operator sou sectoral' do

        let!(:valid_params) do
          {
            evaluation_export: attributes_for(:evaluation_export, :sic)
          }
        end

        context 'set default attributes' do
          let(:organ) { user.organ }
          let!(:user) { create(:user, :operator_sou_sectoral) }

          before do
            user
            post(:create, params: valid_params)
          end

          it { expect(controller.evaluation_export.filters[:organ]).to eq(organ.id) }
          it { expect(controller.evaluation_export.ticket_type_filter).to eq('sou') }
        end

        context 'acts_as_sic == true' do
          let!(:user) { create(:user, :operator_sou_sectoral, acts_as_sic: true) }

          before do
            user
             valid_params[:evaluation_export][:filters][:ticket_type] = :sic
            post(:create, params: valid_params)
          end

          it { expect(controller.evaluation_export.ticket_type_filter).to eq('sic') }
        end
      end

      context 'when operator sic sectoral' do
        let!(:user) { create(:user, :operator_sic_sectoral) }

        context 'set default attributes' do
          let(:organ) { user.organ }

          before do
            user
            valid_params[:evaluation_export][:filters][:ticket_type] = :sic
            post(:create, params: valid_params)
           end

          it { expect(controller.evaluation_export.filters[:organ]).to eq(organ.id) }
          it { expect(controller.evaluation_export.ticket_type_filter).to eq('sic') }
        end
      end

      context 'when operator subnet' do
        let(:user) { create(:user, :operator_subnet_sectoral) }

        context 'set subnet' do
          let(:subnet) { user.subnet }

          before { post(:create, params: valid_params) }

          it { expect(controller.evaluation_export.filters[:subnet]).to eq(subnet.id) }
        end
      end
    end
  end

  it_behaves_like 'controllers/operator/base/show' do
    it { is_expected.to be_kind_of(Operator::BaseTicketSpreadsheetController) }
  end

  it_behaves_like 'controllers/operator/base/destroy'
end
