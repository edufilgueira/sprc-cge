class Transparency::Contracts::FinancialsController < TransparencyController
  include Transparency::BaseController

  helper_method [
    :financials,
    :contract
  ]

  # Actions

  def index
    index_partial_view_path
  end

  def download
    respond_to do |format|
      format.xlsx {
        send_file(spreadsheet_file_path('xlsx'), filename: file_name('xlsx'), type: 'application/xlsx')
      }

      format.csv {
        send_file(spreadsheet_file_path('csv'), filename: file_name('csv'), type: 'application/csv')
      }
    end
  end


  # helper methods

  def financials
    paginated(resources)
  end

  def contract
    # unscoped pois pode ser contrato ou convênio
    @contract ||= Integration::Contracts::Contract.unscoped.find(params['id'])
  end


  # privates

  private

  # Override BaseController
  def index_partial_view_path
    render partial: 'shared/transparency/contracts/financials/index'
  end

  def resources
    Integration::Contracts::Financial.where(contract: contract).sorted
  end

  # @SPRC-DATA -> Métodos duplicados em: service/integration/contracts/financials/create_spreadsheet.rb
  def file_name(extension)
    "financial_#{contract.isn_sic}.#{extension}"
  end

  def spreadsheet_file_path(extension)
    "#{spreadsheet_dir_path}/#{file_name(extension)}"
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/financials"
  end
  # @SPRC-DATA -> Métodos duplicados em: service/integration/contracts/financials/create_spreadsheet.rb
end
