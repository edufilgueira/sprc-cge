module Reports::Tickets::Report::Sheets
  # Testado em create_ticket_report_spreadsheet_spec

  SIC_SHEETS = [
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

  SOU_SHEETS = [
    Reports::Tickets::Report::Sou::SummaryService,
    Reports::Tickets::Report::Sou::AnswerClassificationService,
    Reports::Tickets::Report::Sou::UsedInputService,
    Reports::Tickets::Report::Sou::SouTypeService,
    Reports::Tickets::Report::Sou::PerceptionDenouncedFactService,
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
