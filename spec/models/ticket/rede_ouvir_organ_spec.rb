require 'rails_helper'

describe Ticket do

  let!(:topic) { create(:topic, :other_organs) }
  let!(:budget_program) { create(:budget_program, :other_organs) }

  describe 'callbacks' do
    it 'create classification other_organs' do
      ticket = build(:ticket, :with_rede_ouvir)

      ticket.save
      ticket.reload

      expect(ticket.classification.other_organs?).to eq(true)
      expect(ticket.classified?).to eq(true)
    end

    it 'not rede_ouvir' do
      ticket = build(:ticket, :with_parent, :with_classification)

      ticket.save
      ticket.reload

      expect(ticket.classification.other_organs?).to eq(false)
      expect(ticket.classified?).to eq(true)
    end

    it 'update classification other_organs' do
      ticket = create(:ticket, :with_parent)

      ticket.update(organ: create(:rede_ouvir_organ))

      expect(ticket.parent.classification.blank?).to eq(true)
      expect(ticket.classification.other_organs?).to eq(true)
      expect(ticket.classified?).to eq(true)
    end

    it 'ensure_rede_ouvir' do
      ticket = build(:ticket, :with_parent, organ: create(:rede_ouvir_organ))

      ticket.save
      expect(ticket.reload.rede_ouvir?).to eq(true)

      ticket.update(organ: create(:executive_organ))
      expect(ticket.reload.rede_ouvir?).to eq(false)
    end
  end
end
