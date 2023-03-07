module Admin::Users::Filters
  include Admin::FilterDisabled

  FILTERED_ENUMS = [
    :user_type,
    :operator_type,
    :person_type
  ]

  FILTERED_ASSOCIATIONS = [
    :organ
  ]

  def filtered_resources
    # Filtro 'Apenas triagem de denúncias'
    # desconsidera qualquer outro tipo de filtro e lista apenas este perfil
    return filtered_only_denunciation_tracking if params[:denunciation_tracking] == 'true'

    # Filtro 'Apenas rede ouvir'
    return filtered_only_rede_ouvir if params[:rede_ouvir] == 'true'    
    filtered = sorted_resources

    filtered = filtered_by_disabled(filtered)

    filtered(User, filtered)
  end

  def filtered_only_denunciation_tracking
    sorted_resources.where(denunciation_tracking: true)
  end

  def filtered_only_rede_ouvir
    sorted_resources.where(rede_ouvir: true)
  end
end