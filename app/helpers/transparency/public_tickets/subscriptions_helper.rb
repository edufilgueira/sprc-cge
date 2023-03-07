module Transparency::PublicTickets::SubscriptionsHelper

  def subscriptions_create_edit_path(ticket, user)
    return create_path(ticket) if user.blank?

    ticket_subscription = TicketSubscription.find_by(ticket_id: ticket, user: user)

    return edit_path(ticket, ticket_subscription) if ticket_subscription.present?

    create_path(ticket)
  end

  private

  def create_path(ticket)
    new_transparency_public_ticket_subscription_path(ticket)
  end

  def edit_path(ticket, ticket_subscription)
    edit_transparency_public_ticket_subscription_path(ticket, ticket_subscription)
  end
end
