require 'rails_helper'

describe Event::Search do
  it { is_expected.to be_searchable_like('events.title') }
end
