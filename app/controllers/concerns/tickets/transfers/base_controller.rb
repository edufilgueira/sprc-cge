module ::Tickets::Transfers::BaseController
  extend ActiveSupport::Concern

  def register_log_and_redirect_to_index
    register_log
    redirect_to operator_tickets_path, notice: t('.done')
  end

  def set_error
    flash.now[:alert] = t('.error')
  end

end
