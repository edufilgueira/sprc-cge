module ::Operator::BaseTicketSpreadsheetController
  extend ActiveSupport::Concern


  def show
    respond_to do |format|
      format.html {
        if request.xhr?
          render partial: 'show', layout: false
        else
          super
        end
      }

      format.xlsx {
        send_file(resource.file_path, filename: resource.file_name, type: 'application/xlsx')
      }
    end
  end
  
end
