class Integration::BaseDataChange < ApplicationDataRecord
  self.abstract_class = true

  # Associations

  has_one :utils_data_change, as: :changeable, class_name: 'Integration::Utils::DataChange'


  # Callbacks

  before_create :build_utils_last_change
  before_update :create_last_change


  # Delegations

  delegate :data_changes, to: :utils_data_change, allow_nil: true
  delegate :resource_status, to: :utils_data_change, allow_nil: true



  private

  # Instace methods

  def create_last_change
    return if changes_notificables.blank?

    build_utils_last_change if self.utils_data_change.blank?

    merged_changes_notificables = self.data_changes.present? ? self.data_changes.merge!(changes_notificables) : changes_notificables

    self.utils_data_change.update(data_changes: merged_changes_notificables, resource_status: :updated_resource_notificable)
  end

  def changes_notificables
    begin
      self.changes.slice(*self.class::NOTIFICABLE_CHANGED_ATTRIBUTES)
    rescue NameError
      []
    end
  end

  def build_utils_last_change
    self.build_utils_data_change
  end
end
