class CreatePPASourceGuidelines < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_source_guidelines do |t|
      t.string :codigo_regiao
      t.string :descricao_regiao
      t.string :descricao_objetivo_estrategico
      t.string :descricao_estrategia
      t.string :codigo_ppa_objetivo_estrategico
      t.string :codigo_ppa_estrategia
      t.string :codigo_eixo
      t.string :descricao_eixo
      t.string :codigo_tema
      t.string :descricao_tema
      t.string :codigo_programa
      t.string :descricao_programa
      t.string :codigo_ppa_iniciativa
      t.string :descricao_ppa_iniciativa
      t.string :codigo_acao
      t.string :descricao_acao
      t.string :codigo_produto
      t.string :descricao_produto
      t.string :descricao_portal
      t.string :prioridade_regional
      t.string :ordem_prioridade
      t.string :descricao_referencia
      t.decimal :valor_programado_ano1
      t.decimal :valor_programado_ano2
      t.decimal :valor_programado_ano3
      t.decimal :valor_programado_ano4
      t.decimal :valor_programado1619_ar
      t.decimal :valor_programado1619_dr
      t.decimal :valor_realizado_ano1
      t.decimal :valor_realizado_ano2
      t.decimal :valor_realizado_ano3
      t.decimal :valor_realizado_ano4
      t.decimal :valor_realizado1619_ar
      t.decimal :valor_realizado1619_dr
      t.decimal :valor_lei
      t.decimal :valor_lei_creditos
      t.decimal :valor_empenhado
      t.decimal :valor_pago

      t.integer :ano

      t.timestamps
    end

    add_index :ppa_source_guidelines, [:codigo_regiao, :codigo_ppa_objetivo_estrategico, :codigo_ppa_estrategia, :codigo_eixo, :codigo_tema, :codigo_ppa_iniciativa, :codigo_produto, :descricao_referencia, :ano], unique: true, name: :psg_index_primary
  end
end
