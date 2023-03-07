require 'rails_helper'

describe CreateTicketReportSpreadsheet do
  before { 
    create(:topic, :no_characteristic)
  }

  let(:ticket_report) { create(:ticket_report) }

  subject(:create_ticket_report_spreadsheet) { CreateTicketReportSpreadsheet.new(ticket_report.id) }

  it 'invalid ticket_report' do
    expect { CreateTicketReportSpreadsheet.call(0) }.to_not raise_error
    expect(CreateTicketReportSpreadsheet.call(0)).to eq nil
  end

  context 'file' do
    it 'creates base ticket_report dir' do
      dir = Rails.root.join('public', 'files', 'downloads', 'ticket_report', ticket_report.id.to_s)
      FileUtils.rm_rf(dir) if File.exist?(dir)

      subject.call

      expect(File.exist?(dir)).to eq(true)
    end

    it 'overrides existing directory' do
      base_dir_path = ['public', 'files', 'downloads', 'ticket_report', ticket_report.id.to_s].join('/').to_s

      base_dir = Rails.root.join(base_dir_path)
      test_file_path = base_dir.join('test_file').to_s

      FileUtils.mkpath(base_dir.to_s)

      FileUtils.touch(test_file_path)
      expect(File.exist?(test_file_path)).to eq(true)

      subject.call

      expect(File.exist?(base_dir.to_s)).to eq(true)
      expect(File.exist?(test_file_path)).to eq(false)
    end
  end

  context 'sheets' do
    let(:sic_sheet_name) do
      [
        Reports::Tickets::Report::Sic::SummaryService,
        Reports::Tickets::Report::Sic::AnswerClassificationService,
        Reports::Tickets::Report::Sic::UsedInputService,
        Reports::Tickets::Report::Sic::InternalStatusService,
        Reports::Tickets::Report::Sic::OrganService,
        Reports::Tickets::Report::Sic::MostWantedTopicsService,
        Reports::Tickets::Report::Sic::TopicService,
        Reports::Tickets::Report::Sic::SubtopicService,
        Reports::Tickets::Report::Sic::EvaluationService,
        Reports::Tickets::Report::Sic::PercentageOnTimeService,
        Reports::Tickets::Report::Sic::AverageTimeAnswerService,
        Reports::Tickets::Report::Sic::AverageAnswerDepartmentService,
        Reports::Tickets::Report::Sic::AverageAnswerSubDepartmentService,
        Reports::Tickets::Report::Sic::SolvabilityService,
        Reports::Tickets::Report::Sic::SolvabilityDeadlineService,
        Reports::Tickets::Report::Sic::BudgetProgramService,
        Reports::Tickets::Report::Sic::ServiceTypeService,
        Reports::Tickets::Report::Sic::SubDepartmentService,
        Reports::Tickets::Report::Sic::StateService,
        Reports::Tickets::Report::Sic::CityService,
        Reports::Tickets::Report::Sic::NeighborhoodService,
        Reports::Tickets::Report::Sic::AnswerPreferenceService
      ]
    end

    let(:sou_sheet_name) do
      [
        Reports::Tickets::Report::Sou::SummaryService,
        Reports::Tickets::Report::Sou::AnswerClassificationService,
        Reports::Tickets::Report::Sou::UsedInputService,
        Reports::Tickets::Report::Sou::SouTypeService,
        Reports::Tickets::Report::Sou::InternalStatusService,
        Reports::Tickets::Report::Sou::OrganService,
        Reports::Tickets::Report::Sou::TopicService,
        Reports::Tickets::Report::Sou::SubtopicService,
        Reports::Tickets::Report::Sou::AverageAnswerDepartmentService,
        Reports::Tickets::Report::Sou::AverageAnswerSubDepartmentService,
        Reports::Tickets::Report::Sou::EvaluationService,
        Reports::Tickets::Report::Sou::SolvabilityService,
        Reports::Tickets::Report::Sou::BudgetProgramService,
        Reports::Tickets::Report::Sou::ServiceTypeService,
        Reports::Tickets::Report::Sou::SouTypeByTopicService,
        Reports::Tickets::Report::Sou::SubDepartmentService,
        Reports::Tickets::Report::Sou::ReopenedService,
        Reports::Tickets::Report::Sou::StateService,
        Reports::Tickets::Report::Sou::CityService,
        Reports::Tickets::Report::Sou::NeighborhoodService,
        Reports::Tickets::Report::Sou::DenunciationTypeService
      ]
    end

    context 'sic' do
      let(:ticket_report) { create(:ticket_report, :sic) }

      it { expect(create_ticket_report_spreadsheet.send(:sheets)).to eq(sic_sheet_name) }

      it 'specific sheet filter' do
        sheets = ['Reports::Tickets::Report::Sic::SummaryService']
        ticket_report = create(:ticket_report, filters: { ticket_type: :sic, sheets: sheets })
        create_ticket_report_spreadsheet = CreateTicketReportSpreadsheet.new(ticket_report.id)

        expect(create_ticket_report_spreadsheet.send(:sheets)).to eq(sheets.map(&:constantize))
      end
    end

    context 'sou' do
      it 'sou_type' do
        expect(create_ticket_report_spreadsheet.send(:sheets)).to eq(sou_sheet_name)
      end

      it 'specific sheet filter' do
        sheets = ['Reports::Tickets::Report::Sou::SummaryService']
        ticket_report = create(:ticket_report, filters: { ticket_type: :sou, sheets: sheets })
        create_ticket_report_spreadsheet = CreateTicketReportSpreadsheet.new(ticket_report.id)

        expect(create_ticket_report_spreadsheet.send(:sheets)).to eq(sheets.map(&:constantize))
      end
    end
  end
end
