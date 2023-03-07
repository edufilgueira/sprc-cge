#
# Representa a entidade de integração de Obras DAE
#
# Extende a classe (Integration::BaseDataChange) que registra as atualizações de atributos notificáveis ao cidadão
#
class Integration::Constructions::Dae < Integration::BaseDataChange
  include ::Integration::Constructions::Daes::Search
  include ::Sortable


  # Consts

  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :status,
    :valor,
    :data_fim_previsto,
    :prazo_inicial,
    :percentual_executado,
    :dias_aditivado,
    # Planilha de medição - callback em Constructions::Dae::Measurement
    # Fotos da Obra - callback em Constructions::Dae::Photo
  ]

  # Enums

  enum dae_status: [
    :waiting,
    :canceled,
    :done,
    :in_progress,
    :finished,
    :paused,
    :physical_progress_done
  ]

  # Validations

  ## Presence

  validates :id_obra,
    :descricao,
    presence: true

  belongs_to :organ, class_name: 'Integration::Supports::Organ'

  has_many :measurements,
  class_name: 'Integration::Constructions::Dae::Measurement',
  foreign_key: 'integration_constructions_dae_id'

  has_many :photos,
  class_name: 'Integration::Constructions::Dae::Photo',
  foreign_key: 'integration_constructions_dae_id'

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_constructions_daes.id_obra'
  end

  def self.default_sort_direction
    :desc
  end

  def self.data_inicio_in_range(start_date, end_date)
    where(data_inicio: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.data_fim_previsto_in_range(start_date, end_date)
    where(data_fim_previsto: (start_date.beginning_of_day..end_date.end_of_day))
  end

  ## Instance methods

  ### Helpers

  def title
    "#{codigo_obra} - #{descricao.to_s.truncate(30)}"
  end

  def dae_status_str
    I18n.t("integration/constructions/dae.dae_statuses.#{dae_status}")
  end

end
