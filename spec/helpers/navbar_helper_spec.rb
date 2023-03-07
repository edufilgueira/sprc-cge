require 'rails_helper'

describe NavbarHelper do

  it 'returns if menu is active' do
    allow(controller).to receive(:controller_path).and_return('test/inner/page')

    expect(navbar_active_class(:test)).to eq('active')
  end

  it 'returns navbar brand image' do
    expected_src = image_path('logos/logo-ceara.png')
    expected_alt = I18n.t('app.title')

    expected = content_tag(:img, '', src: expected_src, alt: expected_alt)

    expect(navbar_brand_image).to eq(expected)
  end

  describe 'navbar admin group' do

    context 'constant' do
      it 'admin group' do
        expected = %w[
          admin/users
          admin/organs
          admin/departments
          admin/search_contents
        ]

        expect(NavbarHelper::ADMIN_ADMIN_GROUP).to eq expected
      end

      it 'transparency group' do
        expected = %w[
          admin/integrations
          admin/pages
        ]

        expect(NavbarHelper::ADMIN_TRANSPARENCY_GROUP).to eq expected
      end

      it 'ticket group' do
        expected = %w[
          admin/topics
          admin/service_types
          admin/budget_programs
        ]

        expect(NavbarHelper::ADMIN_TICKET_GROUP).to eq expected
      end
    end

    context 'is active' do
      it 'true' do
        allow(controller).to receive(:controller_path).and_return('admin/topics')

        expect(navbar_active_admin_group_class(NavbarHelper::ADMIN_TICKET_GROUP)).to eq('active')
      end

      it 'false' do
        allow(controller).to receive(:controller_path).and_return('admin/pages')

        expect(navbar_active_admin_group_class(NavbarHelper::ADMIN_TICKET_GROUP)).to eq('')
      end
    end
  end
end
