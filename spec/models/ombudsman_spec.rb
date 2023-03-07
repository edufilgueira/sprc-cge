require 'rails_helper'

describe Ombudsman do

  describe 'enums' do
    it { is_expected.to define_enum_for(:kind).with_values([:executive, :sesa]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :phone }
    it { is_expected.to validate_presence_of :kind }
  end
end
