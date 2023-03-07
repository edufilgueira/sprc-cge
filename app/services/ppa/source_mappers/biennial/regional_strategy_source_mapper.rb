module PPA::SourceMappers
  module Biennial
    class RegionalStrategySourceMapper < Base
      maps PPA::Source::Guideline, to: PPA::Biennial::RegionalStrategy

      # pre-requisites
      attr_reader :region, :strategy

      def map
        # pre-requisites
        @region   = PPA::Region.find_by! code: source.codigo_regiao
        @strategy = PPA::Strategy.find_by! code: source.codigo_ppa_estrategia

        # target
        @target = strategy.biennial_regional_strategies
          .in_biennium_and_region(biennium, region)
          .first_or_initialize

        @target.priority       = priority_from_prioridade_regional_for source.prioridade_regional
        @target.priority_index = priority_index_from_ordem_prioridade_for source.ordem_prioridade

        @target.save! #.tap { |rec| rec.save! if rec.new_record? || rec.changed? }
      end


      def biennium
        @biennium ||= source.biennium
      end

      def blacklisted?
        code = source.codigo_ppa_estrategia

        if ignore? code
          logger.warn "Ignorando Estratégia com código missing (#{code.inspect})"
          true # blacklisted!
        end
      end


      private

      def ignore?(value)
        canonized = value.to_s.strip
        canonized.blank? || canonized == '-'
      end

      def ignore_priority_index?(value)
        return true if ignore? value

        value.to_s.strip == '0'
      end

      def priority_from_prioridade_regional_for(prioridade_regional)
        case prioridade_regional.to_s.strip.downcase
        when 'sim' then :prioritized
        end
      end

      def priority_index_from_ordem_prioridade_for(ordem_prioridade)
        return nil if ignore?(ordem_prioridade) || ordem_prioridade.to_s.strip == '0'

        source.ordem_prioridade.to_i
      end
    end
  end
end
