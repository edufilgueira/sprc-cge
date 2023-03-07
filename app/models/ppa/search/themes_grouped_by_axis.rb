module PPA
=begin
  Módulo responsável por organizar buscas não convencionais. Novas buscas
  devem viver em /models/ppa/search/.

  Essa busca é chamada no controller de eixos e deve retornar os eixos filtrados
  pelo termo existente em tema


  Para evitar a manipulação direta do hash de parâmetros a classe SearchParams
  filtra os parâmetros permitidos e cria helpers para manipulação dos mesmos


  Como o escopo inicial desse filtro é realizado em PPA::Theme e depois os resultados
  são agrupados por seus respectivos eixos, para evitar a manipulação de hashes/arrays na view
  os resultados são encapsulados em instâncias de SearchRecord, classe com métodos `name` e `themes`
  para simular o comportamento de uma instância de PPA::Axis

=end
  module Search
    class ThemesGroupedByAxis

      def initialize(query={})
        @params = SearchParams.new(query)
      end

      def records
        records = @params.has_name_query? ? name_filtered : all
        group(records)
      end

      private

      def all
        PPA::Theme.all
      end

      def name_filtered
        all.where('LOWER(name) LIKE LOWER(?)', "%#{@params.name_query}%")
      end

      def group(records)
        records
          .order(:name)
          .group_by(&:axis)
          .map { |axis_arr| SearchRecord.new(axis_arr) }
          .sort { |a,b| a.name <=> b.name }
      end

      class SearchParams
        ALLOWED_KEYS = %i{ term }

        def initialize(params)
          params  = params || {}
          @params = sanitize(params)
        end

        def has_name_query?
          !@params[:term].blank?
        end

        def name_query
          @params[:term]
        end

        private

        def sanitize(params)
          selected = params.to_hash.select { |k, v| ALLOWED_KEYS.include?(k.to_sym) }
          HashWithIndifferentAccess.new(selected)
        end
      end

      class SearchRecord
        attr_reader :themes

        def initialize(collection)
          @axis   = collection.first
          @themes = collection.last
        end

        def name
          @axis.name
        end
      end

    end
  end
end
