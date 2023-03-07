require 'rails_helper'

describe Ticket::Sharing do

  let(:reject_attributes) { %w[
      id
      protocol
      parent_protocol
      parent_id
      created_by
      created_at
      organ_id
      unknown_organ
      unknown_classification
      subnet_id
      unknown_department
      description
      denunciation_description
      internal_status
      encrypted_password
      plain_password
      sou_type
      public_ticket
      published
    ]
  }

  let(:permitted_params) { %w[
      id
      rede_ouvir
      organ_id
      subnet_id
      unknown_subnet
      description
      sou_type
      denunciation_organ_id
      denunciation_description
      denunciation_date
      denunciation_place
      denunciation_witness
      denunciation_evidence
      denunciation_assurance
      justification
    ]
  }

  let(:user) { create(:user, :operator_cge) }
  let(:ticket_parent) { create(:ticket) }
  let(:ticket_children) { build_list(:ticket, 3, :with_parent) }
  let(:ticket_subnet) { build(:ticket, :with_subnet) }
  let(:classification_rede_ouvir) { create(:classification, :other_organs) }
  let(:ticket_rede_ouvir) { build(:ticket, :with_rede_ouvir, classification: classification_rede_ouvir) }
  let(:ticket_children_invalid) { build_list(:ticket, 3, :with_parent, organ_id: 1) }
  let(:justification) { 'Justificativa para compartilhar'}

  let(:new_tickets_attributes) do
    result = {}

    ticket_children.each_with_index do |ticket, index|
      result[index] = ticket.attributes.slice(*permitted_params).merge(justification: justification).stringify_keys
    end

    result[4] = ticket_rede_ouvir.attributes.slice(*permitted_params)

    result[5] = ticket_subnet.attributes.slice(*permitted_params)

    result
  end

  let(:new_tickets_attributes_invalid) do
    result = {}

    ticket_children_invalid.each_with_index do |ticket, index|
      result[index] = ticket.attributes.slice(*permitted_params)
    end

    result
  end

  let(:service) { Ticket::Sharing.new(ticket_parent.id, new_tickets_attributes, user.id) }


  it 'self.call' do
    service = double
    allow(Ticket::Sharing).to receive(:new).with(ticket_parent.id, new_tickets_attributes, user.id) { service }
    allow(service).to receive(:call)

    Ticket::Sharing.call(ticket_id: ticket_parent.id, new_tickets_attributes: new_tickets_attributes, current_user_id: user.id)

    expect(Ticket::Sharing).to have_received(:new).with(ticket_parent.id, new_tickets_attributes, user.id)
    expect(service).to have_received(:call)
  end

  it 'initialization' do
    expect(service.ticket_parent).to be_an_instance_of(Ticket)
    expect(service.current_user).to be_an_instance_of(User)
    expect(service.tickets_attributes).to be_an_instance_of(Hash)

    first_ticket_attribute = service.tickets_attributes.first
    expect(first_ticket_attribute).to be_an_instance_of(Array)
  end

  it 'valid' do
    expect(service.call).to be_truthy
  end

  it 'invalid' do
    service = Ticket::Sharing.new(ticket_parent.id, new_tickets_attributes_invalid, user.id)

    expect(service.call).to be_falsey
  end

  it 'empty justification' do
    new_tickets_attributes[0]['justification'] = ''
    service = Ticket::Sharing.new(ticket_parent.id, new_tickets_attributes, user.id)

    expect(service.call).to be_falsey
    expect(ticket_parent.reload.tickets).to be_empty
  end

  it 'create_tickets_children' do
    service.call
    ticket_parent.reload

    expect(ticket_parent.tickets.count).to eq(5)
    expect(ticket_parent.tickets.last.subnet).to eq(ticket_subnet.subnet)
    expect(ticket_parent.tickets.last.unknown_classification).to be_truthy
  end

  context 'clear ticket parent classification' do
    let(:ticket_parent) { create(:ticket, :with_classification) }

    before do
      service.call
      ticket_parent.reload
    end

    it { expect(ticket_parent.classified?).to be_falsey }
    it { expect(ticket_parent.classification).to be_nil }
  end

  it 'change status if waiting_referral' do
    ticket_parent.waiting_referral!

    service.call
    ticket_parent.reload

    expect(ticket_parent.sectoral_attendance?).to be_truthy

    child_ticket = ticket_parent.tickets.first

    expect(child_ticket.sectoral_attendance?).to be_truthy

    child_ticket = ticket_parent.tickets.last

    expect(child_ticket.subnet_attendance?).to be_truthy
  end

  it 'register ticket log' do
    allow(RegisterTicketLog).to receive(:call)

    service.call

    resource = ticket_children.first.organ
    expect(RegisterTicketLog).to have_received(:call).with(ticket_parent, user, :share, { description: justification, resource: resource })
  end

  it 'notify' do
    notifier_service = double

    allow(Notifier::Share).to receive(:delay) { notifier_service }
    allow(notifier_service).to receive(:call)

    service.call

    ticket_parent.tickets.ids.each do |id|
      expect(notifier_service).to have_received(:call).with(id, user.id).exactly(1).times
    end
  end
end
