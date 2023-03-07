require 'rails_helper'

describe BudgetProgram do

  it_behaves_like 'models/paranoia'

  subject(:budget_program) { build(:budget_program) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:budget_program, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:other_organs).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:theme_id).of_type(:integer).with_options(foreign_key: true) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer).with_options(foreign_key: true) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer).with_options(foreign_key: true) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:subnet_id) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:theme) }
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:subnet) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:theme).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:name).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:organ).with_prefix }
    it { is_expected.to delegate_method(:subnet?).to(:organ).with_prefix.with_arguments(allow_nil: true) }

    it { is_expected.to delegate_method(:acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
  end

  describe 'scope' do
    it 'sorted' do
      expected = BudgetProgram.order('budget_programs.name ASC').to_sql.downcase
      result = BudgetProgram.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it_behaves_like 'models/disableable'

    it 'not_other_organs' do
      create(:budget_program, :other_organs)
      budget_program.save
      expect(BudgetProgram.not_other_organs).to eq([budget_program])
    end

    it 'create only_no_characteristic' do
      budget_program = create(:budget_program, :no_characteristic)

      expect(BudgetProgram.only_no_characteristic).to eq(budget_program)
    end

    it 'create without_no_characteristic' do
      budget_program = create(:budget_program, :no_characteristic)

      expect(BudgetProgram.without_no_characteristic).not_to eq(budget_program)
    end
  end

  describe 'helpers' do
    context 'title' do
      it 'without organ and subnet' do
        expect(budget_program.title).to eq(budget_program.name)
      end

      it 'with organ' do
        budget_program_organ = create(:budget_program, :with_organ)
        expected = "#{budget_program_organ.organ_acronym} - #{budget_program_organ.name}"

        expect(budget_program_organ.title).to eq(expected)
      end

      it 'with organ' do
        subnet_organ = create(:executive_organ, :with_subnet)
        subnet = create(:subnet, organ: subnet_organ)
        budget_program_subnet = create(:budget_program, :with_subnet, subnet: subnet)
        expected = "#{budget_program_subnet.subnet_acronym} - #{budget_program_subnet.name}"

        expect(budget_program_subnet.title).to eq(expected)
      end
    end
  end
end
