class Operator::Tickets::DenunciationClassificationsController < OperatorController

  before_action :can_classify_denunciation

  helper_method [:ticket]


  # Actions

  def update
    if ticket.update_column(:denunciation_against_operator, classification_param) && share_with_denunciation_commission
      redirect_to operator_ticket_path(ticket, anchor: 'tabs-classification'), notice: t('.done', acronym: params[:acronym])
    else
      redirect_to operator_ticket_path(ticket, anchor: 'tabs-classification'), alert: t('.error')
    end
  end


  # Helper methods

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end


  # privates

  private

  def classification_param
    params['denunciation_against_operator'] == 'true'
  end

  def can_classify_denunciation
    authorize! :classify_denunciation, ticket
  end

  def share_with_denunciation_commission
    params = {
      ticket_id: ticket.id,
      current_user_id: current_user.id,
      new_tickets_attributes: denunciation_commission_ticket_attributes
    }

    Ticket::Sharing.call(params)
  end

  #
  # Metódo responsável em montar os atributos do ticket filho herdando do pai
  # além de atribuir o órgão da comissão de denúncias no novo ticket filho
  #
  def denunciation_commission_ticket_attributes
    child_attributes = {}

    parent_attributes = ticket.attributes.symbolize_keys.slice(
      *Ticket::PERMITTED_PARAMS_FOR_SHARE
    ).as_json

    parent_attributes['id'] = nil

    parent_attributes['organ_id'] = ExecutiveOrgan.find_by(acronym: params[:acronym]).id

    child_attributes[0] = parent_attributes

    child_attributes
  end
end