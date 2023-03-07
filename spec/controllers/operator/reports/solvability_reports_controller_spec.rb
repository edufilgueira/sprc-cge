require 'rails_helper'

describe Operator::Reports::SolvabilityReportsController do
  let(:user) { create(:user, :operator_cge) }
  let(:solvability_report) { create(:solvability_report, user: user) }
  let!(:ticket) { create(:ticket, :confirmed) }

  let(:permitted_params) do
    [
      :title,
      filters: [
        :ticket_type,
        confirmed_at: [
          :start,
          :end
        ]
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

        it 'solvability_reports' do
          expect(controller.solvability_reports).not_to be_nil
        end

        it 'solvability_reports only from current_user' do
          solvability_report = create(:solvability_report, user: user)
          another_solvability_report = create(:solvability_report)

          expect(controller.solvability_reports).to eq([solvability_report])
        end
      end
      context 'pagination' do
        it 'calls kaminari methods' do
          allow(SolvabilityReport).to receive(:page).and_call_original
          expect(SolvabilityReport).to receive(:page).and_call_original

          get(:index)

          controller.solvability_reports
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
        it { is_expected.to render_template('operator/reports/solvability_reports/new') }
        it { is_expected.to render_template('operator/reports/solvability_reports/_form') }
      end

      context 'helper methods' do
        it 'solvability_report' do
          expect(controller.solvability_report).to be_new_record
        end
      end
    end
  end

  context 'create' do
    let(:valid_solvability_report) { attributes_for(:solvability_report) }
    let(:invalid_solvability_report) { attributes_for(:solvability_report, :invalid) }

    let(:params) { { solvability_report: valid_solvability_report } }
    let(:invalid_params) { { solvability_report: invalid_solvability_report } }

    context 'unauthorized' do
      before { post(:create, params: { solvability_report: valid_solvability_report }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits matter params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: { params: params }).on(:solvability_report)
      end

      context 'valid' do
        it 'saves' do
          solvability_report = attributes_for(:solvability_report)
          expect do
            post :create, params: { solvability_report: solvability_report }

            created_solvability_report = SolvabilityReport.last

            expect(created_solvability_report.user).to eq(user)

            expect(response).to redirect_to(operator_reports_solvability_report_path(created_solvability_report))

            expect(controller).to set_flash.to(I18n.t('operator.reports.solvability_reports.create.done') % { title: created_solvability_report.title })
          end.to change(SolvabilityReport, :count).by(1)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          expect do
            post(:create, params: { solvability_report: invalid_solvability_report })

            expect(response).to render_template('operator/reports/solvability_reports/new')
          end.to change(SolvabilityReport, :count).by(0)
        end

        it 'does not create solvability_report spreadsheet' do
          expect(CreateSolvabilityReportSpreadsheet).not_to receive(:call).with(solvability_report)

          post(:create, params: { solvability_report: invalid_solvability_report })
        end
      end

      context 'helper methods' do

        before { post(:create, params: { solvability_report: valid_solvability_report}) }

        it 'javascript' do
          expected = 'views/operator/reports/solvability_reports/create'

          expect(controller.javascript).to eq(expected)
        end

        it 'stylesheet' do
          expected = 'views/operator/reports/solvability_reports/create'

          expect(controller.stylesheet).to eq(expected)
        end
      end
    end
  end

  context 'show' do
    context 'unauthorized' do
      before { get(:show, params: {id: solvability_report}) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: {id: solvability_report}) }

      context 'helper methods' do
        it 'solvability_report' do
          expect(controller.solvability_report).to eq(solvability_report)
        end
      end
    end

    context 'xhr' do

      it 'does not render layout and renders only _show partial' do
        sign_in(user) && get(:show, params: { id: solvability_report }, xhr: true)
        expect(response).not_to render_template('application')
        expect(response).not_to render_template('show')
        expect(response).to render_template(partial: '_show')
      end

      it 'render xlsx' do
        solvability_report = create(:solvability_report, user: user)
        filename = "solvability_report_#{solvability_report.id}.xlsx"

        path = Rails.root.to_s + "/public/files/downloads/solvability_report/#{solvability_report.id}/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        sign_in(user) && get(:show, xhr: true, format: :xlsx, params: { id: solvability_report })
      end

    end
  end

  describe 'destroy' do
    let(:another_solvability_report) { create(:solvability_report, user: user) }

    context 'unauthorized' do
      before { delete(:destroy, params: { id: another_solvability_report }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'destroys' do
        another_solvability_report

        expect do
          delete(:destroy, params: { id: another_solvability_report })
          expect(response).to redirect_to(operator_reports_solvability_reports_path)
          expect(controller).to set_flash.to(I18n.t('operator.reports.solvability_reports.destroy.done') % { title: another_solvability_report.title })
        end.to change(SolvabilityReport, :count).by(-1)
      end
    end
  end
end
