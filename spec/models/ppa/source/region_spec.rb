require 'rails_helper'

RSpec.describe PPA::Source::Region, type: :model do
  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  # os demais testes estão no projeto sprc-data
end
