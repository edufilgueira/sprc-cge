require 'rails_helper'
include UsersHelper

describe TicketsHelper do

  describe 'tickets_elegible_share_with_rede_ouvir' do
    it 'ticket sou and operator cge' do
      ticket = create(:ticket)
      user = create(:user, :operator_cge)

      expect(tickets_elegible_share_with_rede_ouvir?(ticket, user)).to be(true)
    end

    it 'ticket sic and operator cge' do
      ticket = create(:ticket, :sic)
      user = create(:user, :operator_cge)

      expect(tickets_elegible_share_with_rede_ouvir?(ticket, user)).to be(false)
    end
  end

  describe '#ticket_department_text_button' do
    before do
      allow(helper).to receive(:t).with(".transfer_departments.share").and_return(t('shared.tickets.forwards.transfer_departments.share'))
      allow(helper).to receive(:t).with(".referrals.edit").and_return(t('shared.tickets.forwards.referrals.edit'))
    end

    context 'when have ticket_departments' do
      it 'return share text button' do
        TicketsHelper.class_eval do
          define_method :all_ticket_departments do
            FactoryBot.create(:ticket_department)
          end
        end

        expect(helper.ticket_department_text_button).to eq(
          I18n.t('shared.tickets.forwards.transfer_departments.share')
        )
      end
    end

    context 'when havent ticket_departments' do
      it 'return edit text button' do

        TicketsHelper.class_eval do
          define_method :all_ticket_departments do
            []
          end
        end

        expect(helper.ticket_department_text_button).to eq(
          I18n.t('shared.tickets.forwards.referrals.edit')
        )
      end
    end
  end

  describe 'tickets_change_ticket_type_message' do
    it 'complaint to sic' do
      data_attributes = {
        from: 'complaint',
        to: 'sic'
      }

      from = Ticket.human_attribute_name("sou_type.#{data_attributes[:from]}")
      to = Ticket.human_attribute_name("ticket_type.#{data_attributes[:to]}")

      expected = I18n.t('shared.ticket_logs.change_ticket_type.title', from: from, to: to)

      expect(tickets_change_ticket_type_message(data_attributes)).to eq(expected)
    end

    it 'sic to complaint' do
      data_attributes = {
        from: 'sic',
        to: 'complaint'
      }

      from = Ticket.human_attribute_name("ticket_type.#{data_attributes[:from]}")
      to = Ticket.human_attribute_name("sou_type.#{data_attributes[:to]}")

      expected = I18n.t('shared.ticket_logs.change_ticket_type.title', from: from, to: to)

      expect(tickets_change_ticket_type_message(data_attributes)).to eq(expected)
    end

    it 'without from to complaint' do
      data_attributes = {
        from: '',
        to: 'complaint'
      }

      expected = I18n.t("shared.ticket_logs.change_ticket_type.#{data_attributes[:to]}.title")

      expect(tickets_change_ticket_type_message(data_attributes)).to eq(expected)
    end

    it 'without from to sic' do
      data_attributes = {
        from: '',
        to: 'sic'
      }

      expected = I18n.t("shared.ticket_logs.change_ticket_type.#{data_attributes[:to]}.title")

      expect(tickets_change_ticket_type_message(data_attributes)).to eq(expected)
    end
  end

  describe '#tickets_operator_link_cards_params' do
    it 'params for operator_sectoral' do
      user = create(:user, :operator_sectoral)
      expected = { ticket_type: :sou, without_denunciation: false }

      expect(tickets_operator_link_cards_params(user, :sou)).to eq(expected)
    end

    it 'params for operator_subnet' do
      user = create(:user, :operator_subnet)
      expected = { ticket_type: :sou, without_denunciation: false }

      expect(tickets_operator_link_cards_params(user, :sou)).to eq(expected)
    end

    it 'params for operator_cge' do
      user = create(:user, :operator_cge)
      expected = { ticket_type: :sou, without_denunciation: false }

      expect(tickets_operator_link_cards_params(user, :sou)).to eq(expected)
    end

    it 'params for operator_cge_denunciation_tracking' do
      user = create(:user, :operator_cge_denunciation_tracking)
      expected = { ticket_type: :sou, without_denunciation: false }

      expect(tickets_operator_link_cards_params(user, :sou)).to eq(expected)
    end
  end

  it 'ticket_answer_types_for_toggle' do
    expect(ticket_answer_types_for_toggle).to eq(Ticket.answer_types.keys)
  end

  it 'ticket_answer_types_for_select' do
    expected = Ticket.answer_types.keys.map do |answer_type|
      [ I18n.t("ticket.answer_types.#{answer_type}"), answer_type ]
    end

    expect(ticket_answer_types_for_select).to eq(expected)
  end

  it 'denunciation_types' do
    expected = Ticket.denunciation_types.keys.map do |denunciation_type|
      [ I18n.t("ticket.denunciation_types.#{denunciation_type}"), denunciation_type ]
    end

    expect(denunciation_types).to eq(expected)
  end

  it 'ticket_denunciation_assurances_for_select' do
    denunciation_assurances = Ticket.available_denunciation_assurances

    expected = denunciation_assurances.keys.map do |denunciation_assurance|
      [ Ticket.human_attribute_name("denunciation_assurance.#{denunciation_assurance}"), denunciation_assurance ]
    end

    expect(ticket_denunciation_assurances_for_select).to eq(expected)
  end

  it 'ticket_types_for_select' do
    ticket_types = Ticket.ticket_types

    expected = ticket_types.keys.map do |ticket_type|
      [ I18n.t("ticket.ticket_types.#{ticket_type}"), ticket_type ]
    end

    expect(ticket_types_for_select).to eq(expected)
  end

  it 'used_inputs_for_select' do
    used_inputs = Ticket.available_used_inputs

    expected = used_inputs.keys.map do |used_input|
      [ I18n.t("ticket.used_inputs.#{used_input}"), used_input ]
    end

    expect(used_inputs_for_select).to eq(expected)
  end

  it 'ticket_call_center_status_for_select' do
    call_center_statuses = Ticket.call_center_statuses

    expected = call_center_statuses.keys.map do |call_center_status|
      [ I18n.t("ticket.call_center_statuses.#{call_center_status}"), call_center_status ]
    end

    expect(ticket_call_center_status_for_select).to eq(expected)
  end

  context 'sou_types_for_select' do
    it 'default' do
      user = create(:user)
      sou_types = Ticket.sou_types.except(:denunciation)

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(sou_types_for_select(user)).to eq(expected)
    end

    it 'when cge denunciation' do
      user = create(:user, :operator_cge_denunciation_tracking)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(sou_types_for_select(user)).to eq(expected)
    end

    it 'when call_center' do
      user = create(:user, :operator_call_center)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(sou_types_for_select(user)).to eq(expected)
    end

    it 'when secotral' do
      user = create(:user, :operator_sectoral)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(sou_types_for_select(user)).to eq(expected)
    end
  end

  context 'ticket_sou_types_report_for_select' do
    it 'when cge' do
      user = create(:user, :operator_cge)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(ticket_sou_types_report_for_select(user)).to eq(expected)
    end

    it 'when cge denunciation' do
      user = create(:user, :operator_cge_denunciation_tracking)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(ticket_sou_types_report_for_select(user)).to eq(expected)
    end

    it 'when sectoral' do
      user = create(:user, :operator_sectoral)
      sou_types = Ticket.sou_types

      expected = sou_types.keys.map do |sou_type|
        [ I18n.t("ticket.sou_types.#{sou_type}"), sou_type ]
      end

      expect(ticket_sou_types_report_for_select(user)).to eq(expected)
    end
  end

  context 'ticket_answer_classifications_for_select' do

    context 'sic' do
      it 'when tickt in appeal' do
        ticket = create(:ticket, :sic, internal_status: :appeal)

        rejected_params = [
          :sic_attended_personal_info,
          :sic_attended_rejected_partially,
          :sic_rejected_secret,
          :sic_rejected_need_work,
          :sic_rejected_reserved,
          :sic_rejected_personal_info,
          :sic_not_attended_info_unclear,
          :sic_not_attended_info_nonexistent,
          :sic_rejected_ultrasecret,
          :sic_rejected_generic,
          :sic_not_attended_other_organs,
          :sic_attended_active,
          :sic_attended_passive,
          :sou_demand_well_founded,
          :sou_demand_unfounded,
          :sou_well_founded_partially,
          :sou_could_not_verify,
          :sou_waitting_determination_result,
          :other_organs,
          :legacy_classification
        ]

        answer_classifications = Ticket.answer_classifications.except(*rejected_params)

        expected = answer_classifications.keys.map do |answer_classification|
          [ I18n.t("ticket.answer_classifications.#{answer_classification}"), answer_classification ]
        end.sort { |x, y| x[0] <=> y[0] }

        expect(ticket_answer_classifications_for_select(ticket)).to eq(expected)
      end

      it 'when ticket not in appeal' do
        ticket = create(:ticket, :sic, internal_status: :sectoral_attendance)

        rejected_params = [
          :appeal_deferred,
          :appeal_rejected,
          :appeal_deferred_partially,
          :appeal_loss_object,
          :appeal_loss_object_partially,
          :appeal_not_allowed,
          :sou_demand_well_founded,
          :sou_demand_unfounded,
          :sou_well_founded_partially,
          :sou_could_not_verify,
          :sou_waitting_determination_result,
          :other_organs,
          :legacy_classification
        ]

        answer_classifications = Ticket.answer_classifications.except(*rejected_params)

        expected = answer_classifications.keys.map do |answer_classification|
          [ I18n.t("ticket.answer_classifications.#{answer_classification}"), answer_classification ]
        end.sort { |x, y| x[0] <=> y[0] }

        expect(ticket_answer_classifications_for_select(ticket)).to eq(expected)
      end
    end

    it 'sou' do
      ticket = create(:ticket, internal_status: :sectoral_attendance)

      rejected_params = [
        :sic_attended_personal_info,
        :sic_attended_rejected_partially,
        :sic_rejected_secret,
        :sic_rejected_need_work,
        :sic_rejected_reserved,
        :sic_rejected_personal_info,
        :sic_not_attended_info_unclear,
        :sic_not_attended_info_nonexistent,
        :sic_rejected_ultrasecret,
        :sic_rejected_generic,
        :sic_not_attended_other_organs,
        :sic_attended_active,
        :sic_attended_passive,
        :appeal_deferred,
        :appeal_rejected,
        :appeal_deferred_partially,
        :appeal_loss_object,
        :appeal_loss_object_partially,
        :appeal_not_allowed,
        :legacy_classification
      ]

      answer_classifications = Ticket.answer_classifications.except(*rejected_params)

      expected = answer_classifications.keys.map do |answer_classification|
        [ I18n.t("ticket.answer_classifications.#{answer_classification}"), answer_classification ]
      end.sort { |x, y| x[0] <=> y[0] }

      expect(ticket_answer_classifications_for_select(ticket)).to eq(expected)
    end
  end

  describe 'ticket_answer_type_selected' do
    let(:answer_type) { ticket_answer_types_for_select[0] }

    context 'with valid answer_type param' do
      it { expect(ticket_answer_type_selected(answer_type)).to eq(answer_type) }
    end

    context 'with empty param' do
      it { expect(ticket_answer_type_selected(nil)).to eq(answer_type) }
    end
  end

  describe 'remaining_days_to_deadline_class' do

    context 'not confirmed' do
      it { expect(remaining_days_to_deadline_class('-')).to eq('') }
    end

    context '0..4' do
      it { expect(remaining_days_to_deadline_class(4)).to eq('text-danger') }
    end

    context '5..9' do
      it { expect(remaining_days_to_deadline_class(5)).to eq('text-warning') }
    end

    context '10..INFINITY' do
      it { expect(remaining_days_to_deadline_class(10)).to eq('text-success') }
    end
  end

  describe 'status_for_operator' do
    it 'with organ' do
      ticket = build(:ticket, :with_organ)
      organ = ticket.organ

      expected = organ.acronym + ' - ' + ticket.internal_status_str

      expect(status_for_operator(ticket)).to eq expected
    end

    it 'with_rede_ouvir' do
      ticket = build(:ticket, :with_rede_ouvir)
      organ = ticket.organ

      expected = organ.acronym + ' - ' + ticket.internal_status_str + ' - ' + RedeOuvirOrgan.model_name.human

      expect(status_for_operator(ticket)).to eq expected
    end
  end

  it 'status_for_operator with subnet' do
    ticket = build(:ticket, :with_subnet)
    organ = ticket.organ
    subnet = ticket.subnet

    expected = organ.acronym + ' - ' + subnet.acronym + ' - ' + ticket.internal_status_str

    expect(status_for_operator(ticket)).to eq expected
  end

  context 'others children of same parent' do
    let(:ticket) { create(:ticket, :with_parent) }
    let(:parent) { ticket.parent }
    let(:ticket_second) { create(:ticket, :with_organ, parent_id: parent) }
    let(:ticket_third) { create(:ticket, :with_organ, parent_id: parent) }

    before do
      parent.tickets << ticket_second
      parent.tickets << ticket_third
      parent.save
    end

    it 'return children of parent except ticket param' do
      expected = [ticket, ticket_third].sort

      expect(children_except(ticket_second)).to eq expected
    end

    it 'when no children' do
      ticket_alone = create(:ticket)

      expect(children_except(ticket_alone)).to eq []
    end
  end

  describe 'description_for_operator' do
    let(:organ) { create(:executive_organ) }
    let(:department) { create(:department, organ: organ) }
    let(:user_2) { create(:user, department:department, organ: organ) }
    let(:ticket) { create(:ticket, organ: organ, internal_status: :sectoral_attendance) }
    let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
    let(:user) { create(:user, :operator_internal, department: department, organ: organ) }

    context 'internal' do
      context 'when ticket created by other user' do
        it {
          ticket.update(created_by: user_2)
          ticket_department
          expect(description_for_operator(user, ticket)).to eq ticket_department.description
        }
      end

      context 'when ticket created by internal' do
        let(:ticket_created_internal) { create(:ticket, created_by: user, description: "ticket description") }

        it { expect(description_for_operator(user, ticket_created_internal)).to eq ticket_created_internal.description }
      end
    end

    context 'others' do
      let(:user) { create(:user, :operator_cge) }

      it { expect(description_for_operator(user, ticket)).to eq ticket.description }

      context 'when denunciation' do
        let(:ticket) { create(:ticket, :denunciation) }

        it { expect(description_for_operator(user, ticket)).to eq ticket.denunciation_description }
      end
    end
  end

  describe 'document_type' do
    it 'ticket_document_types_for_select' do
      document_types = Ticket.document_types

      expected = document_types.keys.map do |document_type|
        [ I18n.t("ticket.document_types.#{document_type}"), document_type ]
      end

      expect(ticket_document_types_for_select).to eq(expected)
    end
  end

  it 'ticket_used_input_for_select' do
    used_inputs = Ticket.available_used_inputs.keys

    expected = used_inputs.map do |used_input|
      [ Ticket.human_attribute_name("used_input.#{used_input}"), used_input ]
    end

    expect(ticket_used_input_for_select).to eq(expected)
  end

  it 'status_for_citizen' do
    expected = Ticket::STATUSES_FOR_CITIZEN.map do |status|
      [ Ticket.human_attribute_name("statuses_for_citizen.#{status}"), status ]
    end

    expect(ticket_statuses_for_citizen).to eq(expected)
  end

  it 'ticket_all_internal_status' do
    internal_statuses = Ticket.internal_statuses.keys

    expected = internal_statuses.map do |status|
      [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
    end

    expect(ticket_all_internal_status).to eq(expected)
  end

  describe 'ticket_internal_status_for_select' do
    context 'sic' do
      it 'cge' do
        user = create(:user, :operator_cge)
        except_params = [:in_filling, :cge_validation]
        internal_statuses = Ticket.internal_statuses.except(*except_params).keys

        expected = internal_statuses.map do |status|
          [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
        end

        expect(ticket_internal_status_for_select('sic', user)).to eq(expected)
      end
    end

    context 'sou' do
      it 'operator cge' do
        user = create(:user, :operator_cge)
        except_params = [:in_filling, :appeal]
        internal_statuses = Ticket.internal_statuses.except(*except_params).keys

        expected = internal_statuses.map do |status|
          [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
        end

        expect(ticket_internal_status_for_select('sou', user)).to eq(expected)
      end

      it 'user blank' do
        expect(ticket_internal_status_for_select('sou')).to eq([])
      end

      context 'call_center operators' do
        it 'call_center' do
          user = create(:user, :operator_call_center)
          except_parmas = [:appeal, :awaiting_invalidation]
          internal_statuses = Ticket.internal_statuses.except(*except_parmas).keys

          expected = internal_statuses.map do |status|
            [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
          end

          expect(ticket_internal_status_for_select('sou', user)).to eq(expected)
        end

        it 'call_center_supervisor' do
          user = create(:user, :operator_call_center_supervisor)
          except_parmas = [:appeal, :awaiting_invalidation]
          internal_statuses = Ticket.internal_statuses.except(*except_parmas).keys

          expected = internal_statuses.map do |status|
            [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
          end

          expect(ticket_internal_status_for_select('sou', user)).to eq(expected)
        end

        it 'with user' do
          user = create(:user, :user)

          expect(ticket_internal_status_for_select('sou', user)).to eq([])
        end
      end

      it 'operator internal' do
        user = create(:user, :operator_internal)
        internal_statuses = Ticket.internal_statuses.slice(:internal_attendance, :partial_answer, :final_answer).keys

        expected = internal_statuses.map do |status|
          [ Ticket.human_attribute_name("internal_status.#{status}"), status ]
        end

        expect(ticket_internal_status_for_select('sou', user)).to eq(expected)
      end
    end
  end

  describe 'info_details' do

    it 'anonymous' do
      ticket = build(:ticket, :anonymous)
      expect(info_details(ticket)).to eq("")
    end

    it 'only name' do
      ticket = build(:ticket, email: '', document: '')
      expect(info_details(ticket)).to eq("#{ticket.name}")
    end

    it 'only name email' do
      ticket = build(:ticket, document: '')
      expect(info_details(ticket)).to eq("#{ticket.email} - #{ticket.name}")
    end

    it 'only name document' do
      ticket = build(:ticket, email: '')
      expect(info_details(ticket)).to eq("#{ticket.document} - #{ticket.name}")
    end

    it 'document - email - name' do
      ticket = build(:ticket)
      expect(info_details(ticket)).to eq("#{ticket.document} - #{ticket.email} - #{ticket.name}")
    end
  end

  it 'ticket_deadlines_for_select' do
    expected = Ticket::FILTER_DEADLINE.keys.map do |filter|
      [ Ticket.human_attribute_name("deadline.#{filter}"), filter ]
    end

    expect(ticket_deadlines_for_select).to eq(expected)
  end

  describe 'ticket_internal_status_str' do
    it 'status_str_rejected_validation' do
      ticket = create(:ticket, :with_parent, :in_sectoral_attendance)
      answer = create(:answer, ticket: ticket, status: :cge_rejected)

      expected = "[#{Answer.human_attribute_name("status.#{ticket.ticket_type}.cge_rejected")}] #{ticket.internal_status_str}"

      expect(ticket_internal_status_str(ticket)).to eq(expected)
    end

    it 'internal_status_str' do
      ticket = create(:ticket)

      expect(ticket_internal_status_str(ticket)).to eq(ticket.internal_status_str)
    end
  end

  context 'alert index' do
    let(:ticket) { build(:ticket) }

    it 'normal' do
      expect(ticket_highlight_row(ticket)).to eq(nil)
    end

    context 'highlight-background-red' do
      it 'expired' do
        ticket.deadline = -1
        ticket.deadline_ends_at = 1.days.ago

        expect(ticket_highlight_row(ticket)).to eq('highlight-background-red')
      end

      it 'expired and priority' do
        ticket.deadline = -1
        ticket.deadline_ends_at = 1.days.ago
        ticket.priority = true

        expect(ticket_highlight_row(ticket)).to eq('highlight-background-red')
      end

      it 'cge_rejected' do
        ticket = create(:ticket, :with_parent, :in_sectoral_attendance)
        answer = create(:answer, ticket: ticket, status: :cge_rejected)

        expect(ticket_highlight_row(ticket)).to eq('highlight-background-red')
      end

      it 'subnet_rejected' do
        ticket = create(:ticket, :with_parent, internal_status: :subnet_attendance)
        answer = create(:answer, ticket: ticket, status: :subnet_rejected)

        expect(ticket_highlight_row(ticket)).to eq('highlight-background-red')
      end

      it 'ticket has extensin in progress' do
        ticket = create(:ticket, :with_parent)
        extension = create(:extension, :in_progress, ticket: ticket)
        user = create(:user, :operator_chief, organ: ticket.organ)

        expect(ticket_alert_deadline?(ticket, user)).to be_truthy
      end


      context 'reopened' do
        it 'parent' do
          ticket.reopened = 1

          expect(ticket_alert_reopen_appeal?(ticket)).to be_truthy
        end

        it 'child' do
          child = create(:ticket, :with_parent, reopened: 1)
          ticket = child.parent

          expect(ticket_alert_reopen_appeal?(ticket)).to be_truthy
        end
      end

      context 'sectoral_validation' do
        it 'parent' do
          ticket.internal_status = :sectoral_validation

          expect(ticket_alert_waiting?(ticket)).to be_truthy
        end

        it 'child' do
          child = create(:ticket, :with_parent, internal_status: :sectoral_validation)
          ticket = child.parent

          expect(ticket_alert_waiting?(ticket)).to be_truthy
        end
      end

      it 'childs with awaiting_invalidation' do
        ticket = create(:ticket, :with_parent, internal_status: :awaiting_invalidation)
        ticket_parent = ticket.parent

        expect(ticket_alert_waiting?(ticket_parent)).to be_truthy
      end

      it 'highlight-background-yellow priority' do
        ticket.priority = true

        expect(ticket_highlight_row(ticket)).to eq('highlight-background-yellow')
      end
    end
  end

  describe 'ticket_sou_types' do
    let(:ticket) { build(:ticket) }

    context 'when not anonymous' do
      it 'defaut' do
        expect(ticket_sou_types).to eq(Ticket.sou_types.keys)
      end

      it 'with param' do
        expect(ticket_sou_types(false)).to eq(Ticket.sou_types.keys)
      end
    end

    it 'when anonymous' do
      expected = Ticket.sou_types.except("compliment").keys
      expect(ticket_sou_types(true)).to eq(expected)
    end

    it 'when only denunciation' do
      expect(ticket_sou_types(false, true)).to eq(['denunciation'])
      expect(ticket_sou_types(true, true)).to eq(['denunciation'])
    end
  end

  it 'ticket_logs of tickets waiting_invalidation from ticket parent' do
    organ = create(:executive_organ)
    user = create(:user, :operator_sectoral, organ: organ)

    ticket_invalidaded = create(:ticket, :with_parent, internal_status: :awaiting_invalidation, organ: organ)
    ticket_parent = ticket_invalidaded.parent
    create(:ticket, :with_organ, parent: ticket_parent, internal_status: :sectoral_attendance)

    data_waiting = { status: :waiting }
    data_rejected = { status: :rejected }
    create(:ticket_log, ticket: ticket_parent, responsible: user, action: :invalidate, description: "bla", data: data_waiting)
    create(:ticket_log, ticket: ticket_parent, responsible: user, action: :invalidate, description: "bla", data: data_rejected)

    ticket_log = create(:ticket_log, ticket: ticket_parent, responsible: user, action: :invalidate, description: "bla", data: data_waiting)

    expect(ticket_last_log_invalidate(ticket_parent)).to eq(ticket_log)
  end

  describe 'ticket_existent_answer_attachments' do
    let(:ticket) { create(:ticket, :with_parent) }
    let(:ticket_parent) { ticket.parent }
    let(:other_ticket) { create(:ticket, :with_parent, parent: ticket_parent) }

    let(:answer) { create(:answer, ticket: ticket) }
    let(:answer_ticket_parent) { create(:answer, ticket: ticket_parent) }
    let(:answer_other_ticket) { create(:answer, ticket: other_ticket) }

    let(:attachment) { create(:attachment, attachmentable: answer) }
    let(:attachment_ticket_parent) { create(:attachment, attachmentable: answer_ticket_parent) }
    let(:attachment_other_ticket) { create(:attachment, attachmentable: answer_other_ticket) }


    before do
      attachment
      attachment_ticket_parent
      attachment_other_ticket
    end

    context 'when ticket child' do
      context 'when operator sectoral' do
        let(:user) { create(:user, :operator_sectoral) }

        it { expect(ticket_existent_answer_attachments(ticket, user)).to eq([attachment]) }
      end

      context 'when operator internal' do
        let(:user) { create(:user, :operator_internal) }
        let(:other_user) { create(:user, :operator_internal) }

        let(:department) { user.department }
        let(:other_department) { other_user.department }


        let(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
        let(:other_ticket_department) { create(:ticket_department, ticket: ticket, department: other_department) }

        let(:answer) { create(:answer, :approved_positioning, ticket: ticket, user: user) }
        let(:answer_from_other_department) { create(:answer, :approved_positioning, ticket: ticket, user: other_user) }

        let(:attachment_other_answer) { create(:attachment, attachmentable: answer_from_other_department) }

        before do
          ticket_department
          other_ticket_department
          attachment_other_answer
        end


        it { expect(ticket_existent_answer_attachments(ticket, user)).to eq([attachment]) }
      end
    end

    # ticket pai tem acesso a todos anexos dele e vinculados aos filhos
    context 'when ticket parent' do
      let(:user){ create(:user, :operator_cge) }
      it { expect(ticket_existent_answer_attachments(ticket_parent, user)).to eq([attachment, attachment_ticket_parent, attachment_other_ticket]) }
    end
  end

  context 'Operator tabs' do
    let(:user){ create(:user, :operator_sectoral) }
    let(:ticket) { create(:ticket, :with_parent) }

    it 'default' do
      expected = [:infos, :classification, :areas, :comments, :replies, :history]

      expect(tickets_operator_tabs(user, ticket)).to eq(expected)
    end

    it 'attendance_evaluation tab' do
      ticket = create(:ticket, :sic, :with_organ, :replied, internal_status: :final_answer)

      expected = [
        :infos,
        :classification,
        :areas,
        :comments,
        :replies,
        :history,
        :attendance_evaluations
      ]

      expect(tickets_operator_tabs(user, ticket)).to eq(expected)
    end

    it 'operator internal' do
      user = create(:user, :operator_internal)
      expected = [:infos, :areas, :comments, :internal_replies, :history]

      expect(tickets_operator_tabs(user, ticket)).to eq(expected)
    end

    context 'operator CGE' do
      tabs = [:infos, :areas, :classification, :comments, :replies, :history]

      it 'tabs defaults' do
        user = create(:user, :operator_cge)

        expect(tickets_operator_tabs(user, ticket)).to eq(tabs)
      end

      context 'evaluation internal tab' do
        before { 
          ticket.update_attribute(:marked_internal_evaluation, true) 
          ticket.update_attribute(:status, :replied) 
          ticket.update_attribute(:internal_status, :final_answer) 
          user.update_attribute(:operator_type, :cge)

        }
        
        it 'marked for internal valuation' do
          tabs = tabs.concat([:internal_evaluation])
          expect(tickets_operator_tabs(user, ticket)).to eq(tabs)
        end
      end
    end
  end

  context 'count of children who can answer' do
    context 'ticket_parent' do
      let(:ticket) { create(:ticket, :with_parent) }
      let(:ticket_parent) { ticket.parent }

      before do
        second_ticket = create(:ticket, :with_organ, :confirmed)
        third_ticket = create(:ticket, :with_organ, :invalidated)

        ticket_parent.tickets << second_ticket
        ticket_parent.tickets << third_ticket
        ticket_parent.save
      end

      it 'default' do
        expect(ticket_children_can_answer_count(ticket_parent)).to eq(2)
      end

      it 'with reopened' do
        ticket_parent.update_attribute(:reopened, 1)
        expect(ticket_children_can_answer_count(ticket_parent)).to eq(3)
      end

      it 'default' do
        ticket_parent.update_attribute(:appeals, 2)
        expect(ticket_children_can_answer_count(ticket_parent)).to eq(4)
      end
    end

    context 'ticket without parent' do
      it 'default to 1' do
        ticket = create(:ticket, :with_organ, :replied)

        expect(ticket_children_can_answer_count(ticket)).to eq(1)
      end

      it 'ticket reopened' do
        ticket = create(:ticket, :with_organ, :replied, reopened: 2)

        expect(ticket_children_can_answer_count(ticket)).to eq(3)
      end

      it 'ticket appealed' do
        ticket = create(:ticket, :with_organ, :replied, appeals: 2)

        expect(ticket_children_can_answer_count(ticket)).to eq(3)
      end
    end
  end

  context 'ticket_table_columns_for_operator' do

    context 'when ticket_type sou' do
        let(:ticket_type) { :sou }

      context 'when cge' do
        let(:user) { create(:user, :operator_cge) }
        let(:expected) do
          [
            :confirmed_at,
            :deadline,
            :name,
            :parent_protocol,
            :sou_type,
            :internal_status,
            :description
          ]
        end

        it { expect(ticket_table_columns_for_operator(ticket_type, user)).to eq(expected) }
      end

      context 'when call_center' do
        let(:user) { create(:user, :operator_call_center) }
        let(:expected) do
          [
            :confirmed_at,
            :deadline,
            :name,
            :parent_protocol,
            :sou_type,
            :internal_status,
            :description
          ]
        end

        it { expect(ticket_table_columns_for_operator(ticket_type, user)).to eq(expected) }
      end

      context 'when call_center_supervisor' do
        let(:user) { create(:user, :operator_call_center_supervisor) }
        let(:expected) do
          [
            :confirmed_at,
            :deadline,
            :name,
            :parent_protocol,
            :sou_type,
            :internal_status,
            :description
          ]
        end

        it { expect(ticket_table_columns_for_operator(ticket_type, user)).to eq(expected) }
      end

      context 'when sectoral' do
        let(:user) { create(:user, :operator_sectoral) }
        let(:expected) do
          [
            :confirmed_at,
            :deadline,
            :name,
            :parent_protocol,
            :sou_type,
            :internal_status,
            :departments,
            :description
          ]
        end

        it { expect(ticket_table_columns_for_operator(ticket_type, user)).to eq(expected) }
      end

      context 'when internal' do
        let(:user) { create(:user, :operator_internal) }
        let(:expected) do
          [
            :confirmed_at,
            :ticket_departments_deadline,
            :parent_protocol,
            :sou_type,
            :internal_status,
            :organs,
            :description
          ]
        end

        it { expect(ticket_table_columns_for_operator(ticket_type, user)).to eq(expected) }
      end
    end
  end

  describe 'check ticket filters params present ' do
    context 'range filter' do
      it 'present' do
        params = { created_at: { start: 'any', end: 'any' } }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'only start' do
        params = { created_at: { start: 'any' } }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'only end' do
        params = { created_at: { end: 'any' } }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'blank' do
        params = {  }
        expect(ticket_filter_params?(params)).to be_falsey
      end
    end

    context 'finalized filter' do
      it 'finalized' do
        params = { finalized: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'not finalized' do
        params = { finalized: '0' }
        expect(ticket_filter_params?(params)).to be_falsey
      end

      it 'blank' do
        params = { }
        expect(ticket_filter_params?(params)).to be_falsey
      end
    end

    context 'extension_in_progress' do
      it 'in_progress' do
        params = { extension_in_progress: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'not in_progress' do
        params = { extension_in_progress: '0' }
        expect(ticket_filter_params?(params)).to be_falsey
      end

      it 'blank' do
        params = { }
        expect(ticket_filter_params?(params)).to be_falsey
      end
    end

    context 'other filters present' do
      it 'search' do
        params = { search: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'parent_protocol' do
        params = { parent_protocol: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'internal_status' do
        params = { internal_status: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'budget_program' do
        params = { budget_program: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'priority' do
        params = { priority: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'deadline' do
        params = { deadline: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'organ' do
        params = { organ: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'status_for_citizen' do
        params = { status_for_citizen: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'answer_type' do
        params = { answer_type: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'sou_type' do
        params = { sou_type: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'department' do
        params = { department: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'sub_department' do
        params = { sub_department: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'topic' do
        params = { topic: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'service_type' do
        params = { service_type: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'subnet' do
        params = { subnet: 'any' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'extension_in_progress' do
        params = { extension_in_progress: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'denunciation' do
        params = { denunciation: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'finalized' do
        params = { finalized: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'rede_ouvir_cge' do
        params = { rede_ouvir_cge: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'rede_ouvir' do
        params = { rede_ouvir: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'without_denunciation' do
        params = { without_denunciation: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'priority' do
        params = { priority: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end

      it 'other_organs' do
        params = { other_organs: '1' }
        expect(ticket_filter_params?(params)).to be_truthy
      end
    end
  end

  it 'find protocol from ticket_log invalidate' do
    ticket = create(:ticket, :with_parent)

    data = { status: :approved, target_ticket_id: ticket.id }
    ticket_log = create(:ticket_log, ticket: ticket.parent, action: :invalidate, data: data)

    expect(tickets_invalidate_log_protocol(ticket_log)).to eq(ticket.parent_protocol)
  end

  describe '#operator_ticket_transfer_department' do
    before { create(:ticket_department) }

    it 'return ticket department transfer url' do
      TicketsHelper.class_eval do
        define_method :ticket_department_by_user_department do
          TicketDepartment.first
        end
      end

      ticket_department = TicketDepartment.first
      expect(helper.operator_ticket_transfer_department(ticket_department.ticket)).to eq(
        edit_operator_ticket_transfer_department_path(ticket_department.ticket, ticket_department)
      )
    end
  end

  describe '#ticket_log_detail_to_extension?' do
    context 'when extension needs a chief approval' do
      it 'returns chief log detail' do
        extension = create(:extension, :in_progress)
        expect(ticket_log_detail_to_extension(extension)).to eq(
          I18n.t('shared.ticket_logs.extension.in_progress.chief_responsible', organ: extension.organ.title)
        )
      end
    end

    context 'when extension needs a coordinator approval' do
      it 'returns coordination log detail' do
        extension = create(:extension, :in_progress, solicitation: 2)
        expect(ticket_log_detail_to_extension(extension)).to eq(
          I18n.t('shared.ticket_logs.extension.in_progress.coordination_responsible')
        )
      end
    end
  end

  describe '#checked_extension_in_progress?' do
    context 'when extension_status in_progress' do
      context 'when first extension' do
        it 'return true' do
          extension = create(:extension, :in_progress)
          expect(checked_extension_in_progress?(extension.status.to_s, '1')).to be_truthy
        end
      end

      context 'when solicitation is nil' do
        it 'return true' do
          extension = create(:extension, :in_progress)
          expect(checked_extension_in_progress?(extension.status.to_s, nil)).to be_truthy
        end
      end

      context 'when second extension' do
        it 'return false' do
          extension = create(:extension, :in_progress)
          expect(checked_extension_in_progress?(extension.status.to_s, '2')).to be_falsey
        end
      end
    end

    context 'when extension_status is different than in_progress' do
      it 'return false' do
        extension = create(:extension, status: :approved)
        expect(checked_extension_in_progress?(extension.status.to_s, '1')).to be_falsey
      end
    end
  end

  describe '#show_tab?' do
    context 'when tab internal_evaluation and marked_internal_evaluation' do
      let(:ticket){ create(:ticket, :replied) }
      before { ticket.update_attribute(:marked_internal_evaluation, true) }

      it 'ticket marked for internal evaluation' do
        allow(self).to receive(:show_tab?).with(:internal_evaluation, ticket).and_return(true)
        expect(show_tab?(:internal_evaluation, ticket)).to be_truthy
      end
    end
  end

  describe '#controller_name_sou_evaluation_samples?' do
    context 'controller_name' do
      let(:controller_name) { :sou_evaluation_samples }
      let(:controller_name_different) { :not_sou_evaluation_samples }

      it 'is sou_evaluation_samples' do
        set_controller_name(controller_name)
        expect(controller_name_sou_evaluation_samples?).to be_truthy
      end

      it 'different of sou_evaluation_samples' do
        set_controller_name(controller_name_different)
        expect(controller_name_sou_evaluation_samples?).to be_falsey
      end
    end
  end

  describe '#filter_label' do
    let(:controller_name) { :sou_evaluation_samples }
    let(:controller_name_different) { :not_sou_evaluation_samples }
    
    context 'controller_name' do 
      it 'is sou_evaluation_samples' do
        set_controller_name(controller_name)

        expect(filter_label).to eq I18n.t('operator.tickets.index.sample_filters')
      end

      it 'different of sou_evaluation_samples' do
        set_controller_name(controller_name_different)

        expect(filter_label).to eq I18n.t('operator.tickets.index.filters')
      end
    end
  end
  
  describe 'Links to create new Tickets' do

    context 'CT Web' do
      before do
        set_ceara_app(false)
      end

      context 'SOU' do
        context 'Platform' do
          it 'with profile' do
            set_platform
            url = '/platform/tickets/new?ticket_type=sou'
            expect(link_to_new_ticket(ticket_type: 'sou')).to eq(url)
            set_platform(false) # é preciso setar false para nao atrapalhar testes randomicos
          end
        end

        it 'no profile' do
          url = '/tickets/new?ticket_type=sou'
          expect(link_to_new_ticket(ticket_type: 'sou')).to eq(url)
        end

        it 'anonymous' do
          url = '/tickets/new?anonymous=true&ticket_type=sou'
          expect(link_to_new_ticket(ticket_type: 'sou', anonymous: true)).to eq(url)
        end
      end

      context 'SIC' do
        it 'no profile' do
          url = '/tickets/new?ticket_type=sic'
          expect(link_to_new_ticket(ticket_type: 'sic')).to eq(url)
        end

        it 'with profile' do
          set_platform
          url = '/platform/tickets/new?ticket_type=sic'
          expect(link_to_new_ticket(ticket_type: 'sic')).to eq(url)
          set_platform(false) # é preciso setar false para nao atrapalhar testes randomicos
        end
      end
    end

    context 'Ceara App' do
      before do
        set_ceara_app
      end

      context 'SOU' do
        context 'Platform' do
          it 'with profile' do
            set_platform
            url = '/ceara_app/platform/tickets/new?ticket_type=sou'
            expect(link_to_new_ticket(ticket_type: 'sou')).to eq(url)
            set_platform(false) # é preciso setar false para nao atrapalhar testes randomicos
          end
        end

        it 'no profile' do
          url = '/ceara_app/tickets/new?ticket_type=sou'
          expect(link_to_new_ticket(ticket_type: 'sou')).to eq(url)
        end

        it 'anonymous' do
          url = '/ceara_app/tickets/new?anonymous=true&ticket_type=sou'
          expect(link_to_new_ticket(ticket_type: 'sou', anonymous: true)).to eq(url)
        end
      end

      context 'SIC' do
        context 'Platform' do
          it 'with profile' do
            set_platform
            url = '/ceara_app/platform/tickets/new?ticket_type=sic'
            expect(link_to_new_ticket(ticket_type: 'sic')).to eq(url)
            set_platform(false) # é preciso setar false para nao atrapalhar testes randomicos
          end
        end

        it 'no profile' do
          url = '/ceara_app/tickets/new?ticket_type=sic'
          expect(link_to_new_ticket(ticket_type: 'sic')).to eq(url)
        end
      end
    end
  end
end



def set_ceara_app(value=true)
  TicketsHelper.class_eval do
    define_method :is_ceara_app? do
      value
    end
  end
end

def set_platform(value=true)
  TicketsHelper.class_eval do
    define_method :is_platform? do
      value
    end
  end
end

def set_controller_name(controller_name)
  TicketsHelper.class_eval do
    define_method :controller_name_sou_evaluation_samples? do
      controller_name == :sou_evaluation_samples
    end
  end
end
