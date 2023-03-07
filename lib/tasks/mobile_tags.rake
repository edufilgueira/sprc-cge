#
# Rake para popular a lista de categorias de apps.
#
# É do tipo 'create_or_update' pois não destrói dados.
#

namespace :mobile_tags do
  task create_or_update: :environment do

    tags = [
      'Saúde',
      'Turismo',
      'Economia',
      'Tempo',
      'Cultura',
      'Educação',
      'Recursos Hídricos',
      'Trânsito',
      'Agricultura',
      'Inclusão Social',
      'Desenvolvimento Social',
      'Frutas e Verduras',
      'Negócios',
      'Segurança'
    ]

    tags.each do |tag|
      MobileTag.find_or_create_by(name: tag)
    end
  end
end
