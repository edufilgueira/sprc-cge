module ::Tickets::Comments::BaseController
  extend ActiveSupport::Concern

  PERMITTED_PARAMS = [
    :description,
    :commentable_type,
    :commentable_id,
    :scope,

    attachments_attributes: [
      :document
    ]
  ]

  included do

    helper_method [
      :ticket,
      :comment,
      :new_comment,
      :comment_form_url,

      :readonly?
    ]

    before_action :ensure_ticket_scope, :assign_author, :can_create_public_comment,
      :clone_attachments

    def create
      comment.commentable = ticket_parent if comment.external?

      register_logs if comment.save

      copy_comment_to_new_comment

      render_comments

      notify
    end

    def comment
      resource
    end

    # É definido por cada controller que usa esse basecontroller para determinar
    # o ticket em questão. No caso do namespace 'ticket' é o próprio
    # current_ticket logado

    def ticket
      @ticket ||= resource.commentable
    end

    # É definido por cada controller que usa esse basecontroller para determinar
    # a url de seu form de comentários.
    # Ex: [:ticket, comment], [:platform, ...]
    def comment_form_url
    end

    def new_comment
      @new_comment ||= Comment.new(commentable: ticket)
    end

    def readonly?
      created_by.blank?
    end

    def ticket_parent
      ticket.parent || ticket
    end

    protected

    def assign_author
      # XXX definindo o autor do comentário, com as especificidades necessárias
      comment.author = created_by
    end

    private

    def resource_klass
      Comment
    end

    def resource_params
      if params[:comment]
        params.require(:comment).permit(self.class::PERMITTED_PARAMS)
      end
    end

    def render_comments
      comment.internal? ? render_internal_comments : render_external_comments
    end

    def render_internal_comments
      render partial: 'shared/tickets/comments'
    end

    def render_external_comments
      render partial: 'shared/tickets/public_comments'
    end

    def copy_comment_to_new_comment
      @new_comment = comment unless comment.persisted?
    end

    def register_logs
      register_log(ticket, created_by, :comment, comment)
      register_attachments_log(ticket, created_by, comment)

      register_parent_log(created_by) if ticket.child?
    end


    def register_parent_log(created_by)
      register_log(ticket.parent, created_by, :comment, comment)

      register_attachments_log(ticket.parent, created_by, comment)
    end

    def register_attachments_log(ticket, created_by, comment)
      comment.attachments.each do |attachment|
        register_log(ticket, created_by, :create_attachment, attachment)
      end
    end

    def register_log(ticket, created_by, action, resource)
      RegisterTicketLog.call(ticket, created_by, action, { resource: resource })
    end

    def created_by
      current_ticket || current_user
    end

    def notify
      return unless comment.persisted?

      user_id = user.try(:id)
      comment_id = comment.id

      if comment.internal?
        Notifier::InternalComment.delay.call(comment_id, user_id)
      else
        Notifier::UserComment.delay.call(comment_id, user_id)
      end
    end

    def user
      current_user
    end

    def ensure_ticket_scope
      comment.scope = :external if current_ticket.present? ||
        (current_user.present? && current_user.user?)
    end

    def can_create_public_comment
      authorize! :create_public_comment, ticket if comment.external?
    end

    def clone_attachments
      return unless params[:clone_attachments].present?

      params[:clone_attachments].each do |attachment_id|
        existent = Attachment.find(attachment_id)
        comment.attachments << existent.dup
      end
    end
  end
end
