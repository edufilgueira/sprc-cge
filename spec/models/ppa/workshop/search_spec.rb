require 'rails_helper'

describe PPA::Workshop::Search do
  it { is_expected.to be_searchable_like('ppa_workshops.name') }
end
