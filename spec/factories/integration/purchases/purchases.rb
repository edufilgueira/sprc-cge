FactoryBot.define do
  factory :integration_purchases_purchase, class: 'Integration::Purchases::Purchase' do
    numero_publicacao "2016/24578"
    numero_viproc "60019612016"
    num_termo_participacao "20160308"
    cnpj "07954571003715"
    nome_resp_compra "HOSPITAL DE SAUDE MENTAL DE MESSEJANA"
    uf_resp_compra "CE"
    macro_regiao_org "Metropolitana de Fortaleza"
    micro_regiao_org "Fortaleza"
    municipio_resp_compra "Fortaleza"
    cpf_cnpj_fornecedor "00466084000153"
    nome_fornecedor "SUPRIMAX COMERCIAL LTDA - EPP"
    tipo_fornecedor "EPP"
    uf_fornecedor "Ceará"
    macro_regiao_fornecedor "Metropolitana de Fortaleza"
    micro_regiao_fornecedor "Fortaleza"
    municipio_fornecedor "Fortaleza"
    tipo_material_servico "Material"
    nome_grupo "ARTIGOS E UTENSILIOS DE ESCRITORIO"
    codigo_item "11690"
    descricao_item "EXTRATOR DE GRAMPOS, AÇO CROMADO, 15 CM, EMBALAGEM COM IDENTIFICAÇAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE"
    unidade_fornecimento "CARTELA 1.0 UNIDADE "
    marca "LYKE"
    natureza_aquisicao "MATERIAL DE CONSUMO"
    tipo_aquisicao "MATERIAL DE EXPEDIENTE"
    sistematica_aquisicao "PREGÃO"
    forma_aquisicao "ELETRÔNICO"
    tratamento_diferenciado false
    data_publicacao { Date.today }
    quantidade_estimada " 30,0"
    valor_unitario "0.91"
    data_finalizada { Date.today }
    valor_total_melhor_lance "27.30"
    valor_estimado "2.26"
    valor_total_estimado "67.80"
    aquisicao_contrato false
    prazo_entrega "0"
    prazo_pagamento "0"
    exige_amostras "Não"
    data_carga { Date.today }
    ano "2017"
    mes "2"
    ano_mes "201702"
    codigo_classe_material "5"
    nome_classe_material "ARTIGOS PARA ESCRITORIO"
    registro_preco "Não"
    unid_compra_regiao_planej "Grande Fortaleza"
    fornecedor_regiao_planejamento "Grande Fortaleza"
    unidade_gestora "241321"
    grupo_lote "1"
    descricao_item_referencia "EXTRATOR DE GRAMPOS, 15 CM, ACO CROMADO, EMBALAGEM COM IDENTIFICACAO DO PRODUTO, MARCA DO FABRICANTE, ESPATULA, CARTELA 1.0 UNIDADE"
    id_item_aquisicao "113215"
    cod_item_referencia "11690"

    association :manager, factory: :integration_supports_management_unit

    trait :invalid do
      numero_publicacao nil
      numero_viproc nil
      num_termo_participacao nil
      codigo_item nil
    end
  end
end
