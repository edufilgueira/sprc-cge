#rake ppa:2020_2023:situations:import

namespace :ppa do
  namespace '2020_2023' do
    namespace :situations do
      desc 'Import situation from ppa 2020-2023'
      task import: :environment do

      	csv_ppa_soluction = 'lib/ppa/tb_solucao_v2.csv'
        csv_ppa_soluction_problem = 'lib/ppa/tb_solucao_problema_v2.csv'

        #csv_ppa_soluction

      	csv = CSV.parse(
          File.read(
            csv_ppa_soluction
          ), :headers => false, col_sep: ";")

        ApplicationRecord.transaction do
          csv.each_with_index do |row, index|
          	
          	record = PPA::Situation.create(
          		description: row[1],
          		isn_solucao: row[0]
          	)

          	if record.persisted?
          		puts "Salvo - description: #{row[1]} - isn_solucao: #{row[0]}"
          	else
          		puts "Erro - description: #{row[1]} - isn_solucao: #{row[0]} - #{record.errors.messages}"
          	end          	
          end
        end

        #csv_ppa_soluction_problem

        csv = CSV.parse(
          File.read(
            csv_ppa_soluction_problem
          ), :headers => false, col_sep: ";")

        ApplicationRecord.transaction do
          csv.each_with_index do |row, index|
            
            record = PPA::ProblemSituation.new(
              isn_solucao_problema: row[0],
              axis: PPA::Axis.find_by_isn(row[1]),
              theme: PPA::Theme.find_by_isn(row[2]),
              region: PPA::Region.find_by_isn(row[3]),
              situation: PPA::Situation.find_by_isn_solucao(row[4]),
              dth_registro: row[5],
            )
            record.save
            
            if record.persisted?
              puts "Salvo - isn_solucao_problema: #{row[0]}"
            else
              puts "Erro - isn_solucao_problema: #{row[0]}"
            end           
          end
        end
      end
    end
  end
end
