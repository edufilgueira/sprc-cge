#
# Serviço responsável pelo compartilhamento de tickets
#
# O serviço busca pelo ticket pai(matriz) a partir da referência que gera filhos
# Os filhos são gerados a partir das informações do pai e dos atributos dos filhos passados por parâmetro
#
#
# Exemplos comuns de uso:
# - Operador CGE compartilha um ticket pai com uma setorial
# - Ouvidor Setorial compartilha um ticket filho com outra setorial
#
#
# @params
# - ticket_id                :   ticket_id do pai ou filho para referência do compartilhamento
# - new_tickets_attributes   :   hash dos atributos dos novos tickets filhos
# - current_user_id          :   usuário que está realizando a ação de compartilhar
#
#
class Ticket::Sharing

  attr_accessor :ticket_parent, :tickets_attributes, :current_user, :tickets, :ticket_origin

  #
  # Ao criar um novo ticket filho muitas informações são herdadas do pai,
  # exceto estes atributos
  #
  REJECT_ATTRIBUTES = %w[
    id
    protocol
    parent_protocol
    parent_id
    created_by
    created_at
    organ_id
    unknown_organ
    unknown_classification
    subnet_id
    unknown_subnet
    description
    denunciation_description
    internal_status
    encrypted_password
    plain_password
    sou_type
    public_ticket
    published
  ]

  def initialize(ticket_id, new_tickets_attributes, current_user_id)
    @ticket_origin = Ticket.find(ticket_id)
    @ticket_parent = @ticket_origin.parent || @ticket_origin
    @tickets_attributes = new_tickets_attributes
    @current_user = User.find(current_user_id)
    @tickets = []
  end

  def self.call(ticket_id:, new_tickets_attributes:, current_user_id:)
    new(ticket_id, new_tickets_attributes, current_user_id).call
  end


  # privates

  def call
    share
  end

   def share
    ActiveRecord::Base.transaction do
      change_parent_status
      ticket_valid = create_tickets_children && ticket_parent.save
      if ticket_valid
        register_log
        notify
        clear_ticket_parent_classification
      end
      ticket_valid
    end
  end

  def validate_tickets_children
    tickets_attributes.values.all? do |child_attributes|
      child_ticket = build_ticket(child_attributes)
      child_ticket.assign_attributes(child_attributes)
      child_ticket.ticket_origin = @ticket_origin
      tickets << child_ticket

      child_ticket.valid?
    end
  end

  def create_tickets_children
    return unless validate_tickets_children

    tickets.each { |t| ticket_parent.tickets << t }

    true
  end

  def build_ticket(child_attributes)
    child_attributes['id'].present? ? Ticket.find(child_attributes['id']) : default_new_ticket_child(child_attributes)
  end

  def clear_ticket_parent_classification
    return unless ticket_parent.tickets.present?

    ticket_parent.classification&.destroy
  end

  def default_new_ticket_child(child_attributes)
    child_ticket = Ticket.new(permitted_parent_attributes)

    child_ticket.unknown_organ = false
    child_ticket.unknown_classification = true
    child_ticket.parent_id = ticket_parent
    child_ticket.created_by = current_user


    if child_attributes['subnet_id'].present?
      child_ticket.internal_status = :subnet_attendance
    else
      child_ticket.internal_status = :sectoral_attendance
    end

    child_ticket
  end

  def permitted_parent_attributes
    ticket_parent.attributes.except(*REJECT_ATTRIBUTES)
  end

  def change_parent_status
    return unless ticket_parent.waiting_referral?

    ticket_parent.internal_status = :sectoral_attendance
  end

  def register_log
    tickets_attributes.each { |_, v| register_child_log(v) }
  end

  def register_child_log(new_record)
    return if new_record['id'].present?

    organ = Organ.find(new_record['organ_id'])
    justification = new_record['justification']
    RegisterTicketLog.call(ticket_parent, current_user, :share, { description: justification, resource: organ })

    # registrando log quando a descrição da manifestação é alterada no ato do
    # encaminhanto para a Ouvidoria.
    if ticket_parent.denunciation? && (new_record['denunciation_description'] !=
      ticket_parent.denunciation_description)
      RegisterTicketLog.call(ticket_parent, current_user, :edit_ticket_description)
    end

  end

  def notify
    tickets_attributes.each do |_, v|
      next if v['id'].present?

      child = child(v['organ_id'])
      Notifier::Share.delay.call(child.id, current_user.id)
    end
  end

  def child(organ_id)
    ticket_parent.tickets.find_by(organ_id: organ_id) || ticket_parent
  end
end
