require 'rails_helper'

describe Notifier::SatisfactionSurvey do

  let(:organ) { create(:executive_organ) }
  let(:subnet) { create(:subnet, organ: organ) }
  let(:department) { create(:department, organ: organ) }
  let(:sub_department) { create(:sub_department, department: department) }

  # usuários com notificações habilidatas
  let!(:user) { create(:user, :user) }
  let!(:operator_cge) { create(:user, :operator_cge) }
  let!(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }
  let!(:operator_subnet) { create(:user, :operator_subnet, organ: organ, subnet: subnet) }
  let!(:operator_subnet_internal) { create(:user, :operator_subnet_internal, organ: organ, subnet: subnet) }
  let!(:operator_internal) { create(:user, :operator_internal, department: department, organ: department.organ) }
  let!(:operator_sub_department) { create(:user, :operator_internal, department: department, sub_department: sub_department, organ: department.organ) }

  let(:answer) { create(:answer) }
  let(:ticket) { answer.ticket }

  let(:service) { Notifier::SatisfactionSurvey.new(answer.id) }

  let(:url_helpers) { Rails.application.routes.url_helpers }

  describe 'self.call' do
    it 'initialize and invoke call method' do
      service = double
      allow(Notifier::SatisfactionSurvey).to receive(:new).with(answer.id) { service }
      allow(service).to receive(:call)
      Notifier::SatisfactionSurvey.call(answer.id)

      expect(Notifier::SatisfactionSurvey).to have_received(:new).with(answer.id)
      expect(service).to have_received(:call)
    end
  end

  describe 'call' do

    # CGE_APPROVED
    context 'cge_approved' do
      let(:child) { create(:ticket, :with_parent, organ: organ) }
      let(:parent) { child.parent }
      let(:answer) { create(:answer, :with_cge_approved_final_answer, ticket: parent) }
      let(:service) { Notifier::SatisfactionSurvey.new(answer.id) }
      let(:expected_url) { url_helpers.url_for(controller: '/ticket_area/tickets', action: 'show', id: parent.id) }
      let(:notification) { Mailboxer::Notification.last }

      it {
        service.call
        expect(Mailboxer::Notification.count).to eq(1)
      }

      it 'send to no profile user' do
        service.call

        expect(notification.subject).to eq(I18n.t("shared.notifications.messages.satisfaction_survey.subject.#{ticket.ticket_type}", protocol: ticket.protocol))
        expect(notification.body).to include('É rápido e fácil de responder e dessa forma você avalia como foi o atendimento da Ouvidoria na sua manifestação.')
        expect(notification.body).to include('Identificação da Manifestação:')
        expect(notification.body).to include("Protocolo: #{parent.protocol}")
        expect(notification.body).to include("Senha: #{parent.plain_password}")
        expect(notification.body).to include("ticket_area/tickets/#{parent.id}?satisfaction_survey=true")
        expect(notification.body).to include("Clique aqui para responder a pesquisa, utilizando o protocolo e senha da manifestação")
      end

      it 'send to profile user' do
        parent.created_by = user
        parent.save

        service.call

        expect(notification.subject).to eq(I18n.t("shared.notifications.messages.satisfaction_survey.subject.#{ticket.ticket_type}", protocol: ticket.protocol))
        expect(notification.body).to include('É rápido e fácil de responder e dessa forma você avalia como foi o atendimento da Ouvidoria na sua manifestação.')
        expect(notification.body).to include('Identificação da Manifestação:')
        expect(notification.body).to include("Protocolo: #{parent.protocol}")
        expect(notification.body).to include("platform/tickets/#{parent.id}?satisfaction_survey=true")
        expect(notification.body).to include("Clique aqui para responder a pesquisa, utilizando seu usuário e senha")
      end
    end

  end

end
