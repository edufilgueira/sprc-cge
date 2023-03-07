class Transparency::Covid19::GasVouchersController < TransparencyController
  include Transparency::BaseController

  
  FILTERED_COLUMNS = [ :cpf ]

  SORT_COLUMNS = [ :cpf ]

  PER_PAGE = 1

  helper_method [
    :transparency_id,
    :xlsx_download_path,
    :csv_download_path,
    :gas_vouchers
  ]

  def gas_vouchers
    filtered_resources
  end


  def javascript
    "views/#{controller_path}/#{action_name}"
  end

  def controller_base_view_path
    controller_path
  end

  def transparency_id
    :gas_vouchers
  end

  def xlsx_download_path
    download_path(:xls)   
  end

  def csv_download_path
    download_path(:csv)
  end

  def download_path(type)
    download_path = "/files/downloads/gas_voucher/lista_beneficiarios.#{type.to_s}"
    file_path = Rails.root.join('public', 'files', 'downloads', 'gas_voucher', "lista_beneficiarios.#{type.to_s}")
    File.exists?(file_path) ? download_path : nil
  end

  def default_sort_scope
    resource_klass
  end

  private

  def resource_klass
    GasVoucher
  end

  def data_dictionary_file_gas_vouchers_path
    "#{dir_data_dictionary}#{data_dictionary_file_name}"
  end

  def data_dictionary_file_name
    'dicionario_dados_gas_vouchers_ct.xlsx'
  end

end