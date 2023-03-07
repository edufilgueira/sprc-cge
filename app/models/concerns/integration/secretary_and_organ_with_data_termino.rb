##
# Módulo incluído por models que se relacionam com órgão/secretarias de acordo
# com a data de término. Pois os órgãos vão mudando de nome e mantendo os códigos.
##
module Integration::SecretaryAndOrganWithDataTermino
  extend ActiveSupport::Concern

  def organ_with_data_termino(codigo_orgao)
    base_organ = Integration::Supports::Organ.where(codigo_orgao: codigo_orgao, orgao_sfp: false)
    organ_or_secretary_with_data_termino(base_organ)
  end

  def secretary_from_organ(organ)
    return nil if organ.blank?

    base_secretary = Integration::Supports::Organ.secretaries.where(codigo_entidade: organ.codigo_entidade, orgao_sfp: false)
    organ_or_secretary_with_data_termino(base_secretary)
  end

  def organ_or_secretary_with_data_termino(scope)
    if year.present? && (month.present? && month > 0)
      data_termino = Date.new(year, month).end_of_month

      data_termino_organ = scope.where('integration_supports_organs.data_termino >= ?', data_termino).first

      return data_termino_organ if data_termino_organ.present?
    end

    scope.first
  end
end
