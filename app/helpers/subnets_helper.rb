module SubnetsHelper
  def subnets_for_select
    subnet_map_with_title(Subnet)
  end

  def subnets_by_organ_for_select(organ)
    subnet_map_with_title(subnet_by_organ(organ))
  end

  def subnet_by_organ(organ)
    Subnet.from_organ(organ)
  end

  private

  def subnet_title(subnet)
    "[#{subnet.organ_acronym}] #{subnet.acronym} - #{subnet.name}"
  end

  def sorted_subnets(scope)
    scope.enabled.sorted
  end


  def subnet_map_with_title(scope)
    sorted_subnets(scope).map {|subnet| [subnet_title(subnet), subnet.id]}
  end
end
