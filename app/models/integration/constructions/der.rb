#
# Representa a entidade de integração de Obras DER
#
# Extende a classe (Integration::BaseDataChange) que registra as atualizações de atributos notificáveis ao cidadão
#
class Integration::Constructions::Der < Integration::BaseDataChange
  include ::Integration::Constructions::Ders::Search
  include ::Sortable

  NOTIFICABLE_CHANGED_ATTRIBUTES = [
    :status,
    :valor_atual,
    :data_fim_previsto,
    :dias_adicionado,
    :dias_suspenso,
    :percentual_executado,
    :conclusao
    # Planilha de medição - callback em Constructions::Dae::Measurement
  ]

  # Enums

  enum der_status: [
    :canceled,
    :done,
    :in_progress,
    :in_project,
    :in_bidding,
    :not_started,
    :paused,
    :project_done,
    :bid
  ]

  # Validations

  ## Presence

  validates :id_obra,
    :servicos,
    presence: true

  has_many :measurements,
  class_name: 'Integration::Constructions::Der::Measurement',
  foreign_key: 'integration_constructions_der_id'


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_constructions_ders.id_obra'
  end

  def self.default_sort_direction
    :desc
  end

  def self.data_fim_contrato_in_range(start_date, end_date)
    where(data_fim_contrato: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.data_fim_previsto_in_range(start_date, end_date)
    where(data_fim_previsto: (start_date.beginning_of_day..end_date.end_of_day))
  end


  ## Instance methods

  ### Helpers

  def title
    "#{id_obra.to_s} - #{servicos&.truncate(30)}"
  end

  def der_status_str
    I18n.t("integration/constructions/der.der_statuses.#{der_status}")
  end

end
