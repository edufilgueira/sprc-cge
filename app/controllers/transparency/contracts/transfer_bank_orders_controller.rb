class Transparency::Contracts::TransferBankOrdersController < TransparencyController
  include Transparency::BaseController

  helper_method [
    :transfer_bank_orders,
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

  def transfer_bank_orders
    paginated(resources)
  end

  def contract
    @contract ||= Integration::Contracts::Convenant.find(params['id'])
  end


  # privates

  private

  # Override BaseController
  def index_partial_view_path
    render partial: 'shared/transparency/contracts/transfer_bank_orders/index'
  end

  def resources
    Integration::Eparcerias::TransferBankOrder.where(contract: contract).sorted
  end

  # @SPRC-DATA -> Métodos duplicados em: service/integration/eparcerias/transfer_bank_orders/create_spreadsheet.rb
  def file_name(extension)
    "transfer_bank_order_#{contract.isn_sic}.#{extension}"
  end

  def spreadsheet_file_path(extension)
    "#{spreadsheet_dir_path}/#{file_name(extension)}"
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/contracts/convenants/transfer_bank_orders"
  end
  # @SPRC-DATA -> Métodos duplicados em: service/integration/eparcerias/transfer_bank_orders/create_spreadsheet.rb
end
