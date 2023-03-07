namespace :ppa do
  namespace :plans do
    desc 'Creates a PPA Plan for 2016-2019'
    task create_or_update: :environment do

      # Plano base, no período do contrato (2016-2019), para iniciar a base.
      # Períodos de propsotas e votação definidos para Dez/2019
      PPA::Plan.find_or_create_by!(start_year: 2016, end_year: 2019) do |plan|
        plan.attributes = {
          status: 1     
        }
      end

    end
  end
end
