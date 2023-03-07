class Transparency::ServerSalariesController < TransparencyController
  include Transparency::ServerSalaries::BaseController
  include Transparency::ServerSalaries::Breadcrumbs

  def show
    if print?
      render template: 'shared/transparency/server_salaries/print', layout: 'print'
      return
    end

    super
  end

  def data_dictionary_file_server_salaries_path
  	"#{dir_data_dictionary}#{data_dictionary_file_name}"
	end

	def data_dictionary_file_name
	  'dicionario_dados_servidores_ct.xlsx'
	end	
end
