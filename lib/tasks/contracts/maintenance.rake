namespace :contracts do
  namespace :maintenance do
		desc "Deletar Aditivo"   
	    task :delete_additives, [:tipo, :additive_id, :contract_id, :valor_additive] => :environment do |t, args|

	    	  tipo =  args.tipo.to_i
		      id = args.additive_id.to_i
		      isn_sic = args.contract_id.to_i

		      	 response = Integration::Contracts::Additive.find(id).destroy		        
			        if response.destroyed?            
			        	puts "Aditivo #{args.additive_id}  deletado"
			        	puts "---------------------------------------------------------"
			        else
			        	puts "Aditivo #{args.additive_id} não deletado"
			        	puts "---------------------------------------------------------"
			        end

		      	if tipo == 0	  
			        response =  Integration::Contracts::Contract.where(isn_sic: isn_sic, contract_type: tipo).update(calculated_valor_aditivo: args.valor_additive)
			        if response.empty?    
				        puts "Cálculo não atualizado no contrato #{args.contract_id}, aditivo de Prazo"			        
				        puts "---------------------------------------------------------"
				      else			      	
				      	puts "Cálculo atualizado no contrato #{args.contract_id}, aditivo de Valor "
			        	puts "---------------------------------------------------------"
			        end		 
		        else
		        	response =  Integration::Contracts::Convenant.where(isn_sic: isn_sic, contract_type: tipo).update(calculated_valor_aditivo: args.valor_additive)
			        if response.empty?    
				        puts "Cálculo não atualizado no convênio #{args.contract_id}, aditivo de Prazo"			        
				        puts "---------------------------------------------------------"
				      else			      	
				      	puts "Cálculo atualizado no convênio #{args.contract_id}, aditivo de Valor "
			        	puts "---------------------------------------------------------"
			        end	

		        end #/ tipo
		  end  #/ task :delete_additives 
	end #/ namespace :maintenance
end #/ namespace :contracts