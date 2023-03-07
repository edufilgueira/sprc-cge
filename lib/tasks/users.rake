namespace :users do

  desc "Carrega a base de dados com usuários fictícios"
  task create_or_update: :environment do

  #   users_data = [
  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :admin,
  #       name: 'SPRC Admin',
  #       email: 'admin@example.com',
  #       email_confirmation: 'admin@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :cge,
  #       name: 'Operador SPRC',
  #       email: 'operator@example.com',
  #       email_confirmation: 'operator@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :cge,
  #       name: 'Operador CGE',
  #       email: 'operator-cge@example.com',
  #       email_confirmation: 'operator-cge@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :sou_sectoral,
  #       name: 'Operador SOU setorial',
  #       email: 'operator-sectoral@example.com',
  #       email_confirmation: 'operator-sectoral@example.com',
  #       password: '123456',
  #       password_confirmation: '123456',
  #       organ: ExecutiveOrgan.first
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :sou_sectoral,
  #       name: 'Operador setorial RedeOuvirOrgan',
  #       email: 'rede_ouvir@example.com',
  #       email_confirmation: 'rede_ouvir@example.com',
  #       password: '123456',
  #       password_confirmation: '123456',
  #       organ: RedeOuvirOrgan.first
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :internal,
  #       name: 'Operador interno',
  #       email: 'operator-internal@example.com',
  #       email_confirmation: 'operator-internal@example.com',
  #       password: '123456',
  #       password_confirmation: '123456',
  #       department: Department.where(organ: ExecutiveOrgan.first).first
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :call_center,
  #       name: 'Atendente 155',
  #       email: 'operator-155@example.com',
  #       email_confirmation: 'operator-155@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     },

  #     {
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       user_type: :operator,
  #       operator_type: :call_center_supervisor,
  #       name: 'Supervisor 155',
  #       email: 'supervisor-155@example.com',
  #       email_confirmation: 'supervisor-155@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     },

  #     {
  #       user_type: :user,
  #       name: 'Usuário SPRC',
  #       document_type: 0,
  #       document: '764.316.867-99',
  #       city_id: City.first.id,
  #       email: 'user@example.com',
  #       email_confirmation: 'user@example.com',
  #       password: '123456',
  #       password_confirmation: '123456'
  #     }
  #   ]

  #   users_data.each do |user_attrs|
  #     user_email = user_attrs[:email]

  #     user = User.find_or_initialize_by(email: user_email)
  #     user.attributes = user_attrs
  #     user.skip_confirmation!
  #     user.save!
  #   end
  end

  desc "Remove associacao de orgao, departamento, subdepartamento e subrede com usuario que nao deveria ter essa associacao"
  task fix_user_operator_type: :environment do
    User.where(
      user_type: 'operator', operator_type: ['cge', 'call_center', 'call_center_supervisor']
    ).update_all(organ_id: nil, department_id: nil, sub_department_id: nil)

    User.where(
      user_type: 'operator', operator_type: ['chief', 'subnet_chief', 'sou_sectoral', 'sic_sectoral', 'subnet_sectoral']
    ).update_all(department_id: nil, sub_department_id: nil)

    User.where(user_type: 'operator').where.not(
      operator_type: ['subnet_chief', 'subnet_sectoral', 'internal'], subnet_id: nil
    ).update_all(subnet_id: nil)
  end


  desc 'Modifica todas as senhas dos usuários sem login a mais de X (parâmetro) dias.'
  task :reset_password_for_users, [:days] => :environment do |t, args|
    
    if !args.days.present? 
      raise 'Favor informar parametro com os dias'
    end    

    changed_day = Time.current.to_date.to_time - args.days.to_i
    
    User.where('current_sign_in_at <= ?', changed_day).find_each do |user|
      # Generate random, long password that the user will never know:
      password = new_password
      if user.reset_password(password, password)
        if user.update(password_changed_at: Time.current)
          puts user.name
        else
          puts "### Erro update password_changed_at :  #{user.name} - #{user.errors.messages}"
        end
      else
        puts "### Erro reset_password:  #{user.name} - #{user.errors.messages}"
      end
    end
  end


  desc 'Modifica todas as senhas dos usuários que ainda não modificaram a senha para nova politica'
  task reset_password_for_users_with_old_password: :environment do 
    User.where(password_changed_at: nil).find_each do |user|
      password = new_password
      if user.reset_password(password, password)
        if user.update(password_changed_at: Time.current)
          puts user.name
        else
          puts "### Erro update password_changed_at: #{user.name} - #{user.errors.messages}"
        end
      else
        puts "### Erro reset_password:  #{user.name} - #{user.errors.messages}"
      end
    end
  end
end

def new_password
  Devise.friendly_token(50)+"!@#"
end

