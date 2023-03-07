require 'rails_helper'

describe TicketsController do

  let(:ticket) { create(:ticket) }

  let(:permitted_params) do
    [
      :name,
      :email,
      :description,
      :sou_type,
      :organ_id,
      :unknown_organ,
      :status,
      :used_input,

      :answer_type,
      :answer_phone,
      :answer_cell_phone,

      :city_id,
      :answer_address_street,
      :answer_address_number,
      :answer_address_zipcode,
      :answer_address_complement,
      :answer_twitter,
      :answer_facebook,
      :answer_instagram,
      :answer_whatsapp,

      :document,
      :person_type,

      :anonymous,

      :denunciation_organ_id,
      :denunciation_description,
      :denunciation_date,
      :denunciation_place,
      :denunciation_witness,
      :denunciation_evidence,
      :denunciation_assurance,

      attachments_attributes: [
        :id, :document, :_destroy
      ]
    ]
  end

  # garante que o controller tá incluíndo seu breadcrumb
  it { is_expected.to be_kind_of(Tickets::Breadcrumbs) }

  describe '#new' do

    context 'render without login' do
      before {
        create(:executive_organ, :cosco)
        create(:executive_organ, :couvi)

        get(:new)
      }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('tickets/new') }
        it { is_expected.to render_template('tickets/_form') }
      end

      describe 'helper methods' do
        it 'ticket' do
          expect(controller.ticket).to be_new_record
        end

        it 'ticket default sou_type' do
          expect(controller.ticket.sou_type).to be_nil
        end
      end
    end
  end

  describe '#create' do

    let(:valid_ticket) { build(:ticket).attributes }
    let(:invalid_ticket) { build(:ticket, :invalid).attributes }
    let(:ticket_denunciation) { build(:ticket, :denunciation).attributes }

    let(:created_ticket) { Ticket.last }
    let(:parent_ticket) { created_ticket.parent }
    let(:organ) { create(:executive_organ) }

    it 'permits ticket params' do
      should permit(*permitted_params).
        for(:create, params: { ticket: valid_ticket })
    end

    context 'valid' do
      it 'saves' do
        ticket = build(:ticket, answer_type: :phone).attributes
        expect do

          post(:create, params: { ticket: ticket })

          expect(response).to redirect_to(ticket_area_ticket_path(created_ticket))
          expect(subject.current_ticket).to eq created_ticket

          # o flag anônimo é controlada pela view e por parâmetro de controller
          # pois agora o chamado externo pode ser anônimo ou identificado
          # o padrão é o chamado identificado
          expect(controller.ticket).not_to be_anonymous
          expect(controller.ticket).to be_identified

          expect(controller.ticket.answer_type).to eq('phone')

          #verificação de consistência em dado da subnet
          expect(controller.ticket.unknown_subnet).to eq(!controller.ticket.subnet.present?)

        end.to change(Ticket, :count).by(1)
      end


      describe 'saves confirmation' do
        # quando o usuário salva o form, precisamos setar o
        # flash 'from_confirmation' para que o show possa exibir
        # a mensagem de sucesso para o usuário.

        let(:confirmed_at) { Date.today }

        context 'unknown organ' do
          before { post(:create, params: { ticket: valid_ticket }) }

          # o flash é usado para exibir a mensagem específica avisando ao usuário
          # que sua manifestação foi recebida!

          it { expect(controller).to set_flash[:from_confirmation].to(true) }
          it { expect(response).to redirect_to(ticket_area_ticket_path(created_ticket)) }

          it { expect(created_ticket).to be_confirmed }
          it { expect(created_ticket).to be_waiting_referral }
          it { expect(created_ticket.parent_unknown_organ).to be_truthy }
          it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
          #verificação de consistência em dado da subnet
          it { expect(controller.ticket.unknown_subnet).to eq(!controller.ticket.subnet.present?) }
        end

        context 'knowledge organ' do

          before do
            allow(RegisterTicketLog).to receive(:call)

            valid_ticket["organ_id"] = organ.id
            valid_ticket["unknown_organ"] = false
            post(:create, params: { ticket: valid_ticket })
          end
          it { expect(parent_ticket).to be_confirmed }
          it { expect(parent_ticket).to be_sectoral_attendance }
          it { expect(parent_ticket.confirmed_at.to_date).to eq(confirmed_at) }
          it { expect(parent_ticket.organ_id).to be_nil }
          it { expect(created_ticket).to be_confirmed }
          it { expect(created_ticket).to be_sectoral_attendance }
          it { expect(created_ticket.confirmed_at.to_date).to eq(confirmed_at) }
          it { expect(created_ticket.parent_id).to eq(parent_ticket.id) }
          it { expect(created_ticket.organ).to eq(organ) }
          it { expect(created_ticket.parent_unknown_organ).to be_falsey }
          #verificação de consistência em dado da subnet
          it { expect(controller.ticket.unknown_subnet).to eq(!controller.ticket.subnet.present?) }

          it 'register ticket log' do
            expect(RegisterTicketLog).to have_received(:call).with(parent_ticket, parent_ticket, :share, { resource: created_ticket.organ })
          end
        end

        it 'register ticket log' do
          allow(RegisterTicketLog).to receive(:call)

          post(:create, params: { ticket: valid_ticket })

          expect(RegisterTicketLog).to have_received(:call).with(created_ticket, created_ticket, :confirm, {})
        end

        context 'set deadline' do
          let(:deadline) { Holiday.next_weekday(Ticket.response_deadline(:sou)) }
          let(:deadline_ends_at) { Date.today + deadline }
          before { post(:create, params: { ticket: valid_ticket }) }

          it { expect(created_ticket.deadline).to eq(deadline) }
          it { expect(created_ticket.deadline_ends_at).to eq(deadline_ends_at) }
        end

        context 'with attachments' do
          let(:tempfile) do
            file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
            file.write('1')
            file.close
            file.open
            file
          end

          let(:attachment) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

          let(:ticket_with_attachment) do
            valid_ticket[:attachments_attributes] = {
              "1": {
                "document": attachment
              }
            }
            valid_ticket
          end

          it 'saves' do
            post(:create, params: { ticket: ticket_with_attachment })

            expect(controller.ticket.attachments.count).to eq(1)
          end

          it 'register ticket_log for attachments' do
            allow(RegisterTicketLog).to receive(:call).with(anything, anything, :confirm, anything)
            allow(RegisterTicketLog).to receive(:call).with(anything, anything, :create_attachment, anything)

            post(:create, params: { ticket: ticket_with_attachment })

            created_attachment = created_ticket.attachments.first

            expect(RegisterTicketLog).to have_received(:call).with(created_ticket, created_ticket, :create_attachment, { resource: created_attachment })
          end
        end
      end

      it 'saves as anonymous' do
        ticket = build(:ticket, anonymous: true).attributes
        expect do
          post(:create, params: { ticket: ticket })

          expect(controller.ticket).to be_anonymous
          expect(controller.ticket).not_to be_identified
          #verificação de consistência em dado da subnet
          expect(controller.ticket.unknown_subnet).to eq(!controller.ticket.subnet.present?)

        end.to change(Ticket, :count).by(1)
      end

      it 'save as identified when sic' do
        expect do
          ticket = build(:ticket, anonymous: true).attributes
          post(:create, params: { ticket: ticket, ticket_type: :sic })

          expect(controller.ticket).not_to be_anonymous
          expect(controller.ticket).to be_identified
          #verificação de consistência em dado da subnet
          expect(controller.ticket.unknown_subnet).to eq(!controller.ticket.subnet.present?)

        end.to change(Ticket, :count).by(1)
      end

      it 'change internal status' do
        post(:create, params: { ticket: valid_ticket })

        expect(controller.ticket.reload.waiting_referral?).to be_truthy
      end

      it 'ticket type denunciation set unknown_organ true' do
        expect do
          post(:create, params: { ticket: ticket_denunciation })

          expect(subject.current_ticket).to eq created_ticket
          expect(created_ticket.unknown_organ).to be_truthy
          expect(created_ticket.organ).to be_nil
        end.to change(Ticket, :count).by(1)
      end

      it 'set_deadline for sou' do
        sou_deadline = 20
        deadline_ends_at = Date.today + Holiday.next_weekday(sou_deadline)

        post(:create, params: { ticket: valid_ticket })

        expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
      end

      it 'set_deadline for sic' do
        sic_deadline = 20
        deadline_ends_at = Date.today + Holiday.next_weekday(sic_deadline)

        post(:create, params: { ticket: valid_ticket, ticket_type: :sic })

        expect(controller.ticket.deadline_ends_at).to eq(deadline_ends_at)
      end
    end

    context 'invalid' do
      before {
        create(:executive_organ, :cosco)
        create(:executive_organ, :couvi)
      }

      render_views

      it 'does not save' do
        expect do
          post(:create, params: { ticket: invalid_ticket })

          expect(response).to render_template('tickets/new')

          # Importante setar o flash para o usuário saber que houve
          # erro de validação em casos em que o erro está no final
          # da página, escondido.

          expected_flash = I18n.t('tickets.create.sou.error')
          expect(controller).to set_flash.now.to(expected_flash)

        end.to change(Ticket, :count).by(0)
      end
    end

    context 'before_validation' do
      it 'saves cnpj' do
        valid_ticket[:person_type] = :legal
        post(:create, params: { ticket: valid_ticket })

        expect(controller.ticket.document_type).to eq('cnpj')
      end

      it 'dont saves cnpj' do
        valid_ticket[:person_type] = :individual
        valid_ticket[:document_type] = :other
        post(:create, params: { ticket: valid_ticket })

        expect(controller.ticket.document_type).to eq('other')
      end
    end

    describe 'helper methods' do
      it 'ticket' do
        expect(controller.ticket).to be_new_record
      end
    end
  end
end
