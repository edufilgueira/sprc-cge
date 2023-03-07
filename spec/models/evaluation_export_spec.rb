require 'rails_helper'

describe EvaluationExport do
  subject(:evaluation_export) { build(:evaluation_export) }

  it_behaves_like 'models/testable'
  it_behaves_like 'models/timestamp'


  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:processed).of_type(:integer) }
      it { is_expected.to have_db_column(:total).of_type(:integer) }
      it { is_expected.to have_db_column(:total_to_process).of_type(:integer) }
    end
  end

  describe 'enums' do
    it { is_expected.to be_kind_of(EnumLocalizable) }

    it 'status' do
      expected_statuses = [:preparing, :generating, :error, :success]

      is_expected.to define_enum_for(:status).with_values(expected_statuses)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(EvaluationExport.sorted).to eq(EvaluationExport.order(created_at: :desc))
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    it { expect(evaluation_export.filters).to be_a Hash }
  end

  describe 'helpers' do
    it 'progress' do
      evaluation_export.processed = 13
      evaluation_export.total_to_process = 59

      expected = ((13/59.to_f)*100).to_i
      expect(evaluation_export.progress).to eq(expected)

      evaluation_export.processed = 0
      evaluation_export.total_to_process = 0

      expected = 0
      expect(evaluation_export.progress).to eq(expected)
    end

    it 'processing?' do
      evaluation_export.status = :preparing
      expect(evaluation_export).to be_processing

      evaluation_export.status = :generating
      expect(evaluation_export).to be_processing

      evaluation_export.status = :success
      expect(evaluation_export).not_to be_processing

      evaluation_export.status = :error
      expect(evaluation_export).not_to be_processing
    end

    it 'file' do
      evaluation_export.save
      Reports::Tickets::EvaluationsService.call(evaluation_export)
      expect(evaluation_export.file.path).to eq(File.new(evaluation_export.file_path).path)
    end

    describe 'filters' do
      it 'ticket_type' do
        sic_ticket = create(:ticket, :confirmed, ticket_type: :sic)
        create(:answer, ticket: sic_ticket, evaluation: create(:evaluation, :sic))

        sou_ticket = create(:ticket, :confirmed, :replied, ticket_type: :sou)
        create(:answer, ticket: sou_ticket, evaluation: create(:evaluation))

        filters = { ticket_type: :sou }


        evaluation_export.filters = filters


        expect(evaluation_export.filtered_scope).to eq([sou_ticket])
      end

      it 'organ' do
        organ = create(:organ)
        another_organ = create(:organ)

        ticket_with_organ = create(:ticket, :with_parent, organ: organ)
        create(:answer, ticket: ticket_with_organ, evaluation: create(:evaluation))

        ticket_with_another_organ = create(:ticket, :with_parent, organ: another_organ)
        create(:answer, ticket: ticket_with_another_organ, evaluation: create(:evaluation))

        evaluation_export.filters[:organ] = organ.id

        expect(evaluation_export.filtered_scope).to eq([ticket_with_organ])
      end
    end
  end

  describe 'callbacks' do

    context 'before_destroy' do
      it 'removes spreadsheet file before destroy' do
        evaluation_export.save

        expect(RemoveReportableSpreadsheet).to receive(:call).with(evaluation_export)

        evaluation_export.destroy
      end
    end

    context 'before_save' do
      context 'clear empty filters' do

        before do
          evaluation_export.filters = { ticket_type: :sou, custom: '' }

          evaluation_export.save
        end

        it { expect(evaluation_export.filters[:custom]).to be_blank }
      end
    end
  end
end
