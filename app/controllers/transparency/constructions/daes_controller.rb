class Transparency::Constructions::DaesController < TransparencyController
  include Transparency::Constructions::Daes::BaseController
  include Transparency::Constructions::Daes::Breadcrumbs

  DAES_ATTRIBUTES = [
    :id,
    :secretaria,
    :contratada,
    :descricao,
    :municipio,
    :status,
    :valor,
    :latitude,
    :longitude
  ]

  helper_method [
    :coordinates
  ]

  # Helper methods

  def coordinates
    filtered_resources.select(DAES_ATTRIBUTES).where.
      not(latitude: nil, longitude: nil).as_json
  end
end
