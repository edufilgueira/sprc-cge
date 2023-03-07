class Transparency::Constructions::DersController < TransparencyController
  include Transparency::Constructions::Ders::BaseController
  include Transparency::Constructions::Ders::Breadcrumbs

  DERS_ATTRIBUTES = [
    :id,
    :construtora,
    :distrito,
    :programa,
    :servicos,
    :status,
    :trecho,
    :valor_aprovado,
    :latitude,
    :longitude
  ]

  helper_method [
    :coordinates
  ]

  # Helper methods

  def coordinates
    filtered_resources.select(DERS_ATTRIBUTES).where.
      not(latitude: [ nil, '0' ], longitude: [ nil, '0' ]).as_json
  end
end
