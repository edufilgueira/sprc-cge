module UsersHelper
  def user_document_types_for_select
    valid_document_types_for_select.map do |document_type|
      [document_type_title(document_type), document_type]
    end
  end

  def user_admin_document_types_for_select
    valid_admin_document_types_for_select.map do |document_type|
      [document_type_title(document_type), document_type]
    end
  end

  def user_user_types_for_select
    user_types_keys.map do |user_type|
      [user_type_title(user_type), user_type]
    end
  end

  def user_administrative_user_types_for_select
    administrative_user_types_keys.map do |user_type|
      [user_type_title(user_type), user_type]
    end
  end

  def user_operator_types_for_select
    operator_types_keys.map do |operator_type|
      [operator_type_title(operator_type), operator_type]
    end.sort.to_h
  end

  def user_operator_types_for_operators_for_select(user)
    operator_types(user).map do |operator_type|
      [operator_type_title(operator_type), operator_type]
    end.sort.to_h
  end

  def user_person_types_for_select
    person_types_keys.map do |person_type|
      [person_type_title(person_type), person_type]
    end.sort.to_h
  end

  def user_gender_for_select
    gender_keys.map do |gender|
      [gender_title(gender), gender]
    end.sort.to_h
  end

  def user_education_level_for_select
    education_level_keys.map do |education_level|
      [education_level_title(education_level), education_level]
    end.to_h
  end

  def operator?(user)
    user.present? && user.operator?
  end

  def admin?(user)
    user.present? && user.is_a?(User) && user.admin?
  end

  def user?(user)
    user.present? && user.user?
  end

  def user_facebook?(user)
    user?(user) && user.user_facebook?
  end

  def operator_sectoral_or_internal?(user)
    operator?(user) && ( user.sectoral? || user.internal? )
  end

  def operator_internal?(user)
    operator?(user) && user.internal?
  end

  def operator_sectoral?(user)
    operator?(user) && user.sectoral?
  end

  def operator_sectoral_sou?(user)
    operator?(user) && user.sou_sectoral?
  end

  def operator_cge?(user)
    operator?(user) && user.cge?
  end

  def operator_coordination_or_cge?(user)
    operator?(user) && (user.cge? || user.coordination?)
  end

  def operator_coordination_or_cge_or_denunciation?(user)
    operator_coordination_or_cge?(user) || operator_denunciation?(user)
  end

  def operator_denunciation?(user)
    user.present? && user.operator_denunciation?
  end

  def operator_subnet?(user)
    user.present? && (user.subnet_sectoral? || user.subnet_chief?)
  end

  def operator_chief?(user)
    operator?(user) && user.operator_chief?
  end

  def operator_coordination?(user)
    operator?(user) && user.coordination?
  end

  def operator_security_organ?(user)
    operator?(user) && user.security_organ?
  end

  def call_center_responsible_for_select
    call_center_responsibles_sorted.map do |u|
      ["(#{u[0]}) #{u[1]}", u[2]]
    end
  end

  def call_center_for_filter
    call_center_responsible_for_select.unshift([none_message, '__is_null__'])
  end

  def user_ticket_types_availables(user)
    availables = [:sou, :sic]

    availables -= [:sou] if user.sic_sectoral?

    availables -= [:sic] if user.sou_sectoral? && !user.acts_as_sic?

    availables -= [:sic] if user.coordination? && !user.acts_as_sic?

    availables -= [:sic] if user.organ.present? && user.organ_id == ExecutiveOrgan.denunciation_commission&.id

    availables -= [:sic] if user.operator_security_organ?

    availables

  end

  def users_name_by_id(user_id)
    user = User.find_by(id: user_id)

    return "" unless user

    user.name
  end

  private

  def none_message
    I18n.t('messages.filters.select.none')
  end

  def call_center_responsibles_sorted
    call_center_tickets.sort { |x, y| x[0] <=> y[0] }
  end

  def call_center_tickets
    call_center_users.group('users.id').map do |u|
      [call_center_tickets_count(u), u.name, u.id]
    end
  end

  def call_center_tickets_count(u)
    u.call_center_tickets.final_answer.where(call_center_feedback_at: nil).count
  end

  def call_center_users
    User.call_center.enabled.left_joins(:call_center_tickets)
  end

  def valid_document_types_for_select
    User.document_types.except(:cnpj, :registration).keys.sort
  end

  def valid_admin_document_types_for_select
    User.document_types.except(:cnpj).keys.sort
  end

  def user_types_keys
    User.user_types.keys
  end

  def administrative_user_types_keys
    [:operator, :admin]
  end

  def operator_types_keys
    User.operator_types.keys
  end

  def person_types_keys
    User.person_types.keys
  end

  def gender_keys
    User.genders.keys
  end

  def education_level_keys
    User.education_levels.keys
  end

  def document_type_title(document_type)
    I18n.t("user.document_types.#{document_type}")
  end

  def user_type_title(user_type)
    I18n.t("user.user_types.#{user_type}")
  end

  def operator_type_title(user_type)
    I18n.t("user.operator_types.#{user_type}")
  end

  def person_type_title(person_type)
    I18n.t("user.person_types.#{person_type}")
  end

  def gender_title(gender)
    I18n.t("user.genders.#{gender}")
  end

  def education_level_title(education_level)
    I18n.t("user.education_levels.#{education_level}")
  end

  def operator_types(user)
    case user.operator_type
    when 'cge'
      User::OPERATOR_TYPES_FOR_CGE_OPERATORS
    when 'sou_sectoral'
      sou_sectoral_types(user)
    when 'sic_sectoral'
      User::OPERATOR_TYPES_FOR_SIC_OPERATORS
    when 'subnet_sectoral'
      User::OPERATOR_TYPES_FOR_SUBNET_OPERATORS
    else
      []
    end
  end

  def sou_sectoral_types(user)
    user.rede_ouvir? ? User::OPERATOR_TYPES_FOR_SOU_OPERATORS_REDE_OUVIR : User::OPERATOR_TYPES_FOR_SOU_OPERATORS
  end

  def user_enabled_to_view_topic(user)
    user.nil? || user.user?
  end

  def comments_user(user,comment)
    comment.author.present? && ! operator_internal?(user) && !ticket.denunciation?
  end
end
