module Notifications::BaseController
  extend ActiveSupport::Concern
  include ::FilteredController
  include ::PaginatedController
  include ::SortedController

  PERMITTED_PARAMS = [:subject, :created_at, :show_only_unread]

  # O único filtro disponível é `show_only_unread`, que não é um atributo simples
  # para construção de query. Portando, usamos FILTERED_CUSTOM.
  # Assim, ele está implementado na sobrecarga do método padrão `#resources`.

  FILTERED_CUSTOM = [ :show_only_unread ]

  SORT_COLUMNS = [:subject, :created_at]

  PER_PAGE = 20

  included do
    helper_method [
      :notification,
      :notifications
    ]
  end

  ## actions
  #
  def show
    notification.mark_as_read(user)
  end

  def update
    notification.mark_as_unread(user)
    redirect_to_index
  end


  ## helper methods
  #
  def notification
    resource
  end

  def notifications
    paginated_resources
  end

  # privates

  private

  # override
  # Utilizando a classe específica do Mailboxer
  def resource_klass
    Mailboxer::Notification
  end

  # override
  # Escopando em notificações do usuário atual
  def resources
    @resources ||= user_notifications
  end

  # override
  def sorted_resources
    # Dado que o model é Mailboxer::Notification - e não inclui o concern Sortable - precisamos
    # sobrecarregar a ordenação.
    @sorted_resources ||= resources.reorder(sort_column => sort_direction)
  end

  # override
  def default_sort_column
    :created_at
  end

  # override
  def default_sort_direction
    :desc
  end

  def user_notifications
    @user_notifications ||= user.mailbox.notifications(read: show_only_read?)
  end

  def user
    current_user || current_ticket
  end

  def show_only_unread?
    params[:show_only_unread].to_s == 'true'
  end

  def show_only_read?
    ! show_only_unread?
  end
end
