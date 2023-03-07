#
# Representa uma associação dos conjuntos de dados (OpenData::DataSet)
# com as categories VCGE (OpenData::VcgeCategory).
#
# Ver mais em: http://vocab.e.gov.br/id/governo
#

class OpenData::DataSetVcgeCategory < ApplicationDataRecord
   # Associations

  belongs_to :data_set, class_name: 'OpenData::DataSet', foreign_key: :open_data_data_set_id
  belongs_to :vcge_category, class_name: 'OpenData::VcgeCategory', foreign_key: :open_data_vcge_category_id

  #  Validations

  ## Presence

  validates :data_set,
    :vcge_category,
    presence: true

end
