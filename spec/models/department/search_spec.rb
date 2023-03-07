require 'rails_helper'

describe Department::Search do
  it { is_expected.to be_searchable_like('departments.acronym') }
  it { is_expected.to be_searchable_like('departments.name') }
  it { is_expected.to be_searchable_like('organs.acronym') }
  it { is_expected.to be_searchable_like('subnets.acronym') }
end
