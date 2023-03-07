module PPA::Api
  module V1
=begin

  UNUSED
    - esse controller não está sendo usado por enquanto, mas serve como modelo para APIs que
      devem surgir no PPA.

  Controlador para o recurso "Temas, numa dada Região, que possua Estratégias definidas".
  As estratégias de recorte se referem à região e a um biênio:
  - Por padrão, o biênio é o mais atual - relacionado ao Plano (PPA) corrente
  - É possível "escolher" um biênio a partir do parâmetro :biennium (GET query string)

=end
    class Regions::ThemesController < PPAController

      def index
        render json: serialized_themes
      end


      private

      def current_biennium
        @current_biennium ||= PPA::Biennium.current
      end

      def biennium
        @biennium ||= params.key?(:biennium) ? PPA::Biennium.new(params[:biennium]) : current_biennium
      end

      def plan
        @plan ||= PPA::Plan.find_by_biennium biennium
      end

      def region
        @region ||= PPA::Region.find params[:region_id]
      end

      def themes_with_strategies_in_biennium_and_region
        @_themes ||= PPA::Theme.in_biennium_and_region(biennium, region)
      end

      def serialized_themes
        themes_with_strategies_in_biennium_and_region.map do |theme|
          theme.as_json only: %i[id name]
        end
      end

    end
  end
end
