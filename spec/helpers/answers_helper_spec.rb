require 'rails_helper'

describe AnswersHelper do

  let(:user) { create(:user) }
  let(:operator) { create(:user, :operator) }
  let(:ticket) { create(:ticket) }

  context 'answer_types_for_select' do
    context 'sou' do
      let(:ticket) { create(:ticket) }

      it 'default' do
        answer_types = Answer.answer_types

        expected = answer_types.keys.map do |answer_type|
          [ Answer.human_attribute_name("answer_type.#{answer_type}"), answer_type ]
        end

        expect(answer_types_for_select(ticket)).to eq(expected)
      end

      context 'when partial_answer' do

        context 'with status' do

          it ':cge_approved' do
            create(:answer, ticket: ticket, answer_type: :partial, status: :cge_approved)

            expected = [ Answer.human_attribute_name("answer_type.final"), 'final' ]

            expect(answer_types_for_select(ticket)).to eq([expected])
          end

          it ':cge_rejected' do
            create(:answer, ticket: ticket, answer_type: :partial, status: :cge_rejected)

            expected = Answer.answer_types.keys.map do |answer_type|
              [ Answer.human_attribute_name("answer_type.#{answer_type}"), answer_type ]
            end

            expect(answer_types_for_select(ticket)).to eq(expected)
          end

        end
      end
    end
    it 'sic' do
      ticket = create(:ticket, :sic)

      expected = [ Answer.human_attribute_name("answer_type.final"), 'final' ]

      expect(answer_types_for_select(ticket)).to eq([expected])
    end
  end

  describe 'answer_class' do
    let(:answer) { build(:answer) }

    context 'status' do
      it 'sectoral_approved' do
        answer.status = :sectoral_approved
        expect(answer_class(answer)).to eq('alert-success')
      end
      it 'subnet_approved' do
        answer.status = :subnet_approved
        expect(answer_class(answer)).to eq('alert-success')
      end

      context 'user_evaluated' do
        let(:answer) { build(:answer, ticket: ticket) }

        before { answer.status = :user_evaluated }

        context 'ticket reopened' do
          let(:ticket) { build(:ticket, :with_reopen) }

          it { expect(answer_class(answer)).to eq('alert-warning') }
        end

        context 'ticket not reopened' do
          let(:ticket) { build(:ticket) }

          it { expect(answer_class(answer)).to eq('alert-success') }
        end
      end

      it 'awaiting' do
        answer.status = :awaiting
        expect(answer_class(answer)).to eq('alert-info')
      end

      it 'subnet_rejected' do
        answer.status = :subnet_rejected
        expect(answer_class(answer)).to eq('alert-danger')
      end

      it 'sectoral_rejected' do
        answer.status = :sectoral_rejected
        expect(answer_class(answer)).to eq('alert-danger')
      end

      it 'cge_rejected' do
        answer.status = :cge_rejected
        expect(answer_class(answer)).to eq('alert-danger')
      end

      it 'cge_approved' do
        answer.status = :cge_approved
        expect(answer_class(answer)).to eq('alert-info')
      end

      it 'call_center_approved' do
        answer.status = :call_center_approved
        expect(answer_class(answer)).to eq('alert-info')
      end
    end

    context 'user_evaluated' do
    end

  end

  describe 'answer_icon' do
    let(:answer) { build(:answer) }

    it 'cge_approved' do
      answer.status = :cge_approved
      expect(answer_icon(answer)).to eq('fa-thumbs-up')
    end

    it 'sectoral_approved' do
      answer.status = :sectoral_approved
      expect(answer_icon(answer)).to eq('fa-thumbs-up')
    end

    it 'user_evaluated' do
      answer.status = :user_evaluated
      expect(answer_icon(answer)).to eq('fa-answers-o')
    end
  end

  describe 'answer_status' do
    it 'cge' do
      operator.operator_type = :cge

      expect(answer_status(operator)).to eq(:cge_approved)
    end
    it 'sectoral' do
      operator.operator_type = :sou_sectoral

      expect(answer_status(operator)).to eq(:awaiting)
    end
    it 'subnet' do
      operator.operator_type = :subnet_sectoral

      expect(answer_status(operator)).to eq(:awaiting)
    end
    it 'internal' do
      operator.operator_type = :internal

      expect(answer_status(operator)).to eq(:awaiting)
    end

  end

  describe 'answer_scope' do
    it 'cge' do
      operator.operator_type = :cge

      expect(answer_scope(operator, ticket)).to eq(:cge)
    end
    it 'sectoral' do
      operator.operator_type = :sou_sectoral

      expect(answer_scope(operator, ticket)).to eq(:sectoral)
    end
    it 'subnet_sectoral' do
      operator.operator_type = :subnet_sectoral

      expect(answer_scope(operator, ticket)).to eq(:subnet)
    end

    it 'internal' do
      operator.operator_type = :internal

      expect(answer_scope(operator, ticket)).to eq(:department)
    end

    it 'subnet internal' do
      operator.operator_type = :internal
      ticket = create(:ticket, :with_subnet)
      expect(answer_scope(operator, ticket)).to eq(:subnet_department)
    end

  end

  describe '#answer_department_responsible_from_log' do
    it 'present' do
      department = create(:department)
      data = {
        responsible_department_id: department.id
      }

      ticket_log = create(:ticket_log, :answer, data: data)

      expect(answer_department_responsible_from_log(ticket_log)).to eq(department)
    end

    it 'attribute blank nil' do
      ticket_log = create(:ticket_log, :answer)

      expect(answer_department_responsible_from_log(ticket_log)).to be_nil
    end
  end

  describe '#answer_subnet_responsible_from_log' do
    it 'present' do
      subnet = create(:subnet)
      data = {
        responsible_subnet_id: subnet.id
      }

      ticket_log = create(:ticket_log, :answer, data: data)

      expect(answer_subnet_responsible_from_log(ticket_log)).to eq(subnet)
    end

    it 'attribute blank nil' do
      ticket_log = create(:ticket_log, :answer)

      expect(answer_department_responsible_from_log(ticket_log)).to be_nil
    end
  end

  describe '#answer_organ_responsible_from_log' do
    it 'present' do
      organ = create(:executive_organ)
      data = {
        responsible_organ_id: organ.id
      }

      ticket_log = create(:ticket_log, :answer, data: data)

      expect(answer_organ_responsible_from_log(ticket_log)).to eq(organ)
    end

    it 'attribute blank nil' do
      ticket_log = create(:ticket_log, :answer)

      expect(answer_organ_responsible_from_log(ticket_log)).to be_nil
    end
  end

  describe '#answer_description_text' do

    context 'default' do
      it { expect(answer_description_text(operator)).to eq I18n.t('shared.answers.form.description.default') }
    end

    it 'operator internal' do
      operator = build(:user, :operator_internal)
      expect(answer_description_text(operator)).to eq I18n.t('shared.answers.form.description.internal')
    end
  end

  describe '#answer_save_text' do

    context 'operator external' do
      it { expect(answer_save_text(operator)).to eq I18n.t('shared.answers.form.save.default') }
    end

    it 'save external by operator internal' do
      operator = build(:user, :operator_internal)
      expect(answer_save_text(operator)).to eq I18n.t('shared.answers.form.save.internal')
    end
  end

  it 'answer_positioning_departments_for_select' do
    ticket_department = create(:ticket_department, ticket: ticket)
    create(:ticket_department, :answered, ticket: ticket)

    department = ticket_department.department
    expected = [[department.title, department.id]]

    expect(answer_positioning_departments_for_select(ticket)).to eq(expected)
  end

  it 'answer_active_by_ticket_department' do
    user = create(:user, :operator_internal)
    department = user.department
    ticket_department = create(:ticket_department, :answered, ticket: ticket, department: department)
    create(:answer, :rejected_positioning, ticket: ticket, user: user)
    awaiting_positioning = create(:answer, :awaiting_positioning, ticket: ticket, user: user)

    expect(answer_active_by_ticket_department(ticket_department)).to eq(awaiting_positioning)
  end

end
