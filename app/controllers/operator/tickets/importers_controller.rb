class Operator::Tickets::ImportersController < TicketsController
    
  skip_before_action :verify_authenticity_token, :only => [:create]

  
  PERMITTED_TICKET_USER_PARAMS = [
    :name,
    :social_name,
    :gender,
    :document_type,
    :document,
    :email,
    :answer_phone,
    :answer_cell_phone,
    :city_id,
    :answer_address_street,
    :answer_address_number,
    :answer_address_neighborhood,
    :answer_address_complement,
    :answer_address_zipcode,
    :answer_twitter,
    :answer_facebook,
    :answer_instagram
  ]

  PERMITTED_TICKET_PARAMS = [
    :description,
    :sou_type,
    :organ_id,
    :unknown_organ,
    :subnet_id,
    :unknown_subnet,
    :status,
    :used_input,
    :public_ticket,
    :answer_type,
    :person_type,
    :protocol,
    :created_by_id,
    :answer_address_city_name,
    :plain_password,
    :password,
    :anonymous,
    :denunciation_organ_id,
    :denunciation_description,
    :denunciation_date,
    :denunciation_place,
    :denunciation_witness,
    :denunciation_evidence,
    :denunciation_assurance,
    :target_address_zipcode,
    :target_city_id,
    :target_address_street,
    :target_address_number,
    :target_address_neighborhood,
    :target_address_complement,

    attachments_attributes: [
      :id, :document, :_destroy
    ]
  ]

  PERMITTED_PARAMS = PERMITTED_TICKET_PARAMS + PERMITTED_TICKET_USER_PARAMS

  
  # Private

  private

  def resource_save
    resource.save
  end

end
