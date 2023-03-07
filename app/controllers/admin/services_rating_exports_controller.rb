class Admin::ServicesRatingExportsController < Admin::BaseCrudController
	include Admin::ServicesRatingExports::Breadcrumbs

  FIND_ACTIONS = FIND_ACTIONS + ['download']
  
   # Callbacks

  before_action :associate_user, only: :create

  PERMITTED_PARAMS = [
    :name,
    :start_at,
    :ends_at,
    :worksheet_format
  ]


  helper_method [:services_rating_exports, :services_rating_export]

  # Actions

  def create
    super

    if services_rating_export.valid?
      services_rating_export.queued!
      create_services_rating_spreadsheet
    end
  end

  def download
    respond_to do |format|
      format.xlsx {
        send_file(services_rating_export.filepath, filename: services_rating_export.filename, type: 'application/xlsx')
      }

      format.csv {
        send_file(services_rating_export.filepath, filename: services_rating_export.filename, type: 'application/csv')
      }
    end
  end

  # Helper methods

  def services_rating_exports
  	paginated_resources
  end

   def services_rating_export
    resource
  end



  private

  def create_services_rating_spreadsheet
    ServicesRatingExport::CreateSpreadsheet.delay(queue: 'exports').call(services_rating_export.id)
  end

  def associate_user
    resource.user = current_user
  end

end
