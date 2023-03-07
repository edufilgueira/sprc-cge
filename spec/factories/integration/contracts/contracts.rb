FactoryBot.define do
  factory :integration_contracts_contract, class: 'Integration::Contracts::Contract' do
    sequence(:cod_concedente)
    sequence(:cod_financiador)
    sequence(:cod_gestora)
    sequence(:cod_orgao)
    sequence(:cod_secretaria)
    sequence(:decricao_modalidade) { |n| "Modalidade #{n}" }
    sequence(:descricao_objeto) { |n| "Aquisição de Material #{n}" }
    descricao_tipo "MyString"
    descricao_url "MyString"
    data_assinatura "2017-06-14 19:33:06"
    data_processamento "2017-06-14 19:33:06"
    data_termino "2017-06-14 19:33:06"
    flg_tipo 51
    isn_parte_destino 1
    descricao_situacao 'EM EXECUÇÃO - NORMAL'

    # contract e convenant usam sti mas isn_sic deve ser único. usando ímpar para contract e par para convenant
    sequence(:isn_sic) {|n| (2*n) + 1}

    num_spu "MyString"
    valor_contrato "9.99"
    isn_modalidade 1
    isn_entidade 1
    sequence(:tipo_objeto) { |n| "Objeto do tipo #{n}" }
    num_spu_licitacao "MyString"
    descricao_justificativa "MyString"
    valor_can_rstpg "9.99"
    data_publicacao_portal "2017-06-14 19:33:06"
    descricao_url_pltrb "MyString"
    descricao_url_ddisp "MyString"
    descricao_url_inexg "MyString"
    cod_plano_trabalho "MyString"
    num_certidao "MyString"
    descriaco_edital "MyString"
    sequence(:cpf_cnpj_financiador) { |n| "11.737.334/0001-#{n}" }
    sequence(:num_contrato) { |n| "0#{n}/2017" }
    valor_original_concedente "9.99"
    valor_original_contrapartida "9.99"
    valor_atualizado_concedente "9.99"
    valor_atualizado_contrapartida "9.99"

    trait :invalid do
      data_assinatura nil
    end

    trait :contrato do
      flg_tipo 51
      contract_type :contrato
    end

    trait :convenio do
      flg_tipo 49
      contract_type :convenio
    end

    trait :with_nesteds do
      after(:create) do |contract|
        create(:integration_contracts_additive, contract: contract, isn_sic: contract.isn_sic)
        create(:integration_contracts_financial, contract: contract, isn_sic: contract.isn_sic)
        create(:integration_contracts_infringement, contract: contract, isn_sic: contract.isn_sic)
        create(:integration_contracts_adjustment, contract: contract, isn_sic: contract.isn_sic)
      end
    end

    trait :management do
      decricao_modalidade 'GESTÃO'
    end
  end
end
