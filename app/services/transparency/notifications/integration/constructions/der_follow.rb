class Transparency::Notifications::Integration::Constructions::DerFollow < Transparency::Notifications::BaseFollow

  attr_reader :der

  def self.call(der_id)
    new(der_id).call
  end

  def initialize(der_id)
    @der = Integration::Constructions::Der.find der_id
  end

  def call
    return unless has_changes_and_followers?

    send_email

    update_resources
  end


  private

  def has_changes_and_followers?
    followers.present? &&

    (resource.data_changes.present? || measurements_count > 0)
  end

  def resource
    der
  end

  def subject
    I18n.t('transparency.notification.integration.constructions.der_follow.subject')
  end

  def body(follower)
    title_body = I18n.t('transparency.notification.integration.constructions.der_follow.body.title')

    description_body = I18n.t('transparency.notification.integration.constructions.der_follow.body.description', description: der.trecho)

    link_body = I18n.t('transparency.notification.integration.constructions.der_follow.body.links', der_url: der_url, unsubscribe_url: unsubscribe_url(follower))

    "#{title_body} #{description_body} #{changed_attributes_body} #{associations_changed} #{link_body}"
  end

  def der_url
    transparency_constructions_der_url(der)
  end

  def changed_attributes_body
    return if changes.blank?

    changes.map do |change|
      attribute = change.first
      type = Integration::Constructions::Der.type_for_attribute(attribute).type

      name_changed =  Integration::Constructions::Der.human_attribute_name(attribute)
      attr_origin  =  formatted_value(change.second[0], type)
      attr_changed =  formatted_value(change.second[1], type)

      I18n.t("transparency.notification.integration.constructions.der_follow.body.attribute_changed",
        name_changed: name_changed, attr_origin: attr_origin, attr_changed: attr_changed)
    end.join(' ')
  end

  def associations_changed
    "#{measurements_created}"
  end

  def measurements_created
    return if measurements_count < 1

    I18n.t("transparency.notification.integration.constructions.der_follow.body.associations_changed.measurements", count: measurements_count)
  end

  def update_resources
    update_status(der)

    measurements.each { |measurement| update_status(measurement) }
  end

  def measurements
    @measurements ||= der.measurements.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def measurements_count
    measurements.count
  end
end
