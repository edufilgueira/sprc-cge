require 'rails_helper'

describe Ombudsman::Search do
  it { is_expected.to be_unaccent_searchable_like('ombudsmen.title') }
  it { is_expected.to be_unaccent_searchable_like('ombudsmen.contact_name') }
  it { is_expected.to be_unaccent_searchable_like('ombudsmen.phone') }
  it { is_expected.to be_unaccent_searchable_like('ombudsmen.email') }
  it { is_expected.to be_unaccent_searchable_like('ombudsmen.address') }
end
