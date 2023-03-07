module PPA
  module Annual
    module MeasurementPeriodAdapter

      def period_for_descricao_referencia(descricao_referencia)
        case descricao_referencia.to_s
        # Deixando casos de "nulo" para o default do case
        #   when 'Sem Período Concluído para o Ano'
        when 'Jan-Mar' then 'until_march'
        when 'Jan-Jun' then 'until_june'
        when 'Jan-Set' then 'until_september'
        when 'Jan-Dez' then 'until_december'
        end
      end

      def descricao_referencia_for_period(period)
        case period.to_s
        when 'until_march'     then 'Jan-Mar'
        when 'until_june'      then 'Jan-Jun'
        when 'until_september' then 'Jan-Set'
        when 'until_december'  then 'Jan-Dez'
        else 'Sem Período Concluído para o Ano'
        end
      end
    end
  end
end
