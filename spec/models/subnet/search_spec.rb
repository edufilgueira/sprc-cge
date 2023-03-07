require 'rails_helper'

describe Subnet::Search do
  it { is_expected.to be_searchable_like('subnets.acronym') }
  it { is_expected.to be_searchable_like('subnets.name') }
  it { is_expected.to be_searchable_like('organs.acronym') }
end
