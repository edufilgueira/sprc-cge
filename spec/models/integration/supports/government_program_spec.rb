require 'rails_helper'

describe Integration::Supports::GovernmentProgram do
  subject(:government_program) { build(:integration_supports_government_program) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_government_program, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ano_inicio).of_type(:integer) }
      it { is_expected.to have_db_column(:codigo_programa).of_type(:string) }
      it { is_expected.to have_db_column(:titulo).of_type(:string) }
    end

    describe 'indexes' do
      # Os testes de db:indexes ficam concentrados na aplicação sprc-data
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ano_inicio) }
    it { is_expected.to validate_presence_of(:codigo_programa) }
    it { is_expected.to validate_presence_of(:titulo) }
  end

  describe 'helpers' do
    it 'title' do
      expect(government_program.title).to eq(government_program.titulo)
    end
  end
end
