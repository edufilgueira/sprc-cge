CSV_FILE = 'lib/ppa/ppa_2020_2023_estrategias.csv'



namespace :ppa do
  namespace '2020_2023' do
    namespace :strategies do
      desc 'Import strategies from ppa 2020-2023'
      task import: :environment do

        csv = CSV.parse(
          File.read(
            CSV_FILE,
            :encoding => 'windows-1252'
          ), :headers => false, col_sep: ";")

        ApplicationRecord.transaction do
          csv.each_with_index do |row, index|

            theme_code = row[2]
            strategy_description = row[4]
            region = PPA::Region.find_by_code(row[0])

            if theme_code.nil? or strategy_description.nil?
              raise "thema ou estrategia sem codigo na linha #{index + 1}"
            end

            theme = SupportPPA.get_theme_from_code(theme_code)

            # objective = SupportPPA.get_objective_from_theme(theme)
            objective_theme = SupportPPA.get_objective_theme(theme, region)

            strategy = PPA::Strategy.create(
              objective: objective_theme.objective,
              objective_theme: objective_theme,
              code: SupportPPA.last_code(PPA::Strategy),
              name: strategy_description
            )

            puts "Criando Estratégia: #{strategy.id} - #{strategy.name}"

          end
        end
      end
    end
  end
end

class SupportPPA

  # def self.get_objective_from_theme(theme)
  #   if theme.present?
  #     if theme.objectives.present?
  #       theme.objectives.first
  #     else
  #       objective = PPA::Objective.create(
  #         code: SupportPPA.last_code(PPA::Objective),
  #         name: 'Objetivo não definido',
  #       )

  #       theme.objective_themes.create(
  #         objective_id: objective.id,
  #         theme_id: theme.id
  #       )
  #       objective
  #     end
  #   end
  # end

  def self.get_objective_theme(theme, region)

    # Assumir qualquer/primeiro objetivo como correto,
    # pois n tem objetivos p este PPA
    objective = nil

    if theme.objectives.present?
      objective = theme.objectives.first
    else
      objective = PPA::Objective.find_or_create_by(
          code: '00',
          name: 'Objetivo não definido',
      )
    end

    PPA::ObjectiveTheme.find_or_create_by(
      objective: objective,
      theme: theme,
      region: region
    )

  end

  def self.get_theme_from_code(theme_code)
    plan = PPA::Plan.last
    theme = PPA::Theme.joins(:axis).where(code: theme_code, ppa_axes: { plan_id: plan.id}).first
    if theme.present?
      theme
    else
      raise "Não foi localizado nenhum tema com o código: #{theme_code}"
    end
  end

  def self.last_code(klass)
    (klass.pluck(:code).map{|i| i.to_i}.sort.last + 1).to_s
  end
end
