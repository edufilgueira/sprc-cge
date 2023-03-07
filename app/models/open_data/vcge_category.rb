#
# Representa uma categoria VCGE
#
# Ver mais em: http://vocab.e.gov.br/id/governo
#

class OpenData::VcgeCategory < ApplicationDataRecord

  # Associations

  has_many :child_associations, class_name: 'OpenData::VcgeCategoryAssociation', foreign_key: 'parent_id', dependent: :destroy
  has_many :children, through: :child_associations

  has_many :parent_associations, class_name: 'OpenData::VcgeCategoryAssociation', foreign_key: 'child_id', dependent: :destroy
  has_many :parents, through: :parent_associations

  has_many :data_set_vcge_categories, class_name: 'OpenData::DataSetVcgeCategory', foreign_key: 'data_set_vcge_category_id', dependent: :destroy

  #  Validations

  ## Presence

  validates :title,
    :href,
    :name,
    :vcge_id,
    presence: true

  ## Uniqueness

  validates :vcge_id,
    uniqueness: true

end
