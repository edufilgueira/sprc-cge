#
# Representa algum comentário no sistema, como respostas aos chamados,
# por exemplo.
#
# É polimórfico para ser reutilizado sempre que houver funcionalidades de
# comentários.
#

class Comment < ApplicationRecord

  # Setup

  acts_as_paranoid

  # Associations

  belongs_to :commentable, polymorphic: true
  belongs_to :author, polymorphic: true

  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :ticket_logs, as: :resource, dependent: :destroy
  # XXX simulando relação de `has_one :ticket_log` original, do Ticket exato onde o comentário foi feito.
  # Isso se faz necessário pois, caso criemos um comentário em um Ticket-filho, "duplicamos" um
  # TicketLog no Ticket-pai para que seja possível exibir o comentário no Ticket-pai.
  def ticket_log; ticket_logs.find_by(ticket: commentable) end

  # Delegations

  delegate :as_author, to: :author, allow_nil: true

  # Enums

  enum scope: [:internal, :external]

  # Attachments

  accepts_attachments_for :attachments, append: true

  # Nested

  accepts_nested_attributes_for :attachments,
    reject_if: :all_blank, allow_destroy: true

  # Attributes

  attr_accessor :justification

  # Validations

  ## Presence

  validates :description,
    :commentable,
    :scope,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.sorted
    order(:created_at)
  end
end
