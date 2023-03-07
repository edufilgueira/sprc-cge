require 'rails_helper'

describe Operator::Reports::GrossExportsController do

  let(:user) { create(:user, :operator) }
  let(:gross_export) { create(:gross_export, user: user) }
  let!(:ticket) { create(:ticket, :confirmed) }

  let(:permitted_params) do
    [
      :title,
      :load_creator_info,
      :load_description,
      :load_answers,
      filters: [
        :ticket_type,
        :expired,
        :organ,
        :subnet,
        :budget_program,
        :topic,
        :subtopic,
        :deadline,
        :rede_ouvir_scope,
        :departments_deadline,
        :priority,
        :internal_status,
        :search,
        :parent_protocol,
        :department,
        :sub_department,
        :service_type,
        :denunciation,
        :sou_type,

        confirmed_at: [
          :start,
          :end
        ]
      ]
    ]
  end

  describe 'index' do
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

        it 'gross_exports' do
          gross_export

          expect(controller.gross_exports).not_to be_nil
        end

        it 'gross_exports only from current_user' do
          gross_export = create(:gross_export, user: user)
          another_gross_export = create(:gross_export)

          expect(controller.gross_exports).to eq([gross_export])
        end
      end

      context 'pagination' do
        it 'calls kaminari methods' do
          allow(GrossExport).to receive(:page).and_call_original
          expect(GrossExport).to receive(:page).and_call_original

          get(:index)

          controller.gross_exports
        end
      end

      context 'xhr' do
        render_views

        context '#show' do
          it 'renders only resource partial when id is present' do
            get(:show, xhr: true, params: { id: gross_export })

            expect(response).not_to render_template('operator')
            expect(response).not_to render_template('show')
            expect(response).to render_template(partial: '_show')
          end
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
        it { is_expected.to render_template('operator/reports/gross_exports/new') }
        it { is_expected.to render_template('operator/reports/gross_exports/_form') }
      end

      context 'helper methods' do
        it 'javascript' do
          expected = 'views/operator/reports/gross_exports/new'

          expect(controller.javascript).to eq(expected)
        end

        it 'stylesheet' do
          expected = 'views/operator/reports/gross_exports/new'

          expect(controller.stylesheet).to eq(expected)
        end

        it 'gross_export' do
          expect(controller.gross_export).to be_new_record
        end
      end
    end
  end

  context 'create' do
    let(:valid_gross_export) { attributes_for(:gross_export) }
    let(:invalid_gross_export) { attributes_for(:gross_export, :invalid) }

    let(:params) { { gross_export: valid_gross_export } }

    context 'unauthorized' do
      before { post(:create, params: { gross_export: valid_gross_export }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits ticket params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: params).on(:gross_export)
      end

      context 'valid' do
        it 'saves' do
          gross_export = attributes_for(:gross_export)
          expect do
            post(:create, params: { gross_export: gross_export })

            created_gross_export = GrossExport.last

            expect(created_gross_export.user).to eq(user)

            expect(response).to redirect_to(operator_reports_gross_export_path(created_gross_export))

            expect(controller).to set_flash.to(I18n.t('operator.reports.gross_exports.create.done') % { title: created_gross_export.title })
          end.to change(GrossExport, :count).by(1)
        end

        it 'create gross_export spreadsheet' do
          gross_export = create(:gross_export)
          service = double

          allow(controller).to receive(:gross_export) { gross_export }
          allow(CreateGrossExportSpreadsheet).to receive(:delay) { service }

          expect(service).to receive(:call).with(gross_export.id)

          post(:create, params: { gross_export: {}})
        end

        context 'default filters' do
          it 'set :sic as default' do
            gross_export = attributes_for(:gross_export, filters: {})

            post :create, params: { gross_export: gross_export }
            created_gross_export = controller.gross_export

            expect(created_gross_export.filters[:ticket_type]).to eq(:sic)
          end

          it 'set first ticket date as default' do
            gross_export = attributes_for(:gross_export, filters: {})

            post :create, params: { gross_export: gross_export }
            created_gross_export = controller.gross_export

            expected = Ticket.order(confirmed_at: :asc).first.confirmed_at.to_date.to_s

            expect(created_gross_export.filters[:confirmed_at][:start]).to eq(expected)
          end
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          expect do
            post(:create, params: { gross_export: invalid_gross_export })

            expect(response).to render_template(:new)
          end.to change(GrossExport, :count).by(0)
        end

        it 'does not create gross_export spreadsheet' do
          service = double

          allow(CreateGrossExportSpreadsheet).to receive(:delay) { service }

          expect(service).not_to receive(:call).with(gross_export)

          post(:create, params: { gross_export: invalid_gross_export })
        end
      end

      context 'helper methods' do

        before { post(:create, params: { gross_export: valid_gross_export }) }

        it 'javascript' do
          expected = 'views/operator/reports/gross_exports/create'

          expect(controller.javascript).to eq(expected)
        end

        it 'stylesheet' do
          expected = 'views/operator/reports/gross_exports/create'

          expect(controller.stylesheet).to eq(expected)
        end
      end
    end
  end

  describe 'show' do
    context 'unauthorized' do
      before { get(:show, params: { id: gross_export }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: gross_export }) }

      context 'helper methods' do
        it 'gross_export' do
          expect(controller.gross_export).to eq(gross_export)
        end
      end
    end

    context 'xhr' do

      it 'does not render layout and renders only _show partial' do
        sign_in(user) && get(:show, xhr: true, format: :html, params: { id: gross_export })
        expect(response).not_to render_template('application')
        expect(response).not_to render_template('show')
        expect(response).to render_template(partial: '_show')
      end

      it 'render xlsx' do
        gross_export = create(:gross_export, user: user)
        filename = "gross_export_#{gross_export.id}.xlsx"

        path = Rails.root.to_s + "/public/files/downloads/gross_export/#{gross_export.id}/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        sign_in(user) && get(:show, xhr: true, format: :xlsx, params: { id: gross_export })
      end

    end
  end

  describe 'destroy' do
    let(:another_gross_export) { create(:gross_export, user: user) }

    context 'unauthorized' do
      before { delete(:destroy, params: { id: another_gross_export }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'destroys' do
        another_gross_export

        expect do
          delete(:destroy, params: { id: another_gross_export })
          expect(response).to redirect_to(operator_reports_gross_exports_path)
          expect(controller).to set_flash.to(I18n.t('operator.reports.gross_exports.destroy.done') % { title: another_gross_export.title })
        end.to change(GrossExport, :count).by(-1)
      end
    end
  end
end
