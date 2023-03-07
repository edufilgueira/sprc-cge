require 'rails_helper'

describe TicketLogHelper do

  context 'invalidate_status_class' do
    it 'approved' do
      expect(invalidate_status_class('approved')).to eq('alert-success')
    end

    it 'rejected' do
      expect(invalidate_status_class('rejected')).to eq('alert-danger')
    end

    it 'waiting' do
      expect(invalidate_status_class('waiting')).to eq('alert-info')
    end
  end

  context 'date and author' do
    it 'without author' do
      ticket_log = create(:ticket_log, :confirm)

      expect = I18n.l(ticket_log.created_at, format: :shorter)

      expect(ticket_log_date_author(ticket_log)).to eq(expect)
    end

    it 'with author' do
      data = { responsible_as_author: "operator" }
      ticket_log = create(:ticket_log, :confirm, data: data)
      date = I18n.l(ticket_log.created_at, format: :shorter)

      expect = I18n.t('shared.ticket_logs.confirm.author', date: date, author: ticket_log.data[:responsible_as_author])

      expect(ticket_log_date_author(ticket_log)).to eq(expect)
    end
  end

  describe '#ticket_log_denunciation_type_title' do
    context 'when ticket denunciation type is in favor of the state' do
      it 'return history log message' do
        data = { responsible_as_author: "operator", denunciation_type: :in_favor_of_the_state }
        ticket_log = create(:ticket_log, :change_denunciation_type, data: data)

        expect = I18n.t("shared.ticket_logs.change_denunciation_type.title", to: 'Para o Estado')
        expect(ticket_log_denunciation_type_title(ticket_log)).to eq(expect)
      end
    end

    context 'when ticket denunciation type is against of state' do
      it 'return history log message' do
        data = { responsible_as_author: "operator", denunciation_type: :against_the_state }
        ticket_log = create(:ticket_log, :change_denunciation_type, data: data)

        expect = I18n.t("shared.ticket_logs.change_denunciation_type.title", to: 'Contra o Estado')
        expect(ticket_log_denunciation_type_title(ticket_log)).to eq(expect)
      end
    end

    context 'when ticket denunciation type is undefined' do
      it 'return history log message' do
        data = { responsible_as_author: "operator", denunciation_type: nil }
        ticket_log = create(:ticket_log, :change_denunciation_type, data: data)

        expect = I18n.t("shared.ticket_logs.change_denunciation_type.title", to: 'Indefinido')
        expect(ticket_log_denunciation_type_title(ticket_log)).to eq(expect)
      end
    end
  end
end
