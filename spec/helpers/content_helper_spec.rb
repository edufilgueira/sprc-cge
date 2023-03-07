require 'rails_helper'

describe ContentHelper do

  describe 'dash_content_with_label' do
   let(:contract) { build(:integration_contracts_contract) }

    before do
      allow(helper).to receive(:content_with_label)
        .with(contract, :valor_contrato, { undefined_value: '-' }).and_call_original

      helper.dash_content_with_label(contract, :valor_contrato)
    end

    it do
      expect(helper).to have_received(:content_with_label)
      .with(contract, :valor_contrato, { undefined_value: '-' })
    end
  end

  describe 'content_with_label' do

    # helper para facilitar a exibição de informações com label, como por ex:
    #
    # Nome completo
    # Fulano de tal
    #
    # Email
    # fulano@example.com
    #

    let(:ticket) { build(:ticket) }
    let(:expected_label) { Ticket.human_attribute_name(:name) }

    context 'for raw_value option' do
      let(:contract) { build(:integration_contracts_contract) }
      let(:expected_label) { Integration::Contracts::Contract.human_attribute_name(:valor_contrato) }
      let(:expected_value) { contract.valor_contrato }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(contract, :valor_contrato, { raw_value: true })).to eq(expected) }
    end

    context 'for common values' do
      let(:expected_value) { ticket.name }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(ticket, :name)).to eq(expected) }
    end

    context 'for date values' do
      let(:attachment) { build(:attachment) }
      let(:expected_label) { Attachment.human_attribute_name(:imported_at) }
      let(:expected_value) { I18n.l(attachment.imported_at) }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(attachment, :imported_at)).to eq(expected) }
    end

    context 'for currency values' do
      let(:contract) { build(:integration_contracts_contract) }
      let(:expected_label) { Integration::Contracts::Contract.human_attribute_name(:valor_contrato) }
      let(:expected_value) { number_to_currency(contract.valor_contrato) }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(contract, :valor_contrato)).to eq(expected) }
    end

    context 'for datetime values' do
      let(:contract) { build(:integration_contracts_contract) }
      let(:expected_label) { Integration::Contracts::Contract.human_attribute_name(:data_publicacao_portal) }
      let(:expected_value) { I18n.l(contract.data_publicacao_portal, format: :shorter) }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(contract, :data_publicacao_portal)).to eq(expected) }
    end

    context 'for datetime values as date' do
      let(:contract) { build(:integration_contracts_contract) }
      let(:expected_label) { Integration::Contracts::Contract.human_attribute_name(:data_publicacao_portal) }
      let(:expected_value) { I18n.l(contract.data_publicacao_portal.to_date) }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(contract, :data_publicacao_portal, format: :date)).to eq(expected) }
    end

    context 'for empty values' do
      let(:ticket) { build(:ticket, name: nil) }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      context 'without undefined_value option' do
        let!(:expected_value) { content_tag(:em, I18n.t('messages.content.undefined')) }

        it { expect(content_with_label(ticket, :name)).to eq(expected) }
      end

      context 'with undefined_value option' do
        let!(:expected_value) { '-' }

        it do
          expect(content_with_label(ticket, :name, { undefined_value: expected_value })).to eq(expected)
        end
      end
    end

    context 'for acronym value' do
      let(:expected_value) { ticket.name }
      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:acronym, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(ticket, :name, acronym_value: true)).to eq(expected) }
    end

    context 'for label value' do
      let(:expected_value) { ticket.name }
      let(:expected_label) { 'Custom label' }

      let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
      let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

      it { expect(content_with_label(ticket, :name, label: expected_label)).to eq(expected) }
    end

    context 'for boolean values' do
      let(:expected_label) { Ticket.human_attribute_name(:classified) }

      context 'false' do
        let(:expected_value) { I18n.t('boolean.false') }
        let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
        let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

        before { ticket.classified = false }

        it { expect(content_with_label(ticket, :classified)).to eq(expected) }
      end

      context 'true' do
        let(:expected_value) { I18n.t('boolean.true') }
        let(:expected_content) { content_tag(:p, expected_label, class: 'content-label') + content_tag(:p, expected_value, class: 'content-value') }
        let(:expected) { content_tag(:div, expected_content, class: 'content-with-label') }

        before { ticket.classified = true }

        it { expect(content_with_label(ticket, :classified)).to eq(expected) }
      end
    end
  end

  describe 'content_sanitizer' do
    it 'default tags' do
      expected = %w( strong em u ol li ul p )
      expect(ContentHelper::SAFE_TAGS).to eq(expected)
    end

    it 'sanitize content' do
      allow(self).to receive(:sanitize)

      content_sanitizer('string')

      expect(self).to have_received(:sanitize).with('string', tags: ContentHelper::SAFE_TAGS)
    end
  end

  describe 'answer_sanitizer' do
    it 'default tags' do
      expected = %w( strong em u ol li ul p a )
      expect(ContentHelper::ANSWER_SAFE_TAGS).to eq(expected)
    end

    it 'default attributes' do
      expected = %w( href target )
      expect(ContentHelper::ANSWER_SAFE_ATTRIBUTES).to eq(expected)
    end

    it 'sanitize content' do
      allow(self).to receive(:sanitize)

      answer_sanitizer('string')

      expect(self).to have_received(:sanitize).with('string', tags: ContentHelper::ANSWER_SAFE_TAGS, attributes: ContentHelper::ANSWER_SAFE_ATTRIBUTES)
    end
  end

end
