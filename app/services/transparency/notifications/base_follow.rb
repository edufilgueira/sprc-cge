class Transparency::Notifications::BaseFollow
  include Rails.application.routes.url_helpers


  def send_email
    followers.each do |follower|
      Transparency::FollowerMailer.citizen_following(create_email(follower), follower.email).deliver_later
    end
  end

  def update_status(resource)
    #
    # marca o recurso como 'mudanças notificadas'
    #
    resource.utils_data_change&.update(resource_status: 'resource_notified', data_changes: {})
  end

  def create_email(follower)
    {
      subject: subject,
      body: body(follower)
    }
  end

  def followers
    @followers ||= Transparency::Follower.actives(resource)
  end

  def unsubscribe_url(follower)
    edit_transparency_follower_url(follower)
  end

  def changes
    resource.data_changes
  end

  def formatted_value(value, format)
    return value if value.nil?

    case format.to_s
    when 'datetime', 'date'
      I18n.l(value.to_date)
    when 'ActiveSupport::TimeWithZone'
      I18n.l(value, format: :shorter)
    when 'BigDecimal'
      number_to_currency(value)
    when 'FalseClass', 'TrueClass'
      I18n.t("boolean.#{value}")
    else
      value
    end
  end
end
