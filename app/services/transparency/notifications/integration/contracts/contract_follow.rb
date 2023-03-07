class Transparency::Notifications::Integration::Contracts::ContractFollow < Transparency::Notifications::BaseFollow

  attr_reader :contract

  def self.call(contract_id)
    new(contract_id).call
  end

  def initialize(contract_id)
    @contract = Integration::Contracts::Contract.find contract_id
  end

  def call
    return unless has_changes_and_followers?

    send_email

    update_resources
  end


  private

  def has_changes_and_followers?
    followers.present? &&

    (resource.data_changes.present? || financials_count > 0 || additives_count > 0 || adjustments_count > 0)
  end

  def resource
    contract
  end

  def subject
    I18n.t('transparency.notification.integration.contracts.contract_follow.subject')
  end

  def body(follower)
    title_body = I18n.t('transparency.notification.integration.contracts.contract_follow.body.title')

    description_body = I18n.t('transparency.notification.integration.contracts.contract_follow.body.description', description: contract.descricao_objeto)

    link_body = I18n.t('transparency.notification.integration.contracts.contract_follow.body.links', contract_url: contract_url, unsubscribe_url: unsubscribe_url(follower))

    "#{title_body} #{description_body} #{changed_attributes_body} #{associations_changed} #{link_body}"
  end

  def contract_url
    transparency_contracts_contract_url(contract)
  end

  def changed_attributes_body
    return if changes.blank?

    changes.map do |change|
      attribute = change.first
      type = Integration::Contracts::Contract.type_for_attribute(attribute).type

      name_changed =  Integration::Contracts::Contract.human_attribute_name(attribute)
      attr_origin  =  formatted_value(change.second[0], type)
      attr_changed =  formatted_value(change.second[1], type)

      I18n.t("transparency.notification.integration.contracts.contract_follow.body.attribute_changed",
        name_changed: name_changed, attr_origin: attr_origin, attr_changed: attr_changed)
    end.join(' ')
  end

  def associations_changed
    "#{financials_created} #{additives_created} #{adjustments_created}"
  end

  def financials_created
    return if financials_count < 1

    I18n.t("transparency.notification.integration.contracts.contract_follow.body.associations_changed.financials", count: financials_count)
  end

  def additives_created
    return if additives_count < 1

    I18n.t("transparency.notification.integration.contracts.contract_follow.body.associations_changed.additives", count: additives_count)
  end

  def adjustments_created
    return if adjustments_count < 1

    I18n.t("transparency.notification.integration.contracts.contract_follow.body.associations_changed.adjustments", count: adjustments_count)
  end

  def update_resources
    update_status(contract)

    financials.each { |financial| update_status(financial) }
    additives.each { |additive| update_status(additive) }
    adjustments.each { |adjustment| update_status(adjustment) }
  end

  def financials
    @financials ||= contract.financials.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def additives
    @additives ||= contract.additives.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def adjustments
    @adjustments ||= contract.adjustments.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def financials_count
    financials.count
  end

  def additives_count
    additives.count
  end

  def adjustments_count
    adjustments.count
  end
end
