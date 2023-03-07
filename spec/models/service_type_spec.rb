require 'rails_helper'

describe ServiceType do
  subject(:service_type) { build(:service_type) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:service_type, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer) }
      it { is_expected.to have_db_column(:code).of_type(:integer) }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:other_organs).of_type(:boolean).with_options(default: false) }
    end

    # Audits

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:title).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_prefix(true) }
    it { is_expected.to delegate_method(:full_title).to(:organ).with_prefix(true) }

    it { is_expected.to delegate_method(:name).to(:subnet).with_prefix(true) }
    it { is_expected.to delegate_method(:acronym).to(:subnet).with_prefix(true) }
    it { is_expected.to delegate_method(:full_acronym).to(:subnet).with_prefix(true) }
  end

  describe 'scope' do
    it 'sorted' do
      expected = ServiceType.order('service_types.name ASC').to_sql.downcase
      result = ServiceType.sorted.to_sql.downcase
      expect(result).to eq(expected)
    end

    it_behaves_like 'models/disableable'

    it 'not_other_organs' do
      create(:service_type, :other_organs)
      service_type.save
      expect(ServiceType.not_other_organs).to eq([service_type])
    end

    it 'create only_no_characteristic' do
      service_type = create(:service_type, :no_characteristic)

      expect(ServiceType.only_no_characteristic).to eq(service_type)
    end

    it 'create without_no_characteristic' do
      service_type = create(:service_type, :no_characteristic)

      expect(ServiceType.without_no_characteristic).not_to eq(service_type)
    end
  end

  describe 'helpers' do
    context 'title' do
      it "with organ" do
        expected = "[#{service_type.organ_acronym}] - #{service_type.name}"

        expect(service_type.title).to eq(expected)
      end

      it "with subnet" do
        service_type = create(:service_type, subnet: create(:subnet))
        expected = "[#{service_type.subnet_acronym}] - #{service_type.name}"

        expect(service_type.title).to eq(expected)
      end

      it "without organ" do
        service_type.organ = nil
        expect(service_type.title).to eq(service_type.name)
      end
    end
  end

  describe '#set_organ' do
    context 'when subnet is defined' do
      context 'when organ is not defined' do
        it 'organ is defined' do
          subnet = create(:subnet)
          service_type = create(:service_type, organ_id: nil, subnet: subnet)

          expect(service_type.organ).to eq(subnet.organ)
        end
      end
    end

    context 'when subnet is not defined' do
      it 'organ is not defined' do
        service_type = create(:service_type, organ_id: nil)

        expect(service_type.organ).to be_nil
      end
    end
  end
end
