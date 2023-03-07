module ProtectedAttachment
  extend ActiveSupport::Concern

  included do
    # Attributes
    attr_accessor :protected_attachment_ids, :ticket_origin

    #  Callbacks
    after_create :verify_ticket_atachment_protection
  end

  def has_attribute_protected_attachment attachment_id
    protected_attachment_ids.map(&:to_i).include?(attachment_id) if protected_attachment_ids.present?
  end

  ## Helpers
  def verify_ticket_atachment_protection
    create_ticket_attachment_protection(protected_attachment_ids) if protected_attachment_ids.present?
    create_ticket_attachment_protection(
      ticket_origin.ticket_protect_attachments.pluck(:attachment_id)
    ) if ticket_origin and ticket_origin.ticket_protect_attachments.present?
  end

  def create_ticket_attachment_protection(protected_attachment_ids)
    protected_attachment_ids.each do |attachment_id|
      protect_attachment = ticket_protect_attachments.find_or_initialize_by(attachment_id: attachment_id)
      if protect_attachment.new_record?
        protect_attachment.user = @current_user
        protect_attachment.save
      end
    end
  end
end
