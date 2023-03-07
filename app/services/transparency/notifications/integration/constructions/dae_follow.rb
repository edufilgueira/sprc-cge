class Transparency::Notifications::Integration::Constructions::DaeFollow < Transparency::Notifications::BaseFollow

  attr_reader :dae

  def self.call(dae_id)
    new(dae_id).call
  end

  def initialize(dae_id)
    @dae = Integration::Constructions::Dae.find dae_id
  end

  def call
    return unless has_changes_and_followers?

    send_email

    update_resources
  end


  private

  def has_changes_and_followers?
    followers.present? &&

    (resource.data_changes.present? || photos_count > 0 || measurements_count > 0)
  end

  def resource
    dae
  end

  def subject
    I18n.t('transparency.notification.integration.constructions.dae_follow.subject')
  end

  def body(follower)
    title_body = I18n.t('transparency.notification.integration.constructions.dae_follow.body.title')

    description_body = I18n.t('transparency.notification.integration.constructions.dae_follow.body.description', description: dae.descricao)

    link_body = I18n.t('transparency.notification.integration.constructions.dae_follow.body.links', dae_url: dae_url, unsubscribe_url: unsubscribe_url(follower))

    "#{title_body} #{description_body} #{changed_attributes_body} #{associations_changed} #{link_body}"
  end

  def dae_url
    transparency_constructions_dae_url(dae)
  end

  def changed_attributes_body
    return if changes.blank?

    changes.map do |change|
      attribute = change.first
      type = Integration::Constructions::Dae.type_for_attribute(attribute).type

      name_changed =  Integration::Constructions::Dae.human_attribute_name(attribute)
      attr_origin  =  formatted_value(change.second[0], type)
      attr_changed =  formatted_value(change.second[1], type)

      I18n.t("transparency.notification.integration.constructions.dae_follow.body.attribute_changed",
        name_changed: name_changed, attr_origin: attr_origin, attr_changed: attr_changed)
    end.join(' ')
  end

  def associations_changed
    "#{photos_created} #{measurements_created}"
  end

  def photos_created
    return if photos_count < 1

    I18n.t("transparency.notification.integration.constructions.dae_follow.body.associations_changed.photos", count: photos_count)
  end

  def measurements_created
    return if measurements_count < 1

    I18n.t("transparency.notification.integration.constructions.dae_follow.body.associations_changed.measurements", count: measurements_count)
  end

  def update_resources
    update_status(dae)

    photos.each { |photo| update_status(photo) }

    measurements.each { |measurement| update_status(measurement) }
  end

  def photos
    @photos ||= dae.photos.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def measurements
    @measurements ||= dae.measurements.joins(:utils_data_change).where(integration_utils_data_changes: { resource_status: ['new_resource_notificable'] })
  end

  def photos_count
    photos.count
  end

  def measurements_count
    measurements.count
  end
end
