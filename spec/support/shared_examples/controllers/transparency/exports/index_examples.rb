shared_examples_for 'controllers/transparency/exports/index' do
  include ResponseSpecHelper

  describe 'index' do
    it 'json success' do
      resource

      params = {
        'export_name': 'Name of export',
        'export_email': 'user@example.com',
        'export_worksheet_format': 'xlsx'
      }

      get(:index, xhr: true, format: :xlsx, params: params)

      expect(json.size).to eq(2)
      expect(json['status']).to eq('success')
      expect(json['message']).to eq(I18n.t('transparency.exports.create.done', expiration: 2))
    end

    it 'create transparency_export' do
      resource

      params = {
        'export_name': 'Name of export',
        'export_email': 'user@example.com',
        'export_worksheet_format': 'xlsx'
      }

      get(:index, xhr: true, format: :xlsx, params: params)

      export = controller.transparency_export

      expect(export.status).to eq('queued')
      expect(export.resource_name).to eq(resource.class.to_s)
    end

    it 'create transparency_export query with resources filtered' do
      resource
      another_resource

      params = resource_filter_param.merge({
        'export_name': 'Name of export',
        'export_email': 'user@example.com',
        'export_worksheet_format': 'xlsx'
      })

      get(:index, xhr: true, format: :xlsx, params: params)

      query = controller.transparency_export.query
      result = ApplicationDataRecord.connection.execute(query)

      expect(result.count).to eq(1)
    end

    it 'call create_spreadsheet service' do
      allow(Transparency::CreateSpreadsheetWorker).to receive(:perform_async)

      params = {
        'export_name': 'Name of export',
        'export_email': 'user@example.com',
        'export_worksheet_format': 'xlsx'
      }

      get(:index, xhr: true, format: :xlsx, params: params)

      transparency_export = controller.transparency_export

      expect(Transparency::CreateSpreadsheetWorker).to have_received(:perform_async).with(transparency_export.id)
    end

    it 'error' do
      resource

      params = {
        'export_name': '',
        'export_email': 'invalidformat.com',
        'export_worksheet_format': 'csv'
      }

      get(:index, xhr: true, format: :xlsx, params: params)

      expect(json.size).to eq(3)
      expect(json['status']).to eq('error')
      expect(json['errors'].count).to eq(2)
      expect(json['errors']['name']).to be_present
      expect(json['errors']['email']).to be_present
      expect(json['message']).to eq(I18n.t('transparency.exports.create.error'))
    end
  end
end
