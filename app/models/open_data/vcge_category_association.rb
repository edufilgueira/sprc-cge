#
# Representa uma associação pai/filho para categoria VCGE.
# As categorias podem ter um ou mais pais e um ou mais filhos.
#
# Ver mais em: http://vocab.e.gov.br/id/governo
#

class OpenData::VcgeCategoryAssociation < ApplicationDataRecord

  # Associations

  belongs_to :parent, class_name: 'OpenData::VcgeCategory'
  belongs_to :child, class_name: 'OpenData::VcgeCategory'

  #  Validations

  ## Presence

  validates :parent,
    :child,
    presence: true
end
