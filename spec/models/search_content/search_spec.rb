require 'rails_helper'

describe SearchContent::Search do
  it { is_expected.to be_unaccent_searchable_like(:title) }
  it { is_expected.to be_unaccent_searchable_like(:content) }
end

