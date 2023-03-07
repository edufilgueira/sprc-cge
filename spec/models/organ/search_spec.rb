require 'rails_helper'

describe Organ::Search do
  it { is_expected.to be_searchable_like(:acronym) }
  it { is_expected.to be_searchable_like(:name) }
end

