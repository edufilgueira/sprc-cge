namespace :contracts do
	desc "Deletar Aditivo duplicado"
    task :delete_additives => :environment do |t|
     
      ids = [61730] 
      ids.each do |id|
        Integration::Contracts::Additive.find(id).delete
        puts "Aditivo #{id} deletado"
        puts "---------------------------------------------------------"

      isn_sics = [965742] 
      isn_sics.each do |isn_sic|
        Integration::Contracts::Contract.where(isn_sic: isn_sic).update(calculated_valor_aditivo: 55920.31)
        puts "Cálculo atualizado do #{isn_sic} "
        puts "---------------------------------------------------------"

      end #/ ids.each
      end #/ protocols.each
    end #/ task :delete_additives
  end #/ namespace :contracts

