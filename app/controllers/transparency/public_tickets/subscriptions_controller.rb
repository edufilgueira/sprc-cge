class Transparency::PublicTickets::SubscriptionsController < TransparencyController
  include Transparency::PublicTickets::Subscriptions::Breadcrumbs

  PERMITTED_PARAMS = [:email]

  FIND_ACTIONS = FIND_ACTIONS + ['unsubscribe', 'confirmation']

  helper_method :ticket_subscription, :email, :ticket

  def create

    return render :new if current_user.blank? && !human?

    ticket_subscription = build_ticket_subscription

    if ticket_subscription.save
      send_confirmation_email(ticket_subscription.id)
      redirect_create_update
    else
      flash_message = t('.fail')
      flash_message = unique_error_flow if unique_error?(ticket_subscription)

      flash.now[:alert] = flash_message
      render :new
    end
  end

  def confirmation
    if ticket_subscription_confirmation
      ticket_subscription_confirmation.confirm!

      redirect_success_token(ticket_subscription_confirmation.ticket)
    else
      redirect_error_token
    end
  end

  def unsubscribe
    if ticket_subscription_unfollow
      ticket = ticket_subscription_unfollow.ticket

      ticket_subscription_unfollow.destroy

      redirect_success_token(ticket)
    else
      redirect_error_token
    end
  end

  def ticket_subscription
    @ticket_subscription ||= create_or_find_ticket_subscription
  end

  def email
    current_user.email if current_user.present?
  end

  def ticket
    @ticket ||= Ticket.find(param_public_ticket_id)
  end

  private

  def resource_params
    if params[:ticket_subscription]
      params.require(:ticket_subscription).permit(PERMITTED_PARAMS)
    end
  end

  def create_or_find_ticket_subscription
    if current_user.present?
      TicketSubscription.where(ticket_id: param_public_ticket_id, user: current_user).first_or_initialize
    else
      TicketSubscription.new(ticket_id: param_public_ticket_id)
    end
  end

  def ticket_subscription_confirmation
    @ticket_subscription_confirmation ||= TicketSubscription.find_by(token: token, confirmed_email: false)
  end

  def ticket_subscription_unfollow
    @ticket_subscription_unfollow ||= TicketSubscription.find_by(token: token, confirmed_email: true)
  end

  def token
    params[:token]
  end

  def build_ticket_subscription
    ticket_subscription = TicketSubscription.new(ticket_id: param_public_ticket_id, user: current_user)
    ticket_subscription.email = resource_params[:email]
    ticket_subscription.token = Devise.friendly_token[0,20]
    ticket_subscription
  end

  def resource_name
    'ticket_subscription'
  end

  def human?
    verify_recaptcha(model: ticket_subscription, attribute: :recaptcha)
  end

  def param_public_ticket_id
    params[:public_ticket_id]
  end

  def send_confirmation_email(ticket_subscription_id)
    TicketMailer.subscription_confirmation(ticket_subscription_id).deliver_later
  end

  def redirect_create_update
    redirect_to transparency_public_ticket_path(ticket), notice: t('.done')
  end

  def redirect_error_token
    redirect_to transparency_public_tickets_path, notice: t('.fail')
  end

  def redirect_success_token(ticket)
    redirect_to transparency_public_ticket_path(ticket), notice: t(".done.#{ticket.ticket_type}", protocol: ticket.protocol)
  end

  def unique_error_flow
    ticket_subscription = TicketSubscription.find_by(ticket_id: param_public_ticket_id, email: resource_params[:email])
    confirmed = ticket_subscription.confirmed_email

    send_confirmation_email(ticket_subscription.id) unless confirmed
    return unique_error_flash(confirmed)
  end

  def unique_error?(ticket_subscription)
    ticket_subscription.errors.added? :email, :taken
  end

  def unique_error_flash(confirmed_email)
    return t('.was_created.already_following') if confirmed_email

    t('.was_created.unconfirmed')
  end
end
