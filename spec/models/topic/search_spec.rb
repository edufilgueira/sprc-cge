require 'rails_helper'

describe Topic::Search do
  it { is_expected.to be_searchable_like('topics.name') }
  it { is_expected.to be_searchable_like('organs.acronym') }
  it { is_expected.to be_searchable_like('organs.name') }
  it { is_expected.to be_searchable_like('subtopics.name') }
end
