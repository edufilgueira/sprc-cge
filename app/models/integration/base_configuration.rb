class Integration::BaseConfiguration < ApplicationDataRecord
  self.abstract_class = true

  # Enums

  enum status: [:status_queued, :status_in_progress, :status_success, :status_fail]

  #  Associations

  has_one :schedule, as: :scheduleable

  # Nesteds

  accepts_nested_attributes_for :schedule, allow_destroy: true

  # Delegations

  delegate :cron_syntax_frequency, to: :schedule, allow_nil: true

  # Instace methods

  ## Helpers

  def title
    self.model_name.human
  end

  def status_str
    I18n.t("integration/base_configuration.statuses.#{status}")
  end

  def import
    importer_class.delay.call(self.id)
  end
end
