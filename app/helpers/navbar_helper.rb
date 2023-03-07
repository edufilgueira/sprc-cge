module NavbarHelper

  ADMIN_ADMIN_GROUP = %w[
    admin/users
    admin/organs
    admin/departments
    admin/search_contents
  ]

  ADMIN_TRANSPARENCY_GROUP = %w[
    admin/integrations
    admin/pages
  ]

  ADMIN_TICKET_GROUP = %w[
    admin/topics
    admin/service_types
    admin/budget_programs
  ]

  #
  # Retorna a classe de menu ativo caso o controller atual tenha relação com o
  # menu_item passado como parâmetro.
  #
  def navbar_active_class(menu_item)
    controller_path.include?(menu_item.to_s) ? 'active' : ''
  end

  #
  # Retorna a tag com a brand-image usada nas navbar
  #
  def navbar_brand_image
    content_tag(:img, '', src: image_path('logos/logo-ceara.png'), alt: t('app.title'))
  end

  def navbar_active_admin_group_class(admin_group)
    admin_group.any? { |path| controller_path.include?(path) } ? 'active' : ''
  end
end
