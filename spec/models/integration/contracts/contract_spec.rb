require 'rails_helper'

describe Integration::Contracts::Contract do

  subject(:contract) { build(:integration_contracts_contract) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_contracts_contract, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:cod_concedente).of_type(:string) }
      it { is_expected.to have_db_column(:cod_financiador).of_type(:string) }
      it { is_expected.to have_db_column(:cod_financiador_including_zeroes).of_type(:string) }
      it { is_expected.to have_db_column(:cod_gestora).of_type(:string) }
      it { is_expected.to have_db_column(:cod_orgao).of_type(:string) }
      it { is_expected.to have_db_column(:cod_secretaria).of_type(:string) }
      it { is_expected.to have_db_column(:decricao_modalidade).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_objeto).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_tipo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_url).of_type(:string) }
      it { is_expected.to have_db_column(:data_assinatura).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_processamento).of_type(:datetime) }
      it { is_expected.to have_db_column(:data_termino).of_type(:datetime) }
      it { is_expected.to have_db_column(:flg_tipo).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_parte_destino).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_sic).of_type(:integer) }
      it { is_expected.to have_db_column(:num_spu).of_type(:string) }
      it { is_expected.to have_db_column(:valor_contrato).of_type(:decimal) }
      it { is_expected.to have_db_column(:isn_modalidade).of_type(:integer) }
      it { is_expected.to have_db_column(:isn_entidade).of_type(:integer) }
      it { is_expected.to have_db_column(:tipo_objeto).of_type(:string) }
      it { is_expected.to have_db_column(:num_spu_licitacao).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_justificativa).of_type(:string) }
      it { is_expected.to have_db_column(:valor_can_rstpg).of_type(:decimal) }
      it { is_expected.to have_db_column(:data_publicacao_portal).of_type(:datetime) }
      it { is_expected.to have_db_column(:descricao_url_pltrb).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_url_ddisp).of_type(:string) }
      it { is_expected.to have_db_column(:descricao_url_inexg).of_type(:string) }
      it { is_expected.to have_db_column(:cod_plano_trabalho).of_type(:string) }
      it { is_expected.to have_db_column(:num_certidao).of_type(:string) }
      it { is_expected.to have_db_column(:descriaco_edital).of_type(:string) }
      it { is_expected.to have_db_column(:cpf_cnpj_financiador).of_type(:string) }
      it { is_expected.to have_db_column(:num_contrato).of_type(:string) }
      it { is_expected.to have_db_column(:plain_num_contrato).of_type(:string) }
      it { is_expected.to have_db_column(:plain_cpf_cnpj_financiador).of_type(:string) }
      it { is_expected.to have_db_column(:valor_original_concedente).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_original_contrapartida).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_atualizado_concedente).of_type(:decimal) }
      it { is_expected.to have_db_column(:valor_atualizado_contrapartida).of_type(:decimal) }

      it { is_expected.to have_db_column(:descricao_situacao).of_type(:string) }

      it { is_expected.to have_db_column(:data_publicacao_doe).of_type(:datetime) }
      it { is_expected.to have_db_column(:descricao_nome_credor).of_type(:text) }
      it { is_expected.to have_db_column(:isn_parte_origem).of_type(:string) }

      # Data utilizada para atualizações diárias de contratos. O serviço
      # recebe esse parâmetro e retorna os contratos alterados após essa data.
      # Desse forma, podemos otimizar a atualização diária de contratos em vez
      # de carregar todos os contratos, que leva horas para terminar.
      it { is_expected.to have_db_column(:data_auditoria).of_type(:date) }

      # Usado para o retorno no webservice do Eparcerias (Integration::Eparcerias::Importer)
      it { is_expected.to have_db_column(:accountability_status).of_type(:string) }

      # Valores calculados

      it { is_expected.to have_db_column(:calculated_valor_aditivo).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_ajuste).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_empenhado).of_type(:decimal) }
      it { is_expected.to have_db_column(:calculated_valor_pago).of_type(:decimal) }

      it { is_expected.to have_db_column(:contract_type).of_type(:integer) }

      it { is_expected.to have_db_column(:infringement_status).of_type(:integer) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:num_contrato) }
      it { is_expected.to have_db_index(:cod_concedente) }
      it { is_expected.to have_db_index(:cod_financiador) }
      it { is_expected.to have_db_index(:cod_financiador_including_zeroes) }
      it { is_expected.to have_db_index(:cod_gestora) }
      it { is_expected.to have_db_index(:cod_orgao) }
      it { is_expected.to have_db_index(:cod_secretaria) }
      it { is_expected.to have_db_index(:plain_num_contrato) }
      it { is_expected.to have_db_index(:plain_cpf_cnpj_financiador) }
      it { is_expected.to have_db_index(:data_assinatura) }
      it { is_expected.to have_db_index(:data_processamento) }
      it { is_expected.to have_db_index(:data_termino) }
      it { is_expected.to have_db_index(:isn_modalidade) }
      it { is_expected.to have_db_index(:flg_tipo) }
      it { is_expected.to have_db_index(:contract_type) }
      it { is_expected.to have_db_index(:infringement_status) }
      it { is_expected.to have_db_index(:accountability_status) }
      it { is_expected.to have_db_index(:descricao_situacao) }
      it { is_expected.to have_db_index(:decricao_modalidade) }
      it { is_expected.to have_db_index(:isn_parte_origem) }
      it { is_expected.to have_db_index(:data_auditoria) }
    end
  end

  describe 'enums' do
    it 'contract_type' do
      contract_types = [:contrato, :convenio, :unknown]

      is_expected.to define_enum_for(:contract_type).with_values(contract_types)
    end

    it 'infringement_status' do
      infringement_statuses = [:adimplente, :inadimplente]

      is_expected.to define_enum_for(:infringement_status).with_values(infringement_statuses)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_assinatura) }
    it { is_expected.to validate_presence_of(:data_processamento) }
    it { is_expected.to validate_presence_of(:data_termino) }
    it { is_expected.to validate_presence_of(:flg_tipo) }
    it { is_expected.to validate_presence_of(:isn_parte_destino) }
    it { is_expected.to validate_presence_of(:isn_sic) }
    it { is_expected.to validate_presence_of(:valor_contrato) }
    it { is_expected.to validate_presence_of(:isn_modalidade) }
    it { is_expected.to validate_presence_of(:isn_entidade) }
    it { is_expected.to validate_presence_of(:valor_can_rstpg) }
    it { is_expected.to validate_presence_of(:data_publicacao_portal) }
    it { is_expected.to validate_presence_of(:valor_original_concedente) }
    it { is_expected.to validate_presence_of(:valor_original_contrapartida) }
    it { is_expected.to validate_presence_of(:valor_atualizado_concedente) }
    it { is_expected.to validate_presence_of(:valor_atualizado_contrapartida) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:adjustments).dependent(:delete_all) }
    it { is_expected.to have_many(:additives).dependent(:delete_all) }
    it { is_expected.to have_many(:financials).dependent(:delete_all) }
    it { is_expected.to have_many(:infringements).dependent(:delete_all) }

    it { is_expected.to belong_to(:manager) }
    it { is_expected.to belong_to(:grantor) }

    context 'existing foreign_keys' do
      it 'manager'  do
        #
        # O manager deve ser relacionar com a tabela integration_supports_organs.codigo_orgao (orgao_sfp: false)
        # usando sua coluna cod_gestora.
        #
        manager = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false)

        # a flag orgao_sfp é usada para definir órgãos da folha de pagamento. Há sempre 2 órgãos
        # iguais (um com sfp true e outro false),
        manager_sfp = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: true)

        # Não devemos considerar os órgãos que possuem data_termino
        manager_data_termino = create(:integration_supports_organ, codigo_orgao: '1234', orgao_sfp: false, data_termino: Date.yesterday)

        contract = create(:integration_contracts_contract, cod_gestora: '1234')

        expect(contract.manager).to eq(manager)
      end

      it 'creditor'  do
        creditor = create(:integration_supports_creditor, cpf_cnpj: '00001234')

        contract = create(:integration_contracts_contract, cpf_cnpj_financiador: '00001234')

        expect(contract.creditor).to eq(creditor)
      end
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:manager).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:manager).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:grantor).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:sigla).to(:grantor).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:title).to(:creditor).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:data_changes).to(:utils_data_change).with_arguments(allow_nil: true) }
    it { is_expected.to delegate_method(:resource_status).to(:utils_data_change).with_arguments(allow_nil: true) }
  end

  describe 'scope' do
    describe 'default_scope' do
      it 'returns only contracts' do
        contract = create(:integration_contracts_contract)
        convenant = create(:integration_contracts_convenant)

        expect(Integration::Contracts::Contract.pluck(:id)).to include(contract.id)
        expect(Integration::Contracts::Contract.pluck(:id)).not_to include(convenant.id)
      end
    end

    it 'active_on_month' do
      now = DateTime.now

      contract_data = { data_assinatura: now - 1.year, data_termino: now + 1.year}
      active = create(:integration_contracts_contract, contract_data)

      contract_data = { data_assinatura: now - 2.year, data_termino: now - 1.year}
      inactive = create(:integration_contracts_contract, contract_data)

      date = now.to_date

      expect(Integration::Contracts::Contract.data_vigencia_in_range(date, date.end_of_day)).to eq([active])
    end

    it 'sorted' do
      first_unsorted = create(:integration_contracts_contract, data_assinatura: '2017-06-14 19:33:06')
      last_unsorted = create(:integration_contracts_contract, data_assinatura: '2017-06-14 20:33:06')
      expect(Integration::Contracts::Contract.sorted).to eq([last_unsorted, first_unsorted])
    end
  end

  describe 'callbacks' do
    it 'change status' do
      contract.update(descricao_situacao: 'em andamento')
      changes_notificables = { 'descricao_situacao'=>['em andamento', 'concluido'] }

      contract.save

      contract.update(descricao_situacao: 'concluido')

      expect(contract.data_changes).to eq(changes_notificables)
      expect(contract.resource_status).to eq('updated_resource_notificable')
    end

    it 'plain_num_contrato' do
      contract.num_contrato = '123-456/ABC/def-1'
      expected = '123456ABCdef1'

      contract.valid?

      expect(contract.plain_num_contrato).to eq(expected)

      contract.num_contrato = nil
      expected = nil

      contract.valid?

      expect(contract.plain_num_contrato).to eq(expected)
    end

    it 'plain_cpf_cnpj_financiador' do
      contract.cpf_cnpj_financiador = '02.851.974/0001-04'
      expected = '02851974000104'

      contract.valid?

      expect(contract.plain_cpf_cnpj_financiador).to eq(expected)

      contract.cpf_cnpj_financiador = nil
      expected = nil

      contract.valid?

      expect(contract.plain_cpf_cnpj_financiador).to eq(expected)
    end

    it 'cod_financiador_including_zeroes' do
      contract.cod_financiador = '123456'
      expected = '00123456'

      contract.valid?

      expect(contract.cod_financiador_including_zeroes).to eq(expected)

      contract.cod_financiador = nil
      expected = nil

      contract.valid?

      expect(contract.cod_financiador_including_zeroes).to eq(expected)
    end

    it 'contract_type' do
      expected = 'contrato'

      contract.flg_tipo = 51
      contract.valid?
      expect(contract.contract_type).to eq(expected)

      contract.flg_tipo = 52
      contract.valid?
      expect(contract.contract_type).to eq(expected)

      contract.flg_tipo = 54
      contract.valid?
      expect(contract.contract_type).to eq(expected)

      expected = 'convenio'

      contract.flg_tipo = 49
      contract.valid?
      expect(contract.contract_type).to eq(expected)

      contract.flg_tipo = 53
      contract.valid?
      expect(contract.contract_type).to eq(expected)

      expected = 'unknown'

      contract.flg_tipo = 1234
      contract.valid?
      expect(contract.contract_type).to eq(expected)
    end
  end

  describe 'helpers' do
    it 'title' do
      expect(contract.title).to eq(contract.isn_sic.to_s)
    end

    it 'valor_aditivo' do
      expect(contract.valor_aditivo).to eq(contract.additives.total_addition)
    end

    it 'valor_ajuste' do
      expect(contract.valor_ajuste).to eq(contract.adjustments.total_adjustments)
    end

    it 'valor_empenhado' do
      expect(contract.valor_empenhado).to eq(contract.financials.document_sum)
    end

    it 'valor_pago' do
      expect(contract.valor_pago).to eq(contract.financials.payment_sum)
    end

    it 'valor_atualizado_total' do
      expected = (contract.valor_original_concedente + contract.valor_atualizado_contrapartida + contract.valor_aditivo)
      expect(contract.valor_atualizado_total).to eq(expected)
    end

    it 'status' do
      contract.data_termino = Date.today.end_of_day
      expect(contract.status).to eq(:vigente)

      contract.data_termino = (Date.today - 2.days).end_of_day
      expect(contract.status).to eq(:concluido)
    end

    it 'status_str' do
      allow(contract).to receive(:status).and_return(:vigente)
      expected = I18n.t("integration/contracts/contract.statuses.vigente")
      expect(contract.status_str).to eq(expected)
    end

    it 'infringement_status_str' do
      allow(contract).to receive(:infringement_status).and_return(:vigente)
      expected = I18n.t("integration/contracts/contract.infringement_statuses.vigente")
      expect(contract.infringement_status_str).to eq(expected)
    end

    it 'calculated_valor_empenhado' do
      contract.update(calculated_valor_empenhado: nil)
      expected = BigDecimal(0)
      expect(contract.calculated_valor_empenhado).to eq(expected)
    end

    it 'calculated_valor_pago' do
      contract.update(calculated_valor_pago: nil)
      expected = BigDecimal(0)
      expect(contract.calculated_valor_pago).to eq(expected)
    end
  end
end
