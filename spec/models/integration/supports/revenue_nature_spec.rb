require 'rails_helper'

describe Integration::Supports::RevenueNature do
  subject(:revenue_nature) { build(:integration_supports_revenue_nature) }

  # Define que este model deve conectar na base de dados do sprc-data
  it { is_expected.to be_kind_of(ApplicationDataRecord) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:integration_supports_revenue_nature, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:codigo).of_type(:string) }
      it { is_expected.to have_db_column(:descricao).of_type(:string) }
      it { is_expected.to have_db_column(:revenue_nature_type).of_type(:integer) }

      # Códigos cacheados para facilitar o agrupamento
      it { is_expected.to have_db_column(:codigo_consolidado).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_categoria_economica).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_origem).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_subfonte).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_rubrica).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_alinea).of_type(:string) }
      it { is_expected.to have_db_column(:codigo_subalinea).of_type(:string) }

      # Cacheamos se a natureza da receita é uma transferência voluntária/obrigatória
      it { is_expected.to have_db_column(:transfer_required).of_type(:boolean) }
      it { is_expected.to have_db_column(:transfer_voluntary).of_type(:boolean) }

      # Guardamos o full_title para não ter que ficar percorrendo o parent sob
      # demanda

      it { is_expected.to have_db_column(:full_title).of_type(:text) }

      #
      # Algumas naturezas de receitas tem o mesmo nome, e o mesmo 'caminho', fazendo
      # com que apareçam duplicadas tanto no filtro, quanto na árvore. Temos que
      # identificá-los unicamente, usando uma coluna auxiliar que cria um 'sha256' baseado
      # no fulltitle.
      #
      it { is_expected.to have_db_column(:unique_id).of_type(:string) }

      # Unique ids cacheados para facilitar o agrupamento
      it { is_expected.to have_db_column(:unique_id_consolidado).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_categoria_economica).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_origem).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_subfonte).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_rubrica).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_alinea).of_type(:string) }
      it { is_expected.to have_db_column(:unique_id_subalinea).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:codigo) }
      it { is_expected.to have_db_index(:revenue_nature_type) }

      it { is_expected.to have_db_index(:codigo_consolidado) }
      it { is_expected.to have_db_index(:codigo_categoria_economica) }
      it { is_expected.to have_db_index(:codigo_origem) }
      it { is_expected.to have_db_index(:codigo_subfonte) }
      it { is_expected.to have_db_index(:codigo_rubrica) }
      it { is_expected.to have_db_index(:codigo_alinea) }
      it { is_expected.to have_db_index(:codigo_subalinea) }

      it { is_expected.to have_db_index(:transfer_required) }
      it { is_expected.to have_db_index(:transfer_voluntary) }

      it { is_expected.to have_db_index(:unique_id) }

      it { is_expected.to have_db_index(:unique_id_consolidado) }
      it { is_expected.to have_db_index(:unique_id_categoria_economica) }
      it { is_expected.to have_db_index(:unique_id_origem) }
      it { is_expected.to have_db_index(:unique_id_subfonte) }
      it { is_expected.to have_db_index(:unique_id_rubrica) }
      it { is_expected.to have_db_index(:unique_id_alinea) }
      it { is_expected.to have_db_index(:unique_id_subalinea) }
    end
  end

  describe 'enums' do
    it 'revenue_nature_type' do
      expected = [
        :consolidado,
        :categoria_economica,
        :origem,
        :subfonte,
        :rubrica,
        :alinea,
        :subalinea
      ]

      is_expected.to define_enum_for(:revenue_nature_type).with_values(expected)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:codigo) }
    it { is_expected.to validate_presence_of(:descricao) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:consolidado).with_primary_key(:codigo_consolidado).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:categoria_economica).with_primary_key(:codigo_categoria_economica).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:origem).with_primary_key(:codigo_origem).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:subfonte).with_primary_key(:codigo_subfonte).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:rubrica).with_primary_key(:codigo_rubrica).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:alinea).with_primary_key(:codigo_alinea).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
    it { is_expected.to have_one(:subalinea).with_primary_key(:codigo_subalinea).with_foreign_key(:codigo).class_name('Integration::Supports::RevenueNature') }
  end

  describe 'helpers' do
    it 'title' do
      expect(revenue_nature.title).to eq(revenue_nature.descricao)
    end
  end

  describe 'inheritance' do
    let(:receita_orcamentaria) { create(:integration_supports_revenue_nature, codigo: '100000000', descricao: '   Receita Orçamentária.  ') }
    let(:receitas_correntes) { create(:integration_supports_revenue_nature, codigo: '110000000', descricao: '   Receitas Correntes.  ') }
    let(:outras_receitas_correntes) { create(:integration_supports_revenue_nature, codigo: '119000000', descricao: '   Outras Receitas Correntes.  ') }
    let(:indenizacoes_e_restituicoes) { create(:integration_supports_revenue_nature, codigo: '119200000', descricao: '    Indenizações e Restituições.   ') }

    it 'parent' do
      expect(receita_orcamentaria.parent).to be_nil
      expect(receitas_correntes.parent).to eq(receita_orcamentaria)
      expect(outras_receitas_correntes.parent).to eq(receitas_correntes)
      expect(indenizacoes_e_restituicoes.parent).to eq(outras_receitas_correntes)
    end

    describe 'full_title' do
      it 'sets with parent' do
        receita_orcamentaria.valid?
        expect(receita_orcamentaria.full_title).to eq(receita_orcamentaria.descricao.strip)

        receitas_correntes.valid?
        expect(receitas_correntes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip}")

        outras_receitas_correntes.valid?
        expect(outras_receitas_correntes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip} > #{outras_receitas_correntes.descricao.strip}")

        indenizacoes_e_restituicoes.valid?
        expect(indenizacoes_e_restituicoes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip} > #{outras_receitas_correntes.descricao.strip} > #{indenizacoes_e_restituicoes.descricao.strip}")
      end
    end

    #
    # Algumas naturezas de receitas tem o mesmo nome, e o mesmo 'caminho', fazendo
    # com que apareçam duplicadas tanto no filtro, quanto na árvore. Temos que
    # identificá-los unicamente, usando uma coluna auxiliar que cria um 'sha256' baseado
    # no fulltitle.
    #
    describe 'unique_id' do
      it 'sets sha 256 based on full_title' do
        receita_orcamentaria
        another_receita_orcamentaria = create(:integration_supports_revenue_nature, codigo: '900000000', descricao: '   Receita Orçamentária.  ')

        expected_unique_id =  Digest::SHA256.hexdigest(another_receita_orcamentaria.full_title)

        expect(receita_orcamentaria.full_title).to eq(another_receita_orcamentaria.full_title)
        expect(receita_orcamentaria.unique_id).to eq(expected_unique_id)
        expect(receita_orcamentaria.unique_id).to eq(another_receita_orcamentaria.unique_id)

        expect(receitas_correntes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip}")
        expect(receitas_correntes.unique_id_consolidado).to eq(receita_orcamentaria.unique_id)

        expect(outras_receitas_correntes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip} > #{outras_receitas_correntes.descricao.strip}")
        expect(outras_receitas_correntes.unique_id_consolidado).to eq(receita_orcamentaria.unique_id)
        expect(outras_receitas_correntes.unique_id_categoria_economica).to eq(receitas_correntes.unique_id)

        expect(indenizacoes_e_restituicoes.full_title).to eq("#{receita_orcamentaria.descricao.strip} > #{receitas_correntes.descricao.strip} > #{outras_receitas_correntes.descricao.strip} > #{indenizacoes_e_restituicoes.descricao.strip}")
        expect(indenizacoes_e_restituicoes.unique_id_consolidado).to eq(receita_orcamentaria.unique_id)
        expect(indenizacoes_e_restituicoes.unique_id_categoria_economica).to eq(receitas_correntes.unique_id)
        expect(indenizacoes_e_restituicoes.unique_id_origem).to eq(outras_receitas_correntes.unique_id)
        expect(indenizacoes_e_restituicoes.unique_id_subfonte).to eq(indenizacoes_e_restituicoes.unique_id)
      end
    end
  end

  describe 'callbacks' do

    describe 'revenue_nature_type' do

      describe 'sets revenue_nature_type based on codigo' do

        it 'consolidado' do
          # 100000000
          # Receita Orçamentária
          #
          # 800000000
          # Deduções da Receita Orçamentária
          #
          # 900000000
          # Registra as restituições de receitas.

          revenue_nature.codigo = '100000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('consolidado')

          revenue_nature.codigo = '800000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('consolidado')

          revenue_nature.codigo = '900000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('consolidado')

          revenue_nature.codigo = '990000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).not_to eq('consolidado')
        end

        it 'categoria_economica' do
          # 110000000
          # Receitas Correntes

          revenue_nature.codigo = '110000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('categoria_economica')
        end

        it 'origem' do
          # 111000000
          # Receita Tributária

          revenue_nature.codigo = '111000000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('origem')
        end

        it 'subfonte' do
          # 111100000
          # Impostos

          revenue_nature.codigo = '111100000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('subfonte')
        end

        it 'rubrica' do
          # 111120000
          # Impostos sobre o Patrimônio e a Renda

          revenue_nature.codigo = '111120000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('rubrica')
        end

        it 'alinea' do
          # 111120400
          # Imposto sobre a Renda e Proventos de Qualquer Natureza

          revenue_nature.codigo = '111120400'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('alinea')

          revenue_nature.codigo = '116001000'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('alinea')
        end

        it 'subalinea' do
          # 916001301
          # Restituição de Serviços de Inscrição em Concursos Públicos

          revenue_nature.codigo = '916001301'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('subalinea')

          revenue_nature.codigo = '111130260'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('subalinea')

          revenue_nature.codigo = '116002001'
          revenue_nature.valid?
          expect(revenue_nature.revenue_nature_type).to eq('subalinea')
        end
      end
    end

    describe 'transfers' do
      it 'transfer_required' do
        # Códigos das naturezas de receitas consideradas 'Transferências Obrigatórias'
        codigos = ['117213501','117212230','117210101', '117210112', '117210113', '117210132', '117610700', '117430000','117440000', '117210901', '124710700']

        another_codigos = ['123', '789']

        codigos.each do |codigo|
          revenue_nature.codigo = codigo
          revenue_nature.valid?
          expect(revenue_nature).to be_transfer_required
        end

        another_codigos.each do |another_codigo|
          revenue_nature.codigo = another_codigo
          revenue_nature.valid?
          expect(revenue_nature).not_to be_transfer_required
        end
      end

      it 'transfer_voluntary' do
        # Códigos das naturezas de receitas consideradas 'Transferências Voluntárias'
        codigos = ['117212220','117212240','117212270','117213333','117213336', '117213339','117213341','117213342','117213343','117213345','117213349', '117213358','117213359','117213361','117213362','117213363','117213373', '117213389','117213400','117213503','117213504','117213599','117213600', '117219951','117219952','117230100','117240100','117240251','117240252', '117300000','117500000','117610100','117610200','117619900','117630100', '117639900','117640000','117650000','124210100','124230100','124230200', '124300000','124400000','124710100','124710200','124710300','124710400', '124710500','124719900','124739999']

        another_codigos = ['123', '789']

        codigos.each do |codigo|
          revenue_nature.codigo = codigo
          revenue_nature.valid?
          expect(revenue_nature).to be_transfer_voluntary
        end

        another_codigos.each do |another_codigo|
          revenue_nature.codigo = another_codigo
          revenue_nature.valid?
          expect(revenue_nature).not_to be_transfer_voluntary
        end
      end
    end

    describe 'codigos' do
      it 'sets codigos for all revenue_nature_types' do
        # Ex: 111120751
        # "ITCD Principal"

        revenue_nature.codigo = '111120751'
        revenue_nature.valid?

        expect(revenue_nature.codigo_subalinea).to eq('111120751')
        expect(revenue_nature.codigo_alinea).to eq('111120700')
        expect(revenue_nature.codigo_rubrica).to eq('111120000')
        expect(revenue_nature.codigo_subfonte).to eq('111100000')
        expect(revenue_nature.codigo_origem).to eq('111000000')
        expect(revenue_nature.codigo_categoria_economica).to eq('110000000')
        expect(revenue_nature.codigo_consolidado).to eq('100000000')
      end

      it 'does not set codigos for minor revenue_nature_types' do
        # Ex: 111120000
        # "ITCD Principal"

        revenue_nature.codigo = '111120000'
        revenue_nature.valid?

        expect(revenue_nature.codigo_subalinea).to eq(nil)
        expect(revenue_nature.codigo_alinea).to eq(nil)
        expect(revenue_nature.codigo_rubrica).to eq('111120000')
        expect(revenue_nature.codigo_subfonte).to eq('111100000')
        expect(revenue_nature.codigo_origem).to eq('111000000')
        expect(revenue_nature.codigo_categoria_economica).to eq('110000000')
        expect(revenue_nature.codigo_consolidado).to eq('100000000')
      end

      it 'sets level below when not exists' do

        # Há casos em que o nível da árvore sofre um buraco, como no código: 119909953

        # Esse código tem a seguinte classificação:

        #  codigo_consolidado: "100000000",
        #  codigo_categoria_economica: "110000000",
        #  codigo_origem: "119000000",
        #  codigo_subfonte: "119900000",
        #  codigo_rubrica: "119900000",
        #  codigo_alinea: "119909900",
        #  codigo_subalinea: "119909953"

        # Como o código da subfonte e da rubrica são iguais, devemos ajustar a
        # rubrica para o mesmo código da alínea para que a navegação na árvore
        # seja possível nesses casos

        revenue_nature.codigo = '119909953'
        revenue_nature.valid?

        expect(revenue_nature.codigo_subalinea).to eq('119909953')
        expect(revenue_nature.codigo_alinea).to eq('119909900')

        # Esse código deve ser igual ao da alínea!
        expect(revenue_nature.codigo_rubrica).to eq('119909900')

        expect(revenue_nature.codigo_subfonte).to eq('119900000')

        expect(revenue_nature.codigo_origem).to eq('119000000')
        expect(revenue_nature.codigo_categoria_economica).to eq('110000000')
        expect(revenue_nature.codigo_consolidado).to eq('100000000')
      end
    end
  end
end
