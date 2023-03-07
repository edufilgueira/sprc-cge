module ::Tickets::Answers::BaseController
  extend ActiveSupport::Concern

  included do

    # "load_and_authorize_resource" não carrega stream
    # (IOError: closed stream) para nested de anexos do refile
    # É necessário separar e incluir exceção
    before_action :authorize_create_answer, only: :create

    load_and_authorize_resource except: :create

    helper_method [
      :ticket,
      :answer,
      :new_answer,
      :errors,
      :answer_form_url,
      :answer_organ,
      :reopen_ticket,

      :readonly?
    ]


    # Helper methods

    def answer
      resource
    end

    # É definido por cada controller que usa esse basecontroller para determinar
    # o ticket em questão. No caso do namespace 'ticket' é o próprio
    # current_ticket logado

    def ticket
    end

    # É definido por cada controller que usa esse basecontroller para determinar
    # a url de seu form de comentários.
    # Ex: [:ticket, answer], [:platform, ...]
    def answer_form_url
    end

    def created_by
      current_ticket || current_user
    end

    def answer_organ
      # a resposta pode ser enviada diretamento pela CGE sem encaminhamento
      @answer_organ = answer.ticket.organ || Organ.find_by(acronym: 'CGE')
    end

    def readonly?
      current_user.blank? && current_ticket.blank?
    end

    def new_answer
      @new_answer ||= Answer.new(ticket: ticket)
    end

    # Private
    #
    private

    def user_evaluation
      params[:evaluation]
    end

    def answer_ticket
      answer.ticket
    end

    def resource_klass
      Answer
    end

    def resource_params
      if params[:answer]
        params.require(:answer).permit(self.class::PERMITTED_PARAMS)
      end
    end

    def render_ticket_logs
      render partial: 'shared/tickets/ticket_logs'
    end

    def copy_answer_to_new_answer
      @new_answer = answer unless answer.persisted?
    end

    def authorize_create_answer
      authorize! :answer, ticket
    end
  end
end
