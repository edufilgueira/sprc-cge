class Integration::Purchases::Purchase < ApplicationDataRecord
  include ::Integration::Purchases::Purchase::Search
  include ::Sortable

  # SPRC-DATA Associations

  belongs_to :manager,
    class_name: 'Integration::Supports::ManagementUnit'

  # SPRC-DATA Validations

  ## Presence

  validates :numero_publicacao,
            :numero_viproc,
            :num_termo_participacao,
            :codigo_item,
            presence: true

  # Callbacks

  after_validation :set_valor_total_calculated


  # Sortable

  def self.default_sort_column
    'integration_purchases_purchases.numero_publicacao'
  end

  def self.default_sort_direction
    :desc
  end

  # SPRC-DATA methods
  def self.active_on_month(date)
    beginning_of_month = date.beginning_of_month
    end_of_month = date.end_of_month

    where("DATE(data_publicacao) >= :beginning_of_month AND DATE(data_publicacao) <= :end_of_month", beginning_of_month: beginning_of_month, end_of_month: end_of_month)
  end

  # SPRC methods
  def self.data_publicacao_in_range(start_date, end_date)
    where(data_publicacao: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def self.data_finalizada_in_range(start_date, end_date)
    where(data_finalizada: (start_date.beginning_of_day..end_date.end_of_day))
  end

  def title
    descricao_item
  end

  # private

  private

  def set_valor_total_calculated
    self.valor_total_calculated = quantidade_estimada.to_f * valor_unitario.to_f
  end
end
