require 'rails_helper'

describe Reports::Tickets::GrossExport::SouPresenter do
  let(:date) { Date.today }
  let(:gross_export) {
    create(:gross_export, :all_columns, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} })
  }
  let(:gross_export_without_confirmed_at) { create(:gross_export, :all_columns, filters: { ticket_type: :sic, confirmed_at: { start: nil, end: nil} }) }
  let(:scope) { gross_export.filtered_scope }
  let!(:cosco) { create(:executive_organ, :cosco) }

  subject(:presenter) { Reports::Tickets::GrossExport::SouPresenter.new(scope, gross_export.id) }
  subject(:presenter_without_confirmed_at) { Reports::Tickets::GrossExport::SouPresenter.new(scope, gross_export_without_confirmed_at.id) }

  describe 'self.call' do
    it 'initialize' do
      allow(Reports::Tickets::GrossExport::SouPresenter).to receive(:new)

      presenter

      expect(Reports::Tickets::GrossExport::SouPresenter).to have_received(:new).with(scope, gross_export.id)
    end
  end

  describe 'helpers' do

    context 'rows' do
      let(:user) { create(:user, :operator_cge)}
      let(:ticket) do
        ticket = create(:ticket, :with_parent, :gross_export, :replied)
        ticket.extended = false
        ticket.save
        ticket
      end
      let(:parent) { ticket.parent }
      let(:answer_ticket) { ticket.answers.where(answer_type: [ :final, :partial]).cge_approved.first }

      let!(:ticket_log_cge) do
        data = { responsible_as_author: user.title }

        create(:ticket_log, responsible: user, resource: answer_ticket, ticket_id: parent.id, action: TicketLog.actions[:answer_cge_approved], data: data, created_at: DateTime.now)
      end

      let(:ticket_answers) do
        date_approved = I18n.l(ticket_log_cge.created_at, format: :date)
        approved_by = I18n.t("presenters.reports.tickets.gross_export.answers.approved_by" , user: ticket_log_cge.data[:responsible_as_author], date: date_approved)
        answers = I18n.t("presenters.reports.tickets.gross_export.answers.description" , date: answer_ticket.created_at, user: answer_ticket.as_author, description: answer_ticket.description)
        ActionController::Base.helpers.sanitize("#{answers}\n#{approved_by}\n\n", tags: [])
      end

      let(:ticket_reopen) do
        ticket = create(:ticket, :with_organ, :with_classification, :with_reopen_and_log, parent_id: parent, status: :replied, internal_status: :final_answer)
        parent.tickets << ticket
        parent.save
        ticket
      end
      let(:answer_ticket_reopen) { ticket_reopen.answers.where(answer_type: [ :final, :partial]).cge_approved.first }
      let!(:ticket_log_cge_reopen) do
        data = { responsible_as_author: user.title }

        create(:ticket_log, responsible: user, resource: answer_ticket_reopen, ticket_id: parent.id, action: TicketLog.actions[:answer_cge_approved], data: data, created_at: DateTime.now)
      end
      let(:ticket_reopen_answers) do
        date_approved = I18n.l(ticket_log_cge_reopen.created_at, format: :date)
        approved_by = I18n.t("presenters.reports.tickets.gross_export.answers.approved_by" , user: ticket_log_cge_reopen.data[:responsible_as_author], date: date_approved)
        answers = I18n.t("presenters.reports.tickets.gross_export.answers.description" , date: answer_ticket_reopen.created_at, user: answer_ticket_reopen.as_author, description: answer_ticket_reopen.description)
        ActionController::Base.helpers.sanitize("#{answers}\n#{approved_by}\n\n", tags: [])
      end

      let(:ticket_log_child_1) { ticket_reopen.ticket_logs.reopen.first }
      #  Criando uma reabertura fora do período filtrado, não devendo aparecer...
      let(:ticket_log_child_2) { create(:ticket_log, :reopened, ticket: ticket_reopen, created_at: ticket.created_at.to_date.next_month, data: {count: 2}) }

      let(:scope) { [ ticket, ticket_reopen ] }

      let(:row_ticket) do
        {
          sou_type: ticket.sou_type_str,
          denunciation_organ: '-',
          denunciation_type: nil,
          organ: ticket.organ_acronym,
          subnet: '-',    # subrede
          departments: '-',    # departments
          departments_classification: ticket.classification.department_name,    # department
          subdepartment: ticket.classification.sub_department_name,    # subdepartment
          protocol: ticket.parent_protocol,
          created_by: '-',
          anonymous: I18n.t("boolean.#{ticket.anonymous?}").upcase,
          description: ticket.description,
          shared: I18n.t("boolean.#{ticket.shared?}").upcase,
          other_organs: I18n.t("boolean.#{ticket.other_organs || false}").upcase,
          internal_status: ticket.internal_status_str,
          topic: ticket.classification.topic_name,
          subtopic: '-',    # sub assunto
          budget_program: ticket.classification.budget_program_name,
          service_type: ticket.classification.service_type_name,
          origem_input: ticket.used_input_str,
          year: ticket.confirmed_at.year,
          month: ticket.confirmed_at.month,
          confirmed_at: I18n.l(ticket.confirmed_at, format: :date),
          answered_at: responded_at,
          final_answer_at: responded_at,
          answer_time_in_days: answer_time_in_days,
          immediate_answer: I18n.t("boolean.#{ticket.immediate_answer?}").upcase, # NAO
          last_answer_status: last_answer_status_str,
          last_answer_status_department: '-',
          answers_description: ticket_answers,
          answers_department_created_at: '-',
          reopened: ticket.reopened,
          reopened_description: '',
          neighborhood: ticket.answer_address_neighborhood,
          city: ticket.city_name,
          state: ticket.city_state_acronym,
          answer_type: ticket.answer_type_str,
          deadline: ticket_deadline,
          evaluation: ticket.last_evaluation_average,
          has_extension: I18n.t("boolean.#{ticket.extended}").upcase, # NAO
          answer_classification: ticket.answer_classification_str,
          person_type: ticket.person_type_str,
          user_name: ticket.name,
          user_social_name: ticket.social_name,
          user_email: ticket.email,
          user_phone: ticket.answer_phone,
          user_cell_phone: ticket.answer_cell_phone,
          gender: ticket.gender_str
        }.values
      end

      # Linha de Ticket com reabertura sendo que exibida pela primeira vez (linha sem reabertura)
      let(:row_ticket_origin_reopened) do
        {
          sou_type: ticket_reopen.sou_type_str,
          denunciation_organ: '-',
          denunciation_type: nil,
          organ: ticket_reopen.organ_acronym,
          subnet: '-',    # subrede
          departments: '-',    # departments
          departments_classification: ticket_reopen.classification.department_name,    # department
          subdepartment: ticket_reopen.classification.sub_department_name,    # subdepartment
          protocol: ticket_reopen.parent_protocol,
          created_by: '-',
          anonymous: I18n.t("boolean.#{ticket_reopen.anonymous?}").upcase,
          description: ticket_reopen.description,
          shared: I18n.t("boolean.#{ticket_reopen.shared?}").upcase,
          other_organs: I18n.t("boolean.#{ticket_reopen.other_organs || false}").upcase,
          internal_status: ticket_reopen.reopened_internal_status_str('final_answer'),
          topic: ticket_reopen.classification.topic_name,
          subtopic: '-',    # sub assunto
          budget_program: ticket_reopen.classification.budget_program_name,
          service_type: ticket_reopen.classification.service_type_name,
          origem_input: ticket_reopen.used_input_str,
          year: ticket_reopen.confirmed_at.year,
          month: ticket_reopen.confirmed_at.month,
          confirmed_at: I18n.l(ticket_reopen.confirmed_at, format: :date),
          answered_at: I18n.l(ticket_reopen.responded_at, format: :date),
          final_answer_at: I18n.l(ticket_reopen.responded_at, format: :date),
          answer_time_in_days: (ticket_reopen.responded_at.to_date - ticket.confirmed_at.to_date).to_i,      # tempo de resposta em dias
          immediate_answer: I18n.t("boolean.#{ticket_reopen.immediate_answer?}").upcase, # SIM
          last_answer_status: I18n.t("presenters.reports.tickets.gross_export.last_answer_status.answered_on_time"),
          last_answer_status_department: '-',
          answers_description: ticket_reopen_answers,
          answers_department_created_at: '-',
          reopened: 0,
          reopened_description: '',
          neighborhood: ticket_reopen.answer_address_neighborhood,
          city: ticket_reopen.city_name,
          state: ticket_reopen.city_state_acronym,
          answer_type: ticket_reopen.answer_type_str,
          deadline: '-',
          evaluation: ticket_reopen.last_evaluation_average,
          has_extension: I18n.t("boolean.#{ticket_reopen.extended}").upcase, # NAO
          answer_classification: nil,
          person_type: ticket.person_type_str,
          user_name: ticket_reopen.name,
          user_social_name: ticket_reopen.social_name,
          user_email: ticket_reopen.email,
          user_phone: ticket_reopen.answer_phone,
          user_cell_phone: ticket_reopen.answer_cell_phone,
          gender: ticket_reopen.gender_str
        }.values
      end

      let(:row_ticket_reopened_1) do
        {
          sou_type: ticket_reopen.sou_type_str,
          denunciation_organ: '-',
          denunciation_type: nil,
          organ: ticket_reopen.organ_acronym,
          subnet: '-',    # subrede
          departments: '-',    # departments
          departments_classification: ticket_reopen.classification.department_name,    # department
          subdepartment: ticket_reopen.classification.sub_department_name,    # subdepartment
          protocol: ticket_reopen.parent_protocol,
          created_by: '-',
          anonymous: I18n.t("boolean.#{ticket_reopen.anonymous?}").upcase,
          description: ticket_reopen.description,
          shared: I18n.t("boolean.#{ticket_reopen.shared?}").upcase,
          other_organs: I18n.t("boolean.#{ticket_reopen.other_organs || false}").upcase,
          internal_status: ticket_reopen.internal_status_str,
          topic: ticket_reopen.classification.topic_name,
          subtopic: '-',    # sub assunto
          budget_program: ticket_reopen.classification.budget_program_name,
          service_type: ticket_reopen.classification.service_type_name,
          origem_input: ticket_reopen.used_input_str,
          year: ticket_log_child_1.created_at.year,
          month: ticket_log_child_1.created_at.month,
          confirmed_at: I18n.l(ticket_log_child_1.created_at, format: :date),
          answered_at: '-',
          final_answer_at: '-',
          answer_time_in_days: '-',
          immediate_answer: I18n.t("boolean.false").upcase, # NAO
          last_answer_status: I18n.t("presenters.reports.tickets.gross_export.last_answer_status.in_progress"),
          last_answer_status_department: '-',
          answers_description: ticket_reopen_answers,
          answers_department_created_at: '-',
          reopened: ticket_log_child_1.data[:count],
          reopened_description: 'reopen',
          neighborhood: ticket_reopen.answer_address_neighborhood,
          city: ticket_reopen.city_name,
          state: ticket_reopen.city_state_acronym,
          answer_type: ticket_reopen.answer_type_str,
          deadline: ticket_reopen.deadline,
          evaluation: ticket_reopen.last_evaluation_average,
          has_extension: I18n.t("boolean.#{ticket_reopen.extended}").upcase, # NAO
          answer_classification: nil,
          person_type: ticket.person_type_str,
          user_name: ticket_reopen.name,
          user_social_name: ticket_reopen.social_name,
          user_email: ticket_reopen.email,
          user_phone: ticket_reopen.answer_phone,
          user_cell_phone: ticket_reopen.answer_cell_phone,
          gender: ticket_reopen.gender_str
        }.values
      end

      let(:last_answer_status) { :answered_on_time }
      let(:last_answer_status_str) { I18n.t("presenters.reports.tickets.gross_export.last_answer_status.#{last_answer_status}") }

      let(:responded_at) { I18n.l(ticket.responded_at, format: :date) }
      let(:answer_time_in_days) { (ticket.responded_at.to_date - ticket.confirmed_at.to_date).to_i }
      let(:ticket_deadline) { '-' }

      before { ticket; ticket_reopen; ticket_log_child_1; ticket_log_child_2 }

      it 'content' do
        expect(presenter.rows).to eq([row_ticket, row_ticket_origin_reopened, row_ticket_reopened_1])
      end

      context 'presenter without confirmed_at ' do
        it { expect(presenter.rows).to eq([row_ticket, row_ticket_origin_reopened, row_ticket_reopened_1])}
        end

      context 'last_answer_status' do
        context 'answered_on_time' do
          let(:last_answer_status) { :answered_on_time }

          before { ticket.update(responded_at: Date.today, deadline: 0) }

          it { expect(presenter.rows).to include(row_ticket) }
        end

        context 'answered_out_time' do
          let(:last_answer_status) { :answered_out_time }

          before do
            ticket.update(responded_at: Date.today, deadline: -1)
            answer_ticket.update(sectoral_deadline: -1)
          end

          it { expect(presenter.rows).to include(row_ticket) }
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

          it { expect(presenter.rows).to include(row_ticket) }
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

          it do
            expect(presenter.rows).to include(row_ticket)
          end
        end
      end
    end

    context 'columns' do
      let(:ticket) { create(:ticket, :with_parent, :gross_export, :replied) }
      let(:parent) { ticket.parent }

      before { ticket }

      context 'without creator info' do
        let(:gross_export) { create(:gross_export, load_description: true, load_answers: true, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        let(:columns_without_creator_info) do
         [
            :sou_type,
            :denunciation_organ,
            :denunciation_type,
            :organ,
            :subnet,
            :departments,
            :departments_classification,
            :subdepartment,
            :protocol,
            :created_by,
            :anonymous,
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
            :neighborhood,
            :city,
            :state,
            :answer_type,
            :deadline,
            :evaluation,
            :has_extension,
            :answer_classification
          ]
        end

        it { expect(presenter.send('active_columns')).to eq(columns_without_creator_info) }
      end

      context 'without description' do
        let(:gross_export) { create(:gross_export, load_creator_info: true, load_answers: true, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        let(:columns_without_description) do
         [
            :sou_type,
            :denunciation_organ,
            :denunciation_type,
            :organ,
            :subnet,
            :departments,
            :departments_classification,
            :subdepartment,
            :protocol,
            :created_by,
            :anonymous,
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
            :neighborhood,
            :city,
            :state,
            :answer_type,
            :deadline,
            :evaluation,
            :has_extension,
            :answer_classification,
            :person_type,
            :user_name,
            :user_social_name,
            :user_email,
            :user_phone,
            :user_cell_phone,
            :gender
          ]
        end

        it { expect(presenter.active_columns).to eq(columns_without_description) }
      end

      context 'without answers' do
        let(:gross_export) { create(:gross_export, load_creator_info: true, load_description: true, filters: { ticket_type: :sou, confirmed_at: { start: date.beginning_of_month, end: date.end_of_month} }) }
        let(:columns_without_answers) do
         [
            :sou_type,
            :denunciation_organ,
            :denunciation_type,
            :organ,
            :subnet,
            :departments,
            :departments_classification,
            :subdepartment,
            :protocol,
            :created_by,
            :anonymous,
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
            :reopened,
            :reopened_description,
            :neighborhood,
            :city,
            :state,
            :answer_type,
            :deadline,
            :evaluation,
            :has_extension,
            :answer_classification,
            :person_type,
            :user_name,
            :user_social_name,
            :user_email,
            :user_phone,
            :user_cell_phone,
            :gender
          ]
        end

        it { expect(presenter.active_columns).to eq(columns_without_answers) }
      end

      context 'without organ' do
        let(:gross_export) { create(:gross_export, user: create(:user, :operator_sectoral)) }
        let(:columns) do
         [
            :sou_type,
            :denunciation_organ,
            :denunciation_type,
            :subnet,
            :departments,
            :departments_classification,
            :subdepartment,
            :protocol,
            :created_by,
            :anonymous,
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
            :reopened,
            :reopened_description,
            :neighborhood,
            :city,
            :state,
            :answer_type,
            :deadline,
            :evaluation,
            :has_extension,
            :answer_classification
          ]
        end

        it { expect(presenter.active_columns).to eq(columns) }
      end
    end

    context 'extension' do
      let(:user) { create(:user, :operator_cge)}
      let(:user_chief) { create(:user, :operator_chief)}

      it 'ticket extended' do
        # com duas prorrogações
        ticket_extension_approved = create(:ticket, :confirmed, :with_parent, extended: true)


        extension_text_expected = I18n.t("boolean.#{ticket_extension_approved.extended}").upcase
        expect(presenter.send('has_extension', ticket_extension_approved)).to eq(extension_text_expected)
      end

      it 'ticket not extended' do
        # com duas prorrogações
        ticket = create(:ticket, :confirmed, :with_parent, extended: false)

        extension_text_expected = I18n.t("boolean.#{ticket.extended}").upcase
        expect(presenter.send('has_extension', ticket)).to eq(extension_text_expected)
      end
    end

    context 'answer department positioning' do
      let(:internal_user) { create(:user, :operator_internal)}
      let(:ticket_without_department) { create(:ticket, :confirmed, :with_parent, :replied, organ: internal_user.department.organ) }
      let(:ticket) { create(:ticket, :confirmed, :with_parent, :replied, organ: internal_user.department.organ) }
      let(:department) { create(:department, organ: ticket.organ) }

      let!(:ticket_department) { create(:ticket_department, ticket: ticket, department: department) }
      let!(:ticket_department_email) { create(:ticket_department_email, ticket_department: ticket_department) }

      let!(:rejected_answer) { create(:answer, :rejected_positioning, ticket: ticket)}
      let!(:ticket_log_rejected) { create(:ticket_log, ticket: ticket, answer: rejected_answer, responsible: ticket_department_email, created_at: Date.today)}
      let!(:approved_answer) { create(:answer, :approved_positioning, ticket: ticket)}

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

    context 'denunciation_organ' do
      it 'without denunciation_organ' do
        ticket = create(:ticket, :confirmed, :denunciation, denunciation_organ: nil)

        extension_text_expected = nil
        expect(presenter.send('denunciation_organ', ticket)).to eq(extension_text_expected)
      end

      it 'with denunciation_organ' do
        ticket = create(:ticket, :confirmed, :denunciation)
        organ = ticket.denunciation_organ

        extension_text_expected = organ.full_title
        expect(presenter.send('denunciation_organ', ticket)).to eq(extension_text_expected)
      end

      it 'not denunciation' do
        ticket = create(:ticket, :confirmed)

        extension_text_expected = '-'
        expect(presenter.send('denunciation_organ', ticket)).to eq(extension_text_expected)
      end
    end

    context 'denunciation_type' do
      it 'with denunciation_type' do
        ticket = create(:ticket, :confirmed, :denunciation, denunciation_type: :in_favor_of_the_state)

        denunciation_type_text = Ticket.human_attribute_name("denunciation_type.#{ticket.denunciation_type}")
        expect(presenter.send('denunciation_type', ticket)).to eq(denunciation_type_text)
      end

      it 'without denunciation_type' do
        ticket = create(:ticket, :confirmed, :denunciation, denunciation_type: nil)
        expect(presenter.send('denunciation_type', ticket)).to eq(nil)
      end

      it 'without denunciation' do
        ticket = create(:ticket, :confirmed)

        expect(presenter.send('denunciation_type', ticket)).to eq(nil)
      end
    end
  end
end
