module IntegrationSupportsOrgansHelper

  def supports_organs_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_organs(orgao_sfp).map do |organ|
      [ supports_organ_title(organ), organ.try(id_column) ]
    end
  end

  def supports_organs_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_organs_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.select.all'), ' '])
  end

  def supports_organs_from_executivo_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_organs_from_executivo(orgao_sfp).map do |organ|
      [ supports_organ_title(organ), organ.try(id_column) ]
    end
  end

  def supports_organs_from_executivo_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_organs_from_executivo_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.select.all'), ' '])
  end

  def supports_secretaries_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_secretaries(orgao_sfp).map do |secretary|
      [ supports_organ_title(secretary), secretary.try(id_column) ]
    end
  end

  def supports_secretaries_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_secretaries_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.secretary.select.all'), ' '])
  end

  def supports_secretaries_from_executivo_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_secretaries_from_executivo(orgao_sfp).map do |secretary|
      [ supports_organ_title(secretary), secretary.try(id_column) ]
    end
  end

  def supports_secretaries_from_executivo_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_secretaries_from_executivo_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.secretary.select.all'), ' '])
  end

  def supports_secretaries_for_select_with_all_option_codigo_orgao_as_id(orgao_sfp=false)
    supports_secretaries_for_select_with_all_option(orgao_sfp, :codigo_orgao)
  end

  def supports_organs_and_secretaries_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_organs_and_secretaries(orgao_sfp).map do |secretary|
      [ supports_organ_title(secretary), secretary.try(id_column) ]
    end
  end

  def supports_organs_and_secretaries_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_organs_and_secretaries_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.secretary_and_organ.select.all'), ' '])
  end

  def supports_organs_and_secretaries_for_select_with_all_option_codigo_orgao_as_id(orgao_sfp=false)
    supports_organs_and_secretaries_for_select_with_all_option(orgao_sfp, :codigo_orgao)
  end

  def supports_organs_and_secretaries_from_executivo_for_select(orgao_sfp=false, id_column=:id)
    sorted_supports_organs_and_secretaries_from_executivo(orgao_sfp).map do |secretary|
      [ supports_organ_title(secretary), secretary.try(id_column) ]
    end
  end

  def supports_organs_and_secretaries_from_executivo_for_select_with_all_option(orgao_sfp=false, id_column=:id)
    supports_organs_and_secretaries_from_executivo_for_select(orgao_sfp, id_column).insert(0, [I18n.t('organ.secretary_and_organ.select.all'), ' '])
  end

  def supports_organs_and_secretaries_from_executivo_for_select_with_all_option_codigo_orgao_as_id(orgao_sfp=false)
    supports_organs_and_secretaries_from_executivo_for_select_with_all_option(orgao_sfp, :codigo_orgao)
  end

  private

  def supports_organ_title(organ)
    "#{organ.acronym} - #{organ.title}"
  end

  def sorted_supports_organs(orgao_sfp)
    sorted_supports_organs_and_secretaries(orgao_sfp).where(secretary: false)
  end

  def sorted_supports_organs_from_executivo(orgao_sfp)
    sorted_supports_organs(orgao_sfp).where('poder': 'EXECUTIVO')
  end

  def sorted_supports_secretaries(orgao_sfp)
    sorted_supports_organs_and_secretaries(orgao_sfp).where(secretary: true)
  end

  def sorted_supports_organs_and_secretaries(orgao_sfp)
    # ordenação para select de usuário, diferente do sorted do model onde o padrão é por código
    Integration::Supports::Organ.where(orgao_sfp: orgao_sfp, data_termino: nil).order(:descricao_orgao)
  end

  def sorted_supports_organs_and_secretaries_from_executivo(orgao_sfp)
    sorted_supports_organs_and_secretaries(orgao_sfp).where('poder': 'EXECUTIVO')
  end

  def sorted_supports_secretaries_from_executivo(orgao_sfp)
    sorted_supports_secretaries(orgao_sfp).where('poder': 'EXECUTIVO')
  end
end
