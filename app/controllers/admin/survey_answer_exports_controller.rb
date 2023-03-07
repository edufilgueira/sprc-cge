class Admin::SurveyAnswerExportsController < Admin::BaseCrudController
  include Admin::SurveyAnswerExports::Breadcrumbs

  FIND_ACTIONS = FIND_ACTIONS + ['download']

  # Callbacks

  before_action :associate_user, only: :create

  PERMITTED_PARAMS = [
    :name,
    :start_at,
    :ends_at,
    :worksheet_format
  ]

  SORT_COLUMNS = {
    created_at: 'survey_answer_exports.created_at',
    name: 'survey_answer_exports.name'
  }

  helper_method [:survey_answer_exports, :survey_answer_export]


  # Actions

  def create
    super

    if survey_answer_export.valid?
      survey_answer_export.queued!
      create_survey_answer_spreadsheet
    end
  end

  def download
    respond_to do |format|
      format.xlsx {
        send_file(survey_answer_export.filepath, filename: survey_answer_export.filename, type: 'application/xlsx')
      }

      format.csv {
        send_file(survey_answer_export.filepath, filename: survey_answer_export.filename, type: 'application/csv')
      }
    end
  end


  # Helper methods

  def survey_answer_exports
    paginated_resources
  end

  def survey_answer_export
    resource
  end

  # privates

  private

  def create_survey_answer_spreadsheet
    SurveyAnswerExport::CreateSpreadsheet.delay(queue: 'exports').call(survey_answer_export.id)
  end

  def associate_user
    resource.user = current_user
  end
end
