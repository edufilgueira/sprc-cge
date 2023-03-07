class Transparency::Notifications::Integration::Contracts::ManagementContractFollow < Transparency::Notifications::BaseFollow
  attr_reader :management_contract

  def self.call(management_contract_id)
    new(management_contract_id).call
  end

  def initialize(management_contract_id)
    @management_contract = Integration::Contracts::ManagementContract.find management_contract_id
  end

  def call
    return unless has_changes_and_followers?

    send_email

    update_resources
  end


  private

  def has_changes_and_followers?
    followers.present? &&

    (
      resource.data_changes.present? ||
      financials_count > 0 ||
      additives_count > 0 ||
      adjustments_count > 0
    )
  end

  def resource
    management_contract
  end

  def subject
    I18n.t('transparency.notification.integration.contracts.management_contract_follow.subject')
  end

  def body(follower)
    title_body = I18n.t('transparency.notification.integration.contracts.management_contract_follow.body.title')

    description_body = I18n.t('transparency.notification.integration.contracts.management_contract_follow.body.description', description: management_contract.descricao_objeto)

    link_body = I18n.t('transparency.notification.integration.contracts.management_contract_follow.body.links', management_contract_url: management_contract_url, unsubscribe_url: unsubscribe_url(follower))

    "#{title_body} #{description_body} #{changed_attributes_body} #{associations_changed} #{link_body}"
  end

  def management_contract_url
    transparency_contracts_management_contract_url(management_contract)
  end

  def changed_attributes_body
    return if changes.blank?

    changes.map do |change|
      attribute = change.first
      type = Integration::Contracts::ManagementContract.type_for_attribute(attribute).type

      name_changed =  Integration::Contracts::ManagementContract.human_attribute_name(attribute)
      attr_origin  =  formatted_value(change.second[0], type)
      attr_changed =  formatted_value(change.second[1], type)

      I18n.t("transparency.notification.integration.contracts.management_contract_follow.body.attribute_changed",
        name_changed: name_changed, attr_origin: attr_origin, attr_changed: attr_changed)
    end.join(' ')
  end

  def associations_changed
    "#{financials_created} #{additives_created} #{adjustments_created}"
  end

  def financials_created
    return if financials_count < 1

    I18n.t("transparency.notification.integration.contracts.management_contract_follow.body.associations_changed.financials", count: financials_count)
  end

  def additives_created
    return if additives_count < 1

    I18n.t("transparency.notification.integration.contracts.management_contract_follow.body.associations_changed.additives", count: additives_count)
  end

  def adjustments_created
    return if adjustments_count < 1

    I18n.t("transparency.notification.integration.contracts.management_contract_follow.body.associations_changed.adjustments", count: adjustments_count)
  end

  def update_resources
    update_status(management_contract)

    financials.each { |financial| update_status(financial) }
    additives.each { |additive| update_status(additive) }
    adjustments.each { |adjustment| update_status(adjustment) }
  end

  def financials
    @financials ||= management_contract.financials.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def additives
    @additives ||= management_contract.additives.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def adjustments
    @adjustments ||= management_contract.adjustments.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
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
