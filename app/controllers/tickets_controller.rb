class TicketsController < ApplicationController
  include Tickets::Breadcrumbs
  include Tickets::BaseController

  before_action :change_true_unknown_subnet, only: [:create], if: :has_not_subnet?

  # Action

  def create
    @unknown_topic = params[:unknown_topic] == '1'
    @unknown_denunciation_topic = params[:unknown_denunciation_topic] == '1'
    @unknown_denunciation_organ = params[:unknown_denunciation_organ] == '1'
    @only_denunciation = true if params[:only_denunciation] == '1'

    super do
      sign_in(ticket)
      update_created_ticket_status_and_child
    end
  end

  # Private

  private

  def has_not_subnet?
    !resource.subnet_id.present?
  end

  def change_true_unknown_subnet
    resource.unknown_subnet = true
  end

  def resource_save
    human? && resource.save
  end

  def human?
    verify_recaptcha(model: resource, attribute: :recaptcha)
  end

  def new_resource
    new_ticket = Ticket.new(resource_params)

    if params[:ticket_type] == 'denunciation'
      new_ticket.ticket_type = 'sou'
      new_ticket.sou_type = :denunciation

      @only_denunciation = true
    else
      new_ticket.ticket_type = (params[:ticket_type] || new_ticket.ticket_type)
    end

    new_ticket.anonymous = false if new_ticket.sic?
    new_ticket
  end

  def redirect_to_show_with_success
    redirect_to ticket_area_ticket_path(resource)
  end
end
