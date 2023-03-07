module ServiceTypesHelper

  def service_type_by_id_for_select(service_type_id)
    service_type = ServiceType.find_by_id(service_type_id)

    return [] if service_type.nil?

    [[service_type.title, service_type.id]].to_h
  end
end
