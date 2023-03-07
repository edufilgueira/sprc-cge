#
# Serviço responsável por invocar a API de SPRC-Data
#
class Integration::Importers::Import
  attr_accessor :importer_id, :configuration_id

  def self.call(importer_id, configuration_id)
    new(importer_id, configuration_id).call
  end

  def call
    call_import_api
  end

  def initialize(importer_id, configuration_id)
    @importer_id = importer_id
    @configuration_id = configuration_id
  end

  private

  def call_import_api
    Net::HTTP.start(importer_url.host, importer_url.port, use_ssl: use_ssl) do |http|
      http.request(request)
    end
  end

  def importer_url
    URI.parse("#{sprc_data_host}/api/v1/importers")
  end

  def sprc_data_host
    ENV['SPRC_DATA_HOST'] || ''
  end

  def request
    request = Net::HTTP::Post.new(importer_url.path)
    request.form_data = {id: importer_id, configuration_id: configuration_id}
    request
  end

  def use_ssl
    (sprc_data_host =~ /https:/) == 0
  end
end
