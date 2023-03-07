class Api::V1::TicketBaseSerializer < ActiveModel::Serializer

  MAX_DESCRIPTION_SIZE_FOR_INDEX = 50

  HIDDEN_FOR_INDEX = [
    :document_type,
    :document,
    :person_type,
    :name,
    :email,

    :organ_acronym,
    :organ_name,
    :unknown_organ,

    :answer_type,
    :answer_phone,
    :answer_cell_phone,
    :city_title,
    :answer_address_street,
    :answer_address_number,
    :answer_address_zipcode,
    :answer_address_complement,
    :answer_address_neighborhood,
    :answer_twitter,
    :answer_facebook,
    :answer_instagram,

    :status,
    :confirmed_at,

    :used_input,

    :anonymous,

    :denunciation_organ_id,
    :denunciation_description,
    :denunciation_date,
    :denunciation_place,
    :denunciation_witness,
    :denunciation_evidence,
    :denunciation_assurance,

    :attachments,
    :comments
  ]

  INDEX_ATTRIBUTES = [
    :id,
    :description,
    :ticket_type,
    :sou_type,
    :parent_protocol,
    :created_at,
    :internal_status,
    :internal_status_str
  ]

  TICKET_ATTRIBUTES = INDEX_ATTRIBUTES + HIDDEN_FOR_INDEX

  attributes TICKET_ATTRIBUTES


  attribute :attachments do
    include_attachments
  end

  attribute :comments do
    include_comments
  end


  def attributes(*args)
    hash = super
    action_index? ? index_attributes(hash) : hash
  end

  def index_attributes(hash)
    HIDDEN_FOR_INDEX.each { |key| hash.delete(key) }
    hash
  end

  def description
    description = ticket.description
    return description.truncate(MAX_DESCRIPTION_SIZE_FOR_INDEX) if action_index? && description.present?
    description
  end

  def created_at
    ticket.created_at.to_formatted_s(:iso8601)
  end

  def confirmed_at
    ticket.confirmed_at.to_formatted_s(:iso8601) if ticket.confirmed_at.present?
  end


  private

  def ticket
    object
  end

  def action_index?
    instance_options[:action_index] == true
  end

  def include_attachments
    ticket = object.parent || object
    ticket.attachments.map do |attachment|
      {
        id: attachment.id,
        url: attachment.url
      }
    end
  end

  def include_comments
    ticket.comments.map do |comment|
      {
        id: comment.id,
        author: comment.as_author,
        description: comment.description,
        created_at: comment.created_at.to_formatted_s(:iso8601)
      }
    end
  end

end
