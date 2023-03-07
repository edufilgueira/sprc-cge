require 'rails_helper'

describe Admin::SurveyAnswerExportsController do
  let(:user) { create(:user, :admin) }

  let(:survey_answer_export) { create(:survey_answer_export) }

  let(:resources) { [survey_answer_export] + create_list(:survey_answer_export, 1) }

  let(:permitted_params) do
    [
      :name,
      :start_at,
      :ends_at,
      :worksheet_format
    ]
  end

  let(:valid_params) do
    { survey_answer_export: attributes_for(:survey_answer_export) }
  end

  it_behaves_like 'controllers/admin/base/index' do

    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'


    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          created_at: 'survey_answer_exports.created_at',
          name: 'survey_answer_exports.name'
        }
      end

      let(:first_unsorted) { create(:survey_answer_export, name: '456') }

      let(:last_unsorted) { create(:survey_answer_export, name: '123') }
    end
  end

  it_behaves_like 'controllers/admin/base/new'

  it_behaves_like 'controllers/admin/base/show'

  describe '#create' do

    it_behaves_like 'controllers/admin/base/create'

    it 'queued' do
      sign_in(user)

      post(:create, params: valid_params)

      expect(controller.survey_answer_export.status).to eq('queued')
    end

    it 'associate_user' do
      sign_in(user)

      post(:create, params: valid_params)

      expect(controller.survey_answer_export.user).to eq(user)
    end

    it 'call export service' do
      service = double
      allow(SurveyAnswerExport::CreateSpreadsheet).to receive(:delay) { service }
      allow(service).to receive(:call)

      sign_in(user) && post(:create, params: valid_params)

      expect(service).to have_received(:call)
    end

    it 'dont call export service' do
      invalid_params = { survey_answer_export: attributes_for(:survey_answer_export, :invalid) }

      service = double
      allow(SurveyAnswerExport::CreateSpreadsheet).to receive(:delay) { service }
      allow(service).to receive(:call)

      sign_in(user) && post(:create, params: invalid_params)

      expect(service).not_to have_received(:call)
    end
  end

  describe '#download' do

    context 'xhr' do
      it 'render xlsx' do
        survey_answer_export = create(:survey_answer_export, filename: 'filename.xlsx')
        filename = survey_answer_export.filename

        path = Rails.root.to_s + "/public/files/downloads/survey_answer_exports/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/xlsx' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        sign_in(user)
        get(:download, xhr: true, format: :xlsx, params: { id: survey_answer_export })
      end

      it 'render csv' do
        survey_answer_export = create(:survey_answer_export, filename: 'filename.csv')
        filename = survey_answer_export.filename

        path = Rails.root.to_s + "/public/files/downloads/survey_answer_exports/#{filename}"

        expect(controller).to receive(:send_file).with(path, { filename: "#{filename}", type: 'application/csv' }) do
          controller.render body: nil # to prevent a 'missing template' error
        end

        sign_in(user)
        get(:download, xhr: true, format: :csv, params: { id: survey_answer_export })
      end
    end
  end
end
