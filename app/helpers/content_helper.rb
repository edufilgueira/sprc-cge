module ContentHelper

  SAFE_TAGS = %w( strong em u ol li ul p )
  ANSWER_SAFE_TAGS = %w( strong em u ol li ul p a )
  ANSWER_SAFE_ATTRIBUTES = %w( href target )

  def dash_content_with_label(resource, attribute_name, options = {})
    options[:undefined_value] = '-'
    content_with_label(resource, attribute_name, options)
  end

  def content_with_label(resource, attribute_name, options = {})
    resource_klass = resource.class

    label = options[:label] || resource_klass.human_attribute_name(attribute_name)
    acronym_value = options[:acronym_value] || false

    value = resource_value(resource, attribute_name, options)

    tag_for_value = acronym_value ? :acronym : :p
    content = content_tag(:p, label, class: 'content-label') + content_tag(tag_for_value, value, class: 'content-value')

    content_tag(:div, content, class: 'content-with-label')
  end

  def check_document_url(resource, document_url, attribute_name, exceptions, blank_contract=[])
    link = exceptions.include? attribute_name
    return resource[attribute_name] if document_url.present? and !link
    return link_to(
      content_tag(:i, nil, class: "fa fa-file-pdf-o fa-2x"), document_url
    )if document_url.present? and link

    return t('.blank_contract') if blank_contract.include? attribute_name
  end

  def check_contract_modality(resource, document_url, attribute_name, exceptions, blank_contract=[])
    return t('.blank_contract') if resource.decricao_modalidade == "DISPENSA" and resource.descricao_url == resource.descricao_url_ddisp

    check_document_url(resource, document_url, attribute_name, exceptions, blank_contract)
  end

  def resource_value(resource, attribute_name, options = {})
    return resource.try(attribute_name) if options.fetch(:raw_value, false)
    # para os helpers de enum *_str, o valor é definido via method_missing.
    # logo, não podemos usar o try!
    if (attribute_name.to_s.end_with?('_str'))
      value = (resource.present? && resource.send(attribute_name))
    else
      # importante o try pois resource pode ser nil
      value = resource.try(attribute_name)
    end

    value = formatted_value(value, options, resource, attribute_name)

    value.present? ? value : options.fetch(:undefined_value, undefined_value)
  end

  def content_sanitizer(content)
    raw sanitize(content, tags: ContentHelper::SAFE_TAGS)
  end

  def answer_sanitizer(content)
    raw sanitize(content, tags: ContentHelper::ANSWER_SAFE_TAGS, attributes: ANSWER_SAFE_ATTRIBUTES)
  end



  private

  def undefined_value
    content_tag(:em, I18n.t('messages.content.undefined'))
  end

  def formatted_value(value, options, resource = nil, attribute_name = nil)
    return value if value.nil?

    format = options[:format]

    type = (format == :date ? 'Date' : value.class.to_s)

    case type
    when 'Date'
      I18n.l(value.to_date)
    when 'ActiveSupport::TimeWithZone'
      if resource.class.name == 'PPA::Workshop' and (
         attribute_name.to_s == 'end_at' or attribute_name.to_s == 'start_at')
        value = I18n.l(value, format: '%d/%m/%Y')
      else
        I18n.l(value, format: :shorter)
      end
    when 'BigDecimal'
      number_to_currency(value)
    when 'FalseClass', 'TrueClass'
      I18n.t("boolean.#{value}")
    when 'String'
      content_sanitizer(value)
    else
      value
    end
  end

  def hide_field?(resource, attribute_name)
    return concealable_and_null(resource, attribute_name) || 
      (without_additive(resource) if attribute_name == :data_termino)
  end

  def conditionally_hidden_fields
    # set attributos de datas para serem ocultados na view
    # detalhamento dos contratos caso, estejam com valores nulos
    [:data_termino, :data_rescisao]
  end

  def without_additive(resource)
    # oculta o campo data_termino se não tiver aditivo, devido
    # redundancia com data_termino_original
    resource.data_termino_original == resource.data_termino
  end

  def concealable_and_null(resource, attribute_name)
    (conditionally_hidden_fields.include?(attribute_name) && 
      resource.send(attribute_name).nil?)
    
  end
end
