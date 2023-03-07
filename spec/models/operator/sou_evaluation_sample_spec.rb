require 'rails_helper'

RSpec.describe Operator::SouEvaluationSample, type: :model do
	
	describe 'db' do
		describe 'columns' do
			it { is_expected.to have_db_column(:code).of_type(:integer) }
			it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
			it { is_expected.to have_db_column(:created_by_id).of_type(:integer) }
			it { is_expected.to have_db_column(:filters).of_type(:jsonb) }
			it { is_expected.to have_db_column(:status).of_type(:integer) }
			it { is_expected.to have_db_column(:title).of_type(:string) }
			it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
		end
	end

	# Associations
	
	describe 'associations' do
  	it { is_expected.to have_many(:sou_evaluation_sample_details) }
	end

	describe 'enums' do
		it 'service_type' do
			statuses = [:open, :completed]

			is_expected.to define_enum_for(:status).with(statuses)
		end
	end

	describe 'setup' do
		it { expect(described_class.ancestors.include?(Searchable)).to be_truthy }
		it { expect(described_class.ancestors.include?(Sortable)).to be_truthy }
	end

end
