class Transparency::Export::IntegrationRealStatesRealStatePresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :service_id,
    :descricao_imovel,
    :property_type_title,
    :occupation_type_title,
    :estado,
    :municipio,
    :area_projecao_construcao,
    :area_medida_in_loco,
    :area_registrada,
    :frente,
    :fundo,
    :lateral_direita,
    :lateral_esquerda,
    :taxa_ocupacao,
    :fracao_ideal,
    :numero_imovel,
    :utm_zona,
    :bairro,
    :cep,
    :endereco,
    :complemento,
    :lote,
    :quadra
  ].freeze


  private

  def self.spreadsheet_header_title(column)
    Integration::RealStates::RealState.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
