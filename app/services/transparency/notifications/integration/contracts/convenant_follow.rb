class Transparency::Notifications::Integration::Contracts::ConvenantFollow < Transparency::Notifications::BaseFollow
  attr_reader :convenant

  def self.call(convenant_id)
    new(convenant_id).call
  end

  def initialize(convenant_id)
    @convenant = Integration::Contracts::Convenant.find convenant_id
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
      adjustments_count > 0 ||
      transfer_bank_orders_count > 0
    )
  end

  def resource
    convenant
  end

  def subject
    I18n.t('transparency.notification.integration.contracts.convenant_follow.subject')
  end

  def body(follower)
    title_body = I18n.t('transparency.notification.integration.contracts.convenant_follow.body.title')

    description_body = I18n.t('transparency.notification.integration.contracts.convenant_follow.body.description', description: convenant.descricao_objeto)

    link_body = I18n.t('transparency.notification.integration.contracts.convenant_follow.body.links', convenant_url: convenant_url, unsubscribe_url: unsubscribe_url(follower))

    "#{title_body} #{description_body} #{changed_attributes_body} #{associations_changed} #{link_body}"
  end

  def convenant_url
    transparency_contracts_convenant_url(convenant)
  end

  def changed_attributes_body
    return if changes.blank?

    changes.map do |change|
      attribute = change.first
      type = Integration::Contracts::Convenant.type_for_attribute(attribute).type

      name_changed =  Integration::Contracts::Convenant.human_attribute_name(attribute)
      attr_origin  =  formatted_value(change.second[0], type)
      attr_changed =  formatted_value(change.second[1], type)

      I18n.t("transparency.notification.integration.contracts.convenant_follow.body.attribute_changed",
        name_changed: name_changed, attr_origin: attr_origin, attr_changed: attr_changed)
    end.join(' ')
  end

  def associations_changed
    "#{financials_created} #{additives_created} #{adjustments_created}"
  end

  def financials_created
    return if financials_count < 1

    I18n.t("transparency.notification.integration.contracts.convenant_follow.body.associations_changed.financials", count: financials_count)
  end

  def additives_created
    return if additives_count < 1

    I18n.t("transparency.notification.integration.contracts.convenant_follow.body.associations_changed.additives", count: additives_count)
  end

  def adjustments_created
    return if adjustments_count < 1

    I18n.t("transparency.notification.integration.contracts.convenant_follow.body.associations_changed.adjustments", count: adjustments_count)
  end

  def transfer_bank_orders_created
    return if transfer_bank_orders_count < 1

    I18n.t("transparency.notification.integration.contracts.convenant_follow.body.associations_changed.transfer_bank_orders", count: transfer_bank_orders_count)
  end

  def update_resources
    update_status(convenant)

    financials.each { |financial| update_status(financial) }
    additives.each { |additive| update_status(additive) }
    adjustments.each { |adjustment| update_status(adjustment) }
    transfer_bank_orders.each { |transfer_bank_order| update_status(transfer_bank_order) }
  end

  def financials
    @financials ||= convenant.financials.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def additives
    @additives ||= convenant.additives.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def adjustments
    @adjustments ||= convenant.adjustments.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def transfer_bank_orders
    @transfer_bank_orders ||= convenant.transfer_bank_orders.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
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

  def transfer_bank_orders_count
    transfer_bank_orders.count
  end
end
