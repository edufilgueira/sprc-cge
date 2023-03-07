class Integration::Servers::ProceedType < ApplicationDataRecord

  validates :cod_provento,
    :dsc_provento,
    :dsc_tipo,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.sorted
    order(cod_provento: :asc)
  end


  ## Instance methods

  ### Helpers

  def title
    dsc_provento
  end

end
