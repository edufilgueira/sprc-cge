require 'rails_helper'

describe RedeOuvirOrgan do

  it_behaves_like 'models/paranoia'

  subject(:rede_ouvir) { build(:rede_ouvir_organ) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:rede_ouvir_organ, :invalid)).to be_invalid }
  end

  describe 'db' do
    # TESTED organ_spec
  end

  describe 'validations' do
    # TESTED organ_spec
  end

  describe 'class_methods' do
    describe 'scopes' do
      it 'default' do
        executive_organ = create(:executive_organ)
        rede_ouvir = create(:rede_ouvir_organ)

        expect(RedeOuvirOrgan.sorted).to eq([rede_ouvir])
      end

      it 'cge' do
        rede_ouvir = create(:rede_ouvir_organ)
        cge = create(:rede_ouvir_organ, :cge)

        expect(RedeOuvirOrgan.cge).to eq(cge)
      end
    end

    describe 'helpers' do
      it 'cge' do
        cge = create(:rede_ouvir_organ, :cge)

        expect(cge.cge?).to eq(true)
      end

      it 'title' do
        expect(rede_ouvir.title).to eq(rede_ouvir.acronym)
      end

      it 'full_title' do
        expect(rede_ouvir.full_title).to eq("#{rede_ouvir.acronym} - #{rede_ouvir.name}")
      end

      it 'full_acronym' do
        expect(rede_ouvir.full_acronym).to eq(rede_ouvir.acronym)
      end

      it 'executive_organ?' do
        expect(rede_ouvir.executive_organ?).to eq(false)
      end

      it 'rede_ouvir?' do
        expect(rede_ouvir.rede_ouvir_organ?).to eq(true)
      end
    end
  end
end
