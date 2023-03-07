require 'rails_helper'

describe Classification do
  it_behaves_like 'models/paranoia'

  subject(:classification) { build(:classification) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:classification, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:topic_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subtopic_id).of_type(:integer) }
      it { is_expected.to have_db_column(:department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:sub_department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:budget_program_id).of_type(:integer) }
      it { is_expected.to have_db_column(:service_type_id).of_type(:integer) }
      it { is_expected.to have_db_column(:other_organs).of_type(:boolean).with_options(default: false) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'validations' do

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:ticket_id) }
    end

    describe 'presence' do
      it { is_expected.to validate_presence_of(:ticket) }
      it { is_expected.to validate_presence_of(:topic) }
      it { is_expected.to validate_presence_of(:budget_program) }
      it { is_expected.to validate_presence_of(:department) }

      context 'sub_department' do
        context 'when department has no sub_departments' do
          it { expect(classification).not_to validate_presence_of(:sub_department) }
        end

        context 'when department has sub_departments' do
          let(:department) { classification.department }
          let(:sub_departments) { create_list(:sub_department, 2, department: department) }

          before do
            sub_departments
            department.reload
          end

          it { expect(classification).to validate_presence_of(:sub_department) }
        end

        context 'when department has sub_departments' do
          let(:department_classification) { create(:department) }
          let(:sub_departments) { create_list(:sub_department, 2, department: department_classification, disabled_at: Date.today) }

          before do
            sub_departments
            classification.department = department_classification
            classification.sub_department = nil
          end

          it { expect(classification).not_to validate_presence_of(:sub_department) }
        end
      end

      context 'subtopic' do
        context 'when topic has no subtopics' do
          it { expect(classification).not_to validate_presence_of(:subtopic) }
        end

        context 'when topic has subtopics' do
          let(:topic) { classification.topic }
          let(:subtopics) { create_list(:subtopic, 2, topic: topic) }

          before { subtopics }

          it { expect(classification).to validate_presence_of(:subtopic) }
        end

        context 'when topic has only subtopics disabled' do
          let(:topic_classification) { create(:topic) }
          let(:subtopics) { create_list(:subtopic, 2, topic: topic_classification, disabled_at: Date.today) }

          before do
            subtopics
            classification.topic = topic_classification
          end

          it { expect(classification).not_to validate_presence_of(:subtopic) }
        end
      end

      context 'other_organs' do

        it 'validate_presence_of ticket' do
          classification.other_organs = true

          expect(classification).to validate_presence_of(:ticket)
        end

        it 'not validate_presence_of department' do
          classification.other_organs = true

          expect(classification).not_to validate_presence_of(:department)
        end

        it 'validate_presence_of subtopic' do
          classification.other_organs = true

          expect(classification).not_to validate_presence_of(:subtopic)
        end
      end
    end
  end

  describe 'scope' do
    it 'sorted' do
      expect(Classification.sorted).to eq(Classification.order(:ticket))
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:topic).with_prefix }
    it { is_expected.to delegate_method(:name).to(:subtopic).with_prefix }
    it { is_expected.to delegate_method(:name).to(:department).with_prefix }
    it { is_expected.to delegate_method(:name).to(:sub_department).with_prefix }
    it { is_expected.to delegate_method(:name).to(:budget_program).with_prefix }
    it { is_expected.to delegate_method(:name).to(:service_type).with_prefix }
  end

  describe 'callbacks' do
    context 'after_commit' do

      context 'update ticket' do
        context 'classified' do
          it 'true' do
            expect(classification.ticket.classified).to be_falsey

            classification.save!

            expect(classification.ticket.classified).to be_truthy
          end

          it 'false' do
            classification.save!
            expect(classification.ticket.classified).to be_truthy

            classification.destroy
            expect(classification.ticket.classified).to be_falsey
          end
        end

        context 'unknown_classification' do
          it 'false' do
            expect(classification.ticket.unknown_classification).to be_truthy

            classification.save!

            expect(classification.ticket.unknown_classification).to be_falsey
          end

          it 'true' do
            classification.save!
            expect(classification.ticket.unknown_classification).to be_falsey

            classification.destroy
            expect(classification.ticket.unknown_classification).to be_truthy
          end
        end

        context 'public_ticket' do

          context 'ticket parent' do
            it 'cannot update' do
              expect(classification.ticket.public_ticket).to be_falsey

              classification.save!

              expect(classification.ticket.public_ticket).to be_falsey
            end
          end

          context 'ticket child' do
            let(:ticket) { create(:ticket, :with_parent) }
            let(:classification) { build(:classification, ticket: ticket) }

            it 'when other_organs = false' do
              classification.other_organs = false

              expect(classification.ticket.public_ticket).to be_falsey

              classification.save!

              expect(classification.ticket.public_ticket).to be_truthy
            end

            it 'when other_organs = true' do
              classification = build(:classification, :other_organs)

              expect(classification.ticket.public_ticket).to be_falsey

              classification.save!

              expect(classification.ticket.public_ticket).to be_falsey
              expect(classification.ticket.answer_classification).to eq('other_organs')
            end

            it 'when sic and other_organs = true' do
              ticket = create(:ticket, :sic)
              classification = build(:classification, :other_organs, ticket: ticket)

              classification.save!

              expect(classification.ticket.answer_classification).to eq('sic_not_attended_other_organs')
            end
          end
        end
      end

    end

    context 'before_validation' do
      it 'update attributes' do
        classification = build(:classification, :other_organs)

        classification.save!

        expect(classification.topic).to eq(Topic.other_organs)
        expect(classification.subtopic).to eq(Subtopic.other_organs)
        expect(classification.department).to be_nil
        expect(classification.sub_department).to be_nil
        expect(classification.budget_program).to eq(BudgetProgram.other_organs)
        expect(classification.service_type).to eq(ServiceType.other_organs)
      end
    end
  end

end
