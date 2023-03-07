require 'rails_helper'

describe Page::Search do
  it { is_expected.to be_unaccent_searchable_like('page_translations.title') }
  it { is_expected.to be_unaccent_searchable_like('page_translations.menu_title') }
end
