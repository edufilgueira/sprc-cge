class Integration::Eparcerias::Configuration < Integration::BaseConfiguration

  # Enums

  enum import_type: [:import_all, :import_active]

  #  Validations

  ## Presence

  validates :wsdl,
    :user,
    :password,
    :schedule,
    presence: true

  validates :transfer_bank_order_operation,
    :transfer_bank_order_response_path,
    :work_plan_attachment_operation,
    :work_plan_attachment_response_path,
    :accountability_operation,
    :accountability_response_path,
    presence: true

end
