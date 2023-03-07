require 'rails_helper'

RSpec.describe PPA::Administrator, type: :model do

  subject(:admin) { build(:ppa_administrator) }

  describe 'factories' do
    it { is_expected.to be_valid }
    it { is_expected.to be_confirmed } # default

    context 'invalid' do
      subject { build :ppa_administrator, :invalid }
      it { is_expected.not_to be_valid }
    end

    context 'confirmed' do
      subject { build :ppa_administrator, :confirmed }
      it { is_expected.to be_confirmed }
    end

    context 'unconfirmed' do
      subject { build :ppa_administrator, :unconfirmed }
      it { is_expected.not_to be_confirmed }
    end
  end

  context 'behaviors' do
    it_behaves_like 'models/paranoia'
  end

  describe 'enums' do
    # ...
  end

  describe 'associations' do
    # ...
  end

  describe 'delegations' do
    # ...
  end

  describe 'validations' do
    context 'cpf' do
      it { is_expected.to validate_presence_of :cpf }
      it { is_expected.to allow_values(CPF.generate(true)).for(:cpf) }
      it { is_expected.not_to allow_values(CPF.generate).for(:cpf) } # exigimos máscara de CPF!
    end

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :name }

    context 'uniqueness' do
      subject { create :ppa_administrator }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
    end
  end

end
