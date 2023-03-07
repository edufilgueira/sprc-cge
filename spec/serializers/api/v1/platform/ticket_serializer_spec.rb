require 'rails_helper'

describe Api::V1::Platform::TicketSerializer do

  let(:city) { create(:city) }

  let(:ticket) { create(:ticket, :confirmed, city: city) }
  let(:denunciation_ticket) { create(:ticket, :confirmed, :denunciation) }

  let(:attachment) { create(:attachment) }
  let(:comment) { create(:comment) }


  subject(:ticket_for_show_json) do
    ticket_serializer = Api::V1::Platform::TicketSerializer.new(ticket)
    ticket_serialization = ActiveModelSerializers::Adapter.create(ticket_serializer)
    JSON.parse(ticket_serialization.to_json)
  end

  subject(:ticket_for_index_json) do
    ticket_serializer = Api::V1::Platform::TicketSerializer.new(ticket, action_index: true)
    ticket_serialization = ActiveModelSerializers::Adapter.create(ticket_serializer)
    JSON.parse(ticket_serialization.to_json)
  end

  subject(:denunciation_ticket_for_index_json) do
    ticket_serializer = Api::V1::Platform::TicketSerializer.new(denunciation_ticket, action_index: true)
    ticket_serialization = ActiveModelSerializers::Adapter.create(ticket_serializer)
    JSON.parse(ticket_serialization.to_json)
  end

  describe 'attributes for index' do
    it { expect(ticket_for_show_json['id']).to eq(ticket.id) }
    it { expect(ticket_for_index_json['ticket_type']).to eq(ticket.ticket_type) }
    it { expect(ticket_for_index_json['description']).to eq(ticket.description.truncate(50)) }
    it { expect(ticket_for_index_json['parent_protocol']).to eq(ticket.parent_protocol) }
    it { expect(ticket_for_index_json['internal_status']).to eq(ticket.internal_status) }

    it { expect(ticket_for_index_json['answer_type']).to be_nil }
    it { expect(ticket_for_index_json['email']).to be_nil }
    it { expect(ticket_for_index_json['organ_name']).to be_nil }
    it { expect(ticket_for_index_json['organ_acronym']).to be_nil }
    it { expect(ticket_for_index_json['unknown_organ']).to be_nil }
    it { expect(ticket_for_index_json['attachments']).to be_nil }
    it { expect(ticket_for_index_json['comments']).to be_nil }
    it { expect(ticket_for_index_json['answer_phone']).to be_nil }
    it { expect(ticket_for_index_json['city_title']).to be_nil }
    it { expect(ticket_for_index_json['answer_address_street']).to be_nil }
    it { expect(ticket_for_index_json['answer_address_number']).to be_nil }
    it { expect(ticket_for_index_json['answer_address_zipcode']).to be_nil }
    it { expect(ticket_for_index_json['answer_address_complement']).to be_nil }
    it { expect(ticket_for_index_json['answer_address_neighborhood']).to be_nil }
    it { expect(ticket_for_index_json['answer_twitter']).to be_nil }
    it { expect(ticket_for_index_json['answer_facebook']).to be_nil }
    it { expect(ticket_for_index_json['answer_instagram']).to be_nil }

    context 'denunciation' do
      it { expect(denunciation_ticket_for_index_json['description']).to be_nil }
    end

    describe 'custom attributes' do
      it 'sou_type' do
        expected = ticket.sou_type
        expect(ticket_for_index_json['sou_type']).to eq(expected)
      end
    end

    it 'created_at' do
      expected = ticket.created_at.to_formatted_s(:iso8601)
      expect(ticket_for_show_json['created_at']).to eq(expected)
    end
  end

  describe 'attributes for show and other actions' do

    before do
      ticket.attachments.push(attachment)
      ticket.comments.push(comment)
      ticket.save!
    end

    it { expect(ticket_for_show_json['id']).to eq(ticket.id) }
    it { expect(ticket_for_show_json['ticket_type']).to eq(ticket.ticket_type) }
    it { expect(ticket_for_show_json['sou_type']).to eq(ticket.sou_type) }
    it { expect(ticket_for_show_json['description']).to eq(ticket.description) }
    it { expect(ticket_for_show_json['document_type']).to eq(ticket.document_type) }
    it { expect(ticket_for_show_json['document']).to eq(ticket.document) }
    it { expect(ticket_for_show_json['person_type']).to eq(ticket.person_type) }
    it { expect(ticket_for_show_json['name']).to eq(ticket.name) }
    it { expect(ticket_for_show_json['email']).to eq(ticket.email) }
    it { expect(ticket_for_show_json['parent_protocol']).to eq(ticket.parent_protocol) }

    it { expect(ticket_for_show_json['organ_acronym']).to eq(ticket.organ_acronym) }
    it { expect(ticket_for_show_json['organ_name']).to eq(ticket.organ_name) }
    it { expect(ticket_for_show_json['unknown_organ']).to eq(ticket.unknown_organ) }

    it { expect(ticket_for_show_json['answer_type']).to eq(ticket.answer_type) }
    it { expect(ticket_for_show_json['answer_phone']).to eq(ticket.answer_phone) }
    it { expect(ticket_for_show_json['answer_cell_phone']).to eq(ticket.answer_cell_phone) }
    it { expect(ticket_for_show_json['city_title']).to eq(ticket.city_title) }
    it { expect(ticket_for_show_json['answer_address_street']).to eq(ticket.answer_address_street) }
    it { expect(ticket_for_show_json['answer_address_number']).to eq(ticket.answer_address_number) }
    it { expect(ticket_for_show_json['answer_address_zipcode']).to eq(ticket.answer_address_zipcode) }
    it { expect(ticket_for_show_json['answer_address_complement']).to eq(ticket.answer_address_complement) }
    it { expect(ticket_for_show_json['answer_address_neighborhood']).to eq(ticket.answer_address_neighborhood) }
    it { expect(ticket_for_show_json['answer_twitter']).to eq(ticket.answer_twitter) }
    it { expect(ticket_for_show_json['answer_facebook']).to eq(ticket.answer_facebook) }
    it { expect(ticket_for_show_json['answer_instagram']).to eq(ticket.answer_instagram) }

    it { expect(ticket_for_show_json['status']).to eq(ticket.status) }
    it { expect(ticket_for_show_json['internal_status']).to eq(ticket.internal_status) }

    it { expect(ticket_for_show_json['used_input']).to eq(ticket.used_input) }

    it { expect(ticket_for_show_json['anonymous']).to eq(ticket.anonymous) }

    it { expect(ticket_for_show_json['denunciation_organ_id']).to eq(ticket.denunciation_organ_id) }
    it { expect(ticket_for_show_json['denunciation_description']).to eq(ticket.denunciation_description) }
    it { expect(ticket_for_show_json['denunciation_date']).to eq(ticket.denunciation_date) }
    it { expect(ticket_for_show_json['denunciation_place']).to eq(ticket.denunciation_place) }
    it { expect(ticket_for_show_json['denunciation_witness']).to eq(ticket.denunciation_witness) }
    it { expect(ticket_for_show_json['denunciation_evidence']).to eq(ticket.denunciation_evidence) }
    it { expect(ticket_for_show_json['denunciation_assurance']).to eq(ticket.denunciation_assurance) }


    describe 'custom attributes' do
      it 'created_at' do
        expected = ticket.created_at.to_formatted_s(:iso8601)
        expect(ticket_for_show_json['created_at']).to eq(expected)
      end

      it 'confirmed_at' do
        expected = ticket.confirmed_at.to_formatted_s(:iso8601)
        expect(ticket_for_show_json['confirmed_at']).to eq(expected)
      end
    end

    describe 'associations' do

      it 'attachment' do
        expected = [
          {
            'id' => attachment.id,
            'url' => attachment.url
          }
        ]
        expect(ticket_for_show_json['attachments']).to eq(expected)
      end

      it 'comments' do
        expected = [
          {
            'id' => comment.id,
            'author' => comment.as_author,
            'description' => comment.description,
            'created_at' => comment.created_at.to_formatted_s(:iso8601)
          }
        ]
        expect(ticket_for_show_json['comments']).to eq(expected)
      end

    end

  end

end
