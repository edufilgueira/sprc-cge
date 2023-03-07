namespace :data_fixes do

  # Corrige os usuários que não fazem parte de subrede mas estão com "lixo" no
  # campo de subrede
  task fix_user_clerat_subnet: :environment do
    User.where.not(subnet: nil, operator_type: [:subnet_sectoral, :subnet_chief, :internal]).update_all(subnet_id: nil)
  end
end
