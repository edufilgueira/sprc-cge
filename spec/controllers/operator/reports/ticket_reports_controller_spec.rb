require 'rails_helper'

describe Operator::Reports::TicketReportsController do
  let(:user) { create(:user, :operator) }
  let(:ticket_report) { create(:ticket_report, user: user) }
  let!(:ticket) { create(:ticket, :confirmed) }

  let(:permitted_params) do
    [
      :title,
      filters: [
        :ticket_type,
        :expired,
        :organ,
        :subnet,
        :budget_program,
        :topic,
        :subtopic,
        :other_organs,
        :rede_ouvir_scope,
        :deadline,
        :priority,
        :internal_status,
        :search,
        :denunciation,
        :sou_type,
        :state,
        :city,
        :used_input,
        :answer_type,
        :data_scope,
        :department,
        confirmed_at: [
          :start,
          :end
        ],
        sheets: []
      ]
    ]
  end

  context 'index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      context 'template' do
        render_views

        before { get(:index) }

        it { is_expected.to respond_with(:success) }
      end

      context 'helper methods' do

        before { get(:index) }

        it 'ticket_reports' do
          expect(controller.ticket_reports).not_to be_nil
        end

        it 'ticket_reports only from current_user' do
          ticket_report = create(:ticket_report, user: user)
          another_ticket_report = create(:ticket_report)

          expect(controller.ticket_reports).to eq([ticket_report])
        end
      end
      context 'pagination' do
        it 'calls kaminari methods' do
          allow(TicketReport).to receive(:page).and_call_original
          expect(TicketReport).to receive(:page).and_call_original

          get(:index)

          controller.ticket_reports
        end
      end
    end
  end

  context 'new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/reports/ticket_reports/new') }
        it { is_expected.to render_template('operator/reports/ticket_reports/_form') }
      end

      context 'helper methods' do
        it 'ticket_report' do
          expect(controller.ticket_report).to be_new_record
        end
      end
    end
  end

  context 'create' do

    before { 
      create(:topic, :no_characteristic)
      create(:executive_organ, :cge)
    }

    let(:valid_ticket_report) { attributes_for(:ticket_report) }
    let(:invalid_ticket_report) { attributes_for(:ticket_report, :invalid) }

    let(:params) { { ticket_report: valid_ticket_report } }
    let(:invalid_params) { { ticket_report: invalid_ticket_report } }

    context 'unauthorized' do
      before { post(:create, params: { ticket_report: valid_ticket_report }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits matter params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: params).on(:ticket_report)
      end

      context 'valid' do
        it 'saves' do
          ticket_report = attributes_for(:ticket_report)
          expect do
            post :create, params: { ticket_report: ticket_report }

            created_ticket_report = TicketReport.last

            expect(created_ticket_report.user).to eq(user)

            expect(response).to redirect_to(operator_reports_ticket_report_path(created_ticket_report))

            expect(controller).to set_flash.to(I18n.t('operator.reports.ticket_reports.create.done') % { title: created_ticket_report.title })
          end.to change(TicketReport, :count).by(1)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          expect do
            post(:create, params: { ticket_report: invalid_ticket_report })

            expect(response).to render_template('operator/reports/ticket_reports/new')
          end.to change(TicketReport, :count).by(0)
        end

        it 'does not create ticket_report spreadsheet' do
          expect(CreateTicketReportSpreadsheet).not_to receive(:call).with(ticket_report)

          post(:create, params: { ticket_report: invalid_ticket_report })
        end
      end

      context 'helper methods' do

        before { post(:create, params: { ticket_report: valid_ticket_report}) }

        it 'javascript' do
          expected = 'views/operator/reports/ticket_reports/create'

          expect(controller.javascript).to eq(expected)
        end

        it 'stylesheet' do
          expected = 'views/operator/reports/ticket_reports/create'

          expect(controller.stylesheet).to eq(expected)
        end
      end
    end
  end

  context 'show' do
    context 'unauthorized' do
      before { get(:show, params: {id: ticket_report}) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: {id: ticket_report}) }

      context 'helper methods' do
        it 'ticket_report' do
          expect(controller.ticket_report).to eq(ticket_report)
        end
      end
    end

    context 'xhr' do

      it 'does not render layout and renders only _show partial' do
        sign_in(user) && get(:show, params: { id: ticket_report }, xhr: true)
        expect(response).not_to render_template('application')
        expect(response).not_to render_template('show')
        expect(response).to render_template(partial: '_show')
      end

      it 'render xlsx' do
        ticket_report = create(:ticket_report, user: user)
        filename = "ticket_report_#{ticket_report.id}.xlsx"

        path = Rails.root.to_s + "/public/files/downloads/ticket_report/#{ticket_report.id}/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        sign_in(user) && get(:show, xhr: true, format: :xlsx, params: { id: ticket_report })
      end

    end
  end

  describe 'destroy' do
    let(:another_ticket_report) { create(:ticket_report, user: user) }

    context 'unauthorized' do
      before { delete(:destroy, params: { id: another_ticket_report }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'destroys' do
        another_ticket_report

        expect do
          delete(:destroy, params: { id: another_ticket_report })
          expect(response).to redirect_to(operator_reports_ticket_reports_path)
          expect(controller).to set_flash.to(I18n.t('operator.reports.ticket_reports.destroy.done') % { title: another_ticket_report.title })
        end.to change(TicketReport, :count).by(-1)
      end
    end
  end
end
