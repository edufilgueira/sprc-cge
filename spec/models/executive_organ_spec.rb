require 'rails_helper'

describe ExecutiveOrgan do

  it_behaves_like 'models/paranoia'

  subject(:executive_organ) { build(:executive_organ) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:executive_organ, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:acronym).of_type(:string) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:subnet).of_type(:boolean) }
      it { is_expected.to have_db_column(:ignore_cge_validation).of_type(:boolean) }
      it { is_expected.to have_db_column(:ignore_cge_validation).of_type(:boolean) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:acronym) }
      it { is_expected.to have_db_index(:code) }
      it { is_expected.to have_db_index(:subnet) }
    end

    describe 'associations' do
      it { is_expected.to have_many(:departments) }
      it { is_expected.to have_many(:subnets) }
      it { is_expected.to have_many(:tickets) }
      it { is_expected.to have_many(:attendance_evaluations).through(:tickets) }
      it { is_expected.to have_many(:subnet_departments).through(:subnets).source(:departments).class_name(:Department) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:acronym) }

    it { is_expected.to validate_uniqueness_of(:acronym) }
  end

  describe 'class_methods' do
    describe 'scopes' do
      it 'default' do
        rede_ouvir = create(:rede_ouvir_organ)
        executive_organ = create(:executive_organ)

        expect(ExecutiveOrgan.sorted).to eq([executive_organ])
      end

      it 'sorted' do
        expected = ExecutiveOrgan.order('organs.acronym ASC').to_sql.downcase
        result = ExecutiveOrgan.sorted.to_sql.downcase

        expect(result).to eq(expected)
      end

      it_behaves_like 'models/disableable'

      it 'denunciation_commission' do
        create(:executive_organ, acronym: 'COSCO')

        denunciation_commission = ExecutiveOrgan.denunciation_commission

        expect(denunciation_commission.acronym).to eq('COSCO')
      end

      it 'comptroller' do
        create(:executive_organ, acronym: 'CGE')

        comptroller = ExecutiveOrgan.comptroller

        expect(comptroller.acronym).to eq('CGE')
      end

      it 'dpge' do
        create(:executive_organ, acronym: 'DPGE')

        executive_organ = ExecutiveOrgan.dpge

        expect(executive_organ.acronym).to eq('DPGE')
      end
    end
  end

  describe 'instance_methods' do
    describe 'helpers' do
      it 'title' do
        expect(executive_organ.title).to eq(executive_organ.acronym)
      end

      it 'full_title' do
        expect(executive_organ.full_title).to eq("#{executive_organ.acronym} - #{executive_organ.name}")
      end

      it 'full_acronym' do
        expect(executive_organ.full_acronym).to eq(executive_organ.acronym)
      end

      it 'cge' do
        executive_organ.acronym = 'CGE'

        expect(executive_organ.cge?).to be_truthy
      end

      it 'executive_organ?' do
        expect(executive_organ.executive_organ?).to eq(true)
      end

      it 'rede_ouvir?' do
        expect(executive_organ.rede_ouvir_organ?).to eq(false)
      end

      it 'average_organ_attendance_evaluation' do
        ticket = create(:ticket, :with_organ, organ: executive_organ)
        attendance1 = create(:attendance_evaluation, clarity: 10, content: 10, wording: 9, kindness: 9 , ticket: ticket)

        ticket2 = create(:ticket, :with_organ, organ: executive_organ)
        attendance2 = create(:attendance_evaluation, clarity: 2, wording: 10, kindness: 4, ticket: ticket2)

        ticket3 = create(:ticket, :with_organ)
        create(:attendance_evaluation, average: 5, ticket: ticket3)

        expected = ((attendance1.average + attendance2.average) / 2).to_f.round(1)

        expect(executive_organ.average_attendance_evaluation).to eq(expected)
      end
    end
  end
end
