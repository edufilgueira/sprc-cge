class Transparency::Contracts::ManagementContractsController < TransparencyController
  include Transparency::Contracts::Contracts::BaseController
  include Transparency::Contracts::ManagementContracts::Breadcrumbs


  # Private

  private

  def resource_klass
    Integration::Contracts::ManagementContract
  end

  def transparency_id
    'contracts/management_contracts'
  end

  ## Spreadsheet

  def spreadsheet_download_prefix
    'contracts/management_contracts'
  end

  def spreadsheet_file_prefix
    :contratos_de_gestao
  end

  ## Stats

  def stats_klass
    Stats::Contracts::ManagementContract
  end

  def data_dictionary_file_management_contracts_path
    "#{dir_data_dictionary}#{data_dictionary_file_name}"    
  end

  def data_dictionary_file_name
    'dicionario_dados_contratos_gestao_ct.xlsx'
  end

end
