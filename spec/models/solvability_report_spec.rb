require 'rails_helper'

describe SolvabilityReport do
  subject(:solvability_report) { build(:solvability_report) }

  it_behaves_like 'models/testable'
  it_behaves_like 'models/timestamp'

  describe 'factory' do
    it { is_expected.to be_valid }
    it { expect(build(:solvability_report, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:filters).of_type(:text) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:processed).of_type(:integer) }
      it { is_expected.to have_db_column(:total).of_type(:integer) }

    end
  end

  describe 'enums' do
    it 'status' do
      expected_statuses = [:preparing, :generating, :error, :success]

      is_expected.to define_enum_for(:status).with_values(expected_statuses)
    end
  end

  describe 'serializations' do
    it { expect(solvability_report.filters).to be_a Hash }
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
      expect(SolvabilityReport.sorted).to eq(SolvabilityReport.order(created_at: :desc))
    end
  end

  describe 'helpers' do
    it 'status_str' do
      expected = I18n.t("solvability_report.statuses.#{solvability_report.status}")

      expect(solvability_report.status_str).to eq(expected)
    end

    it 'progress' do
      solvability_report.processed = 13
      solvability_report.total_to_process = 59

      expected = ((13/59.to_f)*100).to_i
      expect(solvability_report.progress).to eq(expected)

      solvability_report.processed = 0
      solvability_report.total_to_process = 0

      expected = 0
      expect(solvability_report.progress).to eq(expected)
    end

    it 'processing?' do
      solvability_report.status = :preparing
      expect(solvability_report).to be_processing

      solvability_report.status = :generating
      expect(solvability_report).to be_processing

      solvability_report.status = :success
      expect(solvability_report).not_to be_processing

      solvability_report.status = :error
      expect(solvability_report).not_to be_processing
    end

    it 'file' do
      solvability_report.save
      CreateSolvabilityReportSpreadsheet.call(solvability_report.id)
      expect(solvability_report.file.path).to eq(File.new(solvability_report.file_path).path)
    end
  end

  describe 'filters' do
    it 'ticket_type' do
      sic_ticket = create(:ticket, :confirmed, ticket_type: :sic)
      sou_ticket = create(:ticket, :confirmed, ticket_type: :sou)

      filters = { ticket_type: :sou }


      solvability_report.filters = filters


      expect(solvability_report.filtered_scope).to eq([sou_ticket])
    end

    context 'confirmed_at' do

      let(:ticket_old) { create(:ticket, :confirmed, confirmed_at: 20.days.ago.to_date) }
      let(:ticket_new) { create(:ticket, :confirmed, confirmed_at: Date.yesterday) }

      it 'empty start' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: nil,
            end: 5.days.ago.to_date
          }
        }

        solvability_report.filters = filters

        expect(solvability_report.filtered_scope).to eq([ticket_old])
      end

      it 'empty end' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: 5.days.ago.to_date,
            end: nil
          }
        }

        solvability_report.filters = filters

        expect(solvability_report.filtered_scope).to eq([ticket_new])
      end

      it 'empty start and end' do
        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: nil,
            end: nil
          }
        }

        solvability_report.filters = filters

        expect(solvability_report.filtered_scope).to match_array([ticket_old, ticket_new])
      end

      it 'with start and end' do

        filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: 5.days.ago.to_date,
            end: Date.today
          }
        }

        solvability_report.filters = filters

        expect(solvability_report.filtered_scope).to eq([ticket_new])
      end
    end
  end

  describe 'callbacks' do

    context 'before_destroy' do
      it 'removes spreadsheet file before destroy' do
        solvability_report.save

        expect(RemoveReportableSpreadsheet).to receive(:call).with(solvability_report)

        solvability_report.destroy
      end
    end

    context 'before_save' do
      it 'clear empty filters' do

        solvability_report.filters = {
          ticket_type: :sou,
          confirmed_at: {
            start: '',
            end: nil
          }
        }
        expected = {
          ticket_type: :sou
        }
        solvability_report.save
        expect(solvability_report.filters).to eq(expected)
      end
    end
  end
end
