require 'rails_helper'

describe AttendanceReport do
  subject(:attendance_report) { build(:attendance_report) }

  it_behaves_like 'models/testable'
  it_behaves_like 'models/timestamp'


  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:starts_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:ends_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:processed).of_type(:integer) }
      it { is_expected.to have_db_column(:total_to_process).of_type(:integer) }
    end
  end

  describe 'attributes' do
    it { expect(AttendanceReport.new).to be_preparing }
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
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
  end

  describe 'scopes' do
    it 'sorted' do
      expect(AttendanceReport.sorted).to eq(AttendanceReport.order(created_at: :desc))
    end
  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    it { expect(attendance_report.filters).to be_a Hash }
  end

  describe 'helpers' do
    it 'progress' do
      attendance_report.processed = 13
      attendance_report.total_to_process = 59

      expected = ((13/59.to_f)*100).to_i
      expect(attendance_report.progress).to eq(expected)

      attendance_report.processed = 0
      attendance_report.total_to_process = 0

      expected = 0
      expect(attendance_report.progress).to eq(expected)
    end

    it 'processing?' do
      attendance_report.status = :preparing
      expect(attendance_report).to be_processing

      attendance_report.status = :generating
      expect(attendance_report).to be_processing

      attendance_report.status = :success
      expect(attendance_report).not_to be_processing

      attendance_report.status = :error
      expect(attendance_report).not_to be_processing
    end

    it 'file' do
      attendance_report.save
      Reports::AttendancesService.call(attendance_report.id)
      expect(attendance_report.file.path).to eq(File.new(attendance_report.file_path).path)
    end
  end

  describe 'callbacks' do

    context 'before_destroy' do
      it 'removes spreadsheet file before destroy' do
        attendance_report.save

        expect(RemoveReportableSpreadsheet).to receive(:call).with(attendance_report)

        attendance_report.destroy
      end
    end

    context 'before_save' do
      context 'clear empty filters' do

        before do
          attendance_report.filters = { ticket_type: '' }

          attendance_report.save
        end

        it { expect(attendance_report.filters).to be_blank }
      end
    end
  end
end
