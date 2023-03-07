require 'rails_helper'

describe BreadcrumbsHelper do

  it 'renders a breadcrumbs' do
    breadcrumbs = [
      { title: 'one title', url: 'url' },
      { title: 'another title', url: '' }
    ]

    expected = render('shared/breadcrumbs', breadcrumbs: breadcrumbs)
    expect(helper.render_breadcrumbs(breadcrumbs)).to eq(expected)
  end

end
