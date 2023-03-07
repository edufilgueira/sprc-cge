module Extensions::BaseController
  extend ActiveSupport::Concern

  included do

    private

    def reject_params
      permitted_evaluation_params.merge({ status: :rejected })
    end

    def permitted_evaluation_params
      if params[:extension]
        params.require(:extension).permit(:justification)
      end
    end

    def ensure_justification_and_save
      ensure_justification && extension.update_attributes(reject_params)
    end

    def ensure_justification
      justification.present? || add_justification_error_and_return_false
    end

    def justification
      params[:extension][:justification] if params[:extension].present?
    end

    def add_justification_error_and_return_false
      extension.valid?
      extension.errors.add(:justification, :blank)

      false
    end

    def ticket_parent
      ticket.parent || ticket
    end

    def register_log
      data = { status: extension.status }
      RegisterTicketLog.call(ticket_parent, current_user, :extension, { resource: extension, data: data, description: justification })
    end
  end
end
