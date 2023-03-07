module OrgansHelper
  def organs_for_select
    sorted_organs.map {|organ| [organ_title(organ), organ.id]}
  end

  def current_user_organ_for_select
    [[organ_title(current_user.organ), current_user.organ.id]]
  end

  def organ_associations_for_select
    organ_associations_user.map {|organ| [organ_title(organ.organ_association), organ.organ_association.id]}
  end

  def organ_and_organ_associations_for_select
    (current_user_organ_for_select + organ_associations_for_select).sort_by { |k, v| v }
  end

  def organs_rede_ouvir_for_select
    sorted_rede_ouvir_organs.map {|rede_ouvir| [rede_ouvir_title(rede_ouvir), rede_ouvir.id]}
  end

  def organs_to_share_for_select_with_subnet_info(ticket)
    return [] if ticket.blank?

    if ticket.organ&.subnet? && !Ticket.within_share_deadline?(ticket.confirmed_at)
      [[organ_title(ticket.organ), ticket.organ_id, 'data-subnet': ticket.organ.subnet]]
    else
      organs_for_select_with_subnet_info
    end
  end

  def organs_for_select_with_subnet_info
    sorted_organs.map {|organ| [organ_title(organ), organ.id, 'data-subnet': organ.subnet, 'data-topic': true]}
  end

  def organs_for_select_with_all_option
    organs_for_select.insert(0, [I18n.t('organ.select.all'), ' '])
  end

  def acronym_organs_list(ticket)
    return ticket.unit_full_acronym if ticket.child?

    ticket.tickets.map { |t| "#{t.unit_full_acronym}" }.reject(&:blank?).sort.join("; ")
  end

  def organs_from_parent_classification(ticket_parent)
    executive_organs = ticket_parent.children_from_executive_power

    return if executive_organs.blank?

    executive_organs.map do |child|
      [organ_title(child.organ), child.organ.id, 'data-url': url_classification(child)]
    end
  end

  private

  def organ_title(organ)
    "#{organ.acronym} - #{organ.name}"
  end

  def rede_ouvir_title(rede_ouvir)
    organ_title(rede_ouvir)
  end

  def share_to_couvi?
    can?(:share_to_couvi, Ticket)
  end

  def share_to_cosco?
    can?(:share_to_cosco, Ticket)
  end

  def sorted_organs
    hide_organs_from_list =
      if share_to_couvi? && share_to_cosco?
        []
      elsif share_to_couvi?
        [denunciation_commission_organ.id]
      elsif share_to_cosco?
        [ombudsman_coordination_organ.id]
      else
        [denunciation_commission_organ.id, ombudsman_coordination_organ.id]
      end

    ExecutiveOrgan.enabled.where.not(id: hide_organs_from_list).sorted
  end

  def organ_associations_user
    current_user.organ.organ_associations
  end

  def sorted_rede_ouvir_organs
    return RedeOuvirOrgan.enabled.sorted
  end

  # COSCO
  def denunciation_commission_organ
    ExecutiveOrgan.denunciation_commission
  end

  # Couvi
  def ombudsman_coordination_organ
    ExecutiveOrgan.ombudsman_coordination
  end

  def enable_to_show_denunciation_commission_organ?(current_user)
    current_user&.admin? || current_user&.cge? || denunciation_commission_organ.blank?
  end

  def url_classification(ticket)
    return new_operator_ticket_classification_path(ticket) unless ticket.classification.present?

    operator_ticket_classification_path(ticket, ticket.classification)
  end
end
