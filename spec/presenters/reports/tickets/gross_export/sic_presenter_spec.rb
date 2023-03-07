require 'rails_helper'

describe Reports::Tickets::GrossExport::SicPresenter do
  let(:date) { Date.today }
  let(:gross_export) { create(:gross_export, :all_columns, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
  let(:gross_export_without_confirmed_at) { create(:gross_export, :all_columns, filters: { ticket_type: :sic, confirmed_at: { start: nil, end: nil} }) }
  let(:scope) { gross_export.filtered_scope }

  subject(:presenter) { Reports::Tickets::GrossExport::SicPresenter.new(scope, gross_export.id) }
  subject(:presenter_without_confirmed_at) { Reports::Tickets::GrossExport::SicPresenter.new(scope, gross_export_without_confirmed_at.id) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::GrossExport::SicPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::GrossExport::SicPresenter).to have_received(:new).with(scope, gross_export.id)
    end
  end

  describe 'helpers' do

    context 'rows' do
      let(:ticket) do
        ticket = create(:ticket, :sic, :replied, :gross_export)
        ticket.extended = false
        ticket.save
        ticket
      end
      let(:scope) { [ ticket ] }
      let(:answer_ticket) { ticket.answers.where(answer_type: [ :final, :partial]).cge_approved.first }


      let(:cell_line_break) { "\x0D\x0A" }
      let(:cell_separator) { "#{cell_line_break}---------------------------#{cell_line_break}" }
      let(:expected_attendance_evaluation) {
        attendance_evaluation = ticket.attendance_evaluation
        "#{AttendanceEvaluation.human_attribute_name(:clarity)}: #{attendance_evaluation.clarity}#{cell_line_break}" +
        "#{AttendanceEvaluation.human_attribute_name(:content)}: #{attendance_evaluation.content}#{cell_line_break}" +
        "#{AttendanceEvaluation.human_attribute_name(:wording)}: #{attendance_evaluation.wording}#{cell_line_break}" +
        "#{AttendanceEvaluation.human_attribute_name(:kindness)}: #{attendance_evaluation.kindness}#{cell_line_break}#{cell_line_break}" +
        "#{AttendanceEvaluation.human_attribute_name(:average)}: #{attendance_evaluation.average}#{cell_separator}" +
        "#{AttendanceEvaluation.human_attribute_name(:comment)}:#{cell_line_break}#{attendance_evaluation.comment}"
      }

      let(:last_answer_status) { :answered_on_time }
      let(:last_answer_status_str) { I18n.t("presenters.reports.tickets.gross_export.last_answer_status.#{last_answer_status}") }

      let(:responded_at) { I18n.l(ticket.responded_at, format: :date) }
      let(:answer_time_in_days) { (ticket.responded_at.to_date - ticket.confirmed_at.to_date).to_i }
      let(:ticket_deadline) { '-' }

      let(:row) do
        {
          organ: ticket.organ_acronym,
          subnet: '-',
          departments: '-',
          departments_classification: ticket.classification.department_name,
          subdepartment: ticket.classification.sub_department_name,
          protocol: ticket.parent_protocol,
          created_by: '-',
          description: ticket.description,
          shared: I18n.t("boolean.#{ticket.shared?}").upcase,
          other_organs: I18n.t("boolean.#{ticket.other_organs || false}").upcase,
          internal_status: ticket.internal_status_str,
          topic: ticket.classification.topic_name,
          subtopic: '-',    # subtopic_name,
          budget_program: ticket.classification.budget_program_name,
          service_type: ticket.classification.service_type_name,
          origem_input: ticket.used_input_str,
          year: ticket.confirmed_at.year,
          month: ticket.confirmed_at.month,
          confirmed_at: I18n.l(ticket.confirmed_at, format: :date),
          answered_at: responded_at,
          final_answer_at: responded_at,
          answer_time_in_days: answer_time_in_days,
          immediate_answer: I18n.t("boolean.#{ticket.immediate_answer?}").upcase, # NAO,
          last_answer_status: last_answer_status_str,
          last_answer_status_department: '-',
          answers_description: nil,
          answers_department_created_at: '-',
          reopened: 0,
          reopened_description: '',
          appeals: ticket.appeals,
          neighborhood: ticket.answer_address_neighborhood,
          city: ticket.city_name,
          state: ticket.city_state_acronym,
          answer_type: ticket.answer_type_str,
          deadline: ticket_deadline,
          evaluation: ticket.last_evaluation_average,
          has_extension: I18n.t("boolean.#{ticket.extended}").upcase,     # ticket.extensions.approved.present?
          answer_classification: ticket.answer_classification_str,
          attendance_evaluation: expected_attendance_evaluation,
          average_attendance_evaluation_organ: ticket.organ.average_attendance_evaluation,
          person_type: ticket.person_type_str,
          user_name: ticket.name,
          user_social_name: ticket.social_name,
          user_email: ticket.email,
          user_phone: ticket.answer_phone,
          user_cell_phone: ticket.answer_cell_phone,
          gender: ticket.gender_str
        }.values
      end

      before { ticket }

      it 'content' do
        expect(presenter.rows).to eq([row])
      end

      context 'presenter without confirmed_at ' do
        it { expect(presenter_without_confirmed_at.rows).to eq([row]) }
      end

      context 'last_answer_status' do
        context 'answered_on_time' do
          let(:last_answer_status) { :answered_on_time }

          before { ticket.update(responded_at: Date.today, deadline: 0) }

          it { expect(presenter.rows).to eq([row]) }
        end

        context 'answered_out_time' do
          let(:last_answer_status) { :answered_out_time }

          before do
            ticket.update(responded_at: Date.today, deadline: -1)
            answer_ticket.update(sectoral_deadline: -1)
          end

          it { expect(presenter.rows).to eq([row]) }
        end

        context 'in_progress' do
          let(:last_answer_status) { :in_progress }

          let(:responded_at) { nil }
          let(:answer_time_in_days) { 0 }
          let(:ticket_answers) { '' }
          let(:ticket_deadline) { ticket.deadline }

          before do
            ticket.update(responded_at: nil, deadline: 0)
            ticket.answers.destroy_all
          end

          it { expect(presenter.rows).to eq([row]) }
        end

        context 'delayed' do
          let(:last_answer_status) { :delayed }

          let(:responded_at) { nil }
          let(:answer_time_in_days) { 0 }
          let(:ticket_answers) { '' }
          let(:ticket_deadline) { ticket.deadline }

          before do
            ticket.update(responded_at: nil, deadline: -1)
            ticket.answers.destroy_all
          end

          it {
            expect(presenter.rows).to eq([row])
          }
        end
      end

      context 'answer' do
        let(:user) { create(:user, :operator_cge)}
        let(:ticket_replied) { create(:ticket, :sic, :with_parent, :replied) }
        let(:ticket_replied_parent) do
          ticket_replied.parent.created_by = user
          ticket_replied.parent.sic!
          ticket_replied.parent
        end
        let(:answer_ticket) { ticket_replied.answers.where(answer_type: [ :final, :partial]).cge_approved.first }

        let!(:ticket_log_cge) do
          data = { responsible_as_author: user.title }

          create(:ticket_log, responsible: user, resource: answer_ticket, ticket_id: ticket_replied_parent.id, action: TicketLog.actions[:answer_cge_approved], data: data, created_at: DateTime.now)
        end

        let(:ticket_answers) do
          date_approved = I18n.l(ticket_log_cge.created_at, format: :date)
          approved_by = I18n.t("presenters.reports.tickets.gross_export.answers.approved_by" , user: ticket_log_cge.data[:responsible_as_author], date: date_approved)
          answers = I18n.t("presenters.reports.tickets.gross_export.answers.description" , date: answer_ticket.created_at, user: answer_ticket.as_author, description: answer_ticket.description)
          ActionController::Base.helpers.sanitize("#{answers}\n#{approved_by}\n\n", tags: [])
        end

        let(:responded_at) { I18n.l(ticket_replied.responded_at, format: :date) }
        let(:scope) { [ ticket_replied ] }

        let(:row_answer) do
          {
            organ: ticket_replied.organ_acronym,
            subnet: '-',    # subrede
            departments: '-',    # departments
            departments_classification: nil,
            subdepartment: nil,
            protocol: ticket_replied.parent_protocol,
            created_by: user.as_author,
            description: ticket_replied.description,
            shared: I18n.t("boolean.#{ticket.shared?}").upcase,
            other_organs: I18n.t("boolean.#{ticket.other_organs || false}").upcase,
            internal_status: ticket_replied.internal_status_str,
            topic: '-',
            subtopic: '-',    # subtopic_name,
            budget_program: '-',
            service_type: '-',
            origem_input: ticket_replied.used_input_str,
            year: ticket_replied.confirmed_at.year,
            month: ticket_replied.confirmed_at.month,
            confirmed_at: I18n.l(ticket_replied.confirmed_at, format: :date),
            answered_at: responded_at,
            final_answer_at: responded_at,
            answer_time_in_days: 0,
            immediate_answer: I18n.t("boolean.#{ticket.immediate_answer?}").upcase, # NAO,
            last_answer_status: last_answer_status_str,
            last_answer_status_department: '-',
            answers_description: ticket_answers,
            answers_department_created_at: '-',
            reopened: ticket.reopened,
            reopened_description: '',
            appeals: ticket_replied.appeals,
            neighborhood: ticket_replied.answer_address_neighborhood,
            city: ticket_replied.city_name,
            state: ticket_replied.city_state_acronym,
            answer_type: ticket_replied.answer_type_str,
            deadline: '-',
            evaluation: ticket_replied.last_evaluation_average,
            has_extension: I18n.t("boolean.#{ticket_replied.extended}").upcase,     # ticket.extensions.approved.present?
            answer_classification: ticket_replied.answer_classification_str,
            attendance_evaluation: nil,
            average_attendance_evaluation_organ: 0.0,
            person_type: ticket_replied.person_type_str,
            user_name: ticket_replied.name,
            user_social_name: ticket_replied.social_name,
            user_email: ticket_replied.email,
            user_phone: ticket_replied.answer_phone,
            user_cell_phone: ticket_replied.answer_cell_phone,
            gender: ticket_replied.gender_str
          }.values
        end

        it { expect(presenter.rows).to eq([row_answer]) }
      end
    end

    context 'columns' do
      let(:ticket) { create(:ticket, :sic, :with_parent, :gross_export, :replied) }
      let(:parent) { ticket.parent }
      let(:columns_creator_info) {
        [
          :person_type,
          :user_name,
          :user_social_name,
          :user_email,
          :user_phone,
          :user_cell_phone,
          :gender
        ]
      }

      let(:columns_without_creator_info) {
        [
          :organ,
          :subnet,
          :departments,
          :departments_classification,
          :subdepartment,
          :protocol,
          :created_by,
          :description,
          :shared,
          :other_organs,
          :internal_status,
          :topic,
          :subtopic,
          :budget_program,
          :service_type,
          :origem_input,
          :year,
          :month,
          :confirmed_at,
          :answered_at,
          :final_answer_at,
          :answer_time_in_days,
          :immediate_answer,
          :last_answer_status,
          :last_answer_status_department,
          :answers_description,
          :answers_department_created_at,
          :reopened,
          :reopened_description,
          :appeals,
          :neighborhood,
          :city,
          :state,
          :answer_type,
          :deadline,
          :evaluation,
          :has_extension,
          :answer_classification,
          :attendance_evaluation,
          :average_attendance_evaluation_organ
        ]
      }

      let(:columns) {
        columns_without_creator_info + columns_creator_info
      }

      before { ticket }

      context 'without creator info' do
        let(:gross_export) { create(:gross_export, load_description: true, load_answers: true, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        it { expect(presenter.active_columns).to eq(columns_without_creator_info) }
      end

      context 'without description' do
        let(:gross_export) { create(:gross_export, load_creator_info: true, load_answers: true, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        it { expect(presenter.active_columns).to eq(columns - [:description]) }
      end

      context 'without answers' do
        let(:gross_export) { create(:gross_export, load_creator_info: true, load_description: true, filters: { ticket_type: :sic, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        it { expect(presenter.active_columns).to eq(columns - [:answers_description, :answers_department_created_at]) }
      end

      context 'without organ, description, answers_description, answers_department_created_at' do
        let(:gross_export) { create(:gross_export, user: create(:user, :operator_sectoral)) }
        it { expect(presenter.active_columns).to eq(columns_without_creator_info  - [:organ, :description, :answers_description, :answers_department_created_at]) }
      end
    end

    context 'extension' do
      let(:user) { create(:user, :operator_cge)}
      let(:user_chief) { create(:user, :operator_chief)}

      it 'ticket extended' do
        ticket_extension_approved = create(:ticket, :sic, :confirmed, :with_parent, extended: true)
        ticket_extension_approved.parent.sic!

        extension_text_expected = I18n.t("boolean.#{ticket_extension_approved.extended}").upcase
        expect(presenter.send('has_extension', ticket_extension_approved)).to eq(extension_text_expected)
      end

      it 'ticket not extended' do
        # com duas prorrogações
        ticket = create(:ticket, :confirmed, :sic, :with_parent, extended: false)

        extension_text_expected = I18n.t("boolean.#{ticket.extended}").upcase
        expect(presenter.send('has_extension', ticket)).to eq(extension_text_expected)
      end
    end

    context 'answer department positioning' do
      let(:internal_user) { create(:user, :operator_internal)}
      let(:ticket_without_department) { create(:ticket, :sic, :confirmed, :with_parent, :replied, organ: internal_user.department.organ) }
      let(:ticket) { create(:ticket, :sic, :confirmed, :with_parent, :replied, organ: internal_user.department.organ) }
      let(:department) { create(:department, organ: ticket.organ) }

      let!(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
      let!(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

      let!(:rejected_answer) { create(:answer, :rejected_positioning, ticket: ticket)}
      let!(:ticket_log_rejected) { create(:ticket_log, ticket: ticket, answer: rejected_answer, responsible: ticket_department_email, created_at: Date.today)}
      let!(:approved_answer) { create(:answer, :approved_positioning, ticket: ticket)}

      before do
        ticket_without_department.parent.sic!
        ticket.parent.sic!
      end
      it 'approved with department email' do
        ticket_log_approved = create(:ticket_log, ticket: ticket, answer: approved_answer, responsible: ticket_department_email, created_at: Date.today)

        positioning_created_at = I18n.l(ticket_log_approved.created_at, format: :date)
        expected = "#{positioning_created_at} - [#{ticket_log_approved.responsible.ticket_department.title}] #{ticket_log_approved.responsible.email}\n"

        expect(presenter.send('answers_department_created_at', ticket)).to eq(expected)
      end

      it 'approved with user department' do
        ticket_log_approved = create(:ticket_log, ticket: ticket, answer: approved_answer, responsible: internal_user, created_at: Date.today)

        positioning_created_at = I18n.l(ticket_log_approved.created_at, format: :date)
        expected = "#{positioning_created_at} - #{ticket_log_approved.responsible.as_author}\n"

        expect(presenter.send('answers_department_created_at', ticket)).to eq(expected)
      end

      it 'without positioning' do
        expected = "-"

        expect(presenter.send('answers_department_created_at', ticket_without_department)).to eq(expected)
      end

    end
  end
end
