class Integration::Utils::DataChange < ApplicationDataRecord

  # Associations

  belongs_to :changeable, polymorphic: true


  # Enumarations

  enum resource_status: [
    :new_resource_notificable,        # Novo recurso recém criado que pode podem gerar notificação
    :updated_resource_notificable,    # Recurso recém com attribs atualizado que podem gerar notificação
    :resource_notified                # O serviço gerou notificação do recurso e atualizou para este status
  ]


  # Validations

  validates :changeable_id,
    :changeable_type,
    presence: true

end
