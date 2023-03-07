require 'rails_helper'

describe OpenData::DataItem do
  subject(:data_item) { build(:data_item) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  # Evita que tente contectar no webservice.
  before { allow(Integration::Importers::Import).to receive(:call).and_return(nil) }

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:data_item_type).of_type(:integer) }
      it { is_expected.to have_db_column(:open_data_data_set_id).of_type(:integer) }
      it { is_expected.to have_db_column(:document_public_filename).of_type(:string) }
      it { is_expected.to have_db_column(:document_format).of_type(:string) }

      # WebService

      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:headers_soap_action).of_type(:string) }
      it { is_expected.to have_db_column(:response_path).of_type(:string) }
      it { is_expected.to have_db_column(:wsdl).of_type(:string) }
      it { is_expected.to have_db_column(:parameters).of_type(:string) }
      it { is_expected.to have_db_column(:operation).of_type(:string) }
      it { is_expected.to have_db_column(:processed_at).of_type(:datetime) }

      # Attachement

      it { is_expected.to have_db_column(:document_id).of_type(:string) }
      it { is_expected.to have_db_column(:document_filename).of_type(:string) }
      it { is_expected.to have_db_column(:document_content_size).of_type(:string) }
      it { is_expected.to have_db_column(:document_content_type).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:data_set).with_foreign_key(:open_data_data_set_id).class_name('OpenData::DataSet') }
  end

  describe 'enums' do
    it 'data_item_type' do
      data_item_types = [:file, :webservice]

      is_expected.to define_enum_for(:data_item_type).with_values(data_item_types)
    end

    it 'status' do
      statuses = [:status_queued, :status_in_progress, :status_success, :status_fail]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:data_item_type) }
    it { is_expected.to validate_presence_of(:data_set) }
    it { is_expected.to validate_presence_of(:document_public_filename) }

    context 'file' do
      before { data_item.data_item_type = :file }

      it { is_expected.to validate_presence_of(:document) }
    end

    context 'webservice' do
      before { data_item.data_item_type = :webservice }

      it { is_expected.to validate_presence_of(:response_path) }
      it { is_expected.to validate_presence_of(:wsdl) }
      it { is_expected.to validate_presence_of(:operation) }
    end
  end

  describe 'callbacks' do
    describe 'after_commit' do
      describe 'call importer' do
        it 'webservice data_item' do
          # Deve chamar importador se for do tipo webservice
          data_item = build(:data_item, :webservice)
          expect(Integration::Importers::Import).to receive(:call).with(:open_data, anything).and_return(nil)
          data_item.save
        end

        it 'does not call for file data_item' do
          # Não deve chamar importador se for do tipo file
          data_item = build(:data_item, :file)
          expect(Integration::Importers::Import).not_to receive(:call).with(:open_data, anything)
          data_item.save
        end

        it 'calls when updated' do
          # Deve chamar o importador ao atualizar
          data_item = create(:data_item, :webservice)
          data_item.title = 'outro'
          expect(Integration::Importers::Import).to receive(:call).with(:open_data, data_item.id).and_return(nil)
          data_item.save
        end
      end
    end
  end

  describe 'helpers' do
    it 'data_item_str' do
      expected = I18n.t("open_data/data_item.data_item_types.#{data_item.data_item_type}")
      expect(data_item.data_item_type_str).to eq(expected)
    end

    describe 'download_url' do
      it 'nil by default' do
        expect(data_item.download_url).to be_nil
      end

      it 'webservice download' do
        data_item = build(:data_item, :webservice)
        data_item.document_filename = 'blabla.txt'
        data_item.save

        expected_url = "/files/downloads/integration/open_data/data_items/#{data_item.id}/#{data_item.document_filename}"

        allow(File).to receive(:exist?).and_return(true)

        expect(data_item.download_url).to eq(expected_url)

        allow(File).to receive(:exist?).and_return(false)

        expect(data_item.download_url).to eq(nil)

        allow(File).to receive(:exist?).and_return(true)

        allow(data_item).to receive(:document_filename).and_return(nil)

        expect(data_item.download_url).to eq(nil)
      end

      it 'file download' do
        data_item = build(:data_item, :file)
        data_item.document = Refile::FileDouble.new("test", "test.csv", content_type: "text/csv")
        data_item.document_filename = 'blabla.txt'
        data_item.save

        expected_url = Refile.attachment_url(data_item, :document, force_download: true)

        expect(data_item.download_url).to eq(expected_url)

        data_item.document = nil

        expect(data_item.download_url).to eq(nil)
      end
    end
  end
end
