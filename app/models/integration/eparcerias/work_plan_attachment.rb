class Integration::Eparcerias::WorkPlanAttachment < ApplicationDataRecord
  include Integration::Contracts::SubResource

  # Validations

  ## Presence

  validates :isn_sic,
    :file_name,
    :file_size,
    :file_type,
    presence: true

end
